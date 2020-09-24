proc fw {args} {

   global biglist
   global fanout
   global max_level
   global seq
   global select_pin
   global select_cell
   global skip_cell
   global skip_pin_name
   global skip_dft
   global select_bounding_cell
   global select_pin_depot
   global select_cell_depot
   global select_bounding_cell_depot
   global last_tmp
   global last
   global cell_part
   global pin_part
   global stop_level
   global stop_cell
   global stop_cell_flag
   global through_icg

   if {[info exists biglist]             } {unset biglist             }
   if {[info exists fanout]              } {unset fanout              }
   if {[info exists max_level]           } {unset max_level           }
   if {[info exists seq]                 } {unset seq                 }
   if {[info exists select_pin]          } {unset select_pin          }
   if {[info exists select_cell]         } {unset select_cell         }
   if {[info exists select_bounding_cell]} {unset select_bounding_cell}
   if {[info exists through_icg]         } {unset through_icg         }

   set seq                        1
   # set outp $result (_c)
   set fanout                     0
   set max_level                  0
   set depth                      0
   set select_pin                 0
   set select_cell                0
   set select_bounding_cell       0
   set skip_cell                  0
   set skip_pin_name              0
   set skip_dft                   0
   set stop_cell_flag             0
   set through_icg                0
   set select_pin_depot           ""
   set select_cell_depot          ""
   set select_bounding_cell_depot ""
   set last_tmp                   ""
   set last                       ""
   set cell_part                  ""
   set pin_part                   ""
   set stop_level                 ""
   set stop_cell                  ""

   set curArg 0
   set numArg [llength $args]
   if {$numArg == 0 } {
      fb::fwreadme
      return
   }

   set mark 1
   while {$curArg < $numArg} {
      set arg [lindex $args $curArg]
      if {[string index $arg 0] == "-"} {
         set result($arg) 1
         switch -- $arg {
            -seq_level {
                incr curArg
                set seq [lindex $args $curArg]
                incr curArg
            }
            -select_pin {
                incr curArg
                set select_pin 1
            }
            -select_cell {
                incr curArg
                set select_cell 1
            }
            -select_bounding_cell {
                incr curArg
                set select_bounding_cell 1
            }
            -bounding_cell {
                incr curArg
            }
            -skip_cell {
                incr curArg
                set skip_cell 1
                set cell_part [lindex $args $curArg]
                incr curArg
            }
            -skip_pin_name {
                incr curArg
                set skip_pin_name 1
                set pin_part [lindex $args $curArg]
                incr curArg
            }
            -skip_dft {
                incr curArg
                set skip_pin_name 1
                set pin_part [concat $pin_part "SI SE SO"]
            }
            -stop_level {
                incr curArg
                set stop_level [lindex $args $curArg]
                incr curArg
            }
            -stop_cell {
                incr curArg
                set stop_cell [lindex $args $curArg]
                incr curArg
            }
            -through_icg {
                incr curArg
                set through_icg 1
            }
            -quiet {
                incr curArg
            }
            default {
                puts ""
                puts "Application Error"
                fb::fwreadme
                return
            }
         }
      } elseif {$mark} {
         set outp [lindex $args $curArg]
         incr curArg
         set mark 0
      } else {
         puts "Error: collection error"
         return
      }
   }

   _fw $outp $depth 0

   if { ![info exists result(-stop_cell)] } {
      if { [info exists result(-select_pin)] } {
         fb::select_pin [get_pins -quiet $select_pin_depot]
         if { [get_ports -quiet $select_pin_depot] != "" } {
            fb::select_aIO [get_ports -quiet $select_pin_depot]
         }
      } elseif { [info exists result(-select_cell)] } {
         fb::select_cell [get_cells -quiet $select_pin_depot]
      } elseif { [info exists result(-select_bounding_cell)] } {
         fb::select_cell [get_cells -quiet $select_bounding_cell_depot]
      }

      foreach line $last_tmp {
         if { [info exists result(-bounding_cell)] } {
            if { [regexp bounding $line] } {
               set last [lappend last $line]
            }
         } else {
            set last [lappend last $line]
         }
      }

      if { $seq == 1 } {
         set last [lappend last "fanout = $fanout max_level = $max_level"]
      }
   } else {
      set nu 0
      set last_tmp1 ""
      for {set i [llength $last_tmp]} {$i>0} {incr i -1} {
         set line [lindex $last_tmp [expr $i-1]]
         if { [regexp stop $line] } {
            set nu [lindex $line 0]
            set last_tmp1 [lappend last_tmp1 $line]
         } elseif { [lindex $line 0] < $nu } {
            set nu [lindex $line 0]
            set last_tmp1 [lappend last_tmp1 $line]
         }
      }

      for {set i [llength $last_tmp1]} {$i>0} {incr i -1} {
         set line [lindex $last_tmp1 [expr $i-1]]
         set last [lappend last $line]
      }
   }

   if { ![info exists result(-quiet)] } {
      if { [llength $last] > 30000 } {
         puts "INFO:[llength $last] lines greater than 30000 limit"
         puts "     pls use 'redirect <file> { last_result }' if you need result"
      } else {
         last_result
      }
   } else {
      puts "1"
   }

   unset biglist
   unset fanout
   unset max_level
   unset seq
   unset select_pin
   unset select_cell
   unset select_bounding_cell
   unset skip_cell
   unset skip_pin_name
   unset skip_dft
   unset select_pin_depot
   unset select_cell_depot
   unset select_bounding_cell_depot
   unset last_tmp
   unset cell_part
   unset pin_part
   unset stop_level
   unset stop_cell
   unset stop_cell_flag
   unset through_icg

}


