sh mkdir -p LOG Runtime Ready REPORT
set STEP VNET_20150901
########################################################################
# READ DESIGN
import_designs -format verilog -top $TOP -cel $TOP $VNET_LIST 
current_design $TOP
#uniquify
uniquify_fp_mw_cel -verbose
link -force
save_mw_cel -as ${STEP}_read_design

derive_pg_connection -power_net VDD -power_pin VDD -ground_net VSS -ground_pin VSS
create_die_area -boundary {98 98 3540 3540}
create_floorplan -control_type boundary -left_io2core 2 -bottom_io2core 2 -right_io2core 2 -top_io2core 2
read_def -enforce_scaling /proj/BTC/WORK/dongleia/ICC/150829/BTC_allIO_andPAD_150831_update2.def
remove_terminal *
source -e ./LKB11_macro_place_20150901a.tcl
source -e ./LKB11_BLKG_20150901a.tcl
source -e ./flow_btc/UPF/insert_levelshift.tcl > LEVEVLSHIFT_LOG/insert_levelshift.log
check_mv_design -verbose > LEVEVLSHIFT_LOG/check_mv_design.log
source -e ./LKB11_voltage_area_20150901a.tcl
source -e ./LKB11_BLKG_20150901a.tcl
source -e ./flow_btc/tcl/insert_boundary.tcl
source -e ./flow_btc/LKB11_power_plan_20150730a.tcl
source -e ./LKB11_C7_G1_LB_shapes_20150901a.tcl
source -e ./LKB11_C6_makeup_shapes_20150901a.tcl
#-#-  define_name_rules verilog -check_bus_indexing -allowed {a-zA-Z0-9_} -remove_internal_net_bus -flatten_multi_dimension_busses -first_restricted "\\"
#-#-  change_names -rules verilog -hier -verbose
source -e ./LKB11_bounds_20150901a.tcl
source -e ./LKB11_preplaced_clk_levelshift_20150901a.tcl
#-#-  create_fp_placement
source -e ./flow_btc/insert_preplace_buffer.tcl
source -e ./LKB11_CLK_ANCHOR_placement_20150901a.tcl
source -e ./flow_btc/Insert_ISO.tcl

#-#-  source -e ./flow_btc/isolation_buffer.tcl

define_name_rules verilog -check_bus_indexing -allowed {a-zA-Z0-9_} -remove_internal_net_bus -flatten_multi_dimension_busses -first_restricted "\\"
change_names -rules verilog -hier -verbose
create_fp_placement

save_mw_cel -as ${STEP}_fp

########################################################################
# export
source -e flow_btc/tcl/export_des.tcl
