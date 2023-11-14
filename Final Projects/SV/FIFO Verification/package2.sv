// FIFO Package 2
package FIFO_coverage_pkg ;

import FIFO_transaction_pkg ::*;

class FIFO_coverage;

FIFO_transaction F_cvg_txn ;

function void sample_data (input FIFO_transaction F_txn );

F_cvg_txn = F_txn ;

cg.sample();

endfunction

covergroup cg ;

// Here we create cover point for each signal to be used in the cross coverage
wr_en_cp : coverpoint F_cvg_txn.wr_en;
rd_en_cp : coverpoint F_cvg_txn.rd_en;
wr_ack_cp : coverpoint F_cvg_txn.wr_ack;
full_cp	: coverpoint F_cvg_txn.full;
empty_cp : coverpoint F_cvg_txn.empty;
almostfull_cp : coverpoint F_cvg_txn.almostfull;
almostempty_cp : coverpoint F_cvg_txn.almostempty;
overflow_cp	: coverpoint F_cvg_txn.overflow;
underflow_cp : coverpoint F_cvg_txn.underflow;

// Here we create cross coverage for each output with read enable & write enable except(dout)
wr_rd_wr_ack_cross : cross wr_en_cp , rd_en_cp , wr_ack_cp 
		{ 
			ignore_bins write_active_with_wr_ack = ! binsof(wr_en_cp) intersect {1} && binsof(wr_ack_cp) intersect {1};
			ignore_bins read_write_active_with_wr_ack = ! binsof(wr_en_cp) intersect {1} && binsof(rd_en_cp) intersect {1} && binsof(wr_ack_cp) intersect {1}; 
		}

wr_rd_full_cross : cross wr_en_cp , rd_en_cp , full_cp 
		{ 
			ignore_bins write_active_with_full = ! binsof(wr_en_cp) intersect {1} && binsof(full_cp) intersect {1};
			ignore_bins read_active_with_full = binsof(rd_en_cp) intersect {1} && binsof(full_cp) intersect {1};
		}

wr_rd_empty_cross : cross wr_en_cp , rd_en_cp , empty_cp 
		{ 
			ignore_bins read_active_with_empty = ! binsof(rd_en_cp) intersect {1} && binsof(empty_cp) intersect {1};
		}

wr_rd_overflow_cross : cross wr_en_cp , rd_en_cp , overflow_cp 
		{ 
			ignore_bins write_active_with_overflow = ! binsof(wr_en_cp) intersect {1} && binsof(overflow_cp) intersect {1}; 
		}

wr_rd_underflow_cross : cross wr_en_cp , rd_en_cp , underflow_cp 
		{ 
			ignore_bins read_active_with_underflow = ! binsof(rd_en_cp) intersect {1} && binsof(underflow_cp) intersect {1};  
		}

wr_rd_almostfull_cross : cross wr_en_cp , rd_en_cp , almostfull_cp 
		{ 
			ignore_bins write_active_with_almostfull = ! binsof(wr_en_cp) intersect {1} && binsof(almostfull_cp) intersect {1};
			ignore_bins read_write_active_with_almostfull = ! binsof(wr_en_cp) intersect {1} && binsof(rd_en_cp) intersect {1} && binsof(almostfull_cp) intersect {1};  
		}

wr_rd_almostempty_cross : cross wr_en_cp , rd_en_cp , almostempty_cp
		{ 
			ignore_bins read_active_with_almostempty = ! binsof(rd_en_cp) intersect {1} && binsof(almostempty_cp) intersect {1};
			ignore_bins read_write_active_with_almostempty = ! binsof(wr_en_cp) intersect {1} && binsof(rd_en_cp) intersect {1} && binsof(almostempty_cp) intersect {1};
		}

endgroup

function new();
	cg = new ;
	F_cvg_txn = new;
endfunction

endclass

endpackage 