proc _fw {outp depth regdepth} {

   global biglist
   global max_level
   global fanout
   global seq
   global select_pin
   global select_cell
   global select_bounding_cell
   global skip_cell
   global skip_pin_name
   global skip_dft
   global stop_level
   global stop_cell
   global select_pin_depot
   global select_cell_depot
   global select_bounding_cell_depot
   global last_tmp
   global last
   global cell_part
   global pin_part
   global stop_cell_flag
   global through_icg

   set n [get_nets -quiet -of $outp]
   if { [sizeof_collection $n] == 0 } { return }

   set n_n [get_attribute $n full_name]

   if { [info exists biglist($n_n)] } {
      set last_tmp [lappend last_tmp [format "%s%-${depth}s%s" [expr $depth + 1] " " "      (***net already explored***)"]]
      return
   } else {
      set biglist($n_n) ""
   }

   set nextins [get_pins -leaf -quiet -of $n -filter "pin_direction==in"]
   if { $skip_pin_name } {
      foreach _pin_part_ $pin_part {
         set nextins [get_pins -quiet $nextins -filter "name !~ $_pin_part_"]
      }
   }

   if { $stop_level != "" && $stop_level <= $depth } { return }
   incr depth ;# incr depth only when recursion

   if { [sizeof_collection [get_ports -quiet -of $n -filter "direction==out"]] != 0 } {
      set ports [get_attribute [get_ports -quiet -of -filter "direction==out"] full_name]
      set select_pin_depot [concat $select_pin_depot $ports]

      foreach port $ports {
         incr fanout
         if { $seq > 1 } {
            set last_tmp [lappend last_tmp [format "%s%-${depth}s%s" "$depth" " " "$port (bounding port) (seq = $regdepth)"]]
         } else {
            set last_tmp [lappend last_tmp [format "%s%-${depth}s%s" "$depth" " " "$port (bounding port)"]]
         }
      }
   }

   if { [sizeof_collection $nextins] == 0} { return }

   if { $max_level < $depth } {
      set max_level $depth
   }

   if { [get_attribute -quiet $outp full_name] == "" } {
      set outp $outp
   } else {
      set outp [get_attribute $outp full_name]
   }

   if { [sizeof_collection [get_pins -quiet $outp]] > 0 } {
      set outp_cell [get_attribute [get_cells -quiet -of [get_pins -quiet $outp]] full_name]
      set select_cell_depot [concat $select_cell_depot $outp_cell]
   }

   if { [sizeof_collection [get_ports -quiet $outp]] > 0 } {
      #set outp_cell [get_attribute [get_cells -quiet -of [get_ports -quiet $outp]] full_name]
      #set select_cell_depot [concat $select_cell_depot $outp_cell]
   }

   set select_pin_depot [concat $select_pin_depot $outp]

   set regdepth_control 0
   set regdepth_base $regdepth ;#record reqdepth,avoid no-sequ depth error


   if { $skip_cell } {
      while (1) {
         set nextins_tmp ""
         set skipped_cell {}
         set cell_part_exp ""
         foreach cell_p $cell_part {
            append_to_coll skipped_cell [get_cells -quiet -of $nextins -filter "ref_name=~*${cell_p}*"]
            lappend cell_part_exp $cell_p
         }

         if { [sizeof_collection $skipped_cell] == 0 } {
            break
         }
         foreach_in_collection nextin [sort_collection $nextins full_name] {
            set cell_name [get_attribute [get_cells -quiet -of $nextin] full_name]
            set ref [get_attribute [get_cells $cell_name] ref_name]
            if { [regexp [join [split $cell_part_exp " "] |] $ref] } {
               set n [get_net -of [get_pin -of [get_cells $cell_name] -filter "pin_direction==out"]]
               set ni [get_pins -leaf -of $n -filter "pin_direction==in"]
               set nextins_tmp [concat $nextins_tmp [get_attribute $ni full_name]]
            } else {
               set nextins_tmp [concat $nextins_tmp [get_attribute $nextin full_name]]
            }
         }
         set nextins [get_pins $nextins_tmp]
         if { $skip_pin_name } {
            foreach _pin_part_ $pin_part {
               set nextins [get_pins -quiet $nextins -filter "name !~ $_pin_part_"]
            }
         }
      }
   } ;#endif skip_cell


   foreach_in_collection nextin [sort_collection $nextins full_name] {
      set nextin_pin_name [get_attribute $nextin name]

      set cell_name [get_attribute [get_cells -of $nextin] full_name]
      set ref [get_attribute [get_cells $cell_name] ref_name]
      set is_seq  [get_attribute [get_cells $cell_name] is_sequential]
      set is_hard [get_attribute [get_cells $cell_name] is_black_box]
      set is_icg  [get_attribute [get_cells $cell_name] is_clock_gating_check]

      set nextouts [get_pins -quiet -of [get_cells $cell_name] -filter "pin_direction==out"]
      if { $skip_pin_name } {
         foreach _pin_part_ $pin_part {
            set nextouts [get_pins -quiet $nextouts -filter "name !~ $_pin_part_"]
         }
      }

      if { $stop_cell != "" } {
         if { [llength $stop_cell] > 1 } { return "Error: -stop_cell support one cell" }
         if { $cell_name == $stop_cell } {
            set last_tmp [lappend last_tmp [format "%s%-${depth}s%s" "$depth" " " "$cell_name $nextin_pin_name $ref (stop cell)"]]
            set stop_cell_flag 1
            return
         }
      }
      if { $stop_cell_flag == 1 } { set stop_cell_flag 1; break }

      if { $is_seq == false && $is_hard == false } {
         foreach_in_collection nextout_e [sort_collection $nextouts full_name] {
            if { $stop_cell_flag == 1 } { set stop_cell_flag 1; break }
            set nextout_pin_name [get_attribute $nextout_e name]

            set last_tmp [lappend last_tmp [format "%s%-${depth}s%s" $depth " " "$cell_name $nextin_pin_name $ref --> $nextout_pin_name"]]
            _fw $nextout_e $depth $regdepth_base
         }
      } elseif { $through_icg && $is_icg == true } {
         foreach_in_collection nextout_e [sort_collection $nextouts full_name] {
            if { $stop_cell_flag == 1 } { set stop_cell_flag 1; break }
            set nextout_pin_name [get_attribute $nextout_e name]

            set last_tmp [lappend last_tmp [format "%s%-${depth}s%s" $depth " " "$cell_name $nextin_pin_name $ref --> $nextout_pin_name"]]
            _fw $nextout_e $depth $regdepth_base
         }
      } else {
         incr fanout
         if { $regdepth_control == 0 } {
            incr regdepth
            incr regdepth_control
         } ;# increase regdepth flag, avoid nextins have multi bounding cells


         if { $seq == 1 } {
            set select_cell_depot [concat $select_cell_depot $cell_name]
            set select_bounding_cell_depot [concat $select_bounding_cell_depot $cell_name]
            set last_tmp [lappend last_tmp [format "%s%-${depth}s%s" "$depth" " " "$cell_name $nextin_pin_name $ref (bounding cell)"]]
         } elseif { $is_hard == true } {
            set select_cell_depot [concat $select_cell_depot $cell_name]
            set select_bounding_cell_depot [concat $select_bounding_cell_depot $cell_name]
            set last_tmp [lappend last_tmp [format "%s%-${depth}s%s" "$depth" " " "$cell_name $nextin_pin_name $ref (bounding cell) (seq = $regdepth)"]]
         } elseif { $seq > $regdepth } {
            foreach_in_collection seqoutpin [sort_collection $nextouts full_name] {
               set seqoutpin_name [get_attribute $seqoutpin name]

               set last_tmp [lappend last_tmp [format "%s%-${depth}s%s" "$depth" " " "$cell_name $nextin_pin_name $ref --> $seqoutpin_nane (bounding cell) (seq = $regdepth)"]]
               _fw $seqoutpin $depth $regdepth
            }
         } elseif { $seq == $regdepth } {
            set select_cell_depot [concat $select_cell_depot $cell_name]
            set select_bounding_cell_depot [concat $select_bounding_cell_depot $cell_name]
            set last_tmp [lappend last_tmp [format "%s%-${depth}s%s" "$depth" " " "$cell_name $nextin_pin_name $ref (bounding cell) (seq = $regdepth)"]]
         }
      }
   }
}


