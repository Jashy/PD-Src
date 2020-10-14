##in ICC report pins and nets of a cell
#Usage: rc <cell_name>
proc rc { name } {
	set cell_full_name [get_attribute [get_flat_cells  $name] full_name]
	puts "####cell: $cell_full_name"
	#set cell_ref_name [get_model [get_attribute [get_flat_cells $name] ref_name]]
	set cell_ref_name [get_attribute [get_flat_cells $name] ref_name]
	puts "===> reference: $cell_ref_name"


	set input_pins [get_attr [get_pins -leaf -of_objects [get_attr [get_flat_cells $name] full_name] -filter "direction == in"] full_name]
	set input_con [ llength $input_pins]
	puts "===> input pin numbers: $input_con"
	if { $input_con > 1 } {
		foreach pin $input_pins {
			set net [get_attr [get_nets -of_objects $pin -top -segments] full_name]
			set top_net [get_attr [get_nets -of_objects $pin -top] full_name]
			puts "         Input pin: $pin"
			puts "         connect_net: $net"
			puts "     connect_top_net: $top_net"
		}
	} else {
		set net [get_attr [get_nets -of_objects $input_pins -top -segments] full_name]
		set top_net [get_attr [get_nets -of_objects $input_pins -top] full_name]
		puts "         Input pin: $input_pins"
		puts "         connect_net: $net"
		puts "     connect_top_net: $top_net"
	}
		
	set output_pins [get_attr [get_pins -leaf -of_objects [get_attr [get_flat_cells $name] full_name] -filter "direction == out"] full_name]
	set output_con [llength $output_pins]
	puts "===> output pin numbers: $output_con"
	if { $output_con > 1 } {
		foreach pin $output_pins {
			set net [get_attr [get_nets -of_objects $pin -top -segments] full_name]
			set top_net [get_attr [get_nets -of_objects $pin -top] full_name]
			puts "         Output pin: $pin"
			puts "         connect_net: $net"
			puts "     connect_top_net: $top_net"
		}
	} else {
		set net [get_attr [get_nets -of_objects $output_pins -top -segments] full_name]
		set top_net [get_attr [get_nets -of_objects $output_pins -top] full_name]
		puts "         Output pin: $output_pins"
		puts "         connect_net: $net"
		puts "     connect_top_net: $top_net"
	}
	
	set inout_pins [get_attr [get_pins -leaf -of_objects [get_attr [get_flat_cells $name] full_name] -filter "direction == inout"] full_name]
	set inout_con [llength $inout_pins]
	puts "===> inout pin numbers: $inout_con"
	foreach inout $inout_pins {
		set net [get_attr [get_nets -of_objects $inout_pins -top -segments] full_name]
		set top_net [get_attr [get_nets -of_objects $inout_pins -top] full_name]
		puts "         Inout pin: $inout_pins"
		puts "         connect_net: $net"
		puts "     connect_top_net: $top_net"
		
	}
}



##in ICC report loadings and driver from a net
proc rn { name } {
	set net_full_name [get_attr [get_nets $name] full_name]
	puts "####net: $net_full_name"
	set driver_list [get_attr [get_pins -of_objects $net_full_name -leaf -filter "direction =~ *out"] full_name]
	set driver_con [llength $driver_list]
	puts "===> driver numbers: $driver_con"
	foreach driver $driver_list {
		set type [get_model [get_attr [get_flat_cells -of_objects $driver] ref_name ]]
		puts "       driver(pin): $driver        Reference: $type"
	}

	set load_list [get_attr [get_pins -of_objects $net_full_name -leaf -filter "direction =~ *in"] full_name]
	set load_con [llength $load_list]
	puts "===> loading numbers: $load_con"
	foreach loading $load_list {
		set type [get_model [get_attr [get_flat_cells -of_objects $loading] ref_name ]]
		puts "       loading(pin): $loading        Reference: $type\n"
	}
}



