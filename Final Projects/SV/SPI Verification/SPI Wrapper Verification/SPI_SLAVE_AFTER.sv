import spi_pkg::*;
module SPI (MOSI,MISO,SS_n,clk,rst_n,rx_valid,rx_data,tx_valid,tx_data);
input MOSI,SS_n,clk,rst_n,tx_valid;
input [7:0]tx_data;
output reg MISO,rx_valid;
output reg [9:0]rx_data;
reg rx_flag;
//additional signals needed during operation
reg flag,counter_rst_n;
state_e cs,ns; //Replaced it for a more readable transitions
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
always @(cs,SS_n) begin //1st bug : MOSI is included in the sensitivity list 
case(cs)
  IDLE:
   if(SS_n==0)
     ns=CHK_CMD;
   else
     ns=IDLE;
  CHK_CMD:
   if(SS_n==1)
     ns=IDLE;
   else if (SS_n==0&&MOSI==0)
     ns=WRITE;
   else if (SS_n==0&&MOSI==1&&flag==0) begin
     ns=READ_ADD;
   end
   else if (SS_n==0&&MOSI==1&&flag==1) begin
     ns=READ_DATA;
     flag=0;
   end
  WRITE:
   if(SS_n==1) begin
     ns=IDLE;
     flag=0;
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
  READ_DATA:
   if(SS_n==1)
     ns=IDLE;
   else
     ns=READ_DATA;
default: ns=IDLE;
endcase
end
//output logic
always @(posedge clk or negedge rst_n) begin
if(!rst_n)       //2nd bug : We should have reset default for the rx_valid & rx_data otherwise always 'x'
begin                 
rx_valid<=0;
rx_data<=0;  
MISO<=0;              
end
else
begin
  if (ns==CHK_CMD) begin //3rd bug : The output logic is related by the 'ns' not the 'cs'
counter_rst_n <= 1'b0;
end
else
counter_rst_n <= 1'b1;
if(cs==IDLE)
rx_flag=0;
if (((cs==WRITE)||(cs==READ_ADD))&&(!SS_n)) begin 
if (counter_out == 4'd9 && (rx_flag==0)) begin
rx_valid<=1;
rx_data<=din;
rx_flag=1;
end
end
else if ((cs==WRITE||cs==READ_ADD)&&SS_n==1) begin
rx_valid<=0;
end
else if (cs==READ_DATA&&SS_n==0) begin
if (counter_out == 4'd9 &&(rx_flag==0)) begin
rx_valid<=1;
rx_data<=din;
rx_flag=1;
end
MISO <= dout;
end
else if (cs==READ_DATA&&SS_n==1) begin
rx_valid<=0;
end
end
/*
4th bug : rx_valid doesn't fall by the end of the communication
--> Soln: Assign a new flag that checks on rx_valid when high (rx_flag)
*/
end
endmodule