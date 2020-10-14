#limit the number of error, warning, and information messages printed cmd :
# set_message_info -id msg_id -limit number ; number=0 is no limited

list $sh_product_version
echo [ format "icc_shell started on %s at %s" [ sh /bin/hostname ] [ sh /bin/date ] ]

########################################################################
# GET LISENCE
catch "get_license Galaxy-AdvTech"
catch "get_license Galaxy-AdvRules"
catch "get_license Galaxy-Common"
catch "get_license Galaxy-FP"
catch "get_license Galaxy-ICC"
catch "get_license Galaxy-MV"
catch "get_license Galaxy-PNR"
catch "get_license Galaxy-PSYN"
catch "get_license Milkyway-Interface"
########################################################################
# DEFINE VARIABLES
#
set TOP         LKB11;
set MW_LIB	MDB_${TOP} ;
set VNET_LIST   "/proj/BTC/WORK/arckeonw/ICC/TOP/floorplan/NETLIST/LKB11_modify_PLL_IO.v"
set TECH_FILE   "/proj/BTC/LIB_NEW/TechFile/PR_techfile/r2p0-00eac0/milkyway/8M_3Mx_4Cx_1Gx_LB/sc9mcpp84_tech.tf"
#-#-  set TLUP_MAP    "/proj/BTC/WORK/arckeonw/ICC/btc_unit/floorplan_20150625/template/8M_3Mx_4Cx_1Gx_LB_tluplus.map"
#-#-  set TLUP_MAX 	"/proj/BTC/LIB_NEW/TechFile/PR_techfile/r2p0-00eac0/synopsys_tluplus/8M_3Mx_4Cx_1Gx_LB/SigCmaxDP_ErPlus.tluplus"
#-#-  set TLUP_MIN 	"/proj/BTC/LIB_NEW/TechFile/PR_techfile/r2p0-00eac0/synopsys_tluplus/8M_3Mx_4Cx_1Gx_LB/SigRCminDP_ErMinus.tluplus"
 
set db_setup_file "./flow_btc/tcl/PT_lib_20150615a.tcl"  ;
set db_hold_file ""

set mw_reference_library  "\
	/proj/BTC/LIB/SC/sc9mcpp84_base_lvt_c14/arm/samsung/ln14lpp/sc9mcpp84_base_lvt_c14/r3p2/milkyway/9M_3Mx_4Cx_2Gx_LB/sc9mcpp84_ln14lpp_base_lvt_c14 \
	/proj/BTC/LIB/SC/HPK/sc9mcpp84_hpk_lvt_c14/arm/samsung/ln14lpp/sc9mcpp84_hpk_lvt_c14/r3p0/milkyway/9M_3Mx_4Cx_2Gx_LB/sc9mcpp84_ln14lpp_hpk_lvt_c14 \
	/proj/BTC/LIB/SC/sc9mcpp84_base_rvt_c14/arm/samsung/ln14lpp/sc9mcpp84_base_rvt_c14/r3p2/milkyway/9M_3Mx_4Cx_2Gx_LB/sc9mcpp84_ln14lpp_base_rvt_c14 \
	/proj/BTC/LIB/SC/sc9mcpp84_base_lvt_c16/arm/samsung/ln14lpp/sc9mcpp84_base_lvt_c16/r3p2/milkyway/9M_3Mx_4Cx_2Gx_LB/sc9mcpp84_ln14lpp_base_lvt_c16 \
	/proj/BTC/LIB/SC/sc9mcpp84_base_rvt_c16/arm/samsung/ln14lpp/sc9mcpp84_base_rvt_c16/r3p2/milkyway/9M_3Mx_4Cx_2Gx_LB/sc9mcpp84_ln14lpp_base_rvt_c16 \
	/proj/BTC/LIB/SC/HPK/sc9mcpp84_hpk_rvt_c14/arm/samsung/ln14lpp/sc9mcpp84_hpk_rvt_c14/r3p0/milkyway/9M_3Mx_4Cx_2Gx_LB/sc9mcpp84_ln14lpp_hpk_rvt_c14 \
	/proj/BTC/LIB/SC/HPK/sc9mcpp84_hpk_lvt_c16/arm/samsung/ln14lpp/sc9mcpp84_hpk_lvt_c16/r3p0/milkyway/9M_3Mx_4Cx_2Gx_LB/sc9mcpp84_ln14lpp_hpk_lvt_c16 \
	/proj/BTC/LIB/SC/HPK/sc9mcpp84_hpk_rvt_c16/arm/samsung/ln14lpp/sc9mcpp84_hpk_rvt_c16/r3p0/milkyway/9M_3Mx_4Cx_2Gx_LB/sc9mcpp84_ln14lpp_hpk_rvt_c16 \
	/proj/BTC/LIB/SC/PMK/sc9mcpp84_pmk_lvt_c14/arm/samsung/ln14lpp/sc9mcpp84_pmk_lvt_c14/r1p2/milkyway/9M_3Mx_4Cx_2Gx_LB/sc9mcpp84_ln14lpp_pmk_lvt_c14 \
	/proj/BTC/LIB/SC/Supplemental_cell_kits/SC9MCPP84_C14_PMK_YO_LVT/arm/samsung/ln14lpp/sc9mcpp84_pmkyo_lvt_c14/r1p0/milkyway/9M_3Mx_4Cx_2Gx_LB/sc9mcpp84_ln14lpp_pmkyo_lvt_c14 \
	/proj/BTC/LIB/IO/r0p3-00eac0/milkyway/8M_3Mx_4Cx_1Gx_LB/io_gppr_ln14lpp_t18_mv10_fs18_rvt_dr \
	/proj/BTC/WORK/arckeonw/ICC/TOP/floorplan/FRAM/PLL_20150901/milkway \
	/proj/BTC/WORK/arckeonw/ICC/btc_unit/floorplan_20150625/MDB_hce \
	/proj/BTC/WORK/jasons/Milkway/0828_60x75/PAD \
	/proj/BTC/LIB/SC/ECO/sc9mcpp84/arm/samsung/ln14lpp/sc9mcpp84_eco_rvt_c14/r3p0/milkyway/9M_3Mx_4Cx_2Gx_LB/sc9mcpp84_ln14lpp_eco_rvt_c14 \
	/proj/BTC/WORK/jasons/Milkway/0829_CDMM/CDMM \
"
set DATE        [ sh date +%y%m%d ]
set SESSION     ${TOP}_${DATE}
set cts_instance_name_prefix "ALCHIP_${TOP}_"
set num_cpus 16
sh mkdir -p ${SESSION}.run
########################################################################
# SETUP LIBRARY
source -e /proj/HJ/WORK/data/hj_scripts/data/icc_fw.tcl
#-#-  source -e $db_setup_file
set_host_options -max_cores $num_cpus 
########################################################################
# Utility
foreach tcl [glob /proj/HJ/WORK/data/scripts/utility/*.tcl] {
	echo $tcl
	source $tcl
}
source -e /filer/home/arckeon/m_scripts/THP7312/Fishbone/clk_tcl/fishbone_util.tcl