proc bw {args} {
   
   global biglist
   global fanin
   global max_level
   global seq
   global select_pin
   global select_cell
   global skip_cell
   global skip_pin_name
   global skip_dft
   global select_bounding_cell
   global select_pin_depot
   global select_cell_depot
   global select_bounding_cell_depot
   global last_tmp
   global last
   global cell_part
   global pin_part
   global stop_level
   global stop_cell
   global stop_cell_flag
   global through_icg

   if {[info exists biglist]             } {unset biglist             }
   if {[info exists fanin]               } {unset fanin               }
   if {[info exists max_level]           } {unset max_level           }
   if {[info exists seq]                 } {unset seq                 }
   if {[info exists select_pin]          } {unset select_pin          }
   if {[info exists select_cell]         } {unset select_cell         }
   if {[info exists select_bounding_cell]} {unset select_bounding_cell}
   if {[info exists through_icg]         } {unset through_icg         }

   set seq                        1
   # set inp $result(_c)
   set fanin                      0
   set max_level                  0
   set depth                      0
   set select_pin                 0
   set select_cell                0
   set select_bounding_cell       0
   set skip_cell                  0
   set skip_pin_name              0
   set skip_dft                   0
   set stop_cell_flag             0
   set through_icg                0
   set select_pin_depot           ""
   set select_cell_depot          ""
   set select_bounding_cell_depot ""
   set last_tmp                   ""
   set last                       ""
   set cell_part                  ""
   set pin_part                   ""
   set stop_level                 ""
   set stop_cell                  ""

   set curArg 0
   set numArg [llength $args]
   if {$numArg == 0 } {
      fb::bwreadme
      return
   }
   
   puts $args
   set mark 1
   while {$curArg < $numArg} {
      set arg [lindex $args $curArg]
      if {[string index $arg 0] == "-"} {
         set result($arg) 1
         switch -- $arg {
            -seq_level {
               incr curArg
               set seq [lindex $args $curArg]
               incr curArg
            }
            -select_pin {
               incr curArg
               set select_pin 1
            }
            -select_cell {
               incr curArg
               set select_cell 1
            }
            -select_bounding_cell {
               incr curArg
               set select_bounding_cell 1
            }
            -bounding_cell {
               incr curArg
            }
            -skip_cell {
               incr curArg
               set skip_cell 1
               set cell_part [lindex $args $curArg]
               incr curArg
            }
            -skip_pin_name {
               incr curArg
               set skip_pin_name 1
               set pin_part [lindex $args $curArg]
               incr curArg
            }
            -skip_dft {
               incr curArg
               set skip_pin_name 1
               set pin_part [concat $pin_part "SI SE SO"]
            }
            -stop_level {
               incr curArg
               set stop_level [lindex $args $curArg]
               incr curArg
            }
            -stop_cell {
               incr curArg
               set stop_cell [lindex $args $curArg]
               incr curArg
            }
            -through_icg {
               incr curArg
               set through_icg 1
            }
            -quiet {
               incr curArg
            }
            default {
              puts ""
              puts "Application Error"
              fb::bwreadme
              return
            }
         }
      } elseif {$mark} {
         set inp [lindex $args $curArg]
         incr curArg
         set mark 0
      } else {
         puts "Error: collection error"
         return
      }
   }

   _bw $inp $depth 0
   
   if { ![info exists result(-stop_cell)] } {
      if { [info exists result(-select_pin)] } {
         fb::select_pin [get_pins -quiet $select_pin_depot]
         if { [get_ports -quiet $select_pin_depot] != "" } {
            fb::select_aIO [get_ports -quiet $select_pin_depot]
         }
      } elseif { [info exists result(-select_cell)] } {
         fb::select_cell [get_cells -quiet $select_cell_depot]
      } elseif { [info exists result(-select_bounding_cell)] } {
         fb::select_cell [get_cells -quiet $select_bounding_cell_depot]
      }

      foreach line $last_tmp {
         if { [info exists result(-bounding_cell)] } {
            if { [regexp bounding $line] } {
               set last [lappend last $line]
            }
         } else {
            set last [lappend last $line]
         }
      }

      if { $seq == 1 } {
         set last [lappend last "fanin = $fanin max_level = $max_level"]
      }
   } else {
      set nu 0
      set last_tmp1 ""
      for {set i [llength $last_tmp]} {$i>0} {incr i -1} {
         set line [lindex $last_tmp [expr $i-1]]
         if { [regexp stop $line] } {
            set nu [lindex $line 0]
            set last_tmp1 [lappend last_tmp1 $line]
         } elseif { [lindex $line 0] < $nu } {
            set nu [lindex $line 0]
            set last_tmp1 [lappend last_tmp1 $line]
         }
      }

      for {set i [llength $last_tmp1]} {$i>0} {incr i -1} {
         set line [lindex $last_tmp1 [expr $i-1]]
         set last [lappend last $line]
      }
   }

   if { ![info exists result(-quiet)] } {
      if { [llength $last] > 30000 } {
         puts "INFO: [llength $last] lines greater than 30000 limit"
         puts " pls use 'redirect <file> { last_result }' if you need result"
      } else {
         last_result
      }
   } else {
      puts "1"
   }

   unset biglist
   unset fanin
   unset max_level
   unset seq
   unset select_pin
   unset select_cell
   unset select_bounding_cell
   unset skip_cell
   unset skip_pin_name
   unset skip_dft
   unset select_pin_depot
   unset select_cell_depot
   unset select_bounding_cell_depot
   unset last_tmp
   unset cell_part
   unset pin_part
   unset stop_level
   unset stop_cell
   unset stop_cell_flag
   unset through_icg

}


