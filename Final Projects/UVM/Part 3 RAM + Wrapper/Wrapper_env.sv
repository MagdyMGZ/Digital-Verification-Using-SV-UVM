package Wrapper_env ;

	import uvm_pkg::*;
	`include "uvm_macros.svh"
	import Wrapper_agent ::* ;
	import Wrapper_config_obj ::* ;
	import Wrapper_scoreboard ::*;
	import Wrapper_coverage::*;

	class Wrapper_env extends uvm_env ;
		`uvm_component_utils(Wrapper_env) ;

		Wrapper_agent agt ;
		Wrapper_scoreboard sb ;
		coverage cov ;

		function new(string name = "Wrapper_env", uvm_component parent = null );
			super.new(name,parent);
		endfunction

		function void build_phase(uvm_phase phase);
		 	super.build_phase(phase);
		 	agt = Wrapper_agent::type_id::create("agt",this);
		 	sb= Wrapper_scoreboard::type_id::create("sb",this);
		 	cov = coverage ::type_id::create("cov",this) ;
		endfunction 

		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			agt.agt_ap.connect(sb.sb_export);
			agt.agt_ap.connect(cov.cov_export);
		endfunction 	
	endclass 
endpackage 			