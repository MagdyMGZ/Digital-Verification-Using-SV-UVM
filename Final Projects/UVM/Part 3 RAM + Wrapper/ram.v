module project_ram(din, rx_valid, dout, tx_valid, clk, rst_n);
parameter MEM_DEPTH = 256;
parameter ADDR_SIZE = 8;
input rx_valid, clk, rst_n;
input [9:0] din;
output reg tx_valid;
output reg [7:0] dout;
reg [ADDR_SIZE-1:0] addr_rd, addr_wr;
reg [7:0] mem [MEM_DEPTH-1:0];
reg [8:0] i ;
/*
bugs  if rst_n activated the internal register of read/write adderesses is not cleared*/
always @(posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		dout <= 8'b0;
			tx_valid <= 1'b0;
			addr_rd<=0;
			addr_wr<=0;
			i=0;
		for (i = 0; i < MEM_DEPTH; i=i+1) begin
			mem [i] <= 1'b0;
		end 
	end

	else if (rx_valid) begin
			i=8'b1111_1111;
		if (din[9:8] == 2'b00) begin
			addr_wr <= din[7:0];
			tx_valid <= 0;
		end
		else if (din[9:8] == 2'b01) begin
			mem [addr_wr] <= din[7:0];
			tx_valid <= 0;

		i=0;
		end
		else if (din[9:8] == 2'b10) begin
			addr_rd <= din[7:0];
			tx_valid <= 0;
		end
		else begin
			dout <= mem[addr_rd];
			tx_valid <= 1;
		end
	end 
end
endmodule