proc _bw {inp depth regdepth} {

   global biglist
   global max_level
   global fanin
   global seq
   global select_pin
   global select_cell
   global select_bounding_cell
   global skip_cell
   global skip_pin_name
   global skip_dft
   global stop_level
   global stop_cell
   global select_pin_depot
   global select_cell_depot
   global select_bounding_cell_depot
   global last_tmp
   global last
   global cell_part
   global pin_part
   global stop_cell_flag
   global through_icg


   set n [get_nets -of $inp]
   set n_n [get_attribute $n full_name]

   if { [info exists biglist($n_n)] } {
      set last_tmp [lappend last_tmp [format "%s%-${depth}s%s" [expr $depth + 1] " " "      (***net already explored***)"]]
      return
   } else {
      set biglist($n_n) ""
   }

   set nextouts [get_pins -leaf -quiet -of $n -filter "pin_direction==out"]
   if { $skip_pin_name } {
      foreach _pin_part_ $pin_part {
         set nextouts [get_pins -quiet $nextouts -filter "name !~ $_pin_part_"]
      }
   }

   if { $stop_level != "" && $stop_level <= $depth } { return }
   incr depth ; # incr depth only when recursion

   if { [sizeof_collection [get_ports -quiet -of $n -filter "direction==in"]] != 0 } {
      set ports [get_attribute [get_ports -quiet -of $n -filter "direction==in"] full_name]
      set select_pin_depot [concat $select_pin_depot $ports]

      foreach port $ports {
         incr fanin
         if { $seq > 1 } {
            set last_tmp [lappend last_tmp [format "%s%-${depth}s%s" "$depth" " " "$port (bounding port) (seq = $regdepth)"]]
         } else {
            set last_tmp [lappend last_tmp [format "%s%-${depth}s%s" "$depth" " " "$port (bounding port)"]]
         }
      }
   }

   if { [sizeof_collection $nextouts] == 0} { return }

   if {$max_level < $depth } {
      set max_level $depth
   }

   if { [get_attribute -quiet $inp full_name] == "" } {
      set inp $inp
   } else {
      set inp [get_attribute $inp full_name]
   }

   if { [sizeof_collection [get_pins -quiet $inp]] > 0 } {
      set inp_cell [get_attribute [get_cells -quiet -of [get_pins -quiet $inp]] full_name]
      set select_cell_depot [concat $select_cell_depot $inp_cell]
   }

   if { [sizeof_collection [get_ports -quiet $inp]] > 0 } {
      #set inp_cell [get_attribute [get_cell -quiet -of [get_ports -quiet $inp]] full_name]
      #set select_cell_depot [concat $select_cell_depot $inp_cell]
   }

   set select_pin_depot [concat $select_pin_depot $inp]

   set regdepth_control 0
   set regdepth_base $regdepth ; #record regdepth, avoid no-sequ depth error


   if { $skip_cell } {
      while (1) {
         set nextouts_tmp ""
         set skipped_cell {}
         set cell_part_exp ""
         foreach cell_p $cell_part {
            append_to_coll skipped_cell [get_cells -quiet -of $nextouts -filter "ref_name=~*${cell_p}*"]
            lappend cell_part_exp $cell_p
         }

         if { [sizeof_collection $skipped_cell] == 0 } {
            break
         }
         foreach_in_collection nextout [sort_collection $nextouts full_name] {
            set cell_name [get_attribute [get_cells -quiet -of $nextout] full_name]
            set ref [get_attribute [get_cells $cell_name] ref_name]
            if { [regexp [join [split $cell_part_exp " "] |] $ref] } {
               set n [get_net -of [get_pin -of [get_cells $cell_name] -filter "pin_direction==in"]]
               set no [get_pins -leaf -of $n -filter "pin_direction==out"]
               set nextouts_tmp [concat $nextouts_tmp [get_attribute $no full_name]]
            } else {
               set nextouts_tmp [concat $nextouts_tmp [get_attribute $nextout full_name]]
            }
         }
         set nextouts [get_pins $nextouts_tmp]
         if { $skip_pin_name } {
            foreach _pin_part_ $pin_part {
               set nextouts [get_pins -quiet $nextouts -filter "name !~ $_pin_part_"]
            }
         }
      }
   } ;#endif skip_cell


   foreach_in_collection nextout [sort_collection $nextouts full_name] {
      set nextout_pin_name [get_attribute $nextout name]

      set cell_name [get_attribute [get_cells -of $nextout] full_name]
      set ref [get_attribute [get_cells $cell_name] ref_name]
      set is_seq  [get_attribute [get_cells $cell_name] is_sequential]
      set is_hard [get_attribute [get_cells $cell_name] is_black_box]
      set is_icg  [get_attribute [get_cells $cell_name] is_clock_gating_check]

      set nextins [get_pins -quiet -of [get_cells $cell_name] -filter "pin_direction==in"]
      if { $skip_pin_name } {
         foreach _pin_part_ $pin_part {
            set nextins [get_pins -quiet $nextins -filter "name !~ $_pin_part_"]
         }
      }

      if { [sizeof_collection $nextins] == 0 } {
         incr fanin
         if { $seq > 1 } {
            set last_tmp [lappend last_tmp [format "%s%-${depth}s%s" "$depth" " " "$cell_name $nextout_pin_name $ref (tie cell) (seq = $regdepth)"]]
         } else {
            set last_tmp [lappend last_tmp [format "%s%-${depth}s%s" "$depth" " " "$cell_name $nextout_pin_name $ref (tie cell)"]]
         }
         continue
      }

      if { $stop_cell != "" } {
         if { [llength $stop_cell] > 1 } { return "Error: -stop_cell support one cell" }
         if { $cell_name == $stop_cell } {
            set last_tmp [lappend last_tmp [format "%s%-${depth}s%s" "$depth" " " "$cell_name $nextout_pin_nane $ref (stop cell)"]]
            set stop_cell_flag 1
            return
         }
      }
      if { $stop_cell_flag == 1 } { set stop_cell_flag 1; break }

      if { $is_seq == false && $is_hard == false } {
         foreach_in_collection nextin_e [sort_collection $nextins full_name] {
            if { $stop_cell_flag == 1 } { set stop_cell_flag 1; break }
            set nextin_pin_name [get_attribute $nextin_e name]

            set last_tmp [lappend last_tmp [format "%s%-${depth}s%s" $depth " " "$cell_name $nextout_pin_name $ref --> $nextin_pin_name"]]
            _bw $nextin_e $depth $regdepth_base
         }
      } elseif { $through_icg && $is_icg == true } {
         foreach_in_collection nextin_e [sort_collection [get_pins -quiet $nextins -filter "is_clock_pin==true"] full_name] {
            set nextin_pin_name [get_attribute $nextin_e name]
            set last_tmp [lappend last_tmp [format "%s%-${depth}s%s" $depth " " "$cell_name $nextout_pin_name $ref --> $nextin_pin_name"]]
            _bw $nextin_e $depth $regdepth_base
         }

      } else {
         incr fanin
         if { $regdepth_control == 0 } {
            incr regdepth
            incr regdepth_control
         }
         if { $seq == 1 } {
            set select_cell_depot [concat $select_cell_depot $cell_name]
            set select_bounding_cell_depot [concat $select_bounding_cell_depot $cell_name]
            set last_tmp [lappend last_tmp [format "%s%-${depth}s%s" "$depth" " " "$cell_name $nextout_pin_name $ref (bounding cell)"]]
         } elseif { $is_hard == true } {
            set select_cell_depot [concat $select_cell_depot $cell_name]
            set select_bounding_cell_depot [concat $select_bounding_cell_depot $cell_name]
            set last_tmp [lappend last_tmp [format "%s%-${depth}s%s" "$depth" " " "$cell_name $nextout_pin_name $ref (bounding cell) (seq = $regdepth)"]]
         } elseif { $seq > $regdepth } {
            foreach_in_collection seqinpin [sort_collection $nextins full_name] {
               if { [get_attribute [get_pins $seqinpin] is_clock_pin] } {
                  continue
               }
               set seqinpin_name [get_attribute $seqinpin name]

               set last_tmp [lappend last_tmp [format "%s%-${depth}s%s" "$depth" " " "$cell_name $nextout_pin_name $ref --> $seqinpin_nane (bounding cell) (seq = $regdepth)"]]
               _bw $seqinpin $depth $regdepth
            }
         } elseif { $seq == $regdepth } {
            set select_cell_depot [concat $select_cell_depot $cell_name]
            set select_bounding_cell_depot [concat $select_bounding_cell_depot $cell_name]
            set last_tmp [lappend last_tmp [format "%s%-${depth}s%s" "$depth" " " "$cell_name $nextout_pin_name $ref (bounding cell) (seq = $regdepth)"]]
         }
      }
   }
}


