module PISO(clk,tx_valid,counter,tx_data,dout);

output reg dout;
input [7:0] tx_data;
input clk ;
input tx_valid ;
input [3:0] counter;
reg [7:0]temp;

always @ (posedge clk) begin
	if (tx_valid) begin
		if (counter==0)
			temp <= tx_data;
		else begin
			dout <= temp[7];
			temp <= {temp[6:0],1'b0};
		end
	end
end
endmodule
