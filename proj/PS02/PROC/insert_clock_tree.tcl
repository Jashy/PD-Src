####################################################################################################
## DESIGN DEPENDENT CONFIGURATION
####################################################################################################
	set lib tcbn90lphpwc
	set root_pin_names {
		CLK_CTSBUF/C
	}
	remove_attribute [ get_lib_cells $lib/CKBD* ] dont_use
	remove_attribute [ get_lib_cells $lib/CKBD* ] dont_touch


	set of [ open fishbone_nets.lis w+ ]
	foreach pin $root_pin_names {
		set net [ get_nets -of_objects $pin ]
	  	set net_name [get_attribute $net full_name ]			  
	    puts $of $net_name
	}
	close $of


	set structure_list(CLK_CTSBUF/C)   {{{ CKBD16 1 }} {{ CKBD24 2} { CKND24 0}} {{ CKBD24 12} { CKND24 0}}}

####################################################################################################
## TECHNOLOGY DEPENDENT CONFIGURATION
####################################################################################################

  proc get_structure_list { pin_count } {
    if       { $pin_count <=  40 } { set structure_list { { { CLKBUFX16MTS 1 } } { { CLKBUFX16MTS 1 } { CLKINVX6MTS 1 } } { { CLKBUFX24MTS  1 } { CLKINVX8MTS 7 } } }
    } elseif { $pin_count <=  80 } { set structure_list { { { CLKBUFX16MTS 1 } } { { CLKBUFX16MTS 1 } { CLKINVX6MTS 1 } } { { CLKBUFX24MTS  2 } { CLKINVX8MTS 6 } } }
    } elseif { $pin_count <= 120 } { set structure_list { { { CLKBUFX16MTS 1 } } { { CLKBUFX16MTS 1 } { CLKINVX6MTS 1 } } { { CLKBUFX24MTS  3 } { CLKINVX8MTS 5 } } }
    } elseif { $pin_count <= 160 } { set structure_list { { { CLKBUFX16MTS 1 } } { { CLKBUFX16MTS 1 } { CLKINVX6MTS 1 } } { { CLKBUFX24MTS  4 } { CLKINVX8MTS 4 } } }
    } elseif { $pin_count <= 200 } { set structure_list { { { CLKBUFX16MTS 1 } } { { CLKBUFX16MTS 1 } { CLKINVX6MTS 1 } } { { CLKBUFX24MTS  5 } { CLKINVX8MTS 3 } } }
    } elseif { $pin_count <= 240 } { set structure_list { { { CLKBUFX16MTS 1 } } { { CLKBUFX16MTS 1 } { CLKINVX6MTS 1 } } { { CLKBUFX24MTS  6 } { CLKINVX8MTS 2 } } }
    } elseif { $pin_count <= 280 } { set structure_list { { { CLKBUFX16MTS 1 } } { { CLKBUFX16MTS 1 } { CLKINVX6MTS 1 } } { { CLKBUFX24MTS  7 } { CLKINVX8MTS 1 } } }
    } elseif { $pin_count <= 160 } { set structure_list { { { CLKBUFX16MTS 1 } } { { CLKBUFX16MTS 1 } { CLKINVX6MTS 1 } } { { CLKBUFX24MTS  8 } { CLKINVX8MTS 0 } } }
    } elseif { $pin_count <= 360 } { set structure_list { { { CLKBUFX16MTS 1 } } { { CLKBUFX16MTS 2 } { CLKINVX6MTS 0 } } { { CLKBUFX24MTS  9 } { CLKINVX8MTS 7 } } }
    } elseif { $pin_count <= 400 } { set structure_list { { { CLKBUFX16MTS 1 } } { { CLKBUFX16MTS 2 } { CLKINVX6MTS 0 } } { { CLKBUFX24MTS 10 } { CLKINVX8MTS 6 } } }
    } elseif { $pin_count <= 440 } { set structure_list { { { CLKBUFX16MTS 1 } } { { CLKBUFX16MTS 2 } { CLKINVX6MTS 0 } } { { CLKBUFX24MTS 11 } { CLKINVX8MTS 5 } } }
    } elseif { $pin_count <= 480 } { set structure_list { { { CLKBUFX16MTS 1 } } { { CLKBUFX16MTS 2 } { CLKINVX6MTS 0 } } { { CLKBUFX24MTS 12 } { CLKINVX8MTS 4 } } }
    } elseif { $pin_count <= 520 } { set structure_list { { { CLKBUFX16MTS 1 } } { { CLKBUFX16MTS 2 } { CLKINVX6MTS 0 } } { { CLKBUFX24MTS 13 } { CLKINVX8MTS 3 } } }
    } elseif { $pin_count <= 560 } { set structure_list { { { CLKBUFX16MTS 1 } } { { CLKBUFX16MTS 2 } { CLKINVX6MTS 0 } } { { CLKBUFX24MTS 14 } { CLKINVX8MTS 2 } } }
    } elseif { $pin_count <= 600 } { set structure_list { { { CLKBUFX16MTS 1 } } { { CLKBUFX16MTS 2 } { CLKINVX6MTS 0 } } { { CLKBUFX24MTS 15 } { CLKINVX8MTS 1 } } }
    } else                         { set structure_list { { { CLKBUFX16MTS 1 } } { { CLKBUFX16MTS 4 } { CLKINVX6MTS 0 } } { { CLKBUFX24MTS 16 } { CLKINVX8MTS 0 } } }
    }
    return $structure_list
  }

  # input pin    : capacitance
  # CLKBUFX6MTS  : 0.001389
  # CLKBUFX8MTS  : 0.001748
  # CLKINVX4MTS  : 0.002376
  # CLKBUFX12MTS : 0.002393
  # CLKBUFX16MTS : 0.003163
  # CLKINVX6MTS  : 0.003422
  # CLKINVX8MTS  : 0.004293
  # CLKBUFX24MTS : 0.004469
  # CLKBUFX32MTS : 0.005823
  # CLKINVX12MTS : 0.006381
  # CLKINVX16MTS : 0.008566
  # CLKINVX24MTS : 0.012701
  # CLKINVX32MTS : 0.016909

