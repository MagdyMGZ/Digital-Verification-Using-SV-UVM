package Wrapper_coverage ;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	import Wrapper_seq_item ::* ; 

	class coverage extends uvm_component ;

		`uvm_component_utils(coverage) 
		uvm_analysis_export #(Wrapper_seq_item) cov_export ;
		uvm_tlm_analysis_fifo #(Wrapper_seq_item) cov_fifo ;
		Wrapper_seq_item seq_item_cov ;

		covergroup Wrapper_cg ;
			reset_cp: coverpoint seq_item_cov.rst_n;
			SS_n_cp : coverpoint seq_item_cov.SS_n ;
			MOSI_cp :  coverpoint seq_item_cov.MOSI; 
			MISO_cp : coverpoint seq_item_cov.MISO ;
			operation_cp : coverpoint seq_item_cov.data_holder[10:8]
			{
				bins WRITE_add = {3'b000} ;
				bins WRITE_data =  {3'b001} ;
				bins READ_add = {3'b110};
				bins READ_data = {3'b111} ;
				illegal_bins Invalid_op = default ;
			}

			READ_op : cross operation_cp,MISO_cp 
			{
				ignore_bins not_read0 = binsof(operation_cp.WRITE_add);
				ignore_bins not_read1 = binsof(operation_cp.WRITE_data);
				ignore_bins not_read2 = binsof(operation_cp.READ_add);
			}

		endgroup 
		
		function new(string name = "coverage", uvm_component parent);
			super.new(name,parent);
			Wrapper_cg =new() ;
		endfunction 
		
		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			cov_export = new("cov_export",this);
			cov_fifo = new("cov_fifo", this) ;
		endfunction 
		
		function void connect_phase(uvm_phase phase );
			super.connect_phase(phase);
			cov_export.connect(cov_fifo.analysis_export);
		endfunction
				
		task run_phase(uvm_phase phase);
		 	super.run_phase(phase);
		 	forever begin
		 		cov_fifo.get(seq_item_cov);
		 		Wrapper_cg.sample() ;
		 	end	
		endtask
	endclass
endpackage : Wrapper_coverage		 		