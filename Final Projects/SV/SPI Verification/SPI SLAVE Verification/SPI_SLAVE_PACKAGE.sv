package spi_pkg;
typedef enum  {IDLE,CHK_CMD,WRITE,READ_ADD,READ_DATA} state_e;
class spi_random;
   rand logic SS_n;
   rand logic  [10:0] data;
   rand logic rst_n;
   logic [9:0]rx_data;
   logic rx_valid;
   logic MISO;
constraint c{
SS_n dist{0:=90,1:=10};
rst_n dist{1:=98,0:=2};
data[10:8] inside{3'b111,3'b110,3'b000,3'b001};
}
   covergroup cvr_grp2;
   SS_N_cp:coverpoint SS_n{
      bins high={1};
      bins low={0};
   }
   rst_n_cp:coverpoint rst_n{
      bins active={0};
      bins non_active={1};
   }
   rx_data_cp:coverpoint rx_data[9:8]
   {
bins write_address={2'b00};
bins write_data={2'b01};
bins read_addr={2'b10};
bins read_data={2'b11};
   }

   rx_valid_cp:coverpoint rx_valid{
      bins high={1};
      bins low={0};
   }
rx_valid_with_rst: cross rx_valid_cp,rst_n_cp{   ignore_bins rx_valid_activated_rst=binsof(rx_valid_cp.high)&&binsof(rst_n_cp.active);

}

rx_data_with_rst: cross  rx_data_cp,rst_n_cp{
      ignore_bins rx_data_with_activated_rst=binsof(rx_data_cp)&&binsof(rst_n_cp.active);

}
rx_data_with_SS_N: cross rx_data_cp,SS_N_cp;
   endgroup
   function new();
      cvr_grp2=new;
   endfunction 
endclass 
endpackage