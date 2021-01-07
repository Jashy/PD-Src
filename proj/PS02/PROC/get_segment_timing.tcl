#########################################################################
# PROCEDURE: segment_to_timing
#
# ABSTRACT: Reports the timing from the given 'from' point to the given 
#   'to' point.  The  -to parameters is required. Only the path 
#    segment is reported. This command should be used to generate timing
#    reports  to point B, where B is/is not an 
#    endpoints.
#
# ARGUMENTS: -to  are both required.
#
#
# $Id: segment_timing.tcl,v 1.9 2005/10/14 15:50:07 mruff Exp $
#
#########################################################################
proc segment_to_timing {args} {
  suppress_message CMD-041
  suppress_message PTE-060

  parse_proc_arguments -args $args results


  set delay_key ""
  set delay_key [array names results -delay_type]
  if {$delay_key != ""} {
   set delay_type $results(-delay_type)
  }
  set to $results(-to)

  report_print_header "segment_timing" "N/A " $to

  if {$delay_key != ""} {
   set paths [get_timing_paths -include_hierarchical_pins -to $to -delay_type $delay_type]
  } else {
   set paths [get_timing_paths -include_hierarchical_pins -from $to ]
  }
 
  if {[string compare $paths ""] == 0} {
    echo "No paths.\n";
    return 0;
  }

  foreach_in_collection path $paths {
    set path_type [get_attribute $path path_type]
    set path_group [get_attribute $path path_group]
    if {[string compare $path_group ""] == 0} {
      set path_group_name ""
    } else {
      set path_group_name [get_attribute $path_group full_name]
    }

    echo "  Segment startpoint: $to"
    echo "  Path Group: $path_group_name"
    echo "  Path Type: $path_type\n"

    report_one_path_line "Point" "Incr" "Path"
    echo "  ---------------------------------------------------------------"

    set previous_arrival 0.0
    set in_segment 0
    # since a start point is not specified, use the one ptime found
    set in_segment 1
    set temp 0

    foreach_in_collection point [get_attribute $path points] {
      set object [get_attribute $point object]
      set arrival [get_attribute $point arrival]
      set incr [expr $arrival - $previous_arrival]

      set previous_arrival $arrival
      set rise_fall [get_attribute $point rise_fall]
      set point_name [get_attribute $object full_name]


      if { $in_segment } {
        report_one_path_line $point_name [report_format_float $incr "%8.5f"] \
	  [report_format_float [expr $arrival - $temp] "%8.5f"] \
	  [string range $rise_fall 0 0] }
	if { [ regexp "$point_name" $to ] } {
	  break
       	} 
    }
  }
  return $arrival
}

define_proc_attributes segment_to_timing \
-info "Report timing for a path segment" \
-define_args {{-to "To pin" "to" string required} \
              {-delay_type "delay_type" "delay_type" string optional}}

###############################################################################


#########################################################################
# PROCEDURE: segment_from_timing
#
# ABSTRACT: Reports the timing from the given 'from' point to the given 
#   'to' point.  The -from is required. Only the path 
#    segment is reported. This command should be used to generate timing
#    reports from pin A, where pins A is/is not a startpoint.
#
# ARGUMENTS: -from is both required.
#
#########################################################################
proc segment_from_timing {args} {
  suppress_message CMD-041

  parse_proc_arguments -args $args results


  set delay_key ""
  set delay_key [array names results -delay_type]
  if {$delay_key != ""} {
   set delay_type $results(-delay_type)
  }
  set through ""
  set through [array names results -through]
  if {$through != ""} {
   set through $results(-through)
  }
  set from $results(-from)

  report_print_header "segment_timing" $from "N/A "

  if {$through != ""} {
     if {$delay_key != ""} {
      set paths [get_timing_paths -include_hierarchical_pins -through $through -from $from -delay_type $delay_type]
     } else {
      set paths [get_timing_paths -include_hierarchical_pins -through $through -from $from ]
     }
  } else {
     set through "BOGUS"
     if {$delay_key != ""} {
      set paths [get_timing_paths -include_hierarchical_pins -from $from -delay_type $delay_type]
     } else {
      set paths [get_timing_paths -include_hierarchical_pins -from $from ]
     }
  }
 
  if {[string compare $paths ""] == 0} {
    echo "No paths.\n";
    return 0;
  }

  foreach_in_collection path $paths {
    set path_type [get_attribute $path path_type]
    set path_group [get_attribute $path path_group]
    if {[string compare $path_group ""] == 0} {
      set path_group_name ""
    } else {
      set path_group_name [get_attribute $path_group full_name]
    }

    echo "  Segment startpoint: $from"
    echo "  Path Group: $path_group_name"
    echo "  Path Type: $path_type\n"

    report_one_path_line "Point" "Incr" "Path"
    echo "  ---------------------------------------------------------------"

    set previous_arrival 0.0
    set in_segment 0

    foreach_in_collection point [get_attribute $path points] {
      set object [get_attribute $point object]
      set arrival [get_attribute $point arrival]
      set incr [expr $arrival - $previous_arrival]

      set previous_arrival $arrival
      set rise_fall [get_attribute $point rise_fall]
      set point_name [get_attribute $object full_name]

      if {$point_name == $from} { 
        set in_segment 1
        set temp $arrival
      }

      if {$in_segment} {
        report_one_path_line $point_name [report_format_float $incr "%8.5f"] \
	  [report_format_float [expr $arrival - $temp] "%8.5f"] \
	  [string range $rise_fall 0 0] }
      if {$point_name == $through} {
          set dly [expr $arrival - $temp]
          break
      }
    }
  }
 echo "\n"
  return $arrival
}

