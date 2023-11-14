module SIPO (clk,SS_n ,MOSI, rx_data); 
input  clk, MOSI,SS_n; 
output [9:0] rx_data; 
reg [9:0] tmp; 
 
  always @(posedge clk) 
  begin
    if(!SS_n)  //In case the Master shuts the communication , rx_data should remain (Corner Case) [May be a Bug]
        tmp = {tmp[8:0],MOSI}; 
  end 
  assign rx_data = tmp; 
endmodule
