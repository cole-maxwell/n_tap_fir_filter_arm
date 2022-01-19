transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/coleh/Desktop/reconfigurable_computing/projects/n_tap_fir_filter/rtl {C:/Users/coleh/Desktop/reconfigurable_computing/projects/n_tap_fir_filter/rtl/fir_tap.sv}
vlog -sv -work work +incdir+C:/Users/coleh/Desktop/reconfigurable_computing/projects/n_tap_fir_filter/rtl {C:/Users/coleh/Desktop/reconfigurable_computing/projects/n_tap_fir_filter/rtl/fir.sv}
vlib arm_hps
vmap arm_hps arm_hps

