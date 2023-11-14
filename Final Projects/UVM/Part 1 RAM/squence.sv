package squence_pkg;
import uvm_pkg::*;
import squence_item_pkg::*;
`include "uvm_macros.svh"
////////////////////////////////////////////////////////////
class ram_reset_squence extends uvm_sequence;
    `uvm_object_utils(ram_reset_squence)
    function new(string name ="ram_reset_squence");
    super.new(name);    
    endfunction //new()
virtual task body();
ram_seq_item item;
item=ram_seq_item::type_id::create("item");
start_item(item);
item.din=0;
item.rst_n=0;
item.rx_valid=0;
finish_item(item);
endtask
endclass 
//////////////////////////////////////////////////
class ram_write_squence extends uvm_sequence;
    `uvm_object_utils(ram_write_squence)
    function new(string name ="ram_read_write_squence");
    super.new(name);    
    endfunction //new()
virtual task body();
repeat(10000) begin
ram_seq_item item;
item=ram_seq_item::type_id::create("item");
start_item(item);
item.constraint_mode(0);
item.write_only.constraint_mode(1);
assert(item.randomize());
finish_item(item);
end
endtask
endclass  
///////////////////////////////////////////////////////
class ram_read_squence extends uvm_sequence;
    `uvm_object_utils(ram_read_squence)
    function new(string name ="ram_read_write_squence");
    super.new(name);    
    endfunction //new()
virtual task body();
repeat(10000) begin
ram_seq_item item;
item=ram_seq_item::type_id::create("item");
start_item(item);
item.constraint_mode(0);
item.read_only.constraint_mode(1);
assert(item.randomize());
finish_item(item);
end
endtask
endclass  
//////////////////////////////////////////////////////////////////
class ram_read_and_write_squence extends uvm_sequence;
    `uvm_object_utils(ram_read_and_write_squence)
    function new(string name ="ram_read_write_squence");
    super.new(name);    
    endfunction //new()
virtual task body();
repeat(10000) begin
ram_seq_item item;
item=ram_seq_item::type_id::create("item");
start_item(item);
item.constraint_mode(0);
item.read_and_write.constraint_mode(1);
assert(item.randomize());
finish_item(item);
end
endtask
endclass 
endpackage