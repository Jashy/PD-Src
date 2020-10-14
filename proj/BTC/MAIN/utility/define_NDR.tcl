remove_routing_rules -all
set M1S [expr ([get_layer_attribute -layer M1 minSpacing]*2)]
set M2S [expr ([get_layer_attribute -layer M2 minSpacing]*2)]
set M3S [expr ([get_layer_attribute -layer M3 minSpacing]*2)]
set M4S [expr ([get_layer_attribute -layer M4 minSpacing]*2)]
set M5S [expr ([get_layer_attribute -layer M5 minSpacing]*2)]
set M6S [expr ([get_layer_attribute -layer M6 minSpacing]*2)]

set M2W [expr ([get_layer_attribute -layer M2 minWidth]*1.5)]
set M3W [expr ([get_layer_attribute -layer M3 minWidth]*1.5)]
set M4W [expr ([get_layer_attribute -layer M4 minWidth]*1.5)]
set M5W [expr ([get_layer_attribute -layer M5 minWidth]*1.5)]
set M6W [expr ([get_layer_attribute -layer M6 minWidth]*1.5)]

set M2S3 [expr ([get_layer_attribute -layer M2 minSpacing]*3)]
set M3S3 [expr ([get_layer_attribute -layer M3 minSpacing]*3)]
set M4S3 [expr ([get_layer_attribute -layer M4 minSpacing]*3)]
set M5S3 [expr ([get_layer_attribute -layer M5 minSpacing]*3)]
set M6S3 [expr ([get_layer_attribute -layer M6 minSpacing]*3)]

define_routing_rule \
        -snap_to_track -default_reference_rule \
        -spacings "M1 $M1S M2 $M2S M3 $M3S M4 $M4S M5 $M5S M6 $M6S" \
        DS_routing_rule
define_routing_rule \
        -snap_to_track -default_reference_rule \
        -spacings "M1 $M1S M2 $M2S M3 $M3S M4 $M4S M5 $M5S M6 $M6S" \
	-via_cuts {
	       {VIA12 2x1 NR} {VIA12 2x1 R} {VIA12_HV 2x1 NR} {VIA12_HV 2x1 R} 
	       {VIA23 2x1 NR} {VIA23 2x1 R} 
	       {VIA34 2x1 NR} {VIA34 2x1 R}  
	       {VIA45 2x1 NR} {VIA45 2x1 R}  
	       {VIA56 2x1 NR} {VIA56 2x1 R}  
		} \
        DSDV_routing_rule
define_routing_rule \
        -snap_to_track -default_reference_rule \
	-via_cuts {
	       {VIA12 2x1 NR} {VIA12 2x1 R} {VIA12_HV 2x1 NR} {VIA12_HV 2x1 R} 
	       {VIA23 2x1 NR} {VIA23 2x1 R} 
	       {VIA34 2x1 NR} {VIA34 2x1 R}  
	       {VIA45 2x1 NR} {VIA45 2x1 R}  
	       {VIA56 2x1 NR} {VIA56 2x1 R}  
		} \
        DV_routing_rule
