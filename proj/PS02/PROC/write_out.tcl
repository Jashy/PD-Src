#
proc alchip_define_naming_rule {} {
define_name_rules no_special_name
define_name_rules no_special_name -reset
define_name_rules no_special_name -max_length 0
define_name_rules no_special_name -map { {{"/", "__"}, {"^_", ""}, {"\\\*cell\\\*", "star_cell_star"}, {"\[%d\]", "_%d_"}, {"\\\*Logic1\\\*", "star_Logic1_star"}, {"\\\*Logic0\\\*", "star_Logic0_star"}, {"^\\\*", "star"}, {"^\\", ""}, {"\.","_"}} }

define_name_rules no_special_name -allowed "A-Za-z0-9_"
#define_name_rules no_special_name -target_bus_naming_style "%s_%d_"
#bus_naming_style="%s[%d]"
define_name_rules no_special_name -reserved_words {always, and, assign, begin, buf, bufif0, bufif1, case, casex, casez, cmos, deassign, default, defparam, disable, edge, else, end, endattribute, endcase, endfunction, endmodule, endprimitive, endspecify, endtable, endtask, event, for, force, forever, fork, function, highz0, highz1, if, initial, inout, input, integer, join, large, macromodule, medium, module, nand, negedge, nmos, nor, not, notif0, notif1, or, output, parameter, pmos, posedge, primitive, pull0, pull1, pullup, pulldown, reg, rcmos, reg, release, repeat, rnmos, rpmos, rtran, rtranif0, rtranif1, scalared, small, specify, specparam, strength, strong0, strong1, supply0, supply1, table, task, time, tran, tranif0, tranif1, tri, tri0, tri1, trinand, trior, trireg, use, vectored, wait, wand, weak0, weak1, while, wire, wor, xor, xnor}
define_name_rules no_special_name -prefix "alchipP_" -type port
define_name_rules no_special_name -prefix "alchipU_" -type cell
define_name_rules no_special_name -prefix "alchipN_" -type net
define_name_rules no_special_name -first_restricted "0-9_"
#define_name_rules no_special_name -last_restricted "_"
define_name_rules no_special_name -replacement_char "_"
define_name_rules no_special_name -equal_ports_nets -inout_ports_equal_nets
}

alchip_define_naming_rule
# verilog
write_app_var -file var_save.icc_${SESSION}.tcl
report_net_fanout -threshold  16 -nosplit       > ${SESSION}.run/post_route.net_fanout.rpt
report_timing -input -path full_clock_expanded -slack_lesser_than 0  -net -nosplit >             ${SESSION}.run/post_routing.timing.rpt
report_violation                                  ${SESSION}.run/post_route.timing.rpt
report_congestion -congestion_effort high       > ${SESSION}.run/post_route.congestion.rpt
report_timing -max 1000 -net -tran -cap -input  -slack_lesser_than 0 > ${SESSION}.run/post_route.max.rpt
report_constraint -all                          > ${SESSION}.run/post_route.all.rpt
change_names -hier -rules no_special_name
#write -format verilog -hierarchy   -output        ${SESSION}.run/post_route.v
write_verilog -no_physical_only_cells ${SESSION}.run/post_route.v
save_mw_cel $TOP
###### output flat netlist
#change_names -hierarchy -rules no_special_name
#ungroup -all -flatten -force
#write_verilog -no_physical_only_cells ${TOP}_flatten.v
### eco cmd : Hierarchical ECO across modules can be done easily in IC Compiler using the following commands:
#	connect_net, disconnect_net, create_cell, report_cell, insert_buffer,
#	remove_buffer, create_net, remove_net, connect_pin, and create_port.

## classical eco route cmd: route_eco -auto -reroute modified_nets_first_then_others

