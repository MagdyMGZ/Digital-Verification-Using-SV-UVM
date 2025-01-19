package Wrapper_scoreboard ;
	import Wrapper_pack ::* ;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	import Wrapper_seq_item ::* ; 

	class Wrapper_scoreboard extends uvm_scoreboard ;
		`uvm_component_utils(Wrapper_scoreboard)
		uvm_analysis_export #(Wrapper_seq_item) sb_export ;
		uvm_tlm_analysis_fifo # (Wrapper_seq_item) sb_fifo ;
		Wrapper_seq_item seq_item_sb ;
		

		int error_count =0 ;
		int correct_count =0 ;
		int bits_counter =0 ;
		bit u ;
		int counter ;
		logic [7:0] word_exp;
		logic [7:0] word_rec ; 
		logic [7:0] mem [255:0];
		logic [7:0] wr_addr;
		logic [7:0] rd_addr;

		function new(string name = "Wrapper_scoreboard", uvm_component parent = null);
			super.new(name,parent) ;
		endfunction : new
		
		function void build_phase(uvm_phase phase) ;
			super.build_phase(phase) ;
			sb_export = new("sb_export" , this) ;
			sb_fifo = new("sb_fifo" , this) ;
		endfunction
		
		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			sb_export.connect(sb_fifo.analysis_export); 		
		endfunction

		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			word_rec =0 ;
			counter =0 ;
			forever begin 
				sb_fifo.get(seq_item_sb);
				`uvm_info("run_phase",seq_item_sb.convert2string_op(),UVM_HIGH)
				refrence_model(seq_item_sb);
				if(seq_item_sb.data_holder[10:8] == 3'b111 ) begin
					if(counter>14) begin
						word_rec[22-counter] = seq_item_sb.MISO ;
					end
					counter++;
					if(counter==23) begin
						counter =0;
						if(word_rec !== word_exp) begin
							`uvm_error ("run_phase", $sformatf("Comparison Failed, Recieved: %b ---Expected: %h"
								,word_rec,word_exp))
							error_count++ ;
						end
						else begin
							`uvm_info("run_phase","Correct_output in Scoreboard",UVM_HIGH)
							correct_count ++ ;
						end							
					end 
				end
				else begin
					word_rec =0 ;
					counter =0;
				end	 				
			end
		endtask
		task refrence_model(Wrapper_seq_item x);
		
			if(!x.rst_n)
			begin
			    for (int i = 0; i < 256; i=i+1) 	mem [i] = 1'b0;
			    word_exp=0;
			    wr_addr=0;
			    rd_addr=0;
			    u=0;
			end
			else begin
			    if(x.data_holder[10:8]==3'b000)
					wr_addr= x.data_holder[7:0];
			    if(x.data_holder[10:8]==3'b001)
					mem[wr_addr]= x.data_holder[7:0];
			 	if(x.data_holder[10:8]==3'b110)begin
					rd_addr= x.data_holder[7:0];
					u=1;
				end
				if((x.data_holder[10:8]==3'b111)&&(u)) begin
					word_exp= mem[rd_addr];
				    u=0;
				end 
			end

		endtask 	 

		function void report_phase(uvm_phase phase);
			super.report_phase(phase);
			`uvm_info ("report_phase",$sformatf("Total successful transactions: %d ",correct_count),UVM_LOW)
			`uvm_info ("report_phase",$sformatf("Total failed transactions: %d ",error_count),UVM_LOW)
		endfunction
	endclass
endpackage : Wrapper_scoreboard					 	