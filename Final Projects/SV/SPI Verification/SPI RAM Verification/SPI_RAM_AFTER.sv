// SPI RAM RTL Code After Bug Fixing
module project_ram(din, rx_valid, dout, tx_valid, clk, rst_n);
parameter MEM_DEPTH = 256;
parameter ADDR_SIZE = 8;
input rx_valid, clk, rst_n;
input [9:0] din;
output reg tx_valid;
output reg [7:0] dout;
reg [ADDR_SIZE-1:0] addr_rd, addr_wr;
reg [7:0] mem [MEM_DEPTH-1:0];
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		// make integer i = 0 to be int i = 0 inside the for loop to be in its scope and 
		// Not to take in code coverage report as it can't make 100 % its 32 bits Toggle
		for (int i = 0 ; i < r_if.MEM_DEPTH ; i = i + 1) begin 
			mem [i] <= 0;   
		end
		dout <= 0;     // "Bug Fix" Zero For all the Following outside For Loop
		tx_valid <= 0;
		addr_rd <= 0;       // "Bug Fix" make addr_rd <= 0 When rst_n
		addr_wr <= 0;       // "Bug Fix" make addr_wr <= 0 When rst_n
	end
	else if (rx_valid) begin
		if (din[9:8] == 2'b00) begin
			addr_wr <= din[7:0];
			tx_valid <= 0;
		end
		else if (din[9:8] == 2'b01) begin
			mem [addr_wr] <= din[7:0];
			tx_valid <= 0;
		end
		else if (din[9:8] == 2'b10) begin
			addr_rd <= din[7:0];
			tx_valid <= 0;
		end
		else if (din[9:8] == 2'b11) begin
			dout <= mem[addr_rd];
			tx_valid <= 1;
		end
		else begin
			dout <= 0;
			tx_valid <= 0;
		end
	end 
end
endmodule