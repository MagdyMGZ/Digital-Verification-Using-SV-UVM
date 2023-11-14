import spi_pkg::*;
module spi_tb();
    logic clk,rst_n;
    logic SS_n;
    logic MOSI;
    logic MISO;
    logic [9:0]rx_data;
    logic rx_valid;
    logic [7:0] tx_data;
    logic [9:0] temp;
    logic [10:0] temp_o;
    logic tx_valid;
    spi_random z;
    SPI dut (MOSI,MISO,SS_n,clk,rst_n,rx_valid,rx_data,tx_valid,tx_data);
initial begin
    clk=0;
    forever begin
     #1 clk=!clk;   
    end
end
initial begin
    z=new();
    @(negedge clk) rst_n=0;
 @(negedge clk)    check_rst_n();
    @(negedge clk) rst_n=1;
   @(negedge clk) write_command_test();
    @(negedge clk) read_address_test();
    @(negedge clk) rst_n=0; z.rst_n=0;
    refrence_model(z);
     @(negedge clk) rst_n=1;
     z.rst_n=1;
     refrence_model(z);
        ////////random testing:
    repeat(10000)    begin
 @(negedge clk) 
 z.randomize();
     rst_n=z.rst_n;
     SS_n=z.SS_n;
     tx_data=0;
     tx_valid=0;
     temp_o=0;
     refrence_model(z);
    for (int i=10; i>=0; i--) begin
        MOSI=z.data[i];
        @(negedge clk);
        temp_o[i]=MOSI;
    end

@(negedge clk);
if((rx_valid !== z.rx_valid)||(rx_data!==z.rx_data))
begin
    $display("error in rx_valid and rx_data (randomisation) !");
    $stop;
end
z.SS_n=1;
SS_n=1;
refrence_model(z);
    end
$stop;    
end
task  check_rst_n();
 if(rst_n)
begin
if(MISO!==0)
$display("error in the reset operation of MISO at %t",$time);
if(rx_data!==0)
$display("error in the reset operation of rx_data at %t",$time);
if(rx_valid!==0)
$display("error in the reset operation of rx_data at %t",$time);
    end
endtask 
task write_command_test();
SS_n=0;
MOSI=0;  
repeat(2)@(negedge clk)MOSI=0;  
repeat(8)@(negedge clk)MOSI=1;
repeat(2)@(negedge clk);
SS_n=1;
if(rx_valid!==1)
$display("error in rx_valid write operation at %t",$time);
if(rx_data!==10'b0011111111)
$display("error in rx_data write operation at %t",$time);
@(negedge clk)
MOSI=0;  
repeat(2)@(negedge clk)MOSI=0;  
repeat(8)@(negedge clk)MOSI=!MOSI;
if(rx_valid!==0)
$display("error in rx_valid write operation at %t",$time);
if(rx_data!==10'b0011111111)
$display("error in rx_data write operation at %t",$time);
endtask
////////////////////
task read_address_test();
SS_n=0;
MOSI=1;  
repeat(2)begin
    @(negedge clk)MOSI=0;
    temp={temp[8:0],MOSI}; 
end  
repeat(8)@(negedge clk)begin
  MOSI=$random;
  temp={temp[8:0],MOSI}; 
end
repeat(2)@(negedge clk);
SS_n=1;
if(rx_valid!==1)
$display("error in rx_valid write operation at %t",$time);
if(rx_data!==temp)
$display("error in rx_data write operation at %t",$time);
@(negedge clk)
MOSI=0; 
repeat(2)begin
    @(negedge clk)MOSI=0;
    temp={temp[8:0],MOSI}; 
end  
repeat(8)@(negedge clk)begin
  MOSI=$random;
  temp={temp[8:0],MOSI}; 
end
if(rx_valid!==0)
$display("error in rx_valid read_address_operation operation at %t",$time);
if(rx_data==temp)
$display("error in rx_data read_address_operation at %t",$time);
endtask
///////////////////////////////////////////////////////////
task read_data_test();
SS_n=0;
MOSI=1;  
repeat(2)begin
    @(negedge clk)MOSI=0;
    temp={temp[8:0],MOSI}; 
end  
repeat(8)@(negedge clk)begin
  MOSI=$random;
  temp={temp[8:0],MOSI}; 
end
repeat(2)@(negedge clk);
SS_n=1;
if(rx_valid!==1)
$display("error in rx_valid write operation at %t",$time);
if(rx_data!==temp)
$display("error in rx_data write operation at %t",$time);
@(negedge clk)
MOSI=0; 
repeat(2)begin
    @(negedge clk)MOSI=0;
    temp={temp[8:0],MOSI}; 
end  
repeat(8)@(negedge clk)begin
  MOSI=$random;
  temp={temp[8:0],MOSI}; 
end
if(rx_valid!==0)
$display("error in rx_valid read_data operation at %t",$time);
if(rx_data==temp)
$display("error in rx_data read_data operation at %t",$time);
endtask 
task refrence_model(input spi_random  x);
    if(!x.rst_n)
    begin
        x.rx_valid=0;
        x.rx_data=0;
        x.MISO=0;
    end
    else begin
        if(!x.SS_n)
        begin
            if(x.data[10:8]==3'b000)
            begin
        x.rx_data=x.data[9:0];
            x.rx_valid=1;    
            end
              if(x.data[10:8]==3'b001)
            begin
            x.rx_data=x.data[9:0];
            x.rx_valid=1;    
            end
               if(x.data[10:8]==3'b110)
            begin
         x.rx_data=x.data[9:0];
            x.rx_valid=1;    
            end
        if(x.data[10:8]==3'b111)
            begin
         x.rx_data=x.data[9:0];
         x.rx_valid=1;    
            end
        end else begin
            x.rx_valid=0;
        end
    end
      x.cvr_grp2.sample();
endtask
endmodule