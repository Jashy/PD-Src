## Compliant with PDK 1.0
source ../../project_setup.tcl

set OFILE [open ../calibre_sourceme w]

# Flow variables
puts $OFILE "# Flow variables"
puts $OFILE "setenv MODULE_NAME $GFVAR_DESIGN(name)"
puts $OFILE "setenv BLOCK $GFVAR_DESIGN(name)"
puts $OFILE "setenv BEOL_STACK $GFVAR_STACK"
puts $OFILE "setenv PKG_OPTION LBthick"
puts $OFILE "setenv SOURCE_LVS_NETLIST \"../design_data/verilog/$GFVAR_DESIGN(name).routed.lvs.v\" "
puts $OFILE "setenv HCELL_LIST $GFVAR_LVS_HCELL_LIST\n"
## Option for the -turbo Calibre switch
puts $OFILE "setenv  CPU_COUNT ${GFVAR_CALIBRE_NUM_CPU_USED}"

puts $OFILE "# PDK related variables"
puts $OFILE "setenv PDK_HOME $GFVAR_PDK_HOME"
puts $OFILE "setenv TECHDIR_DRC $GFVAR_PDK_HOME/DRC/Calibre"
puts $OFILE "setenv TECHDIR_LVS $GFVAR_PDK_HOME/LVS/Calibre"
puts $OFILE "setenv BATCH YES"
puts $OFILE "setenv CALIBRE_DRC_DECK $GFVAR_CALIBRE_DRC_DECK"
puts $OFILE "setenv CALIBRE_LVS_DECK $GFVAR_CALIBRE_LVS_DECK\n"

puts $OFILE "# Calibre DRC variables"
puts $OFILE "setenv LAYOUT_PRIMARY $GFVAR_DESIGN(name)"
puts $OFILE "setenv LAYOUT_FILE_TYPE_EXT ${GFVAR_CALIBRE_LAYOUT_EXT}"

if {$GFVAR_CALIBRE_USE_FILL_GDS=="TRUE"} {
  puts $OFILE "# Using Fill ${GFVAR_CALIBRE_LAYOUT_SYSTEM}"
  puts $OFILE "setenv LAYOUT_PATH ../design_data/gds/$GFVAR_DESIGN(name).merged.${GFVAR_CALIBRE_LAYOUT_EXT}"
} else {
  puts $OFILE "# Using Non-Fill Merged ${GFVAR_CALIBRE_LAYOUT_SYSTEM}"
  puts $OFILE "setenv LAYOUT_PATH ../run_merge/$GFVAR_DESIGN(name)_stdcell_merged.${GFVAR_CALIBRE_LAYOUT_EXT}"
}

puts $OFILE "setenv LAYOUT_SYSTEM ${GFVAR_CALIBRE_LAYOUT_SYSTEM}"
puts $OFILE "setenv RESULTS_DATABASE $GFVAR_DESIGN(name).drc.ascii"
puts $OFILE "setenv SUMMARY_REPORT $GFVAR_DESIGN(name).drc.report"
puts $OFILE "setenv SOURCE_PRIMARY $GFVAR_DESIGN(name)"
puts $OFILE "setenv SOURCE_SYSTEM SPICE"
puts $OFILE "setenv LVS_REPORT $GFVAR_DESIGN(name).lvs.report"
puts $OFILE "setenv SOURCE_PATH ../run_v2lvs/$GFVAR_DESIGN(name).v2lvs.net\n"
#puts $OFILE "setenv CALIBRE_LVS_OPTIONS $GFVAR_LVS_OPTIONS\n"

