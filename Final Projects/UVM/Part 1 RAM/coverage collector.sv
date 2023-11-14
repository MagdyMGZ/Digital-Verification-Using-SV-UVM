package coverage_collector;
import uvm_pkg::*;
import squence_item_pkg::*;
`include "uvm_macros.svh"

class ram_coverage extends uvm_component;
    `uvm_component_utils(ram_coverage)
    uvm_analysis_export #(ram_seq_item) cov_export;
    uvm_tlm_analysis_fifo #(ram_seq_item) cov_fifo;
    ram_seq_item seq_item_cov;

    covergroup g;
        din_cp:coverpoint seq_item_cov.din ;
        rx_valid_cp: coverpoint seq_item_cov.rx_valid;
        the_order_cp: coverpoint seq_item_cov.din[9:8]{
            bins read_add={2'b10};
            bins read_data={2'b11};
            bins write_add={2'b00};
           bins write_data={2'b01};
        }
        rst_n_cp:coverpoint seq_item_cov.rst_n;
        the_order_with_rx_valid_cp: cross the_order_cp,rx_valid_cp;
        rx_valid_with_rst_n_cp: cross rx_valid_cp,the_order_cp;
        the_order_with_rst_n_cp:cross the_order_cp, rst_n_cp;

    endgroup

    function  new(string name ="ram_coverage",uvm_component parent =null);
        super.new(name,parent);
        g=new;
    endfunction
    
    function void build_phase( uvm_phase phase);
        super.build_phase(phase);
        cov_export=new("cov_export",this);
        cov_fifo=new("cov_fifo",this); 
    endfunction
function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
cov_export.connect(cov_fifo.analysis_export);    
endfunction
task run_phase(uvm_phase phase);
super.run_phase(phase);
forever
begin
    cov_fifo.get(seq_item_cov);
    g.sample();
end   
endtask
endclass
endpackage