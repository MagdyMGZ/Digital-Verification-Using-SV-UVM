vlib work
vlog GOLD_Single_Port_Async_RAM.sv GOLD_SPI_Slave_Interface.sv GOLD_SPI_Wrapper.sv SPI_WRAPPER_PACKAGE.sv spi_wrapper.sv counter.sv piso.sv sipo.sv SPI_SLAVE_AFTER.sv SPI_RAM_AFTER.sv SPI_WRAPPER_TB.sv +cover
vsim -voptargs=+acc work.SPI_Master_tb -cover
add wave *
coverage save SPI_WRAPPER_TB.ucdb -onexit
run -all
# quit -sim
# vcover report SPI_WRAPPER_TB.ucdb -details -annotate -all -output Wrapper_Coverage_Rprt.txt