remove_routing_rules -all
set M1S [expr ([get_layer_attribute -layer M1 minSpacing]*2)]
set M2S [expr ([get_layer_attribute -layer M2 minSpacing]*2)]
set M3S [expr ([get_layer_attribute -layer M3 minSpacing]*2)]
set C4S [expr ([get_layer_attribute -layer C4 minSpacing]*2)]
set C5S [expr ([get_layer_attribute -layer C5 minSpacing]*2)]
set C6S [expr ([get_layer_attribute -layer C6 minSpacing]*2)]
set C7S [expr ([get_layer_attribute -layer C7 minSpacing]*2)]

set M1S3 [expr ([get_layer_attribute -layer M1 minSpacing]*3)]
set M2S3 [expr ([get_layer_attribute -layer M2 minSpacing]*3)]
set M3S3 [expr ([get_layer_attribute -layer M3 minSpacing]*3)]
set C4S3 [expr ([get_layer_attribute -layer C4 minSpacing]*3)]
set C5S3 [expr ([get_layer_attribute -layer C5 minSpacing]*3)]
set C6S3 [expr ([get_layer_attribute -layer C6 minSpacing]*3)]
set C7S3 [expr ([get_layer_attribute -layer C7 minSpacing]*3)]

set M2W [expr ([get_layer_attribute -layer M2 minWidth]*2)]
set M3W [expr ([get_layer_attribute -layer M3 minWidth]*2)]
set C4W [expr ([get_layer_attribute -layer C4 minWidth]*2)]
set C5W [expr ([get_layer_attribute -layer C5 minWidth]*2)]
set C6W [expr ([get_layer_attribute -layer C6 minWidth]*2)]
set C7W [expr ([get_layer_attribute -layer C7 minWidth]*2)]

define_routing_rule \
        -snap_to_track -default_reference_rule \
        -spacings "M1 $M1S M2 $M2S M3 $M3S C4 $C4S C5 $C5S C6 $C6S" \
        DS_routing_rule
define_routing_rule \
	-snap_to_track  -default_reference_rule \
	-spacings "M1 $M1S M2 $M2S M3 $M3S C4 $C4S C5 $C5S C6 $C6S" \
	-widths "M2 $M2W M3 $M3W C4 $C4W C5 $C5W C6 $C6W" \
	DSDW_routing_rule

define_routing_rule \
	-snap_to_track  -default_reference_rule \
	-spacings "M1 $M1S M2 $M2S M3 $M3S C4 $C4S C5 $C5S C6 $C6S" \
	-widths "M2 $M2W M3 $M3W C4 $C4W C5 $C5W C6 $C6W" \
	-shield_spacings "M1 0 M2 0 M3 0 C4 0 C5 0 C6 0.04" \
	-shield_widths "M1 0 M2 0 M3 0 C4 0 C5 0 C6 0.04" \
	DSDW_shield_routing_rule

define_routing_rule \
	-snap_to_track  -default_reference_rule \
	-spacings "M1 $M1S M2 $M2S M3 $M3S C4 $C4S C5 $C5S C6 $C6S C7 $C7S" \
	-widths "M2 $M2W M3 $M3W C4 $C4W C5 $C5W C6 $C6W C7 $C7W" \
	-shield_spacings "M1 0 M2 0 M3 0 C4 0.04 C5 0.04 C6 0.04 C7 0.04" \
	-shield_widths "M1 0 M2 0 M3 0 C4 0.04 C5 0.04 C6 0.04 C7 0.04" \
	DSDW_shield_preroute_clk_routing_rule
