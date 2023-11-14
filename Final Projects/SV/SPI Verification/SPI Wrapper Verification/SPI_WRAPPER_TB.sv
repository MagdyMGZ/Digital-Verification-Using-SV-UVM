// While Box Verification For SPI_Wrapper Using Golden Model & Self Checking
module SPI_Master_tb ();

reg clk , rst_n , MOSI , SS_n;
wire MISO, MISO_EXP;

spi_wrapper DUT (MOSI,MISO,SS_n,clk,rst_n);
SPI_Wrapper_GOLD DUT_GOLD (MOSI,MISO_EXP,SS_n,clk,rst_n);

// Clock Generation
initial begin
    clk = 0;
    forever
        #5 clk = ~clk; // CLK Period = 10
end

reg [7:0] wr_add, rd_add; 
reg [7:0] wr_data, rd_data;

int error_count = 0;
int correct_count = 0;

// Reset and Initial Values for Inputs
initial begin
    // Test Reset for 5 Cycles
    $display("Test Reset Operation");
    rst_n = 0;
    {wr_add,rd_add,wr_data,rd_data} = 4'b0000;
    repeat(5) begin
        MOSI = $random;
        SS_n = $random;
        // Golden Model Checking
        RESET_CHK();
        @(negedge clk);      
        // Self Checking For Reset
        if ((DUT.spislave.cs !== 0) && (DUT.mem.dout !== 0) && (DUT.mem.tx_valid !== 0) && (DUT.mem.addr_rd !== 0) && (DUT.mem.addr_wr !== 0)) begin
            $display("Reset Operation Doesn't Done Correctly");
            error_count = error_count + 1;
        end
        else begin
            $display("Reset Operation Done Correctly");
            correct_count = correct_count + 1;
        end
    end
    rst_n = 1;

    // Test Each Operation
    $display("Write Address Operation");
    SS_n = 0;   // Start Communication
    @(negedge clk);
    MOSI = 0;
    repeat(3) @(negedge clk);    // Write Address

    repeat (8) begin             // SIPO
        MOSI = $random;
        wr_add = {wr_add[6:0],MOSI};
        @(negedge clk);
    end
    SS_n = 1;   // END Communication
    // Golden Model Checking
    SPI_SLAVE_CHK();
    Wrapper_CHK();
    RAM_CHK();
    @(negedge clk);
    // Self Checking for Write Address Value
    if (DUT.mem.addr_wr == wr_add) begin
        $display("Write Address is Done Correctly");
        correct_count = correct_count + 1;
    end
    else begin
        $display("t: %0d Error in Write Address",$time);
        error_count = error_count + 1;
    end
    @(negedge clk);
    
    $display("Write Data Operation");
    SS_n = 0;
    @(negedge clk);

    MOSI = 0;
    repeat(2) @(negedge clk);        // Write Data
    MOSI = 1;
    @(negedge clk);

    repeat(8) begin                  // SIPO
        MOSI = $random;
        wr_data = {wr_data[6:0],MOSI};
        @(negedge clk);
    end
    SS_n = 1;
    // Golden Model Checking
    SPI_SLAVE_CHK();
    Wrapper_CHK();
    RAM_CHK();
    @(negedge clk);
    // Self Checking for Write Data Value
    if (DUT.mem.mem[DUT.mem.addr_wr] == wr_data) begin
        $display("Write Data is Done Correctly");
        correct_count = correct_count + 1;
    end
    else begin
        $display("t: %0d Error in Write Data",$time);
        error_count = error_count + 1;
    end
    @(negedge clk);

    $display("Read Address Operation");
    SS_n = 0;
    @(negedge clk);
    MOSI = 1;
    repeat(2) @(negedge clk);      // Read Address
    MOSI = 0;
    @(negedge clk);
    
    repeat(8) begin
        MOSI = $random;
        rd_add = {rd_add[6:0],MOSI};        // SIPO
        @(negedge clk);
    end
    SS_n = 1;
    // Golden Model Checking
    SPI_SLAVE_CHK();
    Wrapper_CHK();
    RAM_CHK();
    @(negedge clk);
    // Self Checking for Read Address
    if (DUT.mem.addr_rd == rd_add) begin
        $display("Read Address is Done Correctly");
        correct_count = correct_count + 1;
    end
    else begin
        $display("t: %0d Error in Read Address",$time);
        error_count = error_count + 1;
    end
    @(negedge clk);

    $display("Read Data Operation");
    SS_n = 0;
    @(negedge clk);
    MOSI = 1;
    repeat(3) @(negedge clk);                // Read Data
    
    repeat(8) begin                          
        MOSI = $random; // Dummy Data
        @(negedge clk);
    end
    @(negedge clk);

    repeat(8) begin                       // PISO
        @(negedge clk);
        rd_data = {rd_data[6:0],MISO};
    end

    SS_n = 1;
    // Golden Model Checking
    SPI_SLAVE_CHK();
    Wrapper_CHK();
    RAM_CHK();
    @(negedge clk);
    // Self Checking for Read Address
    if (DUT.mem.mem[DUT.mem.addr_rd] == rd_data) begin
        $display("Read Data is Done Correctly");
        correct_count = correct_count + 1;
    end
    else begin
        $display("Error in Read Data");
        error_count = error_count + 1;
    end
    repeat(2) @(negedge clk);

    $display("----------------------------------------------------");
    $display("The Number of Successful Operation = %0d , Failed Operations = %0d",correct_count,error_count);
    
    $stop;
