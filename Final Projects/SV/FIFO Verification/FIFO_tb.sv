import shared_pkg ::*;

import FIFO_transaction_pkg ::*;

module FIFO_tb(FIFO_if.TEST if_obj);

FIFO_transaction obj_test ;       // create obj from the class to randomize it

// we choose these certain values to make the overall iteration = 10,000
localparam MIXED_TESTS = 9933;    
localparam WRITE_TESTS = 40;      
localparam READ_TESTS = 25;

initial begin
	obj_test = new();

//-------initially reset the FIFO for 2 clk cycles--------
if_obj.rst_n = 0;   
repeat(2) @(negedge if_obj.clk); 
if_obj.rst_n = 1;

//--------first loop to write only inside the FIFO--------
obj_test.constraint_mode(0);
obj_test.write_only.constraint_mode(1);
repeat(WRITE_TESTS) begin
	assert(obj_test.randomize());
	if_obj.rst_n = obj_test.rst_n ;
	if_obj.rd_en = obj_test.rd_en ;
	if_obj.wr_en = obj_test.wr_en ;
	if_obj.data_in = obj_test.data_in ;
	@(negedge if_obj.clk);
end

//---------Second loop to read only from the FIFO---------
obj_test.constraint_mode(0);
obj_test.read_only.constraint_mode(1);
obj_test.data_in.rand_mode(0);   // we disable the randomization for the data_in as in the read mode we don't need it
repeat(READ_TESTS) begin
	assert(obj_test.randomize());
	if_obj.rst_n = obj_test.rst_n ;
	if_obj.rd_en = obj_test.rd_en ;
	if_obj.wr_en = obj_test.wr_en ;
	if_obj.data_in = obj_test.data_in ;
	@(negedge if_obj.clk);
end

//----------Third loop for mixed operations(read & write) inside FIFO--------
obj_test.constraint_mode(1);
obj_test.data_in.rand_mode(1);   // Again , we enable the data_in for write operation
obj_test.read_only.constraint_mode(0);
obj_test.write_only.constraint_mode(0);
repeat(MIXED_TESTS) begin
	assert(obj_test.randomize());
	if_obj.rst_n = obj_test.rst_n ;
	if_obj.rd_en = obj_test.rd_en ;
	if_obj.wr_en = obj_test.wr_en ;
	if_obj.data_in = obj_test.data_in ;
	@(negedge if_obj.clk);
end

test_finished = 1 ;    // End of the test stimulus

end   // end of the initial block

endmodule