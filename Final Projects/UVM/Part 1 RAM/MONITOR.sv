package monitor_pkg;
import squence_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class ram_monitor extends uvm_monitor;
`uvm_component_utils(ram_monitor)
virtual ram_if ramif;
ram_seq_item rsp_seq_item;
uvm_analysis_port #(ram_seq_item) mon_ap;

    function new(string name ="ram_monitor",uvm_component parent=null);
        super.new(name,parent);
        mon_ap=new("mon_ap",this);
    endfunction //new()

    task run_phase(uvm_phase phase);
    super.run_phase(phase);
        forever begin
           rsp_seq_item=ram_seq_item::type_id::create("rsp_seq_item");
           @(negedge ramif.clk);
    rsp_seq_item.din=ramif.din;
    rsp_seq_item.rx_valid=ramif.rx_valid;
    rsp_seq_item.rst_n=ramif.rst_n;
    rsp_seq_item.dout=ramif.dout;
    rsp_seq_item.tx_valid=ramif.tx_valid;
    mon_ap.write(rsp_seq_item);
  `uvm_info("run_phase",rsp_seq_item.convert2string(),UVM_HIGH)
        end
    endtask
endclass //className extends superClass    
endpackage