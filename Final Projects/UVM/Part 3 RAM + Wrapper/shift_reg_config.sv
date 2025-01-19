package ram_config_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
class ram_config extends uvm_object;
`uvm_object_utils(ram_config);
uvm_active_passive_enum active ;
virtual ram_if ramif;
    function new(string name ="ram_config");
     super.new(name);   
    endfunction 
    endclass 
    
endpackage