define_proc_attributes segment_from_timing \
-info "Report timing for a path segment" \
-define_args {{-from "From pin" "from" string required} \
              {-through "Through pin" "through" string optional} \
              {-delay_type "delay_type" "delay_type" string optional}}

###############################################################################




#########################################################################
# PROCEDURE: segment_to_from_timing
#
# ABSTRACT: Reports the timing from the given 'from' point to the given 
#   'to' point.  The -from and -to parameters are required. Only the path 
#    segment is reported. This command should be used to generate timing
#    reports from pin A to pin B, where pins A and B are not startpoints or
#    endpoints.
#
# ARGUMENTS: -from  and -to  are both required.
#
#########################################################################
proc segment_to_from_timing {args} {
  suppress_message CMD-041

  parse_proc_arguments -args $args results

  set delay_key ""
  set delay_key [array names results -delay_type]
  if {$delay_key != ""} {
   set delay_type $results(-delay_type)
  }
  set force_in_segment [array names results -force_in_segment]
  if {$force_in_segment != ""} {
   set force_in_segment $results(-force_in_segment)
  } 


  set from $results(-from)
  set to $results(-to)

  report_print_header "segment_to_from_timing" $from $to
  set dly 0

  if {$delay_key != ""} {
   set paths [get_timing_paths -include_hierarchical_pins -from $from -to $to -delay_type $delay_type]
  } else {
   set paths [get_timing_paths -include_hierarchical_pins -from $from -to $to]
  }
 
  if {[string compare $paths ""] == 0} {
    echo "No paths.\n";
    return 0;
  }

  foreach_in_collection path $paths {
    set path_type [get_attribute $path path_type]
    set path_group [get_attribute $path path_group]
    if {[string compare $path_group ""] == 0} {
      set path_group_name ""
    } else {
      set path_group_name [get_attribute $path_group full_name]
    }

    echo "  Segment startpoint: $from"
    echo "  Segment endpoint  : $to"
    echo "  Path Group: $path_group_name"
    echo "  Path Type: $path_type\n"

    report_one_path_line "Point" "Incr" "Path"
    echo "  ---------------------------------------------------------------"

    set previous_arrival 0.0
  if {$force_in_segment != ""} {
    set in_segment 0
  } else {
    set in_segment 1
  }

 
    set temp 0

    foreach_in_collection point [get_attribute $path points] {
      set object [get_attribute $point object]
      set arrival [get_attribute $point arrival]
      set incr [expr $arrival - $previous_arrival]

      set previous_arrival $arrival
      set rise_fall [get_attribute $point rise_fall]
      set point_name [get_attribute $object full_name]

      if {$point_name == $from} { 
        set in_segment 1
        set temp $arrival
      }

      if {$in_segment} {
        report_one_path_line $point_name [report_format_float $incr "%8.5f"] \
	  [report_format_float [expr $arrival - $temp] "%8.5f"] \
	  [string range $rise_fall 0 0] }
      if {$point_name == $to} {
          set dly [expr $arrival - $temp]
          break
      }
    }
    echo "\n"
  }
  if { $dly == 0 } {
          set dly [expr $arrival - $temp]
  }
  return $dly
}

define_proc_attributes segment_to_from_timing \
-info "Report timing for a path segment" \
-define_args {{-from "From pin" "from" string required} \
	      {-to "To pin" "to" string required} \
	      {-force_in_segment "Force in segment " "force_in_segment " string optional} \
              {-delay_type "delay_type" "delay_type" string optional}}



