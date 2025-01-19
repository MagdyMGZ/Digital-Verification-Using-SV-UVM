package squencer_pkg;
import uvm_pkg::*;
import squence_item_pkg::*;
`include "uvm_macros.svh"
  class ram_squencer extends uvm_sequencer #( ram_seq_item) ;
`uvm_component_utils(ram_squencer) 
function  new(string name = "ram_squencer",uvm_component parent =null);
super.new(name,parent);    
endfunction   
  endclass  
endpackage