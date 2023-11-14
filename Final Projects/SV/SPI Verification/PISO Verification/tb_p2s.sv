module p2s ();
    logic serial_out,begin_flag,gserial_out;
    logic [7:0] parallel_in;
    bit clk;
    integer err;
    bit[3:0] counter;

always @(posedge clk)begin
    counter++;
    if(counter=='d10)
        counter<=0;
end


PISO DUT(.clk(clk),.tx_valid(begin_flag),.counter(counter),.tx_data(parallel_in),.dout(serial_out));

always #1 clk=~clk;

task chk_p2s();
    if(begin_flag)
        for(int i = 9 ; i >= 0 ; i--) begin
            @(posedge clk);
            gserial_out <= parallel_in[i];
   @(negedge clk);
    if(serial_out!==serial_out)
        begin 
            err++;
            $display("@time=%0t,Expected = %b , found = %b",$time,serial_out,gserial_out);     
        end
        end
endtask

initial begin
    err=0;         
    begin_flag = 0;
    repeat(3) begin
        begin_flag = ~begin_flag;
    repeat(100) begin
        @(negedge clk);
        parallel_in=$random;
        chk_p2s();
    end
end
    #2;
    $display("Test ended with %0d failed",err);
    $stop();
end

endmodule