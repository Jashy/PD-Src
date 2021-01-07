proc alchip_define_naming_rule {} {
define_name_rules no_special_name
define_name_rules no_special_name -reset
define_name_rules no_special_name -max_length 0
define_name_rules no_special_name -map { {{"/", "__"}, {"^_", ""}, {"\\\*cell\\\*", "star_cell_star"}, {"\[%d\]", "_%d_"}, {"\\\*Logic1\\\*
", "star_Logic1_star"}, {"\\\*Logic0\\\*", "star_Logic0_star"}, {"^\\\*", "star"}, {"^\\", ""}, {"\.","_"}} }

define_name_rules no_special_name -allowed "A-Za-z0-9_"
#define_name_rules no_special_name -target_bus_naming_style "%s_%d_"
#bus_naming_style="%s[%d]"
define_name_rules no_special_name -reserved_words {always, and, assign, begin, buf, bufif0, bufif1, case, casex, casez, cmos, deassign, def
ault, defparam, disable, edge, else, end, endattribute, endcase, endfunction, endmodule, endprimitive, endspecify, endtable, endtask, event
, for, force, forever, fork, function, highz0, highz1, if, initial, inout, input, integer, join, large, macromodule, medium, module, nand, 
negedge, nmos, nor, not, notif0, notif1, or, output, parameter, pmos, posedge, primitive, pull0, pull1, pullup, pulldown, reg, rcmos, reg, 
release, repeat, rnmos, rpmos, rtran, rtranif0, rtranif1, scalared, small, specify, specparam, strength, strong0, strong1, supply0, supply1
, table, task, time, tran, tranif0, tranif1, tri, tri0, tri1, trinand, trior, trireg, use, vectored, wait, wand, weak0, weak1, while, wire,
 wor, xor, xnor}
define_name_rules no_special_name -prefix "alchipP_" -type port
define_name_rules no_special_name -prefix "alchipU_" -type cell
define_name_rules no_special_name -prefix "alchipN_" -type net
define_name_rules no_special_name -first_restricted "0-9_"
#define_name_rules no_special_name -last_restricted "_"
define_name_rules no_special_name -replacement_char "_"
define_name_rules no_special_name -equal_ports_nets -inout_ports_equal_nets
}

alchip_define_naming_rule

change_names -hier -rules no_special_name
write_verilog -no_physical_only_cells ${SESSION}.run/post_route.v
save_mw_cel $TOP

