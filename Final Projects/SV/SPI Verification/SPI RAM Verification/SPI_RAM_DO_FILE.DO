vlib work
vlog SPI_RAM_AFTER.sv SPI_RAM_PACKAGE.sv SPI_RAM_INTERFACE.sv SPI_RAM_SVA.sv SPI_RAM_TB.sv SPI_RAM_TOP.sv +cover
vsim -voptargs=+acc work.SPI_RAM_TOP -cover
add wave *
add wave -position insertpoint  \
sim:/SPI_RAM_TOP/r_if/rx_valid \
sim:/SPI_RAM_TOP/r_if/rst_n \
sim:/SPI_RAM_TOP/r_if/din \
sim:/SPI_RAM_TOP/r_if/tx_valid \
sim:/SPI_RAM_TOP/r_if/dout \
sim:/SPI_RAM_TOP/dut_inst/addr_rd \
sim:/SPI_RAM_TOP/dut_inst/addr_wr \
sim:/SPI_RAM_TOP/dut_inst/mem
add wave /SPI_RAM_TOP/dut_inst/SVA_inst/tx_asser_11 /SPI_RAM_TOP/dut_inst/SVA_inst/tx_asser_00_01 /SPI_RAM_TOP/dut_inst/SVA_inst/tx_asser_10
coverage save SPI_RAM_TOP.ucdb -onexit
run -all
# quit -sim
# vcover report SPI_RAM_TOP.ucdb -details -annotate -all -output RAM_FC_Code_Assertion_Coverage_Rprt.txt