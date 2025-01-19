module SIPO (clk,SS_n ,MOSI, rx_data); 
input  clk, MOSI,SS_n; 
output [9:0] rx_data; 
reg [9:0] tmp; 
 
  always @(posedge clk) 
  begin
    if(!SS_n) 
    tmp = {tmp[8:0],MOSI}; 
  end 
  assign rx_data = tmp; 
endmodule
//bug if SS_n din still loading values