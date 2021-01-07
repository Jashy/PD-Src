set registers [all_registers -clock_pins]

foreach_in_collection reg [filter_collection $registers "full_name !~ ckg*"] {
	set reg_name [get_attribute $reg full_name]
	set clk_net [all_connected $reg_name]
	set clk_net_name [get_attribute $clk_net full_name]
	echo $clk_net_name
}
