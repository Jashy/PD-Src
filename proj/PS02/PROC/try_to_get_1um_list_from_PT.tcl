
set target_output_report /proj/wHydra/WORK/peter/PT/20100905_ECO4/post-layout/normal-mode/wcl_cworst_setup/clk_path.rpt

if { $synopsys_program_name != "pt_shell" } { ERROR }

foreach_in_collection FB_DRV [get_cells * -filter "full_name =~ *FB_L1_DRIVE01" -hierarchical] {
      set buf [get_attribute $FB_DRV full_name]
      clk ${buf}/I >> $target_output_report
}

set llx 1120
set lly 4787
set rtx 1300
set rty 4923

set IN [open $target_output_report r]
set path_ready 0
set 1um_net_list [list ]
while {[gets $IN line] >=0 } {
	if {[regexp {^  Point\s+Trans\s+Incr\s+Path} $line ""]} { 
		set path_ready 1
	}
	if {$path_ready == 0} {continue}
	if {[regexp {^  (\S+) \((\S+)\)} $line "" pin ref]} {
		if { $ref == "inout" || [regexp {/PAD$} $pin ""] } {
			puts "Inform: Ignore $pin !"
			continue
		}
		if {[regexp {FB_L1_DRIVE01/I$} $pin ""]} {
			set path_ready 0
			puts "Inform: Stop to trace clock net at $pin !"
		}
		set net [get_attribute [get_nets -top_net_of_hierarchical_group -segments -of_objects [get_pins $pin] ] full_name]
		lappend 1um_net_list $net
	}
}
close $IN
set OUT [open ${target_output_report}_1um.lis w] 
foreach net [lsort -unique $1um_net_list] {
	puts $OUT $net
}
close $OUT