namespace eval fb {
   proc select_cell {collection} {
      deselectAll
      foreach_in_collection c [get_cells -quiet $collection] {
         set cn [get_object_name $c]
         selectInst $cn
      }
   }
   proc select_pin {collection} {
      deselectAll
      foreach_in_collection c [get_pins -quiet $collection] {
         set cn [get_object_name $c]
         selectPin $cn
      }
   }
   proc select_net {collection} {
      deselectAll
      foreach_in_collection c [get_nets $collection] {
         set cn [get_object_name $c]
         selectNet $cn
      }
   }
   proc select_wire {collection} {
      deselectAll
      foreach_in_colection c [get_nets $collection] {
         set cn [get_object_name $c]
         editSelect -nets $cn
      }
   }
   proc select_IO {collection} {
      deselectAll
      foreach_in_collection c [get_ports $collection] {
         set cn [get_object_name $c]
         selectIOPin $cn
      }
   }
   proc select_acell {collection} {
      foreach_in_collection c [get_cells -quiet $collection] {
         set cn [get_object_name $c]
         selectInst $cn
      }
   }
   proc select_apin {collection} {
      foreach_in_collection c [get_pins -quiet $collection] {
         set cn [get_object_name $c]
         selectPin $cn
      }
   }
   proc select_anet {collection} {
      foreach_in_collection c [get_nets $collection] {
         set cn [get_object_name $c]
         selectNet $cn
      }
   }
   proc select_awire {collection} {
      foreach_in_collection c [get_nets $collection] {
         set cn [get_object_name $c]
         editSelect -nets $cn
      }
   }
   proc select_aI0 {collection} {
      foreach_in_collection c [get_ports $collection] {
         set cn [get_object_name $c]
         selectIOPin $cn
      }
   }

