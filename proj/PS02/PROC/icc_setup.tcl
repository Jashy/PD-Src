###1. all_threestate optimization how ?
##2. connect_tie_cells -obj_type cell_inst \
#   -objects [get_cells -of_objects [get_nets Multiplier/SNPS_LOGIC1 -all]] \
#   -tie_high_lib_cell TIEHI -tie_low_lib_cell XOR2X4M
##3. how to optimizaiont for dedicated target library:
##    set opcon sc_max_worst
##    set libA "sc_max.db"
##    set libAname "sc_max"
##    set libB "sc_specialbuffers_max.db"
##    set libBname "sc_specialbuffers_max"
##
##    set target_library "$libA $libB"
##    set_target_library_subset "$libA" -top
##    set_target_library_subset "$libB" -object_list [get_cells I_sub2]
##    set_target_library_subset "$libA" -object_list [get_cells I_sub2/I_sub3_2]
##
##    set_operating_conditions -library $libA:$libAname $opcon
##    set_operating_conditions -library $libB:$libBname $opcon \ 
##                             -object_list [get_cells I_sub2]
##    set_operating_conditions -library $libA:$libAname $opcon \ 
##                             -object_list [get_cells I_sub2/I_sub3_2]
##4. leakage 
## set_scenario_options -leakage_only true 
## set_scenario_options -leakage_power true
##5.skew group
##set_skew_group -name B [get_pins {F2/CP F3/CP}] -target_skew 0.03
##commit_skew_group
##6.opt buffer
#set_app_var routeopt_verbose 65
##7. freezon net
#define_routing_rule -default_reference_rule freeze_rule
#set_net_routing_rule -rule freeze_rule -reroute freeze [get_net net_A ]
##8. zroute based psyn
#set_app_var placer_enable_enhanced_router true
#set_route_mode_options -zroute true
#place_opt -congestion


## nsp
#set MW_LIB "NSP_SOC"
#set TOP         dpath
#set VNET_LIST   "/proj/NSP2/CURRENT/PNR/ivesl/ENCOUNTER/1206/work/db/RouteEco1206.enc.dat/nsp.v"
#set DEF "/user/home/nealj/NSP2/ICC_SOC_1207/nspRouteEco.def"
#set LEF 		"/user/home/nealj/NSP2/tech.lef"
#set TECH_FILE   "/proj/NSP/CURRENT/PNR/ives/ASTRO/tsmcn65_8lmT2.tf_mody"
#set_mw_technology_file "/proj/NSP/CURRENT/PNR/ives/ASTRO/tsmcn65_8lmT2.tf_mody"
#set MAP_FILE    "/proj/NSP/CURRENT/PNR/ives/ICC/common/star_map.mody"
#set TlUP_WORST  "/proj/NSP/LIB/Tech/Milkyway_Tech/techfiles/tluplus/cln65g+_1p08m+alrdl_top2_cworst.tluplus"
#set db_setup_file "/proj/BM/TEMPLATES/PT/PT_lib.BM2.tcl"
#set db_setup_file "/user/home/nealj/NSP/nsp_slow_lib.tcl"
#set lib_name sc12_cln65gplus_base_lvt_ss_typical_max_0p90v_125c
#set TIE_LOW_lib_cell  ${lib_name}/TIELO_X1M_A12TR
#set TIE_HIGH_lib_cell ${lib_name}/TIEHI_X1M_A12TR
#set ISO_lib_cell ${lib_name}/BUFH_X16M_A12TL
#set symbol_library ""
#set target_library  [list tcbn65lphpbwplvtwcl.db \
#                        ts1n65lpa2048x16m8_140a_ss1p08vm40c.db \
#                        ts5n65lpa256x16m4_140a_ss1p08vm40c.db \
#  ]
#set mw_reference_library  " /proj/BM/LIB/CURRENT/SC_10/tcbn65lphpbwplvt_140a/TSMCHOME/digital/Back_End/milkyway/tcbn65lphpbwplvt_140a/frame_only/tcbn65lphpbwplvt \
#			 /proj/BM/LIB/CURRENT/SC_10/tcbn65lphpbwp_140a/TSMCHOME/digital/Back_End/milkyway/tcbn65lphpbwp_140a/frame_only/tcbn65lphpbwp \
#	/proj/BM/WORK/INTERNAL/Neal/LIB/MEM_DB \
#"
# leo2 setting
set process 65nm
set AC_opt yes ; # no or yes
set MW_LIB "BLK_dpath"
set TOP         dpath
set STA_MODE    setup
set STA_COND    slow
set VNET_LIST   "/proj/LEO2/WORK/INTERNAL/aresy/DFT/SCAN/NET/dpath.scan.v"
set DEF         "/proj/LEO2/WORK/INTERNAL/aresy/PSYN/data/fp.def.new"
set BLOCKAGE    ""
set TECH_FILE   "/proj/LEO2/LIB/SC/CURRENT/RDF/tech/astro/CS104/8/tech.tf"
set MAP_FILE    "/proj/LEO2/LIB/SC/CURRENT/RDF/tech/starrcxt/CS104/8/layer.map"
set TlUP_WORST   "/proj/LEO2/LIB/SC/CURRENT/RDF/tech/starrcxt/CS104/8/capw/TLUPlus_mfe.200706SP1"
set mw_reference_library    "/proj/LEO2/WORK/INTERNAL/aukoz/lib/CS104SN \
                             /proj/LEO2/WORK/INTERNAL/aukoz/lib/CS104SZ \
                             /proj/LEO2/WORK/INTERNAL/aukoz/lib/RAMROM_0819 \
                             /proj/LEO2/WORK/INTERNAL/aukoz/lib/fuse_0819 \
                             /proj/LEO2/WORK/INTERNAL/aukoz/lib/cs104_104CWJW_XTAL_33_io_IOFVD \
                             /proj/LEO2/WORK/INTERNAL/aukoz/lib/cs104_104FWFX_LVDS_33_io_IOFVD \
                             /proj/LEO2/WORK/INTERNAL/aukoz/lib/cs104_socketize_ip_APLL_PL10AS01 \
                             /proj/LEO2/WORK/INTERNAL/aukoz/lib/io \
                             /proj/LEO2/WORK/INTERNAL/aukoz/lib/cs104_socketize_ip_APLL_ANALOGIOW4H20 \
                             /proj/LEO2/WORK/INTERNAL/aukoz/lib/cs104_104CX_POWSUPCELL_L_196_33_io_IOFVD \
                             /proj/LEO2/WORK/INTERNAL/aukoz/lib/dll_analog_1016 \
                             /proj/LEO2/WORK/INTERNAL/aukoz/lib/TIE"
