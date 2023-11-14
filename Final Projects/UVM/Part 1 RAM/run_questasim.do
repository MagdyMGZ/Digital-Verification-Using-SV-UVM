vlib work
vlog *v +cover

vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -cover

add wave /top/ramif/*

coverage save top.ucdb -onexit

run -all

# quit -sim
# vcover report top.ucdb -details -annotate -all -output ram_coverage_rpt.txt