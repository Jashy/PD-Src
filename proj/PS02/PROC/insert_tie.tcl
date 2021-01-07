###Remove TIE CELLS #############
set tiels [get_cells -hierarchical -filter "is_hierarchical == false && ref_name =~ TIEL*"]
foreach_in_collection cell $tiels {
	set pin [get_pins -of $cell]
	set fan_outs [all_fanout -from $pin -flat]
	set fan_outs [remove_from_coll $fan_outs $pin]
	foreach_in_coll fan_out $fan_outs {
		connect_logic_zero -empty $fan_out
		connect_logic_zero -net_name VSS $fan_out
	}
}


set tiehs [get_cells -hierarchical -filter "is_hierarchical == false && ref_name =~ TIEH*"]
foreach_in_collection cell $tiels {
	set pin [get_pins -of $cell]
	set fan_outs [all_fanout -from $pin -flat]
	set fan_outs [remove_from_coll $fan_outs $pin]
	foreach_in_coll fan_out $fan_outs {
		connect_logic_one -empty $fan_out
		connect_logic_one -net_name VDD $fan_out
        }
}

remove_cell $tiels
remove_cell $tiehs

###############################
set TIEH tcbn65lphvtwcl/TIEHHVT
set TIEL tcbn65lphvtwcl/TIELHVT
set TIEH TIEHHVT
set TIEL TIELHVT

connect_tie_cells -tie_high_lib_cell $TIEH \
		  -tie_low_lib_cell  $TIEL \
		  -tie_high_port_name Z \
		  -tie_low_port_name ZN \
		  -max_fanout 10 \
		  -max_wirelength 50 \
		  -objects {r2si_0/r2ccore_0/cygctl_0/r8051xc_0/U_SYNCNEG/int7_ff1/D r2si_0/rcrgen_0/clk_gate_rrst_reg_OUT_reg_latch/TE} \
		  -obj_type port_inst \
		  -incremental true

##
r2si_0/r2ccore_0/cygctl_0/r8051xc_0/U_SYNCNEG/int7_ff1/D
r2si_0/rcrgen_0/clk_gate_rrst_reg_OUT_reg_latch/TE
