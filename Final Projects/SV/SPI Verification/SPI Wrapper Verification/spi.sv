module SPI (MOSI,MISO,SS_n,clk,rst_n,rx_valid,rx_data,tx_valid,tx_data);
//defining states
parameter IDLE=3'b000;
parameter CHK_CMD=3'b001;
parameter WRITE=3'b010;
parameter READ_ADD=3'b011;
parameter READ_DATA=3'b100;
//input output decleration
input MOSI,SS_n,clk,rst_n,tx_valid;
input [7:0]tx_data;
output reg MISO,rx_valid;
output reg [9:0]rx_data;
//additional signals needed during operation
reg flag,counter_rst_n;
reg [2:0] cs,ns;
wire dout;
wire [9:0]din;
wire [3:0]counter_out;
//SIPO instan.
SIPO shift_reg(clk,MOSI,din);
//up_counter SIPO instan.
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
always @(cs,MOSI,SS_n) begin
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
always @(posedge clk) begin

if (cs==CHK_CMD) begin
counter_rst_n <= 1'b0;
end
else
counter_rst_n <= 1'b1;

if ((cs==WRITE||cs==READ_ADD)&&SS_n==0) begin
if (counter_out == 4'd9) begin
rx_valid<=1;
rx_data<=din;
end
end
else if ((cs==WRITE||cs==READ_ADD)&&SS_n==1) begin
rx_valid<=0;
end

else if (cs==READ_DATA&&SS_n==0) begin
if (counter_out == 4'd9) begin
rx_valid<=1;
rx_data<=din;
end
MISO <= dout;
end
else if (cs==READ_DATA&&SS_n==1) begin
rx_valid<=0;
end

end
endmodule
