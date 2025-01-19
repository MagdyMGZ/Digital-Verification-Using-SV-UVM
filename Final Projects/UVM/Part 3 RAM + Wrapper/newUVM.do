vlib work
vlog -f src_files.list -sv +cover
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -coverage
add wave -position insertpoint  \
sim:/top/DUT/spislave/MOSI \
sim:/top/DUT/spislave/SS_n \
sim:/top/DUT/spislave/clk \
sim:/top/DUT/spislave/rst_n \
sim:/top/DUT/spislave/tx_valid \
sim:/top/DUT/spislave/tx_data \
sim:/top/DUT/spislave/MISO \
sim:/top/DUT/spislave/rx_valid \
sim:/top/DUT/spislave/rx_data \
sim:/top/DUT/spislave/g \
sim:/top/DUT/spislave/flag \
sim:/top/DUT/spislave/counter_rst_n \
sim:/top/DUT/spislave/cs \
sim:/top/DUT/spislave/ns \
sim:/top/DUT/spislave/din \
sim:/top/DUT/spislave/counter_out
coverage save ALSU_tb.ucdb -onexit
run -all 
#quit -sim
#vcover report ALSU_tb.ucdb  -details -annotate -all -output Final_covr.txt
