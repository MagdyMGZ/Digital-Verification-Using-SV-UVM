`timescale 1ns/1ns
module SPI_RAM_TOP();
bit clk;

parameter CLK_PERIOD = 10;

initial begin
    clk = 0;
    forever begin
        #(CLK_PERIOD/2)
        clk = ~clk;
    end
end

RAM_if r_if(clk);
SPI_RAM_AFTER dut_inst(r_if);
SPI_RAM_TB tb_inst(r_if);
bind SPI_RAM_AFTER SPI_RAM_SVA SVA_inst(r_if);

endmodule
