source ../../project_setup.tcl


set OFILE [open  mas_parameters.config w]


puts $OFILE "# MAS Flow variables"
puts $OFILE "setenv BEOL_STACK $GFVAR_STACK"
puts $OFILE "setenv MAS_TOP_CELL $GFVAR_DESIGN(name)"
puts $OFILE "setenv POTFIX_GUIDE TRUE"
puts $OFILE "setenv MAS_DRC_OUT BEOL_P1"
puts $OFILE "setenv GEN_RDB YES"

close $OFILE
