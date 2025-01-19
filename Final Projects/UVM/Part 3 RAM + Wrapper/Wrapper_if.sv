import Wrapper_pack :: * ; 

interface Wrapper_if (input clk );

	logic MOSI,SS_n,rst_n;
	logic MISO; 
	logic address_sent ;
	logic [10:0] data_holder ;
	
endinterface 	