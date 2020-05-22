source ../../project_setup.tcl


set OFILE [open  RUN_LN22FDX_PM w]


puts $OFILE "# PM Flow variables"
puts $OFILE "setenv  TECHDIR ${GFVAR_PDK_HOME}/DFM/DRCplus/Calibre/PM"
puts $OFILE "setenv  OUTPUT_DIR	\".\" "
puts $OFILE "setenv  SKIP_CELL \'\' "
puts $OFILE "setenv  CPU_COUNT ${GFVAR_CALIBRE_NUM_CPU_USED}"

puts $OFILE "setenv  PM_MAIN_RULE_FILE \${TECHDIR}/Include/LN22FDX_PM_MAIN.tvf "
puts $OFILE "setenv  PM_LAYERS_MAPPING_FILE \${TECHDIR}/Include/22FDX_Layermap.svrf "

puts $OFILE "setenv  PM_LIBRARY_FILE1 \${TECHDIR}/Include/Library/PM.M1.CB.svrf "
puts $OFILE "setenv  PM_LIBRARY_FILE2 \${TECHDIR}/Include/Library/PM.M2.AY.svrf "
puts $OFILE "setenv  PM_LIBRARY_FILE3 \${TECHDIR}/Include/Library/PM_M2_Vx_C_x.svrf"
puts $OFILE "setenv  PM_LIBRARY_FILE4 \${TECHDIR}/Include/Library/PMGEN_M2_Vx_C_x.svrf"


puts $OFILE "setenv  RDB_DIR_PM \${OUTPUT_DIR}/rdb/${GFVAR_DESIGN(name)} "
puts $OFILE "setenv  OUTPUT_RDB_PM \${RDB_DIR_PM}/${GFVAR_DESIGN(name)}_PM.rdb "
puts $OFILE "setenv  OUTPUT_RDB_PM_lv2 \${RDB_DIR_PM}/${GFVAR_DESIGN(name)}_PM_LV2.rdb "
puts $OFILE "setenv  OUTPUT_RDB_PM_ALL \${RDB_DIR_PM}/${GFVAR_DESIGN(name)}_PM_ALL.rdb "
puts $OFILE "setenv  OUTPUT_SUM_PM \${RDB_DIR_PM}/${GFVAR_DESIGN(name)}_PM.sum "
puts $OFILE "mkdir -p \${RDB_DIR_PM} \${OUTPUT_DIR}/log_file "

close $OFILE
