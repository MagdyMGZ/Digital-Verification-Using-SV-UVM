vlib work
vlog counter.v counter_tb.sv +cover
vsim -voptargs=+acc work.counter_tb -cover
coverage save counter_tb.ucdb -onexit -du work.up_counter
add wave *
run -all
# quit -sim
# vcover report counter_tb.ucdb -all -annotate -details -output counter_cvr.txt