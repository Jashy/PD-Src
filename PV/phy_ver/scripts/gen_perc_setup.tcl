#!/usr/bin/tclsh
source ../../project_setup.tcl

set OFILE [open run_perc w]

puts $OFILE "# PERC Flow variables"
puts $OFILE "setenv HC_POWER_PAD \"${GFVAR_HC_POWER_PAD}\""
puts $OFILE "setenv LC_POWER_PAD \"${GFVAR_LC_POWER_PAD}\""
puts $OFILE "setenv GROUND_PAD \"${GFVAR_GROUND_PAD}\""
puts $OFILE "setenv FULL_ESD \"${GFVAR_FULL_ESD}\""
puts $OFILE "setenv ESD_RULES \"${GFVAR_ESD_RULES}\""
puts $OFILE "setenv RECOMMENDED_RULES \"YES\""
puts $OFILE "setenv POWER_CHECKS \"YES\""
puts $OFILE "setenv CROSS_DOMAIN_CHECKS \"NO\""

puts $OFILE "setenv netlist_data ../run_v2lvs/$GFVAR_DESIGN(name).v2lvs.net"
puts $OFILE "setenv top_level_cell_name ${GFVAR_DESIGN(name)}"
puts $OFILE "setenv outputdir \"./perc\" "
puts $OFILE "setenv perc_report \${outputdir}/${GFVAR_DESIGN(name)}.perc.report"

puts $OFILE "setenv TECHDIR ${GFVAR_PDK_HOME}/ESD/PERC"
puts $OFILE "setenv CPU_COUNT ${GFVAR_CALIBRE_NUM_CPU_USED}"

puts $OFILE "setenv PERC_RUNSET \${TECHDIR}/cmos22fdsoi.percESD.tvf"
puts $OFILE "setenv config_file \${TECHDIR}/Include/cmos22fdsoi.config.xml"
puts $OFILE "setenv devices_cdl \${TECHDIR}/Include/cmos22fdsoi.devices.cdl"
puts $OFILE "setenv CONTROL_FILE ../scripts/perc_control"
#puts $OFILE "setenv INCLUDE_FILE ${GFVAR_INCLUDE_FILE}"

puts $OFILE "mkdir -p \${outputdir} \${outputdir}/log_file"

close $OFILE
