package monitor ;
	import Wrapper_seq_item ::* ;
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	class MyMonitor extends uvm_monitor ;
		`uvm_component_utils(MyMonitor)
		virtual Wrapper_if Wrapper_vif ;
		Wrapper_seq_item mon_seq_item ;
		uvm_analysis_port #(Wrapper_seq_item) mon_ap ;

		function new (string name = "monitor", uvm_component parent =null );
			super.new(name,parent);
		endfunction

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			mon_ap = new ("mon_ap" ,this);
		endfunction 

		task run_phase(uvm_phase phase) ;
			super.run_phase(phase);
			forever begin
				mon_seq_item = Wrapper_seq_item ::type_id::create("mon_seq_item");
				@(negedge Wrapper_vif.clk);
				update_seq_item();
				mon_ap.write(mon_seq_item);
				`uvm_info("run_phase", mon_seq_item.convert2string(),UVM_HIGH)
			end
		endtask
		
		task update_seq_item();
			mon_seq_item.rst_n = Wrapper_vif.rst_n ;
			mon_seq_item.SS_n = Wrapper_vif.SS_n;
			mon_seq_item.MOSI = Wrapper_vif.MOSI;
			mon_seq_item.MISO = Wrapper_vif.MISO;
			mon_seq_item.address_sent = Wrapper_vif.address_sent;
			mon_seq_item.data_holder = Wrapper_vif.data_holder; 
		endtask

	endclass
endpackage : monitor			