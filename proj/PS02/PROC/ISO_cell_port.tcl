source /user/home/nealj/tcl/ICC_TEMPLATE/script/ISOLATE_PORT.icc.tcl
set all_clock_inputs ""

foreach_in_collection clock [ all_clocks ] {
  foreach_in_collection source [ get_attribute $clock sources ] {
    set all_clock_inputs [ add_to_collection $all_clock_inputs $source ]
  }
}
set all_data_inputs [ remove_from_collection [ all_inputs ] $all_clock_inputs ]
set all_data_outputs [ remove_from_collection [ all_outputs ] $all_clock_inputs ]
foreach_in_collection port_name $all_data_inputs {
  ISOLATE_PORT  -lib_cell $ISO_lib_cell -port_name [get_object_name $port_name] -iso_string ISO_PORT_BUFX32
#  set_isolate_ports -driver $ISO_lib_cell $port_name
}
foreach_in_collection port_name $all_data_outputs {
  ISOLATE_PORT  -lib_cell $ISO_lib_cell -port_name [get_object_name $port_name] -iso_string ISO_PORT_BUFX32
#  set_isolate_ports -driver $ISO_lib_cell $port_name
}

set iso_cells_num [sizeof_collection [get_cells *ISO* -hier]]
echo "ISO cells num : $iso_cells_num"

###################MEMORY ISOLATION####################################

source /user/home/nealj/tcl/ICC_TEMPLATE/script/ISOLATE_MEMORY.icc.tcl

#set mem_cells [get_cells * -hier -filter "ref_name =~ * ]
set ISO_lib_cell tcbn45gsbwp12tlvtwcl/BUFFD8BWP12TLVT
set mem_cells [get_selection]
foreach_in_collection mem_cell $mem_cells {
  set mem_pins [get_pins -of_objects [get_cells $mem_cell]]
  set mem_pins [filter_collection $mem_pins "full_name !~ *CK* && pin_direction == out" ]
  foreach_in_collection mem_pin $mem_pins {
    set mem_pin_name [get_attribute [get_pins $mem_pin] full_name]
    ISOLATE_MEMORY -lib_cell $ISO_lib_cell -iso_string ISO_MEMORY_0 -pin_name $mem_pin_name
  }
}
set isocells [get_cells *ISO* -hier]
foreach_in_collection isocell $isocells {
  set_dont_touch_placement  [get_cells $isocell]
  set_attribute -quiet [get_cells $isocell] is_fixed true
}

