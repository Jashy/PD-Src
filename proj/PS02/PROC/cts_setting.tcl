##################################
## clock tree settings
##
remove_routing_rules -all
define_routing_rule double_spacing -multiplier_spacing 2

set_clock_tree_options -routing_rule double_spacing -layer_list {M2 M3 M4 M5 M6}

set_clock_tree_options -target_skew 0.15 \
		       -max_capacitance 0.2 \
		       -max_transition 0.08 \
		       -layer_list {M2 M3 M4 M5 M6} \
		       -use_default_routing_for_sinks 1 \
                       -gate_sizing true \
                       -gate_relocation false \
                       -buffer_sizing true \
                       -delay_insertion true \
                       -buffer_relocation true \
		       -top_mode true \
                       -max_fanout 16 \
                       -ocv_clustering true

set_route_mode_options -zroute true
set_route_zrt_common_options -max_number_of_threads 4

set_route_zrt_global_options -timing_driven true
set_route_zrt_detail_options -timing_driven true

set_si_options -delta_delay false -static_noise false -timing_window false -min_delta_delay false \
        -static_noise_threshold_above_low 0.3 \
        -static_noise_threshold_below_high 0.3 \
        -route_xtalk_prevention true -route_xtalk_prevention_threshold 0.25 \
        -analysis_effort low -max_transition_mode normal_slew

##################################
## CTS buffer settings
##
reset_clock_tree_references

set all_cts_buffers "CLKBUFV12 CLKBUFV16 CLKBUFV20 CLKNV12 CLKNV16 CLKNV20"
set cts_buffers "CLKBUFV12 CLKBUFV16 CLKBUFV20 CLKNV12 CLKNV16 CLKNV20"
set size_only_buf "CLKBUFV12 CLKBUFV16 CLKBUFV20 CLKNV12 CLKNV16 CLKNV20"
set insertion_only_buf "CLKBUFV12 CLKBUFV16 CLKBUFV20 CLKNV12 CLKNV16 CLKNV20"
foreach buffer $cts_buffers {
  remove_attribute [ get_model $buffer ] dont_touch
  remove_attribute [ get_model $buffer ] dont_use
}
remove_attribute [get_lib_cells scc090ng_hs_rvt_v0p9_ss125/CLKLANQV*] dont_use
remove_attribute [get_lib_cells scc090ng_hs_rvt_v0p9_ss125/CLKLANQV*] dont_touch
set_dont_use  { scc090ng_hs_rvt_v0p9_ss125/*V0 }
#set_dont_use  { scc090ng_hs_rvt_v0p9_ss125/*V20 }
set_dont_use  { scc090ng_hs_rvt_v0p9_ss125/*V24 }

set_clock_tree_references -references $size_only_buf -sizing_only
set_clock_tree_references -references $insertion_only_buf -delay_insertion_only
set_clock_tree_references -references $cts_buffers

set_delay_calculation -clock_arnoldi
set cts_new_clustering true
set cts_use_debug_mode true
set cts_do_characterization true