####################################################################################################
## MAIN
####################################################################################################
  
	foreach root_pin_name $root_pin_names {
		puts "INFO : Deal Fishbone $root_pin_name"
	    set root_net [ get_nets -of_objects $root_pin_name ]
	    set root_net_name [ get_attribute $root_net full_name ]
		#set pin_hiers [ split $pin "/" ]
		#set pin_hier_num [ llength $pin_hiers ]
		#set net_name_piece [ lindex $pin_hiers [ expr $pin_hier_num - 2 ] ]
		#set buffer_hiers [ concat [ lrange $pin_hiers 0 [ expr $pin_hier_num -2 ]  ]  $buffer_name ]
		#set buffer_hier [ join $buffer_hiers "/" ]
	
	    # Define clock structure by pin count
		#set pins [ data list "net_pin_leaf -flow sink" $root_net ]
		#    set pin_count [ llength $pins ]
	    if { [ info exists structure_list($root_pin_name) ] == 0 } {
			set structure_list($root_pin_name) [ get_structure_list $pin_count ]
	    }
		set root_cell_name [get_attribute $root_pin_name cell_name ]
	    # Insert L3 buffer
		set model [ lindex [ lindex [ lindex $structure_list($root_pin_name) 0 ] 0 ] 0 ]
	    set new_cell_name [ format "%s_FB_L3_DRIVE01" $root_cell_name ]
	    set new_net_name  [ format "%s_FB_L2"         $root_cell_name ]
	    set FB_L3 [insert_buffer $root_pin_name  $lib/$model -new_cell_names $new_cell_name -new_net_names $new_net_name]
		set_cell_location $FB_L3 -coordinates { 0 0 }
	
	    # Insert L2 buffer
	    set new_cell_name [ format "%s_FB_L2_DRIVE01" $root_cell_name ]
	    set new_net_name  [ format "%s_FB_L1"         $root_cell_name ]
	    set model [ lindex [ lindex [ lindex $structure_list($root_pin_name) 1 ] 0 ] 0 ]
	    set FB_L2 [insert_buffer $root_pin_name  $lib/$model -new_cell_names $new_cell_name -new_net_names $new_net_name]
		set_cell_location $FB_L2 -coordinates { 0 0 }
	
	    # Insert L1 buffer
	    set new_cell_name [ format "%s_FB_L1_DRIVE01" $root_cell_name ]
	    set new_net_name  [ format "%s_FB_L0"         $root_cell_name ]
	    set model [ lindex [ lindex [ lindex $structure_list($root_pin_name) 0 ] 0 ] 0 ] 
	    set FB_L1 [insert_buffer $root_pin_name  $lib/$model -new_cell_names $new_cell_name -new_net_names $new_net_name]
		set_cell_location $new_cell_name -coordinates { 0 0 }
	
	    # Insert L3 parallel driver
	    for { set i 2 } { $i <= [ lindex [ lindex [ lindex $structure_list($root_pin_name) 2 ] 0 ] 1 ] } { incr i } {
			set model [ lindex [ lindex [ lindex $structure_list($root_pin_name) 2 ] 0 ] 0 ]
	      	set new_cell_name [ format "%s_FB_L3_DRIVE%02d" $root_cell_name $i ]
			puts $new_cell_name
	      	create_cell $new_cell_name $lib/$model 
	      	connect_net [ get_nets -of_objects [format "%s_FB_L3_DRIVE%02d/CLK" $root_cell_name 1 ] ] [ format "%s_FB_L3_DRIVE%02d/CLK" $root_cell_name $i ]
	      	connect_net [ get_nets -of_objects [format "%s_FB_L3_DRIVE%02d/C" $root_cell_name 1 ] ] [ format "%s_FB_L3_DRIVE%02d/C" $root_cell_name $i ]
	    	set_cell_location $new_cell_name -coordinates { 0 0 }
	   }
	
	    # Insert L3 dummy loading
	#    for { set i 1 } { $i <= [ lindex [ lindex [ lindex $structure_list($root_pin_name) 2 ] 1 ] 1 ] } { incr i } {
	#      set new_cell_name [ format "%s_FB_L3_DUMMY%02d" $root_cell_name $i ]
	#      set model [ data find $l [ lindex [ lindex [ lindex $structure_list($root_pin_name) 2 ] 1 ] 0 ] -type model -hier ]
	#      data create cell $model $m $new_cell_name
	#			data put $m/$new_cell_name hier_idx [ data get $m/$root_cell_name hier_idx ]
	#      data attach [ data only pin_net [ format "$m/%s_FB_L3_DRIVE%02d/I" $root_cell_name 1 ] ] net_pin [ format "$m/%s_FB_L3_DUMMY%02d/I" $root_cell_name $i ]
	#    	data attach [ data only pin_net [ format "$m/%s_FB_L3_DRIVE%02d/Y" $root_cell_name 1 ] ] net_pin [ format "$m/%s_FB_L3_DUMMY%02d/Y" $root_cell_name $i ]
	#    }
	
	    # Insert L2 parallel driver
	    for { set i 2 } { $i <= [ lindex [ lindex [ lindex $structure_list($root_pin_name) 1 ] 0 ] 1 ] } { incr i } {
			set model [ lindex [ lindex [ lindex $structure_list($root_pin_name) 1 ] 0 ] 0 ]
			set new_cell_name [ format "%s_FB_L2_DRIVE%02d" $root_cell_name $i ]
			puts $new_cell_name
			create_cell $new_cell_name $lib/$model
			connect_net [ get_nets -of_objects [format "%s_FB_L2_DRIVE%02d/CLK" $root_cell_name 1 ] ] [ format "%s_FB_L2_DRIVE%02d/CLK" $root_cell_name $i ]
			connect_net [ get_nets -of_objects [format "%s_FB_L2_DRIVE%02d/C" $root_cell_name 1 ] ] [ format "%s_FB_L2_DRIVE%02d/C" $root_cell_name $i ]
	    	set_cell_location $new_cell_name -coordinates { 0 0 }
	    }
	
	    # Insert L2 dummy loading
	#    for { set i 1 } { $i <= [ lindex [ lindex [ lindex $structure_list($root_pin_name) 1 ] 1 ] 1 ] } { incr i } {
	#			set new_cell_name [ format "%s_FB_L2_DUMMY%02d" $root_cell_name $i ]
	#      set model [ data find $l [ lindex [ lindex [ lindex $structure_list($root_pin_name) 1 ] 1 ] 0 ] -type model -hier ]
	#      data create cell $model $m $new_cell_name
	#			data put $m/$new_cell_name hier_idx [ data get $m/$root_cell_name hier_idx ]
	#      data attach [ data only pin_net [ format "$m/%s_FB_L2_DRIVE%02d/I" $root_cell_name 1 ] ] net_pin [ format "$m/%s_FB_L2_DUMMY%02d/I" $root_cell_name $i ]
	#    	data attach [ data only pin_net [ format "$m/%s_FB_L2_DRIVE%02d/Y" $root_cell_name 1 ] ] net_pin [ format "$m/%s_FB_L2_DUMMY%02d/Y" $root_cell_name $i ]
	#    }
}
puts "INFO : Insertion Finished"

  ####################################################################################################
  # LOG
  #
  set log_file insert_clock_tree.log
  set log [ open $log_file w ]
  foreach root_pin_name $root_pin_names {
    puts $log [ format "####################################################################################################" ]
    puts $log [ format "# %s" $root_pin_name ]
    puts $log [ format "#" ]
    puts $log [ format "set structure_list($root_pin_name) { { { %s %d } } { { %s %d } { %s %d } } { { %s %d } { %s %d } } }" \
      [ lindex [ lindex [ lindex $structure_list($root_pin_name) 0 ] 0 ] 0 ] [ lindex [ lindex [ lindex $structure_list($root_pin_name) 0 ] 0 ] 1 ] \
      [ lindex [ lindex [ lindex $structure_list($root_pin_name) 1 ] 0 ] 0 ] [ lindex [ lindex [ lindex $structure_list($root_pin_name) 1 ] 0 ] 1 ] \
      [ lindex [ lindex [ lindex $structure_list($root_pin_name) 1 ] 1 ] 0 ] [ lindex [ lindex [ lindex $structure_list($root_pin_name) 1 ] 1 ] 1 ] \
      [ lindex [ lindex [ lindex $structure_list($root_pin_name) 2 ] 0 ] 0 ] [ lindex [ lindex [ lindex $structure_list($root_pin_name) 2 ] 0 ] 1 ] \
      [ lindex [ lindex [ lindex $structure_list($root_pin_name) 2 ] 1 ] 0 ] [ lindex [ lindex [ lindex $structure_list($root_pin_name) 2 ] 1 ] 1 ] \
    ]
	if { [get_attribute $root_pin_name object_class] == "port" } {
		set pin_or_port  port 
	} else {
		set pin_or_port pin
	}
    if {$pin_or_port == "port"} {
        set root_cell   [get_attribute  $root_pin_name full_name]
        set root_cell_name [get_attribute  $root_pin_name full_name]
     } else {
        set root_cell [ get_cells -of_objects $root_pin_name ]
        set root_cell_name [get_attribute  $root_cell full_name]
    }

    # root pin -> L1
    puts $log [ format "#---------------------------------------------------------------------------------------------------" ]
    set pin $root_pin_name
    set net [  get_nets  -of  $pin ]
    set net_name [ get_attribute $net full_name ]
    set source_pins [ sort_collection [ get_pins -of $net_name -leaf -filter "direction == out"] {full_name} ]
    set sink_pins   [ sort_collection [ get_pins -of $net_name -leaf -filter "direction == in" ] {full_name} ]
    foreach_in_collection pin  $source_pins  {
      set pin_name [ get_attribute $pin full_name ]
      set model_name [get_attribute [ get_cells -of_objects  $pin ] full_name ]
      puts $log [ format "# %s (%s)" $pin_name $model_name ]
    }
    puts $log [ format "\t# %s (net) %s" $net_name [ llength $sink_pins ] ]
    foreach pin [ lsort $sink_pins ] {
      set pin_name [  get_attribute $pin full_name   ]
      set model_name [get_attribute [ get_cells -of_objects  $pin ] full_name  ]
      puts $log [ format "\t# %s (%s)" $pin_name $model_name ]
    }

    # L1 -> L2
    set pin [ get_pins -of [ get_cells ${root_cell_name}_FB_L1_DRIVE01 ] -filter "direction == out"  ]
    set net [ get_nets -of  $pin ]
    set net_name [get_attribute $net full_name  ]
    set source_pins [ sort_collection [ get_pins -of $net_name -leaf -filter "direction == out"] {full_name} ]
    set sink_pins   [ sort_collection [ get_pins -of $net_name -leaf -filter "direction == in" ] {full_name} ]
    foreach_in_collection pin  $source_pins  {
      set pin_name [ get_attribute $pin full_name   ]
      set model_name [get_attribute [ get_cells -of_objects  $pin ] full_name ]
      puts $log [ format "\t# %s (%s)" $pin_name $model_name ]
    }
    puts $log [ format "\t\t#---------------------------------------------------------------------------------------------------" ]
    puts $log [ format "\t\t# %s (net) %s" $net_name [ llength $sink_pins ] ]
    foreach_in_collection pin $sink_pins {
      set pin_name [  get_attribute $pin full_name  ]
      set model_name [get_attribute [ get_cells -of_objects  $pin ] full_name  ]
      puts $log [ format "\t\t# %s (%s)" $pin_name $model_name ]
    }

    # L2 -> L3
    set pin [ get_pins -of [ get_cells ${root_cell_name}_FB_L2_DRIVE01 ] -filter "direction == out"  ]
    set net [ get_nets -of  $pin ]
    set net_name [ get_attribute $net full_name  ]
    set source_pins [ sort_collection [ get_pins -of $net_name -leaf -filter "direction == out"] {full_name} ]
    set sink_pins   [ sort_collection [ get_pins -of $net_name -leaf -filter "direction == in" ] {full_name} ]
    foreach_in_collection pin  $source_pins  {
      set pin_name [  get_attribute $pin full_name  ]
      set model_name [ get_attribute [ get_cells -of_objects  $pin ] full_name  ]
      puts $log [ format "\t\t# %s (%s)" $pin_name $model_name ]
    }
    puts $log [ format "\t\t\t#---------------------------------------------------------------------------------------------------" ]
    puts $log [ format "\t\t\t# %s (net) %s" $net_name [ llength $sink_pins ] ]
    foreach_in_collection pin $sink_pins {
      set pin_name [ get_attribute $pin full_name ]
      set model_name [ get_attribute [ get_cells -of_objects  $pin ] full_name  ]
      puts $log [ format "\t\t\t# %s (%s)" $pin_name $model_name ]
    }

#    set cell [  get_cells -of_objects [ lindex $sink_pins 0 ] ]
#    set cell_name [ get_attribute $cell full_name ]

#    # L3 -> leaf pin
#    puts $log [ format "#---------------------------------------------------------------------------------------------------" ]
#    set pin [  get_pins -of [ get_cells  ${root_cell_name}_FB_L3_DRIVE01 ] -filter "direction == out"  ]
#    set net [ get_nets -of  $pin  ]
#    set net_name [get_attribute $net full_name  ]
#    set source_pins [ sort_collection [ get_pins -of $net_name -leaf -filter "direction == out"] {full_name} ]
#    set sink_pins   [ sort_collection [ get_pins -of $net_name -leaf -filter "direction == in" ] {full_name} ]
#    foreach_in_collection pin  $source_pins  {
#      set pin_name [ get_attribute $pin full_name ]
#      set model_name [ get_attribute [ get_cells -of_objects  $pin ] full_name  ]
#      puts $log [ format "# %s (%s)" $pin_name $model_name ]
#    }
#    puts $log [ format "# %s (net) %s" $net_name [ llength $sink_pins ] ]
   #foreach pin $sink_pins {
   
   #  set model_name [ data get [ data only cell_model [ data only pin_cell $pin ] ] name ]
   #  puts $log [ format "# %s (%s)" $pin_name $model_name ]
   #}

  }
  close $log
  unsuppress_message {PSYN-111 PSYN-294}