   proc fwreadme {} {
      puts "Usage: fw <output pin name>"
      puts "      <pin name>            (required) string/collection #specify <output pin name>"
      puts "      -seq_level            (optional) string  #specify trace level"
      puts "      -select_pin           (optional) boolean #specify connect pin in SOCE"
      puts "      -select_cell          (optional) boolean #specify connect cell in SOCE"
      puts "      -select_bounding_cell (optional) boolean #specify bounding cell in SOCE"
      puts "      -skip_cell            (optional) string  #regexp <skip cell> ref_name"
      puts "      -skip_pin_name        (optional) string  #skip specify pin name brance"
      puts "      -skip_dft             (optional) string  #skip \"SI SO SE\" name brance"
      puts "      -stop_level           (optional) string  #stop level in perform fw"
      puts "      -stop_cell            (optional) string  #stop by cell <cell name>"
      puts "      -bounding_cell        (optional) boolean #only export bounding cell result"
      puts "      -through_icg          (optional) boolean #through clock gating cell"
      puts "      -quiet                (optional) boolean #specify for quiet"
   }
   proc bwreadme {} {
      puts "Usage: bw <input pin name>"
      puts "      <pin name>            (required) string/collection #specify <output pin name>"
      puts "      -seq_level            (optional) string  #specify trace level"
      puts "      -select_pin           (optional) boolean #specify connect pin in SOCE"
      puts "      -select_cell          (optional) boolean #specify connect cell in SOCE"
      puts "      -select_bounding_cell (optional) boolean #specify bounding cell in SOCE"
      puts "      -skip_cell            (optional) string  #regexp <skip cell> ref_name"
      puts "      -skip_pin_name        (optional) string  #skip specify pin name brance"
      puts "      -skip_dft             (optional) string  #skip \"SI SO SE\" name brance"
      puts "      -stop_level           (optional) string  #stop level in perform fw"
      puts "      -stop_cell            (optional) string  #stop by cell <cell name>"
      puts "      -bounding_cell        (optional) boolean #only export bounding cell result"
      puts "      -through_icg          (optional) boolean #through clock gating cell"
      puts "      -quiet                (optional) boolean #specify for quiet"
   }
}

proc last_result {} {
   global last

   foreach line $last {
      puts $line
   }
}

proc last_cell_num {} {
   global last
   global last_cell
   set num 0
   foreach line $last {
      if { ![regexp {net already explored} $line] && [get_cell -quiet [lindex $line 1]] != "" } {
         if { ![info exists cell([lindex $line 1])] } {
            set cell([lindex $line 1]) ""
            incr num
         }
      }
   }
   set last_cell [array name cell]
   return $num
}