##in ICC report loadings and driver from a pin
proc rp { name } {
	set pin_full_name [get_attr [get_pins $name] full_name]
	set net_full_name [get_attr [get_nets -of_objects $pin_full_name -top -seg] full_name]
	set pin_con [llength $pin_full_name]
	set net_con [llength $net_full_name]
	if {$pin_con == 0} {
		puts "Error: can not find the pin  $name  in current design."
		return
	} elseif {$net_con == 0} {
		puts "Error: can not find the net of pin  $pin_full_name  in current design"
		return
	}
	puts "####pin: $pin_full_name"
	puts "####connecting net: $net_full_name"
	switch [get_attr $pin_full_name direction] {
		"in" {
			set driver_list [get_attr [get_pins -of_objects $net_full_name -leaf -filter "direction =~ *out"] full_name]
			set driver_con [llength $driver_list]
			if { $driver_con == 0 } {
				puts " floating input pin of net $net_full_name"
			}
			puts "===>driver pin numbers:$driver_con"
			foreach driver $driver_list {
				set type [get_model [get_attr [get_flat_cells -of_objects $driver] ref_name ]]
				puts "    driver(pin): $driver      Reference: $type"
			}
		}
		"out" {
			set load_list [get_attr [get_pins -of_objects $net_full_name -leaf -filter "direction =~ *in"] full_name]
			set load_con [llength $load_list]
			if { $load_con == 0 } {
				puts "floating output pin of $net_full_name"
			}
			puts "===> loading pin numbers:$load_con "
			foreach loading $load_list {
				set type [get_model [get_attr [get_flat_cells -of_objects $loading] ref_name ]]
				puts " \n   driver(pin): $pin_full_name     Reference: $type"
				puts "    loading(pin): $loading     Reference: $type"
			}
		}
	}
	
}



##in ICC hilight special cells (such as:tapcell endcap cell spare cell and so on)
proc hcell {name } {
	gui_change_highlight -remove -all_colors
	change_selection [get_flat_cells -all -filter "full_name =~ $name*"]
	set num [sizeof_collection [get_selection]]
	hilight_collection  red [get_selection ]
	gui_zoom -selection -exact -window [gui_get_current_window -types "Layout" -mru ]
	echo "the number of hilight cell are $num."
}

proc hcell_ref {name } {
	gui_change_highlight -remove -all_colors
	change_selection [get_flat_cells -all -filter "ref_name =~ $name*"]
	set num [sizeof_collection [get_selection]]
	hilight_collection  red [get_selection ]
	gui_zoom -selection -exact -window [gui_get_current_window -types "Layout" -mru ]
	echo "the number of hilight cell are $num."
}

proc h_collection {collection } {
	gui_change_highlight -remove -all_colors
	change_selection $collection
	hilight_collection red [get_selection]
	gui_zoom -selection -exact -window [gui_get_current_window -types "Layout" -mru]
}

##hilight clock net
proc hclk_net {} {
	gui_change_highlight -remove -all_colors
	change_selection [get_net_shapes -filter {route_type =="Clk Strap" && net_type == "Clock"}]
	hilight_collection red [get_selection]
	gui_zoom -selection -exact -window [gui_get_current_window -types "Layout" -mru]
}

##in ICC select cell
proc sc { cell_name } {
	change_selection [get_flat_cells -all ${cell_name}*]
	gui_zoom -exact -selection -window [gui_get_current_window -types "Layout" -mru]
}




##in ICC select net
proc sn { net_name } {
	change_selection [get_nets $net_name -all]
	gui_zoom -exact -selection -window [gui_get_current_window -types "Layout" -mru]
}




##in ICC select pin
proc sp { pin_name } {
	change_selection [get_pins $pin_name -all]
	gui_zoom -exact -selection -window [gui_get_current_window -types "Layout" -mru]
}

##report FUJITSU cells' size
proc cell_size {ref_name} {
	set size ""
	if { [ regexp {^FJSC(E|F)\S*X(.).$} $ref_name all var1 size] == 1 } {
		        array set arrName {A x0.5 B x0.75 C x1 E x1.5 H x2 J x3 L x4 M x5 N x6 O x7 P x8 Q x10 R x12 T x16 U x20 V x24 W x30 Y x48 Z x64}
        set size "($arrName($size))"
       }
       return $size
}



