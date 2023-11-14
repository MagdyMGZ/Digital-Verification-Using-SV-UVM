module tb_s2p ();
    bit clk;
    logic serial_in;
    logic [9:0] parallel_out;
    bit [9:0] parallel_g;
    integer err,correct;

SIPO DUT(.clk(clk),.MOSI(serial_in),.rx_data(parallel_out));

always #1 clk = ~clk;

task gmodel ();
    @(posedge clk);
    parallel_g <= {parallel_g,serial_in};
endtask

task chk_s2p();
    @(negedge clk);
    if(parallel_g!==parallel_out)begin
        err++;
        $display("(@ Time = %0t) : Expected = %b , Found = %b ",$time,parallel_out,parallel_g);
    end
    else correct++;
endtask

initial begin
    err=0; correct=0;
    repeat(100) begin //10 samples
        repeat(10)begin //10 MOSI bits (Counter is reponsible to constraint the clock cycles)\
            @(negedge clk);
            serial_in = $random;
            gmodel();
        end 
        chk_s2p();
    end
   #2;
   $display("Test ended with %0d passed & %0d errors",correct,err);
   $stop(); 
end

endmodule 