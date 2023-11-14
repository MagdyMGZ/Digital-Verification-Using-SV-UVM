vlib work
vlog FIFO_before.sv package1.sv package2.sv package3.sv shared_package.sv FIFO_tb.sv Monitor.sv FIFO_interface.sv top_module.sv +cover
vsim -voptargs=+acc work.TOP -cover 
add wave *
add wave -position insertpoint  \
sim:/TOP/if_obj/data_in \
sim:/TOP/if_obj/rst_n \
sim:/TOP/if_obj/wr_en \
sim:/TOP/if_obj/rd_en \
sim:/TOP/if_obj/data_out \
sim:/TOP/if_obj/wr_ack \
sim:/TOP/if_obj/overflow \
sim:/TOP/if_obj/full \
sim:/TOP/if_obj/empty \
sim:/TOP/if_obj/almostfull \
sim:/TOP/if_obj/almostempty \
sim:/TOP/if_obj/underflow \
sim:/TOP/monitor/obj_score
add wave /TOP/dut/write_acknowledge /TOP/dut/underflow_assertion /TOP/dut/overflow_assertion /TOP/dut/increment_assertion /TOP/dut/decrement_assertion /TOP/dut/full_assertion /TOP/dut/empty_assertion /TOP/dut/almostfull_assertion /TOP/dut/almostempty_assertion
coverage save FIFO_before.ucdb -onexit -du work.FIFO
run -all