############### net group routing ##################
set_parameter -name densityDriven -value -1 -module trackAssign
set_parameter -name densityDriven -value 1 -module groute
set_parameter -name maxOffGridTrack -value 1 -module droute
set_parameter -name dontMakePinFat -value 2 -module droute
set_route_options -same_net_notch check_and_fix
set_route_options  -groute_clock_routing balanced
set_si_options -delta_delay false -static_noise false -timing_window false -min_delta_delay false -static_noise_threshold_above_low 0.3 \
        -static_noise_threshold_below_high 0.3 -route_xtalk_prevention true -route_xtalk_prevention_threshold 0.35 \
        -analysis_effort low -max_transition_mode normal_slew

set_route_options  -groute_clock_routing comb
define_routing_rule  -default_reference_rule  -taper_level 0  \
        -widths  { MET1 0.14 MET2 0.21 MET3 0.21 MET4 0.21 MET5 0.21 MET6 0.28 METG1 0.42 METTOP 0.84 }   \
        -spacing  { MET1 0.12 MET2 0.14 MET3 0.14 MET4 0.14 MET5 0.14 MET6 0.28 METG1 0.42 METTOP 0.84 }  \
        -shield_width  { MET1 0.14 MET2 0.14 MET3 0.14 MET4 0.14 MET5 0.14 MET6 0.28 METG1 0.42 METTOP 0.84 }   \
        -shield_spacing  { MET1 0.12 MET2 0.14 MET3 0.14 MET4 0.14 MET5 0.14 MET6 0.28 METG1 0.42 METTOP 0.84 }   \
        -via_cuts  { VIA12_HV 1x1 VIA23_VH 1x1 VIA34_HV 1x1 VIA45_VH 1x1 VIA56 1x1 VIAG1 1x1 VIATOP 1x1 }   {double_rule}
# followed defined which net need the double rule , Format :
# set_net_routing_rule    {$NET_NAME}   -rule {double_rule}  -top_layer_probe  AnyPort  -reroute normal
source double.net  
route_group -all_clock_nets
######## detail route #######
# ICC intergrated a new router engine which is  more fast than Astro and ICC classical router calls : zroute.
set_si_options -delta_delay false -static_noise false -timing_window false -min_delta_delay false -static_noise_threshold_above_low 0.3 \
        -static_noise_threshold_below_high 0.3 -route_xtalk_prevention true -route_xtalk_prevention_threshold 0.35 \
        -analysis_effort low -max_transition_mode normal_slew
set_route_mode_options -zroute true
set_route_zrt_track_options  -crosstalk_driven true
set_route_zrt_common_options -connect_tie_off true
set_route_zrt_detail_options  -generate_extra_off_grid_pin_tracks true -check_pin_min_area_min_length true -check_pin_min_area_min_length true
set_route_zrt_global_options -clock_topology normal
route_zrt_auto
