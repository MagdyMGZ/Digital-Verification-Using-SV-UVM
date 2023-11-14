import SPI_RAM_PACKAGE::*;

module SPI_RAM_TB (RAM_if.TEST r_if);

parameter test_case = 256;

SPI_RAM_CLASS s1 = new();

bit [7:0] dyn_addr []; // dynamic array to carry randmoized addresses
bit [7:0] dyn_data []; // dynamic array to carry randmoized data

logic [7:0] ass_addr_to_data [ bit[7:0] ]; // our reference model

int correct_count = 0;
int error_count = 0;

initial begin
    r_if.rst_n = 1'b1;
    dyn_addr = new[test_case];
    dyn_data = new[test_case];
    r_if.rx_valid = 1;
    r_if.din = 10'bxxxxx_xxxxx; // To Achieve Branch Coverage to be 100 %
    @(negedge r_if.clk);
    r_if.rx_valid = 0;

    for(int i = 0 ; i < test_case ; i++) begin
        assert(s1.randomize());
        dyn_addr[i] = s1.addr;
        dyn_data[i] = s1.data;
        s1.DIN_CHK.sample();
    end

    for(int i = 0 ; i < test_case ; i++) begin
        ass_addr_to_data[dyn_addr[i]] = dyn_data[i];
    end

    RST();
    WRITE_TASK();
    @(negedge r_if.clk);
    READ_CHECK_TASK();
    $display("----------------------------------------------------");
    $display("the number of successful reading operations = %0d " , correct_count);
    $display("the number of failed reading operations = %0d " , error_count);

    $stop;
end

task RST();
    @(negedge r_if.clk);
    r_if.rst_n = 1'b0;
    @(negedge r_if.clk);
    if((r_if.dout === 0) && (r_if.tx_valid === 0) && (dut_inst.addr_rd === 0) && (dut_inst.addr_wr === 0)) begin
        $display("Reset Operation Done Correctly");
        correct_count = correct_count + 1;
    end
    else begin
        $display("Reset Operation Doesn't Done Correctly");
        error_count = error_count + 1;
    end
    r_if.rst_n = 1'b1;
endtask

task WRITE_TASK();
    r_if.rx_valid = 1'b1;
    for(int i = 0 ; i < test_case ; i++) begin
        r_if.din = { 2'b00,dyn_addr[i] };
        @(negedge r_if.clk);
        r_if.din = { 2'b01,dyn_data[i] };
        @(negedge r_if.clk);
    end
    r_if.rx_valid = 1'b0;
endtask

task READ_CHECK_TASK();
    r_if.rx_valid = 1'b1;
    for(int i = 0 ; i < test_case ; i++) begin
        r_if.din = { 2'b10,dyn_addr[i] };
        @(negedge r_if.clk);
        r_if.din = { 2'b11,8'b11111111 };
        @(posedge r_if.tx_valid);
        if( r_if.dout === ass_addr_to_data[dyn_addr[i]] ) begin
            $display("successful reading");
            correct_count = correct_count + 1;
        end
        else begin
            $display("failed reading");
            error_count = error_count + 1;
        end
        @(negedge r_if.clk);
    end
endtask

endmodule