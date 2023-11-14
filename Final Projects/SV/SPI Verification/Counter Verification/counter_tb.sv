module counter_tb ();

reg clk, rst_n;
wire [3:0] counter;

up_counter c1 (.*);

// Clock Generation
initial begin
    clk = 0;
    forever 
        #1 clk = ~clk;
end

initial begin
    // Reset and Initial Values for inputs
    rst_n = 0;
    #50 rst_n = 1;
    #100;
    rst_n = 0;
    #4;
    $stop;
end

endmodule