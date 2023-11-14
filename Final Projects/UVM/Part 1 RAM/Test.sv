
package ram_test_pkg;
import uvm_pkg::*;
import squence_pkg::*;
import ram_config_pkg::*;
`include "uvm_macros.svh"
import ram_env_pkg::*;
class ram_test extends uvm_test;
  `uvm_component_utils(ram_test)
  ram_env env;
ram_config ram_cfg;
virtual ram_if ramif;
ram_read_and_write_squence read_and_write_seq;
ram_reset_squence reset_seq;
ram_read_squence read_seq;
ram_write_squence write_seq;
  function new(string name, uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = ram_env::type_id::create("env", this);
    ram_cfg=ram_config::type_id::create("alu_cfg",this);
    read_and_write_seq=ram_read_and_write_squence::type_id::create("read_and_write_seq",this);
     read_seq=ram_read_squence::type_id::create("read_seq",this);
       write_seq=ram_write_squence::type_id::create("write_seq",this);
    reset_seq=ram_reset_squence::type_id::create("reset_seq",this);
    if(!uvm_config_db #(virtual ram_if)::get(this,"","ram_IF",ram_cfg.ramif))
    `uvm_fatal("build_phase","test -unable to get the virtual interface of alu from uvm_config_db");
    uvm_config_db#(ram_config)::set(this,"*","CFG",ram_cfg);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    `uvm_info("run_phase","reset_asserted", UVM_LOW);
reset_seq.start(env.agt.sqr);
  `uvm_info("run_phase", "reset_deasserted", UVM_LOW);
  `uvm_info("run_phase", "stimulus_generation_started(write_only)", UVM_LOW);
  write_seq.start(env.agt.sqr);
    `uvm_info("run_phase","stimulus generation finished(write_only)  ", UVM_LOW);
    `uvm_info("run_phase", "stimulus_generation_started(read_only)", UVM_LOW);
  read_seq.start(env.agt.sqr);
    `uvm_info("run_phase","stimulus generation finished(read_only)  ", UVM_LOW);
    
    `uvm_info("run_phase", "stimulus_generation_started(read & write)", UVM_LOW);
  read_and_write_seq.start(env.agt.sqr);
    `uvm_info("run_phase","stimulus generation finished(read & write )  ", UVM_LOW);
    phase.drop_objection(this);
  endtask
endclass
endpackage
