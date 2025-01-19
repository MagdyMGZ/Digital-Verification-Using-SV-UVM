package sequencer ;
	import Wrapper_seq_item ::* ;
	import sequences::* ;
	import uvm_pkg::*;
	`include "uvm_macros.svh"	

	class MySequencer extends uvm_sequencer #(Wrapper_seq_item) ;
		`uvm_component_utils(MySequencer) 

		function new(string name = "MySequencer",uvm_component parent =null ) ;
			super.new(name,parent) ;
		endfunction
	endclass
endpackage			