if {$GFVAR_TECH_PROCESS == "14LPP"} {
        puts $OFILE "setenv DESIGN_TYPE CELL_NODEN"
        puts $OFILE "setenv CELL_BOUNDARY OUTLINE"
		  puts $OFILE "setenv CHIP_DIE_COUNT	1CHIP_SHOT"
        puts $OFILE "setenv IOTYPE INLINE_50"
        puts $OFILE "setenv LAYOUT_SYSTEM ${GFVAR_CALIBRE_LAYOUT_SYSTEM}"
        puts $OFILE "setenv C_ORIENTATION VERTICAL"
        puts $OFILE "setenv DP_FLAT_DESIGN_ALL NO"
        puts $OFILE "setenv DP_GENERATION_TOOL_ALL YES"
        puts $OFILE "setenv DRC_SAME_MASK NO"
        puts $OFILE "setenv DP_CHECK_DESIGN_ALL YES"
        puts $OFILE "setenv DP_DECOMP_PREVIEW NO"
        puts $OFILE "setenv DP_LAYOUT_OUT ${GFVAR_CALIBRE_LAYOUT_SYSTEM}"
        puts $OFILE "setenv DP_AUTO_STITCH_ALL NO"
        puts $OFILE "setenv DP_AUTO_FILLSTITCH NO"

} elseif {$GFVAR_TECH_PROCESS == "22FDSOI"} {
        puts $OFILE "# Calibre 22fdsoi related settings"
        puts $OFILE "setenv DENSITY_RULES YES"
        puts $OFILE "setenv BURN_IN YES"
        puts $OFILE "setenv LAYOUT_SYSTEM ${GFVAR_CALIBRE_LAYOUT_SYSTEM}"
        puts $OFILE "setenv RULE_PHASE NOMINAL"
        puts $OFILE "setenv C_ORIENTATION VERTICAL"
      # puts $OFILE "setenv DP_MANUAL_DESIGN M1"
      # puts $OFILE "setenv DP_GENERATION_TOOL M2M3"
      # puts $OFILE "setenv DP_GENERATION_TOOL_R0 YES"
       # puts $OFILE "setenv DP_OUT_MXEZ_ONLY YES"
        puts $OFILE "setenv DRC_SAME_MASK NO"
       # puts $OFILE "setenv DP_DECOMP_PREVIEW NO"
        puts $OFILE "setenv DP_LAYOUT_OUT ${GFVAR_CALIBRE_LAYOUT_SYSTEM}"
       # puts $OFILE "setenv DP_DECOMP_QA NO"
#	puts $OFILE "setenv DP_AUTO_STITCH_ALL NO"
#	puts $OFILE "setenv DP_AUTO_FILLSTITCH NO"
	puts $OFILE "setenv PEX_RUN FALSE"
	puts $OFILE "setenv CHECK_MOSFET_NF FALSE"
	puts $OFILE "setenv CHECK_MOSFET_ULP FALSE"
	puts $OFILE "setenv CHECK_MOSFET_PLORIENT FALSE"
	puts $OFILE "setenv ANTENNA_DEBUG NO"
	puts $OFILE "setenv INCLUDE_FILE $GFVAR_LVS_INCLUDE_LIST"
	puts $OFILE "setenv CUSTOM_ESD IGNORE"
	puts $OFILE "setenv HV_DEBUG NO"
	puts $OFILE "setenv HV_DEBUG_DETAILED NO"
	puts $OFILE "setenv MOB_OPTION NMOB"
	puts $OFILE "setenv RECOMMENDED_RULES NO"
	puts $OFILE "setenv YLC_STD_CELL NO"
        puts $OFILE "setenv RUN_ERC RUN_ALL"
	puts $OFILE "setenv MARK_CENTERLINE FALSE"
### Setup for DRC with DP_colored GDS/OASIS merged or not
        	if { [file exists ../dp_merge] } {
				puts $OFILE "### DRC with M2 colored"
                             	if  {$GFVAR_DESIGN_TYPE == "BLOCK"} {
					 puts $OFILE "setenv DESIGN_TYPE CELL"
                                } else {
                                         puts $OFILE "setenv DESIGN_TYPE CHIP"
                                }
				puts $OFILE "setenv DP_GENERATION_TOOL_ALL NO"
					puts $OFILE "setenv DP_CHECK_DESIGN_ALL NO"
				puts $OFILE "setenv DP_FLAT_DESIGN_ALL NO"
				puts $OFILE "setenv DP_OFF_ALL YES"
				puts $OFILE "setenv DP_APPLY_BALANCING NO" 
			#	puts $OFILE "setenv DP_CHECK_DESIGN_M1 NO"
				puts $OFILE "setenv LAYOUT_PATH ../run_drc/$GFVAR_DESIGN(name).final.${GFVAR_CALIBRE_LAYOUT_EXT}"
			} else {
				puts $OFILE "### DRC with M2 not colored"
   				puts $OFILE "setenv DESIGN_TYPE DP_ONLY"
				puts $OFILE "setenv DP_GENERATION_TOOL_ALL YES"
				puts $OFILE "setenv DP_CHECK_DESIGN_ALL YES"
				puts $OFILE "setenv DP_FLAT_DESIGN_ALL NO"
				puts $OFILE "setenv DP_OFF_ALL NO"
				puts $OFILE "setenv DP_APPLY_BALANCING YES" 
			}
		if {$GFVAR_DESIGN_TYPE == "BLOCK"} {
			puts $OFILE "### DRC setting of BLOCK"
                        puts $OFILE "setenv IOTYPE INLINE"
                        puts $OFILE "setenv PWRS VDD"
                        puts $OFILE "setenv GNDS VSS"
                    } else {
			puts $OFILE " ### DRC setting of TOP"
			puts $OFILE "setenv IOTYPE R_CuP_150"
			puts $OFILE "setenv PWRS \"VDD VDDM VDD03 VDD02 PLLVDDIO\""
                        puts $OFILE "setenv GNDS \"VSS VSS02 VSS03 PLLVSSIO\""
			puts $OFILE "setenv PWR18 \"VDD03 VDD02 PLLVDDIO\""
                    }

}

