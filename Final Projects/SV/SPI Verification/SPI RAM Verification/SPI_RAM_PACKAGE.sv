package SPI_RAM_PACKAGE;

class SPI_RAM_CLASS;
randc bit [7:0] addr;
rand  bit [7:0] data;

covergroup DIN_CHK;
    // Check That Address will cover all the RAM locations by hitting
    // All addr values [0:255] Increamently Which Excersice All Addresses Values
    addr_cp : coverpoint addr
    {
        bins max_addr = {255};
        bins zero_addr = {0};
        bins others = default;
    }
endgroup

function new;
    DIN_CHK = new();    
endfunction

endclass

endpackage 
