package squence_item_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
class ram_seq_item extends uvm_sequence_item;
`uvm_object_utils(ram_seq_item)
rand bit [9:0] din;
rand bit rx_valid,rst_n;
bit [7:0] dout;
bit tx_valid;
function  new(string name ="ram_seq_item");
super.new(name);
endfunction    
function string convert2string();
    return $sformatf("%s rst_n=0b%0b din=0b%0b rx_valid =0b%0b dout =0b%0b  tx_valid=0b%0b ",super.convert2string(),rst_n,din,rx_valid,dout,tx_valid);
endfunction

function string convert2string_stimulus();
    return $sformatf("rst_n=0b%0b din=0b%0b rx_valid =0b%0b ",rst_n,din,rx_valid);
endfunction
    constraint write_only{
rx_valid dist {1:=90,0:=10};
rst_n dist {1:=98,0:=2};
din[9:8] inside {2'b00,2'b01};
    }
        constraint read_only{
rx_valid dist {1:=90,0:=10};
rst_n dist {1:=98,0:=2};
din[9:8] inside {2'b10,2'b11};
    }
            constraint read_and_write{
rx_valid dist {1:=90,0:=10};
rst_n dist {1:=98,0:=2};
    }
endclass
endpackage