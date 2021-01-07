set_auto_disable_drc_nets -constant false 
set_attribute [get_lib_pins -of_object [get_lib_cell $TIE_HIGH_lib_cell] ] max_fanout 15 -type float 
set_attribute [get_lib_pins -of_object [get_lib_cell $TIE_LOW_lib_cell] ] max_fanout 15 -type float 
set_attribute [get_lib_pins -of_object [get_lib_cell $TIE_HIGH_lib_cell] ] max_capacitance 0.2 -type float 
set_attribute [get_lib_pins -of_object [get_lib_cell $TIE_LOW_lib_cell] ] max_capacitance 0.2 -type float 
set_attribute [get_lib_cell $TIE_HIGH_lib_cell ] dont_use false 
set_attribute [get_lib_cell $TIE_LOW_lib_cell ] dont_use false 
set_attribute [get_lib_cell $TIE_HIGH_lib_cell ] dont_touch false 
set_attribute [get_lib_cell $TIE_LOW_lib_cell ] dont_touch false

