proc fix_clock_cell_type { } {

  set total_count(high_vth)      0
  set total_count(low_drive)     0
  set total_count(non_symmetric) 0

  set error_count   0
  set warning_count 0
  set info_count    0

  set clocks [ get_clocks -quiet * ]
  set clocks [ add_to_collection $clocks [ get_clocks -quiet * ] ]

  foreach_in_collection clock $clocks {
    foreach_in_collection source [ get_attribute -quiet $clock sources ] {
      echo [ format "------------------------------------------------------------------------" ]
      if { [ get_attribute $source object_class ] == "port" } {
        echo [ format "Information: Checking clock network from source %s (%s) in clock %s" \
          [ get_attribute $source full_name ] [ get_attribute $source direction ] [ get_attribute $clock full_name ] ]
        incr info_count
      } else {
        echo [ format "Information: Checking clock network from source %s (%s) in clock %s" \
          [ get_attribute $source full_name ] [ get_attribute [ get_cells -of_objects $source ] ref_name ] [ get_attribute $clock full_name ] ]
        incr info_count
      }

      # all cells from clock source
      set clock_cells [ all_fanout -flat -from $source -only_cells ]

      # exclude leaf flipflops
      set clock_cells [ remove_from_collection $clock_cells [ all_fanout -flat -from $source -only_cells -endpoints_only ] ]

      # generated clock source
      if { [ get_attribute $source object_class ] == "pin" } {
        set clock_cell [ get_cells -of_objects $source ]
        if { [ sizeof_collection $clock_cells ] == [ sizeof_collection [ remove_from_collection $clock_cells $clock_cell ] ] } {
          set clock_cells [ add_to_collection $clock_cells $clock_cell ]
        }
      } 

      ########################################################################
      # check high-vth cells
      #
      set high_vth_cells [ filter_collection -regexp $clock_cells { ref_name =~ .*HVT$ } ]
      set count [ sizeof_collection $high_vth_cells ]
      if { $count == 0 } {
        echo [ format "Information: %d high-vth cells used in %s." $count [ get_attribute $clock full_name ] ]
      } else {
        echo [ format "Error: %d high-vth cells used in %s." $count [ get_attribute $clock full_name ] ]
        foreach_in_collection cell $high_vth_cells {
	  set ref_N [ get_attribute $cell ref_name ]
	  regsub "HVT$" $ref_N "" ref_N
         #echo [ format "%s (%s)" [ get_attribute $cell full_name ] [ get_attribute $cell ref_name ] ]
          size_cell $cell tcbn65lpwcl/$ref_N
        }
      }
      set total_count(high_vth) [ expr $total_count(high_vth) + $count ]

      ########################################################################
      # low drive cells
      #
      set low_drive_cells [ filter_collection -regexp $clock_cells { ref_name =~ .*D[01]HVT$ || ref_name =~ .*D[01]$ ||  ref_name =~ .*D[00]$ || ref_name =~ .*D[00]HVT$ } ]
      set count [ sizeof_collection $low_drive_cells ]
      if { $count == 0 } {
        echo [ format "Information: %d low-drive cells used in %s." $count [ get_attribute $clock full_name ] ]
        incr info_count
      } else {
        echo [ format "Error: %d low-drive cells used in %s." $count [ get_attribute $clock full_name ] ]
        foreach_in_collection cell $low_drive_cells {
         #echo [ format "%s (%s)" [ get_attribute $cell full_name ] [ get_attribute $cell ref_name ] ] > fix_clock_low.tcl
	  set ref_N [ get_attribute $cell ref_name ]
          regsub "AN3XD1" $ref_N "AN3D1" ref_N
          regsub "OR2XD1" $ref_N "OR2D1" ref_N
	  regsub "D1$" $ref_N "D2" ref_N
	  regsub "D0$" $ref_N "D2" ref_N
         #echo [ format "%s (%s)" [ get_attribute $cell full_name ] [ get_attribute $cell ref_name ] ]
          size_cell $cell tcbn65lpwcl/$ref_N
        }
        incr warning_count
      }
      set total_count(low_drive) [ expr $total_count(low_drive) + $count ]

      ########################################################################
      # check non-symmetric cells
      #
     #set non_symmetric_cells [ filter_collection -regexp $clock_cells { ref_name =~ ^AN2D[0-9].* || ref_name =~ ^MUX2D[0-9].* || ref_name =~ ^ND2D[0-9].* || ref_name =~ ^XOR2D[0-9].* } ]
      set non_symmetric_cells [ filter_collection -regexp $clock_cells { ref_name =~ ^AN2D[0-9].* || ref_name =~ ^BUFFD[0-9].* || ref_name =~ ^MUX2D[0-9].* || ref_name =~ ^INVD[0-9].* || ref_name =~ ^ND2D[0-9].* || ref_name =~ ^XOR2D[0-9].* } ]
      set count [ sizeof_collection $non_symmetric_cells ]
      if { $count == 0 } {
        echo [ format "Information: %d non-symmetric cells used in %s." $count [ get_attribute $clock full_name ] ]
        incr info_count
      } else {
        echo [ format "Error: %d non-symmetric cells used in %s." $count [ get_attribute $clock full_name ] ]
        foreach_in_collection cell $non_symmetric_cells {
	  set ref_N [ get_attribute $cell ref_name ]
         if {  [ regexp {^INVD[0-9].*} $ref_N ] } {
          regsub "^" $ref_N "CK" ref_N
          regsub "INVD" $ref_N "ND" ref_N
          size_cell $cell tcbn65lpwcl/$ref_N
        } elseif {  [ regexp {^BUF.D[0-9].*} $ref_N ] } {
          regsub "^" $ref_N "CK" ref_N
          regsub "BUF.D" $ref_N "BD" ref_N
          size_cell $cell tcbn65lpwcl/$ref_N
        } else {
	  regsub "^" $ref_N "CK" ref_N
         #echo [ format "%s (%s)" [ get_attribute $cell full_name ] [ get_attribute $cell ref_name ] ]
          size_cell $cell tcbn65lpwcl/$ref_N
	}
        }
        incr error_count
      }
      echo [ format "" ]
      set total_count(non_symmetric) [ expr $total_count(non_symmetric) + $count ]
    }
  }
 #echo [ format "========================================================================" ]
 #echo [ format "Information: Total %d high-vth cells used." $total_count(high_vth) ]
 #echo [ format "Information: Total %d low-drive cells used." $total_count(low_drive) ]
 #echo [ format "Information: Total %d non-symmetric cells used." $total_count(non_symmetric) ]
# echo [ format "Diagnostics summary: %d errors, %d warnings, %d informationals" $error_count $warning_count $info_count ]
 #echo [ format "" ]
}