##in ICC get and hilight the nets ,driver and loadings of pin
proc gpn {pin_name} {
#	set net [get_attr [get_flat_nets -of_objects [get_pins $pin_name]] full_name]
	set net [get_flat_nets -of_objects [get_pins $pin_name]]
	gui_change_highlight -remove -color light_red
	gui_change_highlight -remove -color light_blue
	gui_change_highlight -remove -color yellow
	set driver_list [get_attr [get_pins -of_objects [get_nets [get_nets $net] -top -seg] -filter "direction == out"] full_name]
	set load_list [get_attr [get_pins -of_objects [get_nets [get_nets $net] -top -seg] -filter "direction == in"] full_name]
	set driver_cell [get_cells -of_objects [get_pins -of_objects [get_nets [get_nets $net] -top -seg] -filter "direction == out"]]
	set load_cell  [get_cells -of_objects [get_pins -of_objects [get_nets [get_nets $net] -top -seg] -filter "direction == in"]]
	set drivers [get_attr [get_pins $driver_list] full_name]
	set driver_ref [get_attr [get_cells -of [get_pins $driver_list]] ref_name]
	set driver_con [llength $driver_list]
	set load_con [llength $load_list]
	puts "===> the driver is :"
	puts "driver_num is $driver_con"
	puts "driver (pin) : $drivers  --> $driver_ref [cell_size $driver_ref]"

	puts "===> the loads are :"
	foreach load $load_list {
		set load [get_attr [get_pins $load] full_name]
		set load_ref [get_attr [get_cells -of [get_pins $load]] ref_name]
		puts "load (pin) : $load  --> $load_ref [cell_size $load_ref]"
	}
	puts "loads_num are $load_con"
	gui_change_highlight   -collection [get_nets [get_net $net] -top -seg] -color yellow
	if {$driver_con == 0} {
		puts "floating input pin of net $net"
	} else {
		gui_change_highlight  -collection $driver_cell  -color light_red
	}
	if {$load_con == 0} {
		puts "floating output pin of net $net"
	} else {
		gui_change_highlight -collection $load_cell -color light_blue
	}
	change_selection [get_nets $net -all]
	gui_zoom -exact -selection -window [gui_get_current_window -types "Layout" -mru]
}




##in ICC get the distance of cell1 and cell2
proc iCD {cell1 cell2} {
	set cell1_location [get_attr [get_cells $cell1 -all] bbox]
	set cell1_x_loc [lindex [lindex $cell1_location 0] 0]
	set cell1_y_loc [lindex [lindex $cell1_location 0] 1]
	set cell2_location [get_attr [get_cells $cell2 -all] bbox]
	set cell2_x_loc [lindex [lindex $cell2_location 0] 0]
	set cell2_y_loc [lindex [lindex $cell2_location 0] 1]
	set distance [expr abs($cell1_x_loc - $cell2_x_loc) + abs($cell1_y_loc - $cell2_y_loc)]
	puts "$cell1 and $cell2  distance: $distance"
}




##in ICC get the distance of pin1 and pin2
proc iPD {pin1 pin2} {
	set pin1_x_loc [lindex [get_attr [get_pins $pin1 -all] center] 0]
	set pin1_y_loc [lindex [get_attr [get_pins $pin1 -all] center] 1]
	set pin2_x_loc [lindex [get_attr [get_pins $pin2 -all] center] 0]
	set pin2_y_loc [lindex [get_attr [get_pins $pin2 -all] center] 1]
	set distance [expr abs($pin1_x_loc - $pin2_x_loc) + abs($pin1_y_loc - $pin2_y_loc)]
	puts "$pin1 and $pin2   distance: $distance"
}

##get_selection 
proc gs {} {
	set cell [get_selection]
	set full_name [get_attr [get_flat_cells $cell] full_name]
	set ref_name [get_attr [get_flat_cells $full_name] ref_name]
	puts "$full_name $ref_name"
}

proc gsp {port} {
	set full_name [get_attr [get_ports $port] full_name]
	change_selection [get_ports $full_name]
	puts "$full_name"
	gui_zoom -exact -selection -window [gui_get_current_window -types "Layout" -mru]
}

proc drc {net} {
	set net_full [get_attr [get_flat_nets $net] full_name]
	disconnect_net $net_full -all
	remove_net $net_full
	create_net $net_full
}

proc disc {pin} {
	set pin_full [get_attr [get_pins $pin] full_name]
	set net_full [get_attr [get_nets -of_objects $pin_full] full_name]
	disconnect_net $net_full $pin_full
}
proc discf {pin} {
	set pin_full [get_attr [get_pins $pin] full_name]
	set net_full [get_attr [get_flat_nets -of_objects $pin_full] full_name]
	disconnect_net $net_full $pin_full
}

proc conn {net pin1 pin2 pin3} {
	set net_full [get_attr [get_flat_nets $net] full_name]
	set pin1_full [get_attr [get_pins $pin1] full_name]
	set pin2_full [get_attr [get_pins $pin2] full_name]
	set pin3_full [get_attr [get_pins $pin3] full_name]
	connect_net $net_full "$pin1_full $pin2_full $pin2_full"
}

proc con {pin1 pin2 } {
	set pin1_full [get_attr [get_pins $pin1] full_name]
	set pin2_full [get_attr [get_pins $pin2] full_name]
	connect_pin -from $pin1_full -to $pin2_full -port_name eco_0321a
}