close $OFILE

# Setup file for 22FDSOI BEOL fill in tcl
set OFILE [open ${GFVAR_DESIGN(name)}.cfill.setup w]
puts $OFILE "# Setup file for 22FDSOI BEOL"
puts $OFILE ""
puts $OFILE "set variables \{"
puts $OFILE "  \}"

if {$GFVAR_DESIGN_TYPE == "BLOCK"} {
	puts $OFILE "set boundary_layer_override OUTLINE"
	puts $OFILE "set append_svrf \{"
	puts $OFILE "  FRAME_REGION = (SIZE OPEN_FRAME BY -1.0) NOT (SIZE PROTECT BY 0.5)"
	puts $OFILE "  PRIME_REGION = SIZE OUTLINE BY -1.0"
	puts $OFILE "  \}"
} else {
	puts $OFILE "set boundary_layer_override GUARDEDG"
	puts $OFILE "set append_svrf \{"
        puts $OFILE "PRIME_REGION = COPY GUARDEDG"
        puts $OFILE "FRAME_REGION = (SIZE OPEN_FRAME BY -1.0) NOT PROTECT"
        puts $OFILE " \}"
}

puts $OFILE "set data_dir ${GFVAR_PDK_HOME}/FILLGEN/Calibre"  
puts $OFILE "set tiles_gen_layer_override $GFVAR_CALIBRE_FILL_OPTION"

puts $OFILE "set skip_cell_merge 0" 
puts $OFILE "set verbose 1"
puts $OFILE "set suffix_gen_tiles_output _gt"
puts $OFILE "set tech_node 22fdsoi"
puts $OFILE "set feol_only 0"
puts $OFILE "set feol_ca_m1 0"
puts $OFILE "set beol_only 0"
puts $OFILE "set ca_select 0"
puts $OFILE "set pci_marker 0"
puts $OFILE "set rebal_fill 0"
puts $OFILE "set np_optimize 1" 
puts $OFILE "set nplus_select 0"
puts $OFILE "set nepi_max_dens 0.02"
puts $OFILE "set pepi_max_dens 0.13"
#puts $OFILE "set beol_max_dens 0.68"
puts $OFILE "set m1_max_dens 0.68"
puts $OFILE "set m2_max_dens 0.99"
puts $OFILE "set c1_max_dens 0.68"
puts $OFILE "set c2_max_dens 0.99"
puts $OFILE "set c3_max_dens 0.68"
puts $OFILE "set c4_max_dens 0.99"
puts $OFILE "set c5_max_dens 0.68"
puts $OFILE "set c6_max_dens 0.68"
puts $OFILE "set ba_max_dens 0.68"
puts $OFILE "set bb_max_dens 0.68"
puts $OFILE "set ja_max_dens 0.60"
puts $OFILE "set jb_max_dens 0.68"
puts $OFILE "set oi_max_dens 0.01"
puts $OFILE "set qa_max_dens 0.68"
puts $OFILE "set qb_max_dens 0.68"
puts $OFILE "set verbose 1"
puts $OFILE "set ncpu ${GFVAR_CALIBRE_NUM_CPU_USED}"
puts $OFILE "# BEOL CFILLOPC effort level option"
puts $OFILE "# Note: Effort level must be an integer between 1 and 10"
puts $OFILE "set effort_level 10"

close $OFILE



