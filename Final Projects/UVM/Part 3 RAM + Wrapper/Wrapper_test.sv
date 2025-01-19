package  Wrapper_test_pkg;

	import ram_env_pkg::*;
	import Wrapper_env::* ;
	import uvm_pkg::*;
	import Wrapper_config_obj::*;
	import ram_config_pkg::*;
	import sequences::*;
	import squence_pkg::*;
	`include "uvm_macros.svh"

	class Wrapper_test extends uvm_test ;
		`uvm_component_utils (Wrapper_test) ;

		Wrapper_env my_env ;
		ram_env R_env ;
		virtual Wrapper_if Wrapper_test_vif ;
		virtual ram_if ramif;
		Wrapper_config_obj Wrapper_config_obj_test ;
		ram_config ram_cfg;
		Wrapper_main_seq main_seq ;
		Wrapper_reset_seq reset_seq_w;
		ram_read_and_write_squence read_and_write_seq;
		ram_reset_squence reset_seq;
		ram_read_squence read_seq;
		ram_write_squence write_seq;

		function new(string name  = "Wrapper_test", uvm_component parent = null );
			super.new(name,parent); 	
		endfunction

		function void build_phase(uvm_phase phase);
			super.build_phase(phase); 
			Wrapper_config_obj_test = Wrapper_config_obj::type_id::create("Wrapper_config_obj_test",this) ;
			my_env = Wrapper_env::type_id::create("my_env",this) ;
			main_seq = Wrapper_main_seq::type_id::create("main_seq",this) ;
			reset_seq_w = Wrapper_reset_seq::type_id::create("reset_seq_w",this) ;
			R_env = ram_env::type_id::create("env", this);
		    ram_cfg=ram_config::type_id::create("ram_cfg",this);
		    read_and_write_seq=ram_read_and_write_squence::type_id::create("read_and_write_seq",this);
		    read_seq=ram_read_squence::type_id::create("read_seq",this);
		    write_seq=ram_write_squence::type_id::create("write_seq",this);
		    reset_seq=ram_reset_squence::type_id::create("reset_seq",this);

			if(!uvm_config_db#(virtual Wrapper_if) :: get(this, "", "Wrapper_IF",Wrapper_config_obj_test.Wrapper_config_vif))
			`uvm_fatal("build_phase","ERROR in getting virtual interface");
			uvm_config_db#(Wrapper_config_obj)::set(this, "*", "CFG_Wrapper",Wrapper_config_obj_test);
			Wrapper_config_obj_test.active = UVM_ACTIVE ;

			if(!uvm_config_db #(virtual ram_if)::get(this,"","ram_IF",ram_cfg.ramif))
		    `uvm_fatal("build_phase","test -unable to get the virtual interface of alu from uvm_config_db");
		    uvm_config_db#(ram_config)::set(this,"*","CFG",ram_cfg);	
		    ram_cfg.active = UVM_PASSIVE ;
		    
		endfunction

		task run_phase (uvm_phase phase);
			super.run_phase(phase);
			phase.raise_objection(this);
			`uvm_info ("run_phase","RESET_ASSERTED ",UVM_LOW);
			reset_seq_w.start(my_env.agt.sqr);
			`uvm_info ("run_phase","RESET_DEASSERTED ",UVM_LOW);
			`uvm_info("run_phase","Started generating stimulus",UVM_LOW);
			main_seq.start(my_env.agt.sqr) ;
			`uvm_info ("run_phase","Stimulus generation ended ",UVM_LOW); 
			phase.drop_objection(this) ;
		endtask
			
	endclass

endpackage 