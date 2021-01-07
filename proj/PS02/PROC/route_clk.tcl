########################################################################
# step
set STEP route
########################################################################
## reread sdc
remove_sdc
echo "INFO: read_sdc "
sh rm -f ${SESSION}.run/read_sdc.log
set SDC_LIST [list $FUNC_SDC ]
foreach SDC ${SDC_LIST} {
   source   -echo ${SDC} >> ${SESSION}.run/read_sdc_cts.log
}

########################################################################
## insert_filler
source ./tcl/insert_filler.tcl

########################################################################
# route settings
if { $DERATE != "" } { source $DERATE }
if { $SKIP_ROUTE_LIST != "" } { source $SKIP_ROUTE_LIST }
set_tlu_plus_files -max_tluplus $TLUP_MAX -tech2itf_map $TLUP_MAP
set MIN_ROUTING_LAYER M3
set MAX_ROUTING_LAYER M5
set_ignored_layers -min_routing_layer $MIN_ROUTING_LAYER -max_routing_layer $MAX_ROUTING_LAYER
set_operating_conditions $operating_cond -analysis_type on_chip_variation -lib $operating_cond_lib

set_route_mode_options -zroute true
set_route_zrt_track_options  -crosstalk_driven true
set_route_zrt_global_options -crosstalk_driven true
set_route_zrt_track_options -crosstalk_driven true
set_route_options -same_net_notch check_and_fix
set_route_zrt_common_options -max_number_of_threads $num_cpus
set droute_numCPUs $num_cpus

set_si_options -delta_delay false -static_noise false -timing_window false -min_delta_delay false -static_noise_threshold_above_low 0.3 \
    -static_noise_threshold_below_high 0.3 -route_xtalk_prevention true -route_xtalk_prevention_threshold 0.35 \
    -analysis_effort low -max_transition_mode normal_slew
set_parameter -name doAntennaConx -value 4

#source ./tcl/antenna_rule.tcl

    define_routing_rule double_spacing -multiplier_spacing 2
    mark_clock_tree -clock_net
    mark_clock_tree -routing_rule double_spacing

  foreach_in_collection cell [ get_cells * -hier -filter "full_name =~ *_FB_L3_DRIVE01" ] {
    set outpin [ get_pins -of $cell -filter "direction == out" ]
    set fbnet  [ get_nets -of $outpin -top -seg ]
    set fbnet_name [ get_attr $fbnet full_name ]
    set_attr $fbnet net_type "Clock"
    puts "*INFO* set_route_type on $fbnet_name"
    set_route_type -clock strap [ get_net_shapes -of_objects $fbnet_name ]
    set_route_type -clock strap [ get_vias -of_objects $fbnet_name ]
    #set_net_routing_rule -rule double_spacing $fbnet_name
  }

  set_delay_calculation -clock_arnoldi
  set_route_zrt_global -clock_topology comb -comb_distance 4

route_zrt_group -max_detail_route_iterations 10 -all_clock_nets

set MIN_ROUTING_LAYER M1
set MAX_ROUTING_LAYER M5
set_ignored_layers -min_routing_layer $MIN_ROUTING_LAYER -max_routing_layer $MAX_ROUTING_LAYER

route_zrt_auto
report_cpu_usage

#save_mw_cel -as route
save_mw_cel -as $TOP
save_mw_cel -as WHYDRAIO
exec touch ./route.ready
echo "INFO: end of auto_route"
echo [exec date]
 source /proj/wHydra/WORK/peter/ICC/scripts/extract_clock_pin.tcl
 source /proj/wHydra/WORK/peter/ICC/scripts/write_clock_pin_list.tcl
 source /proj/wHydra/WORK/peter/ICC/scripts/write_clock_ideal_script.tcl
 extract_clock_pin
 write_clock_ideal_script ${SESSION}.run/clock_ideal.txt

exit
########################################################################
# export
