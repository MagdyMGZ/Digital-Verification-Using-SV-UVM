// FIFO Package 3
package FIFO_scoreboard_pkg ;
	
import FIFO_transaction_pkg ::*;

import shared_pkg::*;

class FIFO_scoreboard ;

parameter FIFO_WIDTH = 16 ;
parameter FIFO_DEPTH = 8 ;

bit [FIFO_WIDTH-1 : 0] data_out_ref;      
bit wr_ack_ref, overflow_ref;
bit full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref;
int counter ;      // declared counter to count no. of elements in the queue 
bit [FIFO_WIDTH-1:0] queue[$] ;   // declared queue to check the FIFO 
FIFO_transaction obj = new();     // creation of object from the class

function void comb_flags ();     // void function to evaluate the combinational flags

full_ref = (counter == FIFO_DEPTH)? 1 : 0;     
empty_ref = (counter == 0)? 1 : 0;
almostfull_ref = (counter == FIFO_DEPTH-1)? 1 : 0;         
almostempty_ref = (counter == 1)? 1 : 0;

endfunction 

function void check_data(input FIFO_transaction obj);
	logic	[6:0]	flags_ref , flags_dut;

	reference_model(obj);
	
flags_ref = {wr_ack_ref, overflow_ref, full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref};  // concatenated refrence flags

flags_dut = {obj.wr_ack, obj.overflow, obj.full, obj.empty, obj.almostfull, obj.almostempty, obj.underflow};  // concatenated flags from the obj.

if( (obj.data_out !== data_out_ref) || (flags_dut !== flags_ref) ) begin                                                                           
	$display("at time = %0t , the outputs of the DUT doesn't Match with the Golden model outputs",$time);
	error_count++;
	end
else begin
	correct_count++;
	$display("At time = %0t , The queue = %p",$time,queue);
end

endfunction

function void reference_model(input FIFO_transaction obj_gold);

fork

begin  // first thread (write operation)

if (!obj_gold.rst_n) begin
	wr_ack_ref = 0;
	full_ref = 0;
	almostfull_ref = 0;
	overflow_ref = 0;
	//counter = 0;
	queue.delete();	
end
else if (obj_gold.wr_en && counter < obj_gold.FIFO_DEPTH) begin  
		queue.push_back(obj_gold.data_in) ;
		wr_ack_ref = 1;
	end
	else begin 
		wr_ack_ref = 0; 
		if (full_ref && obj_gold.wr_en)
			overflow_ref = 1;
		else
			overflow_ref = 0;
	end

end  // end of the first thread

begin   // second thread (read operation)

if(!obj_gold.rst_n) begin
	data_out_ref = 0;
	empty_ref = 1;
	almostempty_ref = 0;
	underflow_ref = 0;
end
else if ( obj_gold.rd_en && counter != 0 ) begin   
		data_out_ref = queue.pop_front();
	end
	else begin
		if(empty_ref && obj_gold.rd_en)
			underflow_ref = 1 ;
		else
			underflow_ref = 0 ;
	end                

end  // end of the second thread

join

if(!obj_gold.rst_n) begin
	counter = 0;
end
else if	( ({obj_gold.wr_en, obj_gold.rd_en} == 2'b10) && !full_ref) 
			counter = counter + 1;
		else if ( ({obj_gold.wr_en, obj_gold.rd_en} == 2'b01) && !empty_ref)
			counter = counter - 1;
		else if ( ({obj_gold.wr_en, obj_gold.rd_en} == 2'b11) && full_ref)
			counter = counter - 1;
		else if ( ({obj_gold.wr_en, obj_gold.rd_en} == 2'b11) && empty_ref)
			counter = counter + 1;

comb_flags();    // to get the updated values for the comb. flags

endfunction 


endclass


endpackage 