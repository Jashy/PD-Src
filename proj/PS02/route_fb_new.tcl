proc route_fb_PS02_28hpm { net } {

set_route_mode_options -zroute true
set_route_options -same_net_notch check_and_fix
set_si_options -route_xtalk_prevention false
set_route_zrt_global_options -crosstalk_driven true -timing_driven false
set_route_zrt_track_options  -crosstalk_driven true -timing_driven false
set_route_zrt_detail_options -timing_driven false

set CLK_MIN_ROUTING_LAYER M3
set CLK_MAX_ROUTING_LAYER M7


#### new routing rule add on 11/30.
define_routing_rule shield_28nm_rule -default_reference_rule \
-widths          {M3 0.05 M4 0.05 M5 0.05 M6 0.05 M7 0.05} \
-spacings        {M3 0.05 M4 0.05 M5 0.05 M6 0.05 M7 0.05} \
-shield_widths   {M1 0 M2 0 M3 0.05 M4 0.05 M5 0.05 M6 0.05 M7 0.05} \
-shield_spacings {M1 0 M2 0 M3 0.05 M4 0.05 M5 0.05 M6 0.05 M7 0.05}
report_routing_rules shield_28nm_rule

define_routing_rule shield_28nm_rule_2W2S -default_reference_rule \
-widths          {M3 0.10 M4 0.10 M5 0.10 M6 0.10 M7 0.10} \
-spacings        {M3 0.10 M4 0.10 M5 0.10 M6 0.10 M7 0.10} \
-shield_widths   {M1 0.0 M2 0.0 M3 0.05 M4 0.05 M5 0.05 M6 0.05 M7 0.05} \
-shield_spacings {M1 0.0 M2 0.0 M3 0.10 M4 0.10 M5 0.10 M6 0.10 M7 0.10} \
-via_cuts {
{V3_25_25_25_25_VXBAR_H 1x1 NR} {V3_25_25_25_25_VXBAR_V 1x1 NR} \
{V4_25_25_25_25_VXBAR_H 1x1 NR} {V4_25_25_25_25_VXBAR_V 1x1 NR} \
{V5_25_25_25_25_VXBAR_H 1x1 NR} {V5_25_25_25_25_VXBAR_V 1x1 NR} \
{V6_25_25_25_25_VXBAR_H 1x1 NR} {V6_25_25_25_25_VXBAR_V 1x1 NR} \
}
report_routing_rules shield_28nm_rule_2W2S

define_routing_rule ndr_28nm_rule_2W2S -default_reference_rule \
-widths          {M3 0.10 M4 0.10 M5 0.10 M6 0.10 M7 0.10} \
-spacings        {M3 0.10 M4 0.10 M5 0.10 M6 0.10 M7 0.10} \
-shield_widths   {M1 0.0 M2 0.0 M3 0.00 M4 0.00 M5 0.00 M6 0.00 M7 0.00} \
-shield_spacings {M1 0.0 M2 0.0 M3 0.00 M4 0.00 M5 0.00 M6 0.00 M7 0.00} \
-via_cuts {
{V3_25_25_25_25_VXBAR_H 1x1 NR} {V3_25_25_25_25_VXBAR_V 1x1 NR} \
{V4_25_25_25_25_VXBAR_H 1x1 NR} {V4_25_25_25_25_VXBAR_V 1x1 NR} \
{V5_25_25_25_25_VXBAR_H 1x1 NR} {V5_25_25_25_25_VXBAR_V 1x1 NR} \
{V6_25_25_25_25_VXBAR_H 1x1 NR} {V6_25_25_25_25_VXBAR_V 1x1 NR} \
}
report_routing_rules ndr_28nm_rule_2W2S

##

    ###########################################################################
    # Rule Generation
    echo "remove_routing_rules DSDW_routing_rule_fb "
    remove_routing_rules DSDW_routing_rule_fb
    set M2S [expr ([get_layer_attribute -layer M2 minSpacing]*2)]
    set M3S [expr ([get_layer_attribute -layer M3 minSpacing]*2)]
    set M4S [expr ([get_layer_attribute -layer M4 minSpacing]*2)]
    set M5S [expr ([get_layer_attribute -layer M5 minSpacing]*2)]
    set M6S [expr ([get_layer_attribute -layer M6 minSpacing]*2)]
    set M7S [expr ([get_layer_attribute -layer M7 minSpacing]*2)]
    set IAS [expr ([get_layer_attribute -layer IA minSpacing]*2)]
    set IBS [expr ([get_layer_attribute -layer IB minSpacing]*2)]
    
    set M2W [expr ([get_layer_attribute -layer M2 minWidth]*2)]
    set M3W [expr ([get_layer_attribute -layer M3 minWidth]*2)]
    set M4W [expr ([get_layer_attribute -layer M4 minWidth]*2)]
    set M5W [expr ([get_layer_attribute -layer M5 minWidth]*2)]
    set M6W [expr ([get_layer_attribute -layer M6 minWidth]*2)]
    set M7W [expr ([get_layer_attribute -layer M7 minWidth]*2)]
    set IAW [expr ([get_layer_attribute -layer IA minWidth]*2)]
    set IBW [expr ([get_layer_attribute -layer IB minWidth]*2)]
    
    set M2S3 [expr ([get_layer_attribute -layer M2 minSpacing]*3)]
    set M3S3 [expr ([get_layer_attribute -layer M3 minSpacing]*3)]
    set M4S3 [expr ([get_layer_attribute -layer M4 minSpacing]*3)]
    set M5S3 [expr ([get_layer_attribute -layer M5 minSpacing]*3)]
    set M6S3 [expr ([get_layer_attribute -layer M6 minSpacing]*3)]
    set M7S3 [expr ([get_layer_attribute -layer M7 minSpacing]*3)]
    set IAS3 [expr ([get_layer_attribute -layer IA minSpacing]*3)]
    set IBS3 [expr ([get_layer_attribute -layer IB minSpacing]*3)]
    
    define_routing_rule \
    		-snap_to_track -default_reference_rule \
    		-widths "M3 $M3W M4 $M4W M5 $M5W M6 $M6W M7 $M7W IA $IAW IB $IBW" \
    		-spacings " M3 $M3S M4 $M4S M5 $M5S M6 $M6S M7 $M7S IA $IAS IB $IBS" \
    		DSDW_routing_rule_fb
    #################################################################
	#set L1_input_net [ get_flat_nets -of_objects [get_pins $root_pin ] ]
        #set fbnets [ get_nets -of_objects [get_pins -of_objects [get_cells -of_objects [get_loads $root_pin ] ] -filter "direction==out"] ]
	#set fbnets [get_flat_nets {$net}]
	set fbnets [get_flat_nets $net]

    foreach_in_collection fbnet $fbnets {
            set clock_net_name [get_attribute $fbnet full_name]
            echo " # setting the name of net: $clock_net_name"
    	set_attribute [get_nets {$fbnet}] net_type clock
            set_route_type -clock strap [ get_net_shapes -of_objects $fbnet ]
    }
    set_net_routing_rule $fbnets -rule ndr_28nm_rule_2W2S
    ###################################################################
    # change fishbone trunk and via names
    
    foreach fbnet [get_object_name $fbnets] {
      set net_name [ get_attr $fbnet full_name ]                                        
      create_net ${net_name}_tmp_driver_connection 					
      set_attr [get_nets $net_name] net_type Clock 					
      set_route_type -clock strap [ get_net_shapes -of_objects $fbnet ] 		
    
      foreach_in_collection drive [ get_drivers [get_nets $net_name] ] { 		
        disconnect_net $net_name $drive 						
        connect_net ${net_name}_tmp_driver_connection $drive 			        
      }
      set vias [ get_vias -of $fbnet -quiet ] 						
      set shapes [ get_net_shapes -of $fbnet -quiet -filter "width > 3"] 		
      set owner_net [ lindex [ get_attr $shapes owner_net ] 0 ] 			
      set_attr $shapes owner_net ${net_name}_tmp_driver_connection 			
      set_attr $vias   owner_net ${net_name}_tmp_driver_connection 			
    }


    set_ignored_layers -min_routing_layer $CLK_MIN_ROUTING_LAYER -max_routing_layer $CLK_MAX_ROUTING_LAYER
    set_route_zrt_common_options -net_max_layer_mode soft 
    set_route_zrt_common_options -clock_topology comb -comb_distance 10
    set_parameter -name combMaxConnections -value 12 

    route_zrt_group -max_detail_route_iterations 5 -nets $fbnets 						 
    
    ############### recover fishbone trunk and via names
    set tmp_nets [ get_nets * -hier -filter "full_name =~ *_tmp_driver_connection " ]
    foreach tmp_net [ get_object_name $tmp_nets ] {
      set shapes [ get_net_shapes -of $tmp_net ]
      set vias   [ get_vias -of $tmp_net ]
      set owner_net [ lindex [ get_attr $shapes owner_net ] 0 ]
      regexp {^(\S+)_tmp_driver_connection$} $owner_net "" owner_net
      set_attr $shapes owner_net ${owner_net}
      set_attr $vias   owner_net ${owner_net}
    
      set net_name [ get_attr $tmp_net full_name ]
      regexp {^(\S+)_tmp_driver_connection$} $net_name "" net_name
      foreach_in_collection drive [ get_drivers $tmp_net ] {
        disconnect_net $tmp_net $drive
        connect_net $net_name $drive
      }
      remove_net $tmp_net
    }
    
    #set_route_zrt_common_options -clock_topology normal
    remove_route_guide fb_tmp_route_guide_*
    #set_net_routing_rule -reroute freeze $fbnets 

    #route_zrt_detail -incremental true -initial_drc_from_input true -max_number_iterations 5
}
