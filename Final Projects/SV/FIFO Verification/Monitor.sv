import shared_pkg ::*;

import FIFO_transaction_pkg ::*;   

import FIFO_coverage_pkg ::*;     

import FIFO_scoreboard_pkg ::*;

module FIFO_monitor (FIFO_if.MONITOR if_obj);

// create obj for each class
FIFO_transaction obj_trans ;
FIFO_scoreboard obj_score ;
FIFO_coverage obj_cov ;

initial begin

	obj_trans = new();
	obj_score = new();
	obj_cov = new();

forever begin

	@(negedge if_obj.clk);

	// sample input data
  	obj_trans.data_in = if_obj.data_in ;
  	obj_trans.rst_n = if_obj.rst_n ;
  	obj_trans.wr_en = if_obj.wr_en ;
  	obj_trans.rd_en = if_obj.rd_en ;
  	
  	// sample output data
  	obj_trans.data_out = if_obj.data_out ;
  	obj_trans.wr_ack = if_obj.wr_ack ;
  	obj_trans.overflow = if_obj.overflow ;
  	obj_trans.full = if_obj.full ;
  	obj_trans.empty = if_obj.empty ;
  	obj_trans.almostfull = if_obj.almostfull ;
  	obj_trans.almostempty = if_obj.almostempty ;
  	obj_trans.underflow = if_obj.underflow ;

fork

	begin   // 1st thread
		obj_cov.sample_data(obj_trans);
	end

	begin  // 2nd thread
		@(posedge if_obj.clk);
		#10;                     // small delay to check the data after the output change at the posedge of the clock
		obj_score.check_data(obj_trans);
	end

join

if(test_finished == 1) begin
	$display("Final values stored in the queue = %p ",obj_score.queue);
	$display("no.of error_count :%0d ,no.of correct_count :%0d", error_count , correct_count);
	$stop;
end

end // end of the forever loop

end   // end of the initial block


endmodule