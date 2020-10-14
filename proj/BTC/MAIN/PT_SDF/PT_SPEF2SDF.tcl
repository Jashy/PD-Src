echo [ format "pt_shell started on %s at %s" [ sh /bin/hostname ] [ sh /bin/date ] ]
echo "kill [pid]" > ./kill.csh
if { [ info exists PROJ         ] == 0 } { set PROJ          ""    }
if { [ info exists TOP          ] == 0 } { set TOP           ""    }
if { [ info exists BLOCK_ONLY   ] == 0 } { set BLOCK_ONLY    "no"  }
if { [ info exists PART_TOP_ONLY] == 0 } { set PART_TOP_ONLY "no"  }
if { [ info exists FULL_CLKREP  ] == 0 } { set FULL_CLKREP   "yes"  }
if { [ info exists INTERNAL_ONLY] == 0 } { set INTERNAL_ONLY "no"  }
if { [ info exists INCLUDE_TRAN ] == 0 } { set INCLUDE_TRAN  "no"  }
if { [ info exists VNET_LIST    ] == 0 } { set VNET_LIST     ""    }
if { [ info exists SPEF_LIST    ] == 0 } { set SPEF_LIST     ""    }
if { [ info exists SDF          ] == 0 } { set SDF           ""    }
if { [ info exists SDC_LIST     ] == 0 } { set SDC_LIST      ""    }
if { [ info exists LIB_COND     ] == 0 } { set LIB_COND      ""    }
if { [ info exists RC_COND      ] == 0 } { set RC_COND       ""    }
if { [ info exists STA_COND     ] == 0 } { set STA_COND      ""    }
if { [ info exists STA_MODE     ] == 0 } { set STA_MODE      ""    }
if { [ info exists CLOCK_MODE   ] == 0 } { set CLOCK_MODE    "ideal"}
if { [ info exists SAVE_SESSION ] == 0 } { set SAVE_SESSION  "yes" }
if { [ info exists SAVE_DB      ] == 0 } { set SAVE_DB       "no"  }
if { [ info exists EXIT         ] == 0 } { set EXIT          "yes" }
if { [ info exists max_transition_setting] == 0 } { set max_transition_setting  "" }
if { [ info exists MULTI_CPU	  ] == 0 } { set MULTI_CPU 	1    }	   

exec mkdir -p LOG REPORT OUTPUT CHECK_RESULT

global env
set env(LANG) ""

echo [ format "pt_shell started on %s at %s" [ exec /bin/hostname ] [ exec /bin/date ] ]
set_host_options -num_processes $MULTI_CPU 

#--------------------------------------------------------------------------------------
# PT environment setup
#--------------------------------------------------------------------------------------
source -e /proj/BTC/WORK/carsonl/templete/PT/PT_setup.tcl
  
#--------------------------------------------------------------------------------------
echo "Reading PT lib ..."
source -e /DELL/proj/BTC/WORK/carsonl/templete/PT/PT_lib.tcl

#--------------------------------------------------------------------------------------
# read design
#--------------------------------------------------------------------------------------
file delete -force              ./LOG/read_verilog.log
 foreach VNET ${VNET_LIST} {
		 echo "Reading ${VNET} ..." >> ./LOG/read_verilog.log
		 read_verilog ${VNET}       >> ./LOG/read_verilog.log
 }
current_design ${TOP}
link_design ${TOP} -force > ./LOG/link_design.log


#--------------------------------------------------------------------------------------
# read annotated
#--------------------------------------------------------------------------------------
if { ( ${FLOW} == "spef" ) } { 
		read_parasitics -format SPEF -keep_capacitive_coupling ${SPEF_LIST} >> ./LOG/read_parasitics.log
		report_annotated_parasitics -list_not_annotated -check -max_nets 100000  >  ./REPORT/report_annotated_check.rep
}

#--------------------------------------------------------------------------------------
# OPERATING CONDITIONS
#--------------------------------------------------------------------------------------

set_operating_conditions  -analysis_type on_chip_variation

