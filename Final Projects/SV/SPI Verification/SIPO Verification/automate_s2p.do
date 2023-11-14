vlib work
vlog sipo.v tb_s2p.sv +cover
vsim -voptargs=+acc work.tb_s2p -cover
coverage save sipo.ucdb -onexit -du SIPO
add wave *
run -all
# quit -sim
# vcover report sipo.ucdb -all -annotate -details -output s2p_cvr.txt