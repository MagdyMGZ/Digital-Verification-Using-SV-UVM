
package ram_env_pkg;
import ram_driver_pkg::*;
import squencer_pkg::*;
import uvm_pkg::*;
import agent_pkg::*;
import squence_item_pkg::*;
import score_board_pkg::*;
import coverage_collector::*;
`include "uvm_macros.svh"
class ram_env extends uvm_env;
 `uvm_component_utils(ram_env)
 ram_coverage cov;
 ram_scoreboard sb;
 ram_agent agt;
   function new(string name = "ram_env", uvm_component parent = null);
      super.new(name, parent);
   endfunction
function void build_phase(uvm_phase phase);
super.build_phase(phase);
agt=ram_agent::type_id::create("agt",this);
sb=ram_scoreboard::type_id::create("sb",this);
cov=ram_coverage::type_id::create("cov",this);
endfunction

function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  agt.agt_ap.connect(sb.sb_export);
  agt.agt_ap.connect(cov.cov_export);   
endfunction
endclass
endpackage