set db_setup_file "/proj/LEO2/WORK/INTERNAL/aresy/PSYN/Fujitsu_slow_lib.tcl.icc"
set lib_name cs104sz_uc_core_s_p125_085v
#set TIE_LOW_lib_cell  ${lib_name}/TIELO_X1M_A12TR
#set TIE_HIGH_lib_cell ${lib_name}/TIEHI_X1M_A12TR
set ISO_lib_cell ${lib_name}/SCVBUFXL1
#
set ECO_VERSION "" ; # set it if ECO 
set STA_COND "WCCOML" ; # select the lib 
set XTALK "TRUE" ; # TRUE or FALSE
set IO_TIMING "FALSE" ; # TRUE or FALSE
set CLOCK_MODE ideal 
set MDB_LIB_OLD ""
set MDB_LIB_NEW "MDB_${TOP}"
set ECO_DEF     ""
set BLOCKAGE    ""
set SDC_LIST    ""
set DATE        [ sh date +%y%m%d-%T ]
set SESSION     ${TOP}${ECO_VERSION}_${DATE}
set ignore_binding_open_pins "*"
set cts_instance_name_prefix "ALCHIP${ECO_VERSION}_${TOP}_"
sh mkdir -p ${SESSION}.run
### place opt setup ###
set MAX_FANOUT 10
set MAX_CAPACITANCE 0.3
set MAX_TRANSITION  0.500
set MAX_NET_LENGTH  800
set CAPACITANCE_SCALING_FACTOR 1.1
set RESISTANCE_SCALING_FACTOR 1.1
set DONT_TOUCH_FILE "" ; # 
### route opt setup ###
set MAX_ROUTING_LAYER M8
###
if { $process eq "130nm"} {
	set max_net_ccap_thres 0.003 
	set max_net_ccap_ratio 0.03
} elseif { $process eq "90nm" } {
	set max_net_ccap_thres 0.003 
	set max_net_ccap_ratio 0.03
} elseif { $process eq "65nm" } {
	set max_net_ccap_thres 0.001 
	set max_net_ccap_ratio 0.03

} elseif { $process eq "45nm" } {
	set max_net_ccap_thres 0.001 
	set max_net_ccap_ratio 0.03

}
#################################
# SETUP LIBRARY
#
suppress_message {PSYN-040 }
source /user/home/nealj/tcl/ICC_TEMPLATE/script/PSYN_setup.tcl
source /user/home/nealj/tcl/ICC_TEMPLATE/script/report_violation.tcl
source /user/home/nealj/tcl/ICC_TEMPLATE/script/report_violation_summary.tcl
source /user/home/nealj/tcl/ICC_TEMPLATE/script/report_cpu_usage.tcl
source /user/home/nealj/tcl/ICC_TEMPLATE/script/timing.tcl
source /user/home/nealj/tcl/icc_proc.tcl
set collection_result_display_limit 100
set enable_recovery_removal_arcs true
set timing_enable_multiple_clocks_per_reg true
set case_analysis_sequential_propagation always
##

##################################
#  run
#if { $ECO_VERSION != "" } {
#	source /user/home/nealj/tcl/ICC_TEMPLATE/create_FP.tcl
#	source /user/home/nealj/tcl/ICC_TEMPLATE/ISO_cell_port.tcl
#	source /user/home/nealj/tcl/ICC_TEMPLATE/pg_defination.tcl
#	source /user/home/nealj/tcl/ICC_TEMPLATE/tie_cell.tcl
#	source /user/home/nealj/tcl/ICC_TEMPLATE/read_sdc.tcl
##	source /user/home/nealj/tcl/ICC_TEMPLATE/route_FB.tcl
#	source /user/home/nealj/tcl/ICC_TEMPLATE/place_opt.tcl
#	source /user/home/nealj/tcl/ICC_TEMPLATE/route_opt.tcl
#	source /user/home/nealj/tcl/ICC_TEMPLATE/write_out.tcl
#} else  {
#	source /user/home/nealj/tcl/ICC_TEMPLATE/create_FP_eco.tcl
#	source /user/home/nealj/tcl/ICC_TEMPLATE/tie_cell.tcl
#	source /user/home/nealj/tcl/ICC_TEMPLATE/place_opt_eco.tcl
#	source /user/home/nealj/tcl/ICC_TEMPLATE/route_opt_eco.tcl
#	source /user/home/nealj/tcl/ICC_TEMPLATE/write_out_eco.tcl
#  
#}
#

