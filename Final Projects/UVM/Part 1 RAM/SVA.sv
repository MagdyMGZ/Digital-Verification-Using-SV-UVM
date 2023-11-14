module SPI_RAM_SVA(din , rx_valid , tx_valid , clk);
	input [9:0] din;
	input rx_valid,tx_valid,clk;

sequence A;
	((din[9] == 1'b1) && (din[8] == 1'b1));
endsequence

property tx_valid_chk_11;
	@(posedge clk) A |-> ##1 $rose(tx_valid) |-> ##1 !tx_valid;
endproperty

tx_chk_11: cover property(tx_valid_chk_11);
tx_asser_11: assert property(tx_valid_chk_11);

sequence B;
	((din[9] == 1'b0) && (din[8] == 1'b0)) || ((din[9] == 1'b0) && (din[8] == 1'b1));
endsequence

property tx_valid_chk_00_01;
	@(posedge clk) B |=> !(tx_valid);
endproperty

tx_chk_00_01: cover property(tx_valid_chk_00_01);
tx_asser_00_01: assert property(tx_valid_chk_00_01);

sequence C;
	((din[9] == 1'b1) && (din[8] == 1'b0));
endsequence

property tx_valid_chk_10;
	@(posedge clk) C |-> ##1 (tx_valid == 0);
endproperty

tx_chk_10: cover property(tx_valid_chk_10);
tx_asser_10: assert property(tx_valid_chk_10);

endmodule