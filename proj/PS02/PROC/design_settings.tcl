########################################################################
## SETTINGS FOR DESIGN AND ENVIROMENT
########################################################################

########################################################################
# ICC START
#
list $sh_product_version
echo [ format "icc_shell started on %s at %s" [ sh /bin/hostname ] [ sh /bin/date ] ]

if { [info exist DATE] == 0} {
    set DATE	    [ sh date +%y%m%d ]
}

echo "DATE : $DATE"
########################################################################
# DEFINE VARIABLES
#
set TOP			ZHUIIO
set STA_MODE		setup
set STA_COND		slow
#set NEW_VNET_LIST	""
set VNET_LIST		/proj/Zhui/CURRENT/DFT/frankz/ES/release/netlist/20100315_ZHUIIO_NETLIST_DFT_ECO.v
set DEF			/proj/Zhui/CURRENT/PNR/chloec/ES/ICC/0314_FP/ZHUIIO_icc.def
#set PGROUTE             { /proj/Hydra5/RELEASE/20091021_FP_1/HYDRA5IO_20091020_power_nets.tcl
#                          /proj/Hydra5/RELEASE/20091021_FP_1/HYDRA5IO_20091020_analog_nets.tcl }
#set ROUTEGUIDE            /proj/Hydra5/RELEASE/20091021_FP_1/HYDRA5IO_20091020_route_guide.tcl
#set ROUTEGUIDE_DM	""
#set REGION              /proj/Hydra5/RELEASE/20091020_FP/HYDRA5IO_region.tcl
#set BLOCKAGE            /proj/Hydra5/RELEASE/20091021_FP_1/HYDRA5IO_20091021c_place_blkg.tcl
set FUNC_SDC		/proj/Zhui/CURRENT/PNR/donid/release/0312/ZHUIIO_pt_normal-mode_wcl_cworst_setup_20100308.sdc.mod.2
#set MBIST1_SDC		/proj/Zhui/CURRENT/PNR/donid/release/0314/mbist_psyn/mbist1.sdc
set MBIST2_SDC		/proj/Zhui/CURRENT/PNR/donid/release/0314/mbist_psyn/mbist2.sdc
set MBISTR_SDC		/proj/Zhui/CURRENT/DFT/frankz/ES/release/sdc/bistr/ZHUI_bistr.sdc
set SCAN_CAPTURE_DC	/proj/Zhui/CURRENT/DFT/frankz/ES/release/sdc/scan/ZHUI_scan_capture_dc.sdc
#set SCAN_CAPTURE_AC	/proj/Zhui/CURRENT/DFT/frankz/release/sdc/4occ/ZHUI_scan_capture_occ.sdc
set KEEP_LIST		{
			/proj/Zhui/CURRENT/PNR/donid/release/0311/ZHUI_KEEP_INSTANCE_CELL_20100311.tcl.set_size_only_cell
			/proj/Zhui/CURRENT/DFT/frankz/ES/release/keep_cell/ZHUI_KEEP_INSTANCE_CELL_DFT.tcl
			}

#set ISOLATION_BUFFER    {
#			/proj/Hydra5/RELEASE/20091021_FP_1/HYDRA5IO_20091019_ISOLATION_PLLPW.tcl
#			/proj/Hydra5/RELEASE/20091021_FP_1/HYDRA5IO_20091023_ISOLATION_NOARC.tcl
#			/proj/Hydra5/RELEASE/20091021_FP_1/HYDRA5IO_20091023_ISOLATION_PLLOSC.tcl
#			/proj/Hydra5/RELEASE/20091021_FP_1/HYDRA5IO_20091023_ISOLATION_PLLOSC_SIGNAL.tcl
#			/proj/Hydra5/RELEASE/20091021_FP_1/HYDRA5IO_20091023_KEEP_ISOLATION.tcl
#			}

#set CNB_GROUP		../sample/net_guide.tcl
set DONT_USE_LIST1	/proj/Zhui/CURRENT/STA/rogern/ICC/ZhuiES/tcl/set_dont_use.tcl
set DONT_USE_LIST2	/proj/Zhui/CURRENT/STA/rogern/ICC/ZhuiES/tcl/DONT_USE_LIB.tcl
#set DONT_USE_forroute	/proj/Zhui/TEMPLATES/ICC/DONT_USE_forroute.tcl
set DONT_TOUCH_LIST	/proj/Zhui/CURRENT/PNR/donid/release/0311/ZHUI_DONT_TOUCH_WIRE_20100308.tcl.set_dont_touch_net
set DERATE		/proj/Zhui/TEMPLATES/ICC/timing_derate.tcl
set SLEW_CONST		""
set SLEW_CONST_ROUTE	""
set SESSION		${TOP}
set mode		ocv_setup
set pvt_wire		wcl_cworst

exec mkdir -p ${SESSION}.run

proc SOURCE {ll} { foreach e $ll { set cmd "source -e $e" ; puts $cmd ; catch "uplevel { $cmd }" }}
proc WAIT_FILE {f} { while {[file exists $f] == 0} { puts "Waiting $f" ; exec sleep 180 } }

########################################################################
# SETUP TIMING LIBRARY
#
# SLOW LIB
source /proj/Zhui/TEMPLATES/PT/PT_lib.tcl
#04/03 lappend search_path   /proj/Hydra5/WORK/tsuji/ICC/LIB
#04/03 lappend link_library "/proj/Hydra5/WORK/tsuji/ICC/LIB/INT_R.db /proj/Hydra5/WORK/tsuji/ICC/LIB/PO_RES.db"

# LINK LIBRARY
echo "LINK_LIBRARY:"
    foreach library $link_library {
		puts $library
	}
# TARGET LIBRARY
    set target_library ""
    foreach library $link_library {
      if {  ( [ regexp {tcb} $library ] == 1 ) } {
		echo $library
	set target_library [ concat $target_library $library ]
      }
    }
echo "TARGET_LIBRARY:"
    foreach library $target_library {
	puts $library
    }

########################################################################
# TLU PLUS & TF	 MILKYWAY REF LIB
#
set TLUP_MAP  /proj/Zhui/LIB/ES/Techfile/starrc/cln65lp_1p05m+alrdl.map
set TLUP_MAX  /proj/Zhui/LIB/ES/Techfile/tluplus/cln65lp_1p05m+alrdl_cworst.tluplus
set TLUP_MIN  /proj/Zhui/LIB/ES/Techfile/tluplus/cln65lp_1p05m+alrdl_cbest.tluplus
set TECH_FILE /proj/Zhui/LIB/ES/Techfile/astro/tsmcn65lp_5lm3x1yAlrdl.tf
set MW_LIB MDB_$TOP
set MW_CEL $TOP

########################################################################
# LOGIC0 AND LOGIC1 NETS
#
set mw_power_net   VDD
set mw_ground_net  VSS
set mw_power_port  VDD
set mw_ground_port VSS
set mw_logic1_net  VDD
set mw_logic0_net  VSS

