set fr1 [ open clock_nets.rpt w ]
#set fr2 [ open clock_ideal.tcl w ] 
foreach_in_collection net [ get_nets -hier * ] {
    set type [ get_attribute $net net_type ]
       puts $fr1 " [get_attr $net full_name] $type\n"
#       puts $fr2 "set_load -net $net 0.1p\n"
#       puts $fr2 "set_slew -net $net 0.2n\n"
}
close $fr1
#close $fr2
