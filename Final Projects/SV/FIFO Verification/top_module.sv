module TOP;

bit clk ;
initial begin
	clk = 0;
	forever begin
		#25;
		clk = ~clk;
	end 
end

FIFO_if if_obj(clk);

FIFO dut (if_obj);

FIFO_tb TB (if_obj);

FIFO_monitor monitor(if_obj);

endmodule