import ram_test_pkg::*;
import uvm_pkg::*;
import ram_config_pkg::*;
`include "uvm_macros.svh"
module top();
 bit clk;
 initial begin
    clk=0;
    forever #1 clk=!clk;
 end   

 ram_if ramif(clk);
project_ram dut (ramif.din, ramif.rx_valid, ramif.dout, ramif.tx_valid, ramif.clk, ramif.rst_n);
 bind project_ram SPI_RAM_SVA SVA_inst(ramif.din, ramif.rx_valid, ramif.tx_valid, ramif.clk);
 initial begin
   uvm_config_db#(virtual ram_if)::set(null,"uvm_test_top","ram_IF",ramif);
    run_test("ram_test");
 end
endmodule
