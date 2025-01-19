module spi_wrapper(mosi, miso, ss_n, clk, rst_n);
input mosi, ss_n, clk, rst_n;
output miso;
wire rx_valid, tx_valid;
wire [9:0] rx_data;
wire [7:0] tx_data;
SPI spislave(mosi,miso,ss_n,clk,rst_n,rx_valid,rx_data,tx_valid,tx_data);
project_ram mem(rx_data, rx_valid, tx_data, tx_valid, clk, rst_n);

endmodule
