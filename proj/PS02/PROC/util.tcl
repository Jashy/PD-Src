
proc read_list {f} {
  set list {}
  set fp [open $f r]
  for {set e [gets $fp]} {[eof $fp]==0} {set e [gets $fp]} {
    if {[llength $e] > 0} { lappend list $e }
  }
  close $fp
  return $list
}


proc filter_tied_net {net_col} {
  set col {}
  foreach_in_collection n $net_col {
    set f 0
    foreach_in_collection p [all_connected $n] {
      if {[string match {TIE*} [get_attribute [get_attribute $p cell_name] ref_name]]==1} {
        set f 1
        break
      }
    }
    if {$f==0} {set col [add_to_collection $col $n]}
  }
  return $col
}


proc my_report_net {ncol} {
  foreach_in_collection n $ncol {
    if {[string equal [get_attribute $n object_class] net] == 0} {
      puts "Warning: object [get_object_name $n] isn't a net."
      continue
    }
    set net  [get_object_name $n]
    set pcol [all_connected $n]

    set xlen [get_attribute $n x_length]
    set ylen [get_attribute $n y_length]
    if {[llength $xlen] == 0} {set xlen 0}
    if {[llength $ylen] == 0} {set ylen 0}
    set len  [expr $xlen + $ylen]
    set cap  [get_attribute $n total_capacitance_max]

    set drv  {}
    set rec  {}

    foreach_in_collection p $pcol {
      if {[string equal [get_attribute $p object_class] pin] == 0} { continue }

      set pin  [get_object_name $p]
      if {[string match {*out} [get_attribute $p direction]] == 1} {
	set cel [get_attribute $p cell_name]
	lappend drv $pin
	lappend drv [get_attribute $cel ref_name]
	lappend drv [get_attribute $cel origin]
      }
      if {[string match {in*}  [get_attribute $p direction]] == 1} {
	set ft  [get_attribute $p receiver_fall_transition_max]
	set rt  [get_attribute $p receiver_rise_transition_max]
	set tra [expr $ft > $rt ? $ft : $rt]
	lappend rec $pin
	lappend rec $tra
	lappend rec [get_attribute [get_attribute $p cell_name] origin]
      }
    }

    puts [format "NET: %s  %8d um  %7.4f nF" $net $len $cap]
    foreach {d c b} $drv {
      puts [format "  D: %s (%s) %s" $d $c $b]
    }
    foreach {r t b} $rec {
      puts [format "  R: %s %7.4f %s" $r $t $b]
    }
  }
}


proc make_upcell_eco {ncol} {
  foreach_in_collection n $ncol {
    if {[string equal [get_attribute $n object_class] net] == 0} {
      puts "# Warning: object [get_object_name $n] isn't a net."
      continue
    }
    set net  [get_object_name $n]
    set pcol [all_connected $n]

    # set len  [expr [get_attribute $n x_length] + [get_attribute $n y_length]]
    # set cap  [get_attribute $n total_capacitance_max]

    set drv  {}
    set rec  {}

    foreach_in_collection p $pcol {
      if {[string equal [get_attribute $p object_class] pin] == 0} { continue }

      set pin  [get_object_name $p]
      if {[string match {*out} [get_attribute $p direction]] == 1} {
	set cel [get_attribute $p cell_name]
	lappend drv $pin
	lappend drv [get_attribute $cel ref_name]
	# lappend drv [get_attribute $cel origin]
      }
    }

    foreach {d c} $drv {
      set cel [regsub {/[^/]+$} $d {}]
      puts [format "size_cell %s %s ; # (%s)" $cel [UPCELL $c] $c]
    }
  }
}


proc MODELNAMEPARSE {model} {
  if {[regexp {^(.*D)([0-9]+)(HVT)?$} $model match base size post]} then {
    return [list $base $size $post]
  } else {
    return {}
  }
}

proc MODELSCMP {model1 model2} {
  set m1 [MODELNAMEPARSE $model1]
  set m2 [MODELNAMEPARSE $model2]
  return [expr [lindex $m1 1] - [lindex $m2 1]]
}


proc EQFPLIST {model} {
  set lib [regsub {/.*} [get_object_name [get_lib_cells "*/$model"]] {}]
  set patte [MODELNAMEPARSE $model]
  if {[llength $patte] == 0} { return }
  set patte "$lib/[lindex $patte 0]*[lindex $patte 2]"
  set cells [get_object_name [get_lib_cells $patte]]
  return $cells
}

proc UPCELL { cell } {
  set org $cell

  set cells [EQFPLIST $cell]

  ##########################################
  ### ATTENTION: special rule for XD
  if {[llength $cells] == 1 && [regexp {(.*[0-9])XD([0-9]+)(HVT)?$} $cell match base size post]} then {
    set cell "${base}D${size}${post}"
    set cells [EQFPLIST $cell]
  }
  ##########################################

  #puts "# $cells"
  set idx [lsearch $cells "*/$cell"]
  set max_index [expr [llength $cells] - 1]

  set new_index [expr $idx + 1]

  if { $new_index > $max_index } {
    set new_index $max_index
  }
  set new [lindex $cells $new_index]
  if {[llength $new] == 0} { return $org }
  if {[lindex [MODELNAMEPARSE $new] 1] > 20} { return $org }
  # return "s,\\<$org\\>,[regsub -line {^.*/} $new {}],"
  # return "s, $org\\>,$new,"
  return $new
}


proc SPIN {pins} {
  change_selection [get_pins $pins]
}

proc SNET {nets} {
  change_selection [get_nets $nets]
}

proc SCEL {cels} {
  change_selection [get_cells $cels]
}

proc DRV {nets} {
  set dcol {}
  foreach_in_collection n [get_nets $nets] {
    foreach_in_collection p [all_connected $n] {
      if {[string match "*out" [get_attribute $p direction]] == 1} {
	set dcol [add_to_collection $dcol $p]
      }
    }
  }
  return $dcol
}

proc DRV {nets} {
  set dcol {}
  foreach_in_collection n [get_nets $nets] {
    foreach_in_collection p [all_connected $n] {
      if {[string match "*out" [get_attribute $p direction]] == 1} {
	set dcol [add_to_collection $dcol $p]
      }
    }
  }
  return $dcol
}

