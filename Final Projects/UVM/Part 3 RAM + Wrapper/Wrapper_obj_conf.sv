package Wrapper_config_obj ;
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	class Wrapper_config_obj extends uvm_object ;
		`uvm_object_utils(Wrapper_config_obj)

		virtual Wrapper_if Wrapper_config_vif;
		uvm_active_passive_enum active ;

		function new(string name ="Wrapper_config_obj");
			super.new(name);
		endfunction 
	endclass
	
endpackage 			