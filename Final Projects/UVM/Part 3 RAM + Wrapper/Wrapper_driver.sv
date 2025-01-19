package Wrapper_driver ;

	import Wrapper_config_obj ::*;
	import Wrapper_seq_item ::* ;
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	class Wrapper_driver extends uvm_driver #(Wrapper_seq_item);
		`uvm_component_utils(Wrapper_driver)

		virtual Wrapper_if Wrapper_vif ;
		Wrapper_seq_item seq_item ;

		function new(string name = "Wrapper_driver" , uvm_component parent = null);
			super.new(name,parent);
		endfunction 
		
		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			forever begin
				seq_item = Wrapper_seq_item :: type_id :: create ("seq_item");
				seq_item_port.get_next_item(seq_item);

					for (int i =0 ;i<11;i++) begin
						update_if(i);
						@(negedge Wrapper_vif.clk) ;
					end
					 
					if(seq_item.data_holder[10:8] ==3'b111)
						repeat(12) begin
							@(negedge Wrapper_vif.clk) ;
						end

					@(negedge Wrapper_vif.clk) ;
					seq_item.SS_n = 1;
					update_if(10);
					@(negedge Wrapper_vif.clk) ;

				seq_item_port.item_done();
				`uvm_info("run_phase",seq_item.convert2string(),UVM_HIGH) 
			end	
		endtask
		task update_if(int i);
			Wrapper_vif.rst_n = seq_item.rst_n;
			Wrapper_vif.SS_n = seq_item.SS_n;
			Wrapper_vif.MOSI = seq_item.data_holder[10-i];
			Wrapper_vif.address_sent = seq_item.address_sent;
			Wrapper_vif.data_holder = seq_item.data_holder;
		endtask

	endclass 
endpackage : Wrapper_driver			