########################################################################
# MILKYWAY REF LIB
#
set MW_REF_LIB { \
	/proj/Zhui/LIB/ES/SC/TSMCHOME/digital/Back_End/milkyway/tcbn65lp_121c/cell_frame/tcbn65lp \
	/proj/Zhui/LIB/ES/SC/TSMCHOME/digital/Back_End/milkyway/tcbn65lphvt_121c/cell_frame/tcbn65lphvt \
	/proj/Zhui/LIB/ES/ADC_OSC/milkyway \
	/proj/Zhui/LIB/ES/DRAM/Back_End/milkyway/t1hp256kx64milr_c071129_130a0c/frame_only/t1hp256kx64milr_c071129_130a0c \
	/proj/Zhui/LIB/ES/DRAM/Back_End/milkyway/t1hp32kx64milr_c071129_130a0c/frame_only/t1hp32kx64milr_c071129_130a0c \
	/proj/Zhui/LIB/ES/IO/TSMCHOME/digital/Back_End/milkyway/IO_PAD \
	/proj/Zhui/LIB/ES/IO/TSMCHOME/digital/Back_End/milkyway/PFILLER \
	/proj/Zhui/LIB/ES/IO/TSMCHOME/digital/Back_End/milkyway/tpan65lpnv2od3_c071030_140a/mt_2/5lm/cell_frame/tpan65lpnv2od3_c071030 \
	/proj/Zhui/LIB/ES/IO/TSMCHOME/digital/Back_End/milkyway/tpdn65lpnv2od3_c071030_140a/mt_2/5lm/cell_frame/tpdn65lpnv2od3_c071030 \
	/proj/Zhui/LIB/ES/IO/TSMCHOME/digital/Back_End/milkyway/tpzn65lpnv2od3_c071030_140a/mt_2/5lm/cell_frame/tpzn65lpnv2od3_c071030 \
	/proj/Zhui/LIB/ES/PLL/TSMCHOME/mixed_signal/Back_End/milkyway/pgn65lp25mf1000a_130a/cell_frame/pgn65lp25mf1000a_130a \
	/proj/Zhui/LIB/ES/ROM/mdb/ROM
	/proj/Zhui/LIB/ES/SRAM/mdb/SRAM \
	/proj/Zhui/LIB/ES/IIC/TSMCHOME/digital/Back_End/milkyway/tpzn65lpodgv2_iic_c080214_140a/mt_2/5lm/cell_frame/tpzn65lpodgv2_iic_c080214 \
	/proj/Zhui/LIB/ES/Adapter/TSMCHOME/digital/Back_End/milkyway/tpin65nv_130b/mt_2/5lm/frame_only/tpin65nv \
	/proj/Zhui/from_JP/20091222_RES/20091222_INT_R/INT_R/milkyway \
	/proj/Zhui/LIB/ES/PO_RES/milkyway \
	/proj/Zhui/LIB/ES/ESD_FILLER \
	}

########################################################################
# TOOL SETTINGS
#
source /proj/Zhui/TEMPLATES/PT/PT_setup.tcl
set sh_enable_page_mode false
history keep 200
set sh_enable_line_editing true
set enable_recovery_removal_arcs true
set timing_enable_multiple_clocks_per_reg true
set case_analysis_sequential_propagation always
set enable_page_mode false
set enable_recovery_removal_arcs true
set high_fanout_net_threshold 3000

# set timing_enable_multiple_clocks_per_reg true

########################################################################
# PSYN CONTROL
#
set physopt_delete_unloaded_cells		"true"		; # default = "true"
set compile_instance_name_prefix		"ALCHIP_U"	; # default = "U"
set compile_instance_name_suffix		""		; # default = ""
set verilogout_no_tri				"true"		; # default = "false"
set timing_enable_multiple_clocks_per_reg	"true"		; # default = "false"

########################################################################
########################################################################
# AVOIDING TOO MANY MESSAGES
set_message_info -id PSYN-040 -limit 10 ;# Dont_touch for fixed cells
set_message_info -id PSYN-058 -limit 10 ;# Pin direction difference
set_message_info -id PSYN-059 -limit 10 ;# Dont_touch for fixed cells
set_message_info -id PSYN-651 -limit 10 ;# Symmetry is not found
set_message_info -id PSYN-650 -limit 10 ;# Symmetry is not found
set_message_info -id PSYN-267 -limit 10 ;# has no associated site row defined in the floorplan.
set_message_info -id MWLIBP-300 -limit 1 ;# Inconsistent Number Of Metal Layers
set_message_info -id MWLIBP-301 -limit 1 ;# Inconsistent Number Of Metal Layers
set_message_info -id MWLIBP-319 -limit 1 ;# Layer name difference
set_message_info -id MWLIBP-324 -limit 1 ;# Size of cut difference
set_message_info -id MWUI-031 -limit 1 ;# Size of cut difference

########################################################################
set_separate_process_options -placement false -routing false -extraction false

#source /proj/Zhui/TEMPLATES/N2N.tcl
#source /proj/Zhui/TEMPLATES/ICC_bk/write_clock_ideal_script.tcl
########################################################################
#set_separate_process_options -placement false -routing false -extraction false
setenv TMPDIR /proj/Zhui/CURRENT/PNR/donid/TMP
set physopt_tmp_dir /proj/Zhui/CURRENT/PNR/donid/TMP
set sh_enable_page_mode false