#########################################################################
# PROCEDURE: segment_timing
#
# ABSTRACT: Reports the timing from the given 'from' point to the given 
#   'to' point.  The -from and -to parameters are required. Only the path 
#    segment is reported. This command should be used to generate timing
#    reports from pin A to pin B, where pins A and B are not startpoints or
#    endpoints.
#
# ARGUMENTS: -from  and -to  are both required.
#
#########################################################################
proc segment_timing {args} {
  suppress_message CMD-041

  parse_proc_arguments -args $args results

  set delay_key ""
  set delay_key [array names results -delay_type]
  if {$delay_key != ""} {
   set delay_type $results(-delay_type)
  }
  set force_in_segment [array names results -force_in_segment]
  if {$force_in_segment != ""} {
   set force_in_segment $results(-force_in_segment)
  } 


  set from $results(-from)
  set to $results(-to)

  report_print_header "segment_timing" $from $to
  set dly 0

  if {$delay_key != ""} {
   set paths [get_timing_paths -include_hierarchical_pins -through $from -through $to -delay_type $delay_type]
  } else {
   set paths [get_timing_paths -include_hierarchical_pins -through $from -through $to]
  }
 
  if {[string compare $paths ""] == 0} {
    echo "No paths.\n";
    return 0;
  }

  foreach_in_collection path $paths {
    set path_type [get_attribute $path path_type]
    set path_group [get_attribute $path path_group]
    if {[string compare $path_group ""] == 0} {
      set path_group_name ""
    } else {
      set path_group_name [get_attribute $path_group full_name]
    }

    echo "  Segment startpoint: $from"
    echo "  Segment endpoint  : $to"
    echo "  Path Group: $path_group_name"
    echo "  Path Type: $path_type\n"

    report_one_path_line "Point" "Incr" "Path"
    echo "  ---------------------------------------------------------------"

    set previous_arrival 0.0
  if {$force_in_segment != ""} {
    set in_segment 1
  } else {
    set in_segment 0
  }

    set temp 0

    foreach_in_collection point [get_attribute $path points] {
      set object [get_attribute $point object]
      set arrival [get_attribute $point arrival]
      set incr [expr $arrival - $previous_arrival]

      set previous_arrival $arrival
      set rise_fall [get_attribute $point rise_fall]
      set point_name [get_attribute $object full_name]

      if {$point_name == $from} { 
        set in_segment 1
        set temp $arrival
      }

      if {$in_segment} {
        report_one_path_line $point_name [report_format_float $incr "%8.5f"] \
	  [report_format_float [expr $arrival - $temp] "%8.5f"] \
	  [string range $rise_fall 0 0] }
      if {$point_name == $to} {
          set dly [expr $arrival - $temp]
          break
      }
    }
    echo "\n"
  }
  if { $dly == 0 } {
          set dly [expr $arrival - $temp]
  }
  return $dly
}

define_proc_attributes segment_timing \
-info "Report timing for a path segment" \
-define_args {{-from "From pin" "from" string required} \
	      {-to "To pin" "to" string required} \
	      {-force_in_segment "Force in segment " "force_in_segment " string optional} \
              {-delay_type "delay_type" "delay_type" string optional}}

###############################################################################
# PROCEDURE: report_format_float
#
# ABSTRACT: Formats a float other than with the default %g.
#   Correctly handles INFINITY and UNINIT values.  Use the result as a 
#   string, not a float.
###############################################################################
proc report_format_float {number {format_str "%g"}} {
#  catch {format $format_str $number}
  switch -exact -- $number {
    UNINIT { }
    INFINITY { }
    default {set number [format $format_str $number]}
  }
  return $number;
}

###############################################################################
# PROCEDURE: report_get_date
#
# ABSTRACT:  Returns a string of the current date.
###############################################################################
#proc report_get_date { } {
#    set  input [open "| date"]
#    set date [read -nonewline $input]
#    close $input
#    return $date
#}

###############################################################################
# PROCEDURE: report_print_header
#
# ABSTRACT:  Prints a report header for the current design.
###############################################################################
proc report_print_header {title from to } {
  global sh_product_version;
  echo "****************************************"
  echo [format "Report : %s" $title]
  echo [format "Design : %s" [current_design]]
  echo [format "Version: %s" $sh_product_version]
  echo [format "Date   : %s" [date]]
  echo [format "To     : %s" $to ]
  echo [format "From   : %s" $from]gg
  echo "****************************************\n"
}


###############################################################################
# PROCEDURE: report_one_path_line
#
# ABSTRACT:  Prints information for one timing point, including a name,  
#   incremental value, cumulative value, and extra information (like 
#   "r" or "f" to designate rising/falling transition).
###############################################################################
proc report_one_path_line {point incr path {extra ""} } {
    echo [format "  %-35s %10s %10s %s" $point $incr $path $extra]
}


