module SPI_RAM_SVA(RAM_if.DUT r_if);

sequence A;
	((r_if.din[9] == 1'b1) && (r_if.din[8] == 1'b1));
endsequence

property tx_valid_chk_11;
	@(posedge r_if.clk) A |-> ##1 $rose(r_if.tx_valid) |-> ##1 $fell(r_if.tx_valid);
endproperty

tx_chk_11: cover property(tx_valid_chk_11);
tx_asser_11: assert property(tx_valid_chk_11);

sequence B;
	((r_if.din[9] == 1'b0) && (r_if.din[8] == 1'b0)) || ((r_if.din[9] == 1'b0) && (r_if.din[8] == 1'b1));
endsequence

property tx_valid_chk_00_01;
	@(posedge r_if.clk) B |=> !(r_if.tx_valid);
endproperty

tx_chk_00_01: cover property(tx_valid_chk_00_01);
tx_asser_00_01: assert property(tx_valid_chk_00_01);

sequence C;
	((r_if.din[9] == 1'b1) && (r_if.din[8] == 1'b0));
endsequence

property tx_valid_chk_10;
	@(posedge r_if.clk) C |-> ##1 (r_if.tx_valid == 0);
endproperty

tx_chk_10: cover property(tx_valid_chk_10);
tx_asser_10: assert property(tx_valid_chk_10);

endmodule