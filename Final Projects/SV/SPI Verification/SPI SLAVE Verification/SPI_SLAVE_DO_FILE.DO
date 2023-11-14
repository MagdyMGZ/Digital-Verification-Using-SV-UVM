vlib work
vlog SPI_SLAVE_PACKAGE.sv counter.v piso.v sipo.v SPI_SLAVE_AFTER.sv SPI_SLAVE_TB.sv +cover
vsim -voptargs=+acc work.spi_tb -cover
add wave *
coverage save SPI_SLAVE_TB.ucdb -onexit -du work.SPI
run -all
# quit -sim
# vcover report SPI_SLAVE_TB.ucdb -details -annotate -all -output SLAVE_Coverage_Rprt.txt