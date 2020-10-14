########################################################################
## HIGH FANOUT NET
set IDEAL_NETS ""
if { ${IDEAL_NETS} != "" } {
        foreach NET ${IDEAL_NETS} {
                set_ideal_network -no_propagate [get_nets $NET]
                set_dont_touch [get_nets $NET]
                echo "INFO: set_ideal_network on $NET"
        }
}

if { [all_scenarios  ] != "" } {
	puts "*INFO* set_ideal_network in MCMM Mode!"
	foreach mode [all_scenarios  ] {
		current_scenario $mode
		puts "*INFO* scenario: $mode"
		set_ideal_network [all_fanout -flat -clock_tree]
		remove_propagated_clock *
	}
} else {
	set clock_pins [all_fanout -flat -clock_tree]
	set_ideal_network [all_fanout -flat -clock_tree]
	remove_propagated_clock *
}
