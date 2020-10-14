set lib_version lib_C.0.2


proc find_necssary_lib {all_libs pt_link_path} {
  global lib_version
  set f [open $pt_link_path r] 
  set necessary_libs {}
  while {[gets $f line]>=0} {
    set db_name [file root [file tail $line]]
    set lib [lsearch -all -inline -regex $all_libs $db_name]
    if {[llength $lib]==0} {
       if {[file exist /proj/library/BI/$lib_version/rams/timing/$db_name.lib]} {
         lappend necessary_libs /proj/library/BI/$lib_version/rams/timing/$db_name.lib
       } elseif {[file exist /proj/library/BI/$lib_version/rom/timing/$db_name.lib]} {
         lappend necessary_libs /proj/library/BI/$lib_version/rom/timing/$db_name.lib
       } elseif {[file exist /proj/library/BI/$lib_version/ctip/timing/$db_name.lib]} {
         lappend necessary_libs /proj/library/BI/$lib_version/ctip/timing/$db_name.lib
       } else {
         puts "ERROR, can not find corresbonding lib for $line"
       }
    }
    foreach l $lib {
      set lib_name [file rootname [file rootname [file tail $l]]]
      set idb [glob -nocomp /project/PD/signoff/fct/fullchip_timing/BI/XTOP_TRAIL/liuqingli/idb/stdcel/timing_lvf/$lib_name.idb]
      if {[llength $idb] > 0 } {
        lappend necessary_libs $idb
      } else {
        lappend necessary_libs $l
      }
    }
  }
  return $necessary_libs
}
# Create corner/mode/scenario
#set scenarios [list Pt-Func.TT0p85v-tt0p85v85c-typical-85c-Stp-nonSi Pt-Func.SSGNP0p675v-ssgnp0p675v0c-rcworst_CCworst-0c-Hld-Si Pt-Func.SSGNP0p765v-ssgnp0p765v0c-cworst_CCworst-125c-Stp-nonSi Pt-Scanshift.FFGNP1p045v-ffgnp1p045v0c-rcworst_CCworst-0c-Hld-Si Pt-Func.FFGNP1p045v-ffgnp1p045v125c-rcworst_CCworst-125c-Hld-Si]
#find the scenarios automatically
if {[llength $scenarios] == 0} {
  set scenarios [glob -tails -direct  $sta_data_dir *data_finish]
  regsub -all _data_finish $scenarios "" scenarios
}

foreach s $scenarios {
  set tokens [split $s -]
  set m [lindex [split [lindex $tokens 1] .] 0]
  set c [lindex $tokens 2]
  set rc [string tolower [lindex $tokens 3]]
  set checktype [lindex $tokens 5]
puts "list_all_s_rc_mode : $s $m $c $rc $checktype"
  #mode
  if {[get_mode $m] == ""} {
    create_mode $m
  }
  
  #corner
  if {[get_corner $c] == ""} {
    set std_lib {}
    set f [open /proj/library/BI/$lib_version/config/stdcel.timing_lvf.$c.lib.list r]
    while {[gets $f line]>=0} {
      lappend std_lib /proj/library/BI/$lib_version/stdcel/timing_lvf/$line
    }
    close $f
  
    set ram_lib {}
    set f [open /proj/library/BI/$lib_version/config/rams.$c.lib.list r]
    while {[gets $f line]>=0} {
      lappend ram_lib /proj/library/BI/$lib_version/rams/timing/$line
    }
    close $f
  
    set rom_lib {}
    set f [open /proj/library/BI/$lib_version/config/rom.$c.lib.list r]
    while {[gets $f line]>=0} {
      lappend rom_lib /proj/library/BI/$lib_version/rom/timing/$line
    }
    close $f
  
    set ctip_lib {}
    set f [open /proj/library/BI/$lib_version/config/ctip.$c.$rc.lib.list r]
    while {[gets $f line]>=0} {
      lappend ctip_lib /proj/library/BI/$lib_version/ctip/timing/$line
    }
    close $f
    create_corner $c
    puts "start link_timing_library for $c at [exec date], mem: [mem]"
    set necessary_libs [find_necssary_lib [concat $std_lib $ram_lib $rom_lib $ctip_lib] $sta_data_dir/${s}_link_path]
    link_timing_library -corner $c $necessary_libs
    puts "end link_timing_library for $c at [exec date], mem: [mem]"
  }
  
  if {[get_scenario $s] == ""} {
    create_scenario -corner $c -mode $m $s
    if {$checktype eq "Hld"} {
      set_skip_scenarios -max $s
    } elseif {$checktype eq "Stp"} {
      set_skip_scenarios -min $s
    }
  }
}
report_scenario *
save_workspace