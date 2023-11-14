// No Bugs
module SIPO (clk, MOSI, rx_data); 
input  clk, MOSI; 
output [9:0] rx_data; 
reg [9:0] tmp; 
  always @(posedge clk) 
  begin 
    tmp = {tmp[8:0],MOSI}; 
  end 
  assign rx_data = tmp; 
endmodule