end

task RESET_CHK();
    @(negedge clk);
    if ((DUT.spislave.cs !== DUT_GOLD.SPI_Slave_inst.cs) && (DUT.mem.dout !== DUT_GOLD.RAM_inst.dout) && (DUT.mem.tx_valid !== DUT_GOLD.RAM_inst.tx_valid) && (DUT.mem.addr_rd !== DUT_GOLD.RAM_inst.Rd_Addr) && (DUT.mem.addr_wr !== DUT_GOLD.RAM_inst.Wr_Addr)) begin
        $display("Design Reset is Wrong");
        error_count = error_count + 1;
    end
    else begin
        $display("Design Reset is Correct");
        correct_count = correct_count + 1;
    end
endtask

task Wrapper_CHK();
    @(negedge clk);
    if (MISO !== MISO_EXP) begin
        $display("Wrapper Design is Wrong");
        error_count = error_count + 1;
    end
    else begin
        $display("Wrapper Design is Correct");
        correct_count = correct_count + 1;
    end
endtask

task SPI_SLAVE_CHK();
    @(negedge clk);
    if ((DUT_GOLD.SPI_Slave_inst.MISO !== DUT.spislave.MISO) && (DUT_GOLD.SPI_Slave_inst.rx_valid !== DUT.spislave.rx_valid) && (DUT_GOLD.SPI_Slave_inst.rx_data !== DUT.spislave.rx_data)) begin
        $display("SPI Slave Design is Wrong");
        error_count = error_count + 1;
    end
    else begin
        $display("SPI Slave Design is Correct");
        correct_count = correct_count + 1;
    end
endtask

task RAM_CHK();
    @(negedge clk);
    if ((DUT_GOLD.RAM_inst.dout !== DUT.mem.dout) && (DUT_GOLD.RAM_inst.tx_valid !== DUT.mem.tx_valid)) begin
        $display("RAM Design is Wrong");
        error_count = error_count + 1;
    end
    else begin
        $display("RAM Design is Correct");
        correct_count = correct_count + 1;
    end
endtask

initial
$monitor("time = %0d, MOSI = %b, MISO = %b, SS_n = %b, clk = %b, rst_n = %b, rx_data = %d, rx_valid = %b, tx_data = %d, tx_valid = %b",$time,MOSI,MISO,SS_n,clk,rst_n,DUT.rx_data,DUT.rx_valid,DUT.tx_data,DUT.tx_valid);

endmodule