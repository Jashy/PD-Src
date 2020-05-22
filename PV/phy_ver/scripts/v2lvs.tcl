###########################################################################
# file:     v2lvs_wrapper.tcl
# function: runs v2lvs incorporating actual module, user v2lvs macro definitions, stdcells etc
#           * creates v2lvs command string 
#           * runs v2lvs 
# usage:    call this script using tclsh
###########################################################################

# read in ctrl file
source ../../project_setup.tcl

puts "V2LVS Wrapper" 

set LIB_CKTS_NO_ADD_PIN { }
set LOGFILE ""


set IN_VERILOG "../design_data/verilog/$GFVAR_DESIGN(name).routed.lvs.v"

set V2LVS_CMD "v2lvs -64 -sn $GFVAR_V2LVS_USER_CMD_OPTIONS"

foreach no_add_pin_ckt $LIB_CKTS_NO_ADD_PIN {
	if { [file exists $no_add_pin_ckt] } {
		set V2LVS_CMD "$V2LVS_CMD -lsr $no_add_pin_ckt"
    	} else {
		puts "WARNING: $no_add_pin_ckt does not exist!"
    	}
}

# USER_V2LVS should define a macro list,

#foreach lib_ckt [array names GFVAR_STDCELL_SPICE] {
#	if { [file exists $GFVAR_STDCELL_SPICE($lib_ckt)] } {
#		puts "INFO: including $GFVAR_STDCELL_SPICE($lib_ckt) "
#		set V2LVS_CMD "$V2LVS_CMD -s $GFVAR_STDCELL_SPICE($lib_ckt)"
#	} else {
#		puts "WARNING: $GFVAR_STDCELL_SPICE($lib_ckt) does not exist!"
#    	}
#}
#
#foreach lib_ckt [array names GFVAR_HPK_CELL_SPICE] {
#	if { [file exists $GFVAR_HPK_CELL_SPICE($lib_ckt)] } {
#		puts "INFO: including $GFVAR_HPK_CELL_SPICE($lib_ckt) "
#		set V2LVS_CMD "$V2LVS_CMD -s $GFVAR_HPK_CELL_SPICE($lib_ckt)"
#	} else {
#		puts "WARNING: $GFVAR_HPK_CELL_SPICE($lib_ckt) does not exist!"
#    	}
#}
foreach lib_ckt $GFVAR_STDCELL_SPICE {
	if { [file exists $lib_ckt] } {
		puts "INFO: including $lib_ckt "
		set V2LVS_CMD "$V2LVS_CMD -s $lib_ckt"
	} else {
		puts "WARNING: $lib_ckt does not exist!"
    	}
}
set V2LVS_CMD "$V2LVS_CMD -o $GFVAR_DESIGN(name).v2lvs.net -v $IN_VERILOG"

puts "V2LVS_CMD is $V2LVS_CMD"
puts "Executing"

catch { eval exec $V2LVS_CMD }

exit
