


if { $SETUP_MARGIN != 0 } {
  foreach_in_collection clk [all_clocks] {
    set clk_name [get_attr [get_clock $clk] full_name]
    set clk_margin [get_attr [get_clock $clk] setup_uncertainty]
    puts "$clk_name:    $clk_margin"
    set new_clk_margin [expr $clk_margin + $SETUP_MARGIN ]
    set_clock_uncertainty -setup $new_clk_margin $clk_name
    puts "$clk_name:    $new_clk_margin"
  }
}

if { $HOLD_MARGIN  != 0 } {
  foreach_in_collection clk [all_clocks] {
    set clk_name [get_attr [get_clock $clk] full_name]
    set clk_margin [get_attr [get_clock $clk] hold_uncertainty]
    puts "$clk_name:    $clk_margin"
    set new_clk_margin [expr $clk_margin + $HOLD_MARGIN ]
    set_clock_uncertainty -hold $new_clk_margin $clk_name
    puts "$clk_name:    $new_clk_margin"
  }
}

set_max_net_length      $MAX_NET_LENGTH    [current_design]
set_max_capacitance     $MAX_CAPACITANCE   [current_design]
set_max_transition      $MAX_TRANSTION     [current_design]
set_max_fanout          $MAX_FANOUT        [current_design]

if { $DERATE     != "" } { source $DERATE }
if { $DONT_USE   != "" } { source $DONT_USE }
if { $DONT_TOUCH != "" } { source $DONT_TOUCH }
if { $KEEP_LIST  != "" } { source $KEEP_LIST }

set_tlu_plus_files -max_tluplus $TLUP_MAX -tech2itf_map $TLUP_MAP
set_ignored_layers -min_routing_layer $MIN_ROUTING_LAYER -max_routing_layer $MAX_ROUTING_LAYER
set_operating_conditions $operating_cond -analysis_type on_chip_variation -lib $operating_cond_lib

