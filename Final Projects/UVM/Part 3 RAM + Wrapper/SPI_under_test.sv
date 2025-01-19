import Wrapper_pack::*;
module SPI (MOSI,MISO,SS_n,clk,rst_n,rx_valid,rx_data,tx_valid,tx_data);
//defining states
/*parameter IDLE=3'b000;
parameter CHK_CMD=3'b001;
parameter WRITE=3'b010;
parameter READ_ADD=3'b011;
parameter READ_DATA=3'b100;*/
//input output decleration
input MOSI,SS_n,clk,rst_n,tx_valid;
input [7:0]tx_data;
output reg MISO,rx_valid;
output reg [9:0]rx_data;
reg g;
//additional signals needed during operation
reg flag,counter_rst_n;
state_e cs,ns;
wire dout;
wire [9:0]din;
wire [3:0]counter_out;
//SIPO instan.
SIPO shift_reg(clk,rx_valid,MOSI,din);
//up_counter piso instan.
up_counter counter(clk,counter_rst_n,counter_out);
//PISO instan.
PISO shift_regII(clk,tx_valid,counter_out,tx_data,dout);
//state memory
always @(posedge clk or negedge rst_n) begin
 if (~rst_n) 
   cs <= IDLE;
 else
   cs <= ns;
end
//next state logic
always @(cs,MOSI,SS_n) begin //bug : MOSI MUST NOT BE in the sensetivity list !!
case(cs)
  IDLE:begin
    if(!rst_n)
      flag =0 ;
   if(SS_n==0) begin
     ns=CHK_CMD;
   end  
   else
     ns=IDLE;
  end 
  CHK_CMD:
   if(SS_n==1)
     ns=IDLE;
   else if (SS_n==0&&MOSI==0)
     ns=WRITE;
   else if (SS_n==0&&MOSI==1&&flag==0) begin
     ns=READ_ADD;
   end
   else begin
     ns=READ_DATA;
     flag=0;
   end
  WRITE:
   if(SS_n==1) begin
     ns=IDLE;
   end
   else
     ns=WRITE;
  READ_ADD:
   if(SS_n==1) begin
     ns=IDLE;
     flag=1;
   end
   else
     ns=READ_ADD;
 
default:   
  if(SS_n==1)
     ns=IDLE;
  else
     ns=READ_DATA;
endcase
end
//output logic
always @(posedge clk or negedge rst_n) begin
if(!rst_n)
begin
rx_valid<=0;
rx_data<=0;  
MISO<=0;// the mOSI MUST RESET TOO !
end
else
begin
  if (ns==CHK_CMD) begin//THE CONDITIONING MUST BE ON THE ns not cs
counter_rst_n <= 1'b0;
end
else
counter_rst_n <= 1'b1;
if(cs==IDLE)
g=0;
if (((cs==WRITE)||(cs==READ_ADD))&&(!SS_n)) begin 
if (counter_out == 4'd9 && (g==0)) begin
rx_valid<=1;
rx_data<=din;
g=1;
end
end
else if ((cs==WRITE||cs==READ_ADD)&&SS_n==1) begin
rx_valid<=0;
end

else if (cs==READ_DATA&&SS_n==0) begin
if (counter_out == 4'd9 &&(g==0)) begin
rx_valid<=1;
rx_data<=din;
g=1;
end
MISO <= dout;
end
else if (cs==READ_DATA&&SS_n==1) begin
rx_valid<=0;
end
end
//rx_valid must be 0 at the SS_N=1;


end
endmodule