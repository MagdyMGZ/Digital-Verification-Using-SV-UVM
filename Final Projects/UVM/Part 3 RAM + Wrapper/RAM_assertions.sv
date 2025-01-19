module RAM_assertions(din, rx_valid, dout, tx_valid, clk, rst_n);
input rx_valid, clk, rst_n;
input [9:0] din;
input tx_valid;
input  [7:0] dout;

	property property1;
		@(posedge clk) (~rst_n) |-> ( (~tx_valid) && (~dout) ) ;
	endproperty	

	/*property property2;
		@(posedge clk) disable iff(!rst_n) ((~rx_valid)&&(din[9:8]==2'b10)) |-> $stable(rd_addr)  ;
	endproperty
	
	property property3;
		@(posedge clk) disable iff(!rst_n) ((~rx_valid)&&(din[9:8]==2'b00)) |-> $stable(wr_addr)  ;
	endproperty*/

	property property2;
		@(posedge clk) disable iff(!rst_n) ((rx_valid)&&(din[9:8]==2'b11)) |=> (tx_valid==1)  ;
	endproperty

	property property3;
		@(posedge clk) disable iff(!rst_n) ((rx_valid)&&(din[9:8]!=2'b11)) |=> (tx_valid==0)  ;
	endproperty

		property property4;
		@(posedge clk) disable iff(!rst_n) ((rx_valid)&&(din[9:8]!=2'b11)) |=> (tx_valid==0)  ;
	endproperty

	property property5;
		@(posedge clk) disable iff(!rst_n) ((!rx_valid)&&(din[9:8]==2'b11)) |=> ($stable(tx_valid))  ;
	endproperty
	property property6;
		@(posedge clk) disable iff(!rst_n) ((!rx_valid)&&(din[9:8]==2'b11)) |=> $stable(dout)  ;
	endproperty
lb1:	assert property (property1);
lb2:	assert property (property2);
lb3:	assert property (property3);
lb4:	assert property (property4);
lb5:	assert property (property5);
lb6:	assert property (property6);


lb7:	cover property (property1);
lb8:	cover property (property2);
lb9:	cover property (property3);
lb10:	cover property (property4);
lb11:	cover property (property5);
lb12:	cover property (property6);

endmodule