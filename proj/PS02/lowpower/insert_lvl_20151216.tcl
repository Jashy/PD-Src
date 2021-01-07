source /proj/PS02/WORK/jasons/Block/GAIA/Level_shift_1216/utility/insert_lvl_20151211a.tcl
set_attribute [get_flat_cells -filter "full_name=~*ALCHIP_LS_OPT_20151211a* && ref_name==BUF_X3M_A8TR_C34"] is_fixed true
#save_mw_cel -as after_split

#source /proj/PS02/WORK/jasons/Block/GAIA/Level_shift_1216/buf_lvl.lis
#set i 0
#foreach input $input_pins {
	#set driver_net [get_attr [get_net -of [get_pin $input] -all ] full_name ]
	#set driver_pin [get_object_name [get_pins -of [get_nets $driver_net] -fil "direction == out "]]
	#disconnect_net $driver_net $input
	#set name1 [get_attribute [get_cells -of $input] full_name]
	#set name2 [get_attribute [get_pins $input] name ]
	#set cel ${name1}_${name2}_O2LVLUO_X4M_jasons_$i
	#create_cell $cel O2LVLUO_X4M_A8TR
	#connect_net $driver_net $cel/A 
	#create_net ${name1}_${name2}_O2LVLUO_X4M_jasons_n$i
	#connect_net ${name1}_${name2}_O2LVLUO_X4M_jasons_n$i  $cel/Y
	#connect_net ${name1}_${name2}_O2LVLUO_X4M_jasons_n$i  $input
	#set i [expr $i + 1]
	#echo "$input " >> input_pins_list
#}

source /proj/PS02/WORK/jasons/Block/GAIA/data/GAIA.vio.list_dft
set j 0
foreach mem $mems {
set output_pins [get_object_name [get_pins -of_objects [get_cells $mem] -fil "direction == out "]]
foreach output $output_pins {
	set load [get_loads [get_pins $output]]
	if { $load != "" } {
		set load_net [get_attr [get_net -of [get_pin $output] -all ] full_name ]
		disconnect_net $load_net $output
		set name3 [get_attribute [get_cells -of $output] full_name]
		set name4 [get_attribute [get_pins $output] name ]
		set cel ${name3}_${name4}_LVLD_X4M_jasons_$j
		create_cell $cel LVLD_X4M_A8TR
		connect_net $load_net $cel/Y
		create_net ${name3}_${name4}_LVLD_X4M_jasons_n$j
        	connect_net ${name3}_${name4}_LVLD_X4M_jasons_n$j  $cel/A
		connect_net ${name3}_${name4}_LVLD_X4M_jasons_n$j  $output
		set j [expr $j + 1]
		echo "$output " >> output_pins_list
		echo "$output " >> pins_list
        }
}
}

save_mw_cel -as after_output

source /proj/PS02/WORK/jasons/Block/GAIA/Level_shift_1216/utility/single_pin_486.lis
set i 0
foreach input $input_pins {
	set driver_net [get_attr [get_net -of [get_pin $input] -all ] full_name ]
	set driver_pin [get_object_name [get_pins -of [get_nets $driver_net] -fil "direction == out "]]
	disconnect_net $driver_net $input
	set name1 [get_attribute [get_cells -of $input] full_name]
	set name2 [get_attribute [get_pins $input] name ]
	set cel ${name1}_${name2}_O2LVLUO_X4M_jasons_$i
	create_cell $cel O2LVLUO_X4M_A8TR
	connect_net $driver_net $cel/A 
	create_net ${name1}_${name2}_O2LVLUO_X4M_jasons_n$i
	connect_net ${name1}_${name2}_O2LVLUO_X4M_jasons_n$i  $cel/Y
	connect_net ${name1}_${name2}_O2LVLUO_X4M_jasons_n$i  $input
	set i [expr $i + 1]
	echo "$input " >> input_pins_list
	echo "$input " >> pins_list
}


source /proj/PS02/WORK/jasons/Block/GAIA/Level_shift_1216/pins_list
magnet_placement -move_fixed -move_soft_fixed  [get_pins $pins] -mark_fixed

remove_buffer [get_flat_cells -filter "full_name=~*ALCHIP_LS_OPT_20151211a* && ref_name==BUF_X3M_A8TR_C34"]
