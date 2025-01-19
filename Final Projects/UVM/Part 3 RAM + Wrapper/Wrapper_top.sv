import Wrapper_test_pkg::* ;
import ram_test_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

module top();

	bit clk ;
	initial begin
		forever #2 clk=~clk ;
	end

	Wrapper_if  Wrap_if(clk);
	ram_if ramif(clk);

	spi_wrapper DUT(Wrap_if.MOSI , Wrap_if.MISO, Wrap_if.SS_n, Wrap_if.clk, Wrap_if.rst_n);

	initial begin
		uvm_config_db#(virtual Wrapper_if)::set(null,"uvm_test_top","Wrapper_IF",Wrap_if);
		uvm_config_db#(virtual ram_if)::set(null,"uvm_test_top","ram_IF",ramif);
		run_test("Wrapper_test") ;
	end
	assign ramif.rst_n = Wrap_if.rst_n ;
	assign ramif.rx_valid = DUT.rx_valid;
  	assign ramif.din = DUT.rx_data;
  	assign ramif.dout = DUT.tx_data;
  	assign ramif.tx_valid = DUT.tx_valid;

endmodule 	