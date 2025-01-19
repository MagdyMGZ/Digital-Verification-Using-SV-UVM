vlib work
vlog -f src_files.list -sv +cover
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -coverage
run 0
add wave -position insertpoint sim:/top/DUT/*
coverage save Wrapper_DB.ucdb -onexit
run -all

#quit -sim
#vcover report Wrapper_DB.ucdb -all -annotate -details -output fc_cvr_wrp_rprt.txt