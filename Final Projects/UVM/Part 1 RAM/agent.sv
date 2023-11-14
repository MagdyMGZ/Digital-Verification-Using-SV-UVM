package agent_pkg;
`include "uvm_macros.svh"
import uvm_pkg::*;
import squencer_pkg::*;
import ram_config_pkg::*;
import monitor_pkg::*;
import squence_item_pkg:: * ;
import ram_driver_pkg::*;
class ram_agent extends uvm_agent;
`uvm_component_utils(ram_agent)
ram_driver driver;
ram_monitor mon;
 ram_squencer sqr;
ram_config ram_cfg;
uvm_analysis_port #(ram_seq_item) agt_ap;
function  new(string name ="ram_agent",uvm_component parent =null);
    super.new(name,parent);
    agt_ap=new("agt_ap",this);
endfunction
function void build_phase(uvm_phase phase);
super.build_phase(phase);
    if(!uvm_config_db#(ram_config)::get(this,"","CFG",ram_cfg))
    `uvm_fatal("build_phase","unable to get gonfigration object")
    driver=ram_driver::type_id::create("driver",this);
    sqr=ram_squencer::type_id::create("sqr",this);
    mon=ram_monitor::type_id::create("mon",this);
endfunction


function void connect_phase(uvm_phase phase);
    driver.ramif=ram_cfg.ramif;
    mon.ramif=ram_cfg.ramif;
    driver.seq_item_port.connect(sqr.seq_item_export); 
    mon.mon_ap.connect(agt_ap) ;
endfunction
endclass
endpackage