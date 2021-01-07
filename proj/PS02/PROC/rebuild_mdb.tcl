
#################################################################
#create MW database
create_mw_lib -tech $TECH_FILE $MW_LIB
set_mw_lib_reference -mw_reference_library $MW_REF_LIB ./$MW_LIB
open_mw_lib $MW_LIB

########################################################################
# step
set STEP read_design
########################################################################
# READ DESIGN
#
sh rm -f ${SESSION}.run/read_verilog.log
foreach VNET ${VNET_LIST} {
  read_verilog ${VNET} >> ${SESSION}.run/read_verilog.log
}
current_design ${TOP}

link > ${SESSION}.run/link.log

save_mw_cel -as $MW_CEL
save_mw_cel -as $STEP

########################################################################
# step
set STEP read_fp

########################################################################
# FLOORPLAN
echo "INFO: read_def start"

if { ${FP_DEF} != "" } {
   current_design ${TOP}
   read_def -allow_physical  -enforce_scaling  ${FP_DEF} > ${SESSION}.run/read_def.log
}

########################################################################
# connect standard cell PG
derive_pg_connection    -power_net $mw_power_net -ground_net $mw_ground_net \
                        -power_pin $mw_power_pin -ground_pin $mw_ground_pin


save_mw_cel
save_mw_cel -as $STEP

close_mw_cel
close_mw_lib

########################################################################
# ECO MDB
#
#  source ${TCL_SRC}/set_design_constrain.tcl
#
#  source ${TCL_SRC}/create_scenarios.tcl
#
#set ECO_STRING  ECO_4
#
#set ECO_SCRIPTS "/proj/Garnet/WORK/marshals/PT/inter/change_clock_cell_type_0924.tcl /proj/Garnet/WORK/jimmyx/PT/20090923b/PT_ruby_top_20090923a_slow_normal_
#xtk.run/eco_0924.tcl /proj/Garnet/WORK/danielw/PT/TOP/20090923a_no_gating/fix_ddr_all.tcl /proj/Garnet/WORK/marshals/ICC/timing_eco/eco_script/eco_4.tcl"
#  foreach SCRIPT $ECO_SCRIPTS {
#    source -e $SCRIPT >> ${SESSION}.run/ECO_CMD_${STEP}.log
#  }
#
#
#set ECO_STRING  ECO_5
#
#set ECO_SCRIPTS "/proj/Garnet/WORK/marshals/ICC/timing_eco/eco_script/eco_5.tcl /proj/Garnet/WORK/jimmyx/PT/20090924b/PT_ruby_top_20090924a_slow_normal_xtk.r
#un/eco_0925.tcl"
#  foreach SCRIPT $ECO_SCRIPTS {
#    source -e $SCRIPT >> ${SESSION}.run/ECO_CMD_${STEP}.log
#  }
#
#save_mw_cel
#save_mw_cel -as ECO_5
#
