vlib work
vlog piso.v tb_p2s.sv +cover
vsim -voptargs=+acc work.p2s -cover
coverage save tb_p2s.ucdb -onexit -du PISO
add wave *
run -all
# quit -sim
# vcover report tb_p2s.ucdb -all -annotate -details -output p2s_cvr.txt