#--------------------------------------------------------------------------------------
# set constrain
#--------------------------------------------------------------------------------------
file delete -force ./LOG/read_sdc.log
foreach SDC $SDC_LIST {
		if { [ file readable ${SDC} ] == 0 } {
        echo [ format "Cannot open '%s'." ${SDC} ]
     } else {
        echo "Reading ${SDC} ..."    >> ./LOG/read_sdc.log
        source -echo          ${SDC} >> ./LOG/read_sdc.log
     }
}
if {$WRITE_SDF == "1"} {
	reset_timing_derate
	write_sdf -version 3.0 -significant_digits 3 -input_port_nets -output_port_nets -include { SETUPHOLD RECREM } -exclude { no_condelse checkpins } -context verilog -no_internal_pins -compress gzip ./OUTPUT/${TOP}_${SDF_CORNER}_couple.sdf.gz
}

if { ${CLOCK_MODE} == "propagated" } {
	set_propagated_clock [all_clocks] 
} elseif {${CLOCK_MODE} == "ideal"} {
	remove_propagated_clock [get_clocks *]
}
set_clock_uncertainty -setup 0.35 [all_clocks]
set_clock_uncertainty -hold 0.050 [all_clocks]

if {${LIB_COND} == "ml" || ${LIB_COND} == "bc"} {
	set_timing_derate -late 1.08  -clock
}

set_max_fanout 16 [ current_design ]
#set_max_transition 0.25 [ current_design ]
set clocks [ add_to_collection [ get_clocks * -quiet ] [ get_generated_clocks * -quiet ] ]
if { [ sizeof_collection $clocks ] > 0 } {
	set_max_transition 0.100 $clocks -clock_path
}
set NoiseMargin [expr 0.25 * [get_attribute [current_design] voltage_max]]
set_noise_margin $NoiseMargin [get_lib_pins */*/* -filter "direction==in||direction==inout"]
set_noise_margin $NoiseMargin [all_outputs]

#set clock transition
if { [ llength ${SPEF_LIST} ] > 0 } {
#transition
	 echo "###$LIB_COND"	> ./REPORT/report_noise.rep
	 report_noise -all_violators -verbose -slack_type height						      >> ./REPORT/report_noise.rep

############################################################################
# CLK NOISE

	source /proj/BTC/WORK/carsonl/templete/PT/scripts/find_delta.proc
	source /proj/BTC/WORK/carsonl/templete/PT/scripts/si_net_delta_delay.proc
	set NETS [get_clock_network_objects [all_clocks] -include -type net]
	set THRESH 0.005
	si_net_delta_delay $NETS $THRESH all_clock_func_si > ./REPORT/clk_noise.rpt
############################################################################
	report_constraint -nosplit -significant_digits 3 -all_violators -verbose -max_transition  > ./REPORT/report_constraint.max_transition.rep
	exec perl /proj/BTC/WORK/carsonl/templete/PT/scripts/check_max_transition.pl ./REPORT/report_constraint.max_transition.rep > ./REPORT/report_constraint.max_transition.rep.summary
	report_constraint -nosplit -significant_digits 3 -all_violators -verbose -max_fanout      > ./REPORT/report_constraint.max_fanout.rep
	exec perl /proj/BTC/WORK/carsonl/templete/PT/scripts/check_max_fanout.pl                  ./REPORT/report_constraint.max_fanout.rep > ./REPORT/report_constraint.max_fanout.rep.summary
	report_constraints -min_pulse_width -all_violators -verbose -min_period -max_skew -pulse_clock_min_width -pulse_clock_max_width -pulse_clock_max_transition -pulse_clock_min_transition > ./REPORT/min_pulse_width.rep
}

report_clock_timing -nosplit -significant_digits 3 -type skew   > ./REPORT/report_clock_timing.skew.rpt
report_clock_timing -nosplit -significant_digits 3 -type skew -verbose  > ./REPORT/report_clock_timing.skew.detail.rpt

file delete -force ./REPORT/report_clock_timing.latency.rpt
foreach_in_collection clock [ get_clocks * ] {
	set clock_name [ get_attribute $clock full_name ]
	foreach_in_collection source [ get_attribute $clock sources ] {
		set source_name [ get_attribute $source full_name ]
		echo [ format "# report_clock_timing -nosplit -significant_digits 3 -type latency -nworst 999999 -clock %s -from %s" $clock_name $source_name ] >> ./REPORT/report_clock_timing.latency.rpt
		report_clock_timing -nosplit -significant_digits 3 -type latency -nworst 999999 -clock $clock_name -from $source_name  >> ./REPORT/report_clock_timing.latency.rpt
		sh /usr/bin/perl /proj/BTC/WORK/carsonl/templete/PT/scripts/check_report_clock_timing_latency.pl   ./REPORT/report_clock_timing.latency.rpt > ./REPORT/report_clock_timing.latency.rpt.summary
	}
}
################################################################################
#Report timing
################################################################################
if { ${STA_MODE} == "max" || ${STA_MODE} == "min" }  {
    #---------- ALL VIOLATIONS ----------#
	report_timing -nets -input_pins -nosplit -significant_digits 3 -max_paths 100000 -slack_lesser_than 0 -nworst ${NWORST_NUM} -unique_pins -delay_type ${STA_MODE} -path_type full  > ./REPORT/report_timing.rep
	exec /usr/bin/perl /proj/BTC/WORK/carsonl/templete/PT/scripts/check_violation_summary.new.pl ./REPORT/report_timing.rep  > ./REPORT/report_timing.rep.summary
	exec /usr/bin/perl /proj/BTC/WORK/carsonl/templete/PT/scripts/sort_violation_summary.pl ./REPORT/report_timing.rep.summary  >  ./REPORT/report_timing.rep.summary.sort
    #---------- INCLUDE TRANSITION ----------#
	if {$INCLUDE_TRAN == "yes"} {
    		report_timing -nets -input_pins -nosplit -cap -tran -significant_digits 3 -max_paths 100000 -slack_lesser_than 0 -nworst ${NWORST_NUM} -unique_pins -delay_type ${STA_MODE} -path_type full > ./REPORT/report_timing.tran.rep
	}
    #---------- ALL VIOLATIONS WITH FULL CLOCK PATH ----------#
	if { ${CLOCK_MODE} == "propagated" && ${FULL_CLKREP} == "yes" } {
		report_timing -nets -input_pins -nosplit -significant_digits 3 -max_paths 10000 -slack_lesser_than 0 -nworst ${NWORST_NUM} -unique_pins -delay_type ${STA_MODE} -path_type full_clock_expanded -transition -capacitance > ./REPORT/report_timing.full_clock_expanded.rep
	}
    # Report Internal
	if { ${INTERNAL_ONLY} == "yes" } {
		set all_inputs [ all_inputs ]
		set all_outputs [ all_outputs ]
      		foreach_in_collection clock [ get_clocks * -quiet ] {
        		set all_inputs [ remove_from_collection $all_inputs [ get_attribute $clock sources ] ]
		}		
      		set_false_path -from $all_inputs
      		set_false_path -to $all_outputs
      		update_timing > ./LOG/update_timing_internal.log
      		#save_session -replace  ./OUTPUT/session_internal
    #---------- ALL VIOLATIONS ----------#
		report_timing -nets -input_pins -nosplit -significant_digits 3 -max_paths 100000 -slack_lesser_than 0 -nworst ${NWORST_NUM} -unique_pins -delay_type ${STA_MODE} -path_type full > ./REPORT/report_timing_internal.rep
		exec /usr/bin/perl /DELL/proj/BTC/WORK/carsonl/templete/PT/scripts/check_violation_summary.new.pl ./REPORT/report_timing_internal.rep > ./REPORT/report_timing_internal.rep.summary
    #---------- INCLUDE TRANSITION ----------#
		if {$INCLUDE_TRAN == "yes"} {
    			report_timing -nets -input_pins -nosplit -cap -tran -significant_digits 3 -max_paths 100000 -slack_lesser_than 0 -nworst ${NWORST_NUM} -unique_pins -delay_type ${STA_MODE} -path_type full > ./REPORT/report_timing_internal.tran.rep
		}
    #---------- ALL VIOLATIONS WITH FULL CLOCK PATH ----------#
      		if { ${CLOCK_MODE} == "propagated" && ${FULL_CLKREP} == "yes" } {
        		report_timing -nets -input_pins -nosplit -significant_digits 3 -max_paths 10000 -slack_lesser_than 0 -nworst ${NWORST_NUM} -unique_pins -delay_type ${STA_MODE} -path_type full_clock_expanded -transition -capacitance > ./REPORT/report_timing_internal.full_clock_expanded.rep
      		}
	} 
}

###################
if {$FLOW == "spef"} {
   update_timing > ./LOG/update_timing.log
   save_session    ./OUTPUT/spef.session
}

if { ${EXIT} == "yes" } {
   printvar > ./REPORT/printvar.rep
   sh touch   ./pt_ready
   echo [ format "pt_shell end on %s at %s" [ exec /bin/hostname ] [ exec /bin/date ] ]
   quit
}

