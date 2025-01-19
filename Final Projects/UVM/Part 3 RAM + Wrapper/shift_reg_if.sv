interface ram_if (clk);
  input clk;
  logic rst_n;
  logic rx_valid;
  logic tx_valid;
  logic [9:0] din;
  logic [7:0] dout;

endinterface 