package Wrapper_agent ;

	import Wrapper_config_obj ::*;
	import Wrapper_seq_item ::* ;
	import uvm_pkg::*;
	import monitor::*;
	import Wrapper_driver::*;
	import sequencer ::*;
	`include "uvm_macros.svh"

	class Wrapper_agent extends uvm_agent ;
		`uvm_component_utils(Wrapper_agent)

		 MyMonitor mon;
		 MySequencer sqr ;
		 Wrapper_driver drv ;
		 Wrapper_config_obj Wrapper_cfg ;
		 uvm_analysis_port #(Wrapper_seq_item) agt_ap;

		function new (string name = "Wrapper_agent", uvm_component parent =null );
			super.new(name,parent);
		endfunction

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			if(!uvm_config_db#(Wrapper_config_obj)::get(this, "","CFG_Wrapper",Wrapper_cfg))
				`uvm_fatal("build_phase", "Error in reading configurable object")
			if(Wrapper_cfg.active == UVM_ACTIVE) begin 	 	
				sqr = MySequencer ::type_id :: create ("sqr",this) ;
				drv = Wrapper_driver ::type_id :: create ("drv", this);
			end
			mon = MyMonitor ::type_id :: create ("mon", this) ;	
			agt_ap = new("agt_ap",this); 
		endfunction : build_phase
		
		function void connect_phase(uvm_phase phase) ;
			if(Wrapper_cfg.active==UVM_ACTIVE) begin
				drv.Wrapper_vif = Wrapper_cfg.Wrapper_config_vif ;
				drv.seq_item_port.connect(sqr.seq_item_export)	;
			end
			mon.Wrapper_vif = Wrapper_cfg.Wrapper_config_vif ;
			mon.mon_ap.connect(agt_ap) ;
		endfunction
	endclass
endpackage : Wrapper_agent			
