// FIFO Package 1
package FIFO_transaction_pkg ;

class FIFO_transaction;

parameter FIFO_WIDTH = 16 ;
parameter FIFO_DEPTH = 8 ;

rand bit [FIFO_WIDTH-1:0] data_in;
rand bit rst_n, wr_en, rd_en;
logic [FIFO_WIDTH-1:0] data_out;
logic wr_ack, overflow;
logic full, empty, almostfull, almostempty, underflow;

// weighted dist. for the read & write enables
int WR_EN_ON_DIST = 70 ;
int RD_EN_ON_DIST = 30 ;

// constraint blocks for the read_enable & write_enable & reset
constraint c_reset { rst_n dist{ 0:/2 , 1:/98 }; }

constraint c_write { wr_en dist { 0:/(100-WR_EN_ON_DIST)  , 1:/(WR_EN_ON_DIST) }; }

constraint c_read { rd_en dist { 0:/(100-RD_EN_ON_DIST) , 1:/(RD_EN_ON_DIST) }; }

// Additional constraint block for write operation only
constraint write_only { rst_n == 1;  wr_en == 1;  rd_en == 0; } 

// Additional constraint block for read operation only
constraint read_only { rst_n == 1;  wr_en == 0;  rd_en == 1; } 


endclass

endpackage 