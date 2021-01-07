  
  set STEP route_opt 
  remove_sdc -keep_parasitics
  source $FUNC_SDC
  source $DERATE

  set_ignored_layers  -min_routing_layer M1 -max_routing_layer M5
  set_tlu_plus_files -max_tluplus $TLUP_MAX -tech2itf_map $TLUP_MAP
  set_route_options -same_net_notch check_and_fix

  set_route_mode_options -zroute true
  route_opt -effort high
  save_mw_cel -as route_opt
  report_timing -max 10000 -nosplit  -slack_less 0  -net -tran -cap -input -nosplit -derate > ${SESSION}.run/${STEP}_max.rpt
  exec /proj/Hydra5/TEMPLATES/PT/check_violation_summary.pl   ${SESSION}.run/${STEP}_max.rpt >  ${SESSION}.run/${STEP}_max.rpt.summary

  
