module FIFO(FIFO_if.DUT if_obj);

// declaration of max. FIFO address
localparam max_fifo_addr = $clog2(if_obj.FIFO_DEPTH);   // max_fifo_addr = 3

// declaration of Memory (FIFO)
reg [if_obj.FIFO_WIDTH-1:0] mem [if_obj.FIFO_DEPTH-1:0];

// Declaration of read & write pointers
reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;          
reg [max_fifo_addr:0] count;              // extra bit to distinguish between full & empty flags & it represents the fill level of the FIFO

// always block specialized for writing operation
always @(posedge if_obj.clk or negedge if_obj.rst_n) begin
	if (!if_obj.rst_n) begin
		wr_ptr <= 0;
		if_obj.overflow <= 0;
		if_obj.wr_ack <= 0;             // reset the sequential outputs as wr_ack , overflow
	end
	else if (if_obj.wr_en && count < if_obj.FIFO_DEPTH) begin
		mem[wr_ptr] <= if_obj.data_in;
		if_obj.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
	end
	else begin 
		if_obj.wr_ack <= 0; 
		if (if_obj.full && if_obj.wr_en)
			if_obj.overflow <= 1;
		else
			if_obj.overflow <= 0;
	end
end

// always block specialized for reading operation
always @(posedge if_obj.clk or negedge if_obj.rst_n) begin
	if (!if_obj.rst_n) begin
		rd_ptr <= 0;
		if_obj.underflow <= 0;
		if_obj.data_out <= 0;       // reset the sequential outputs as data_out , underflow
	end
	else if (if_obj.rd_en && count != 0) begin
		if_obj.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
		end
	else
	begin
		if(if_obj.empty && if_obj.rd_en)
			if_obj.underflow  <= 1;
		else
			if_obj.underflow  <= 0;
	end
end

// always block specialized for counter signal
always @(posedge if_obj.clk or negedge if_obj.rst_n) begin
	if (!if_obj.rst_n) begin
		count <= 0;
	end
	else begin
		if	( ({if_obj.wr_en, if_obj.rd_en} == 2'b10) && !if_obj.full) 
			count <= count + 1;
		else if ( ({if_obj.wr_en, if_obj.rd_en} == 2'b01) && !if_obj.empty)
			count <= count - 1;
		else if (({if_obj.wr_en, if_obj.rd_en} == 2'b11) && if_obj.full)      // priority for write operation
			count <= count - 1;
		else if (({if_obj.wr_en, if_obj.rd_en} == 2'b11) && if_obj.empty)      // priority for read operation
			count <= count + 1;
	end
end

// continous assignment for the combinational outputs
assign if_obj.full = (count == if_obj.FIFO_DEPTH)? 1 : 0;            
assign if_obj.empty = (count == 0)? 1 : 0;                  
assign if_obj.almostfull = (count == if_obj.FIFO_DEPTH-1)? 1 : 0;           
assign if_obj.almostempty = (count == 1)? 1 : 0;

// Assertions to the DUT
//`ifdef SIM

property p1;
@(posedge if_obj.clk) disable iff(!if_obj.rst_n) (if_obj.wr_en && !if_obj.full) |=> if_obj.wr_ack ;
endproperty
write_acknowledge : assert property(p1);
write_acknowledge_cover : cover property(p1);

property p2;
@(posedge if_obj.clk) disable iff(!if_obj.rst_n) (if_obj.empty && if_obj.rd_en) |=> if_obj.underflow ;
endproperty
underflow_assertion : assert property(p2);
underflow_cover : cover property(p2);

property p3;
@(posedge if_obj.clk) disable iff(!if_obj.rst_n) (if_obj.full & if_obj.wr_en) |=> if_obj.overflow ;
endproperty
overflow_assertion : assert property(p3);
overflow_cover : cover property(p3);

property p4;
@(posedge if_obj.clk) disable iff(!if_obj.rst_n) (!if_obj.full & if_obj.wr_en & !if_obj.rd_en) |=> (count == $past(count) + 4'b0001 ) ;
endproperty
increment_assertion : assert property(p4);
increment_cover : cover property(p4);

property p5;
@(posedge if_obj.clk) disable iff(!if_obj.rst_n) (!if_obj.empty && if_obj.rd_en && !if_obj.wr_en) |=> (count == $past(count) - 4'b0001 ) ;
endproperty
decrement_assertion : assert property(p5);
decrement_cover : cover property(p5);

property p6;
@(posedge if_obj.clk) disable iff(!if_obj.rst_n) (count == if_obj.FIFO_DEPTH) |-> if_obj.full ;
endproperty
full_assertion : assert property(p6);
full_cover : cover property(p6);

property p7;
@(posedge if_obj.clk) disable iff(!if_obj.rst_n) (count == 0) |-> if_obj.empty ;
endproperty
empty_assertion : assert property(p7);
empty_cover : cover property(p7);

property p8;
@(posedge if_obj.clk) disable iff(!if_obj.rst_n) (count == if_obj.FIFO_DEPTH-1) |-> if_obj.almostfull ;
endproperty
almostfull_assertion : assert property(p8);
almostfull_cover : cover property(p8);

property p9;
@(posedge if_obj.clk) disable iff(!if_obj.rst_n) (count == 1) |-> if_obj.almostempty ;
endproperty
almostempty_assertion : assert property(p9);
almostempty_cover : cover property(p9);

//`endif

endmodule