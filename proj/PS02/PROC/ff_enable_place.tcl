#
set enabler_pins [  get_pins *latch/Q -hier]
set net_num 0
foreach_in_collection enabler_pin $enabler_pins {
        set pin_count   [sizeof_collection [get_pins -of_object 
[get_nets -of_object $enabler_pin] -leaf]]
        set net_name    [get_attribute [get_nets -of_object 
$enabler_pin] full_name]
        if { $pin_count > 17 } {
                puts "Warning: No net weight setting on $net_name!"
                continue
        }
        append_to_collection -unique enabler_net_col [get_nets 
-of_object $enabler_pin]
        incr net_num
}

puts "Info: Total $net_num nets were set net weight !"

set_timing_weights -effort ultra $enabler_net_col ; # set_timing_weights 
[-effort low|medium|high|ultra] [list_of_nets]
