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

########################################################################
# READ SDC
#
if { [ info exist scenarios_sdc ] == 0 } {
  echo "INFO: read_sdc "
  sh rm -f ${SESSION}.run/read_sdc.log
  foreach SDC ${SDC_LIST} {
     source   -echo ${SDC} >> ${SESSION}.run/read_sdc.log
  }
#  set a ""
#  set a [get_pins -hier */EMA[*]]
#  foreach_in_collection b $a {
#    set c [get_attribute $b full_name]
#    set_case_analysis 0 [ get_pins  $c  ]
#    echo "set 0 to $c"
#  }
}

save_mw_cel -as $MW_CEL
save_mw_cel -as $STEP
