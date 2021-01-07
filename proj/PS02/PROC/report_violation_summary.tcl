proc report_violation_summary { args } {
    ########################################################################
    # check arguments
    #
    proc usage_report_violation_summary { } {
        puts {    Usage:   report_violation_summary <timing_report_file> [-significant_digits <significant_digits>]}
    }

    set arg_count 0
    while { $arg_count < [ llength $args ] } {
        if { [ regexp -- {^-} [ lindex $args $arg_count ] ] == 1 } {
            if { [ regexp -- [ lindex $args $arg_count ] {-help} ] == 1 } {
                usage_report_violation_summary
                return
            }
            if { [ regexp -- [ lindex $args $arg_count ] {-significant_digits} ] == 1 } {
                incr arg_count
                set significant_digits [ lindex $args $arg_count ]
                incr arg_count
                continue
            }
        } else {
            if { [ info exists file_name ] == 0 } {
                set file_name [ lindex $args $arg_count ]
                incr arg_count
                continue
            }
        }
        usage_report_violation_summary
        return
    }

    ########################################################################
    # initialize variables
    #
    set range_list {
         0.000-0.100
         0.100-0.200
         0.200-0.300
         0.300-0.400
         0.400-0.500
         0.500-0.600
         0.600-0.700
         0.700-0.800
         0.800-0.900
         0.900-1.000
         1.000-2.000
         2.000-3.200
         3.000-4.000
         4.000-5.000
         5.000-6.000
         6.000-7.000
         7.000-
    }
    foreach range $range_list {
        set count($range) 0
    }
    set count(total) 0

    ########################################################################
    # parse given timing report
    #
    set file [ open $file_name r ]
    while { [ gets $file line ] >= 0 } {
        if { [ regexp {^\s*Startpoint:} $line ] == 1 } {
            set startpoint [ lindex $line 1 ]

            set from_clock ""
            set to_clock ""
        }
        if { [ regexp {^\s*Endpoint:} $line ] == 1 } {
            set endpoint [ lindex $line 1 ]

            if { [ info exists endpoints($startpoint) ] == 0 } {
                set endpoints($startpoint) ""
            }
            set endpoints($startpoint) [ concat $endpoints($startpoint) $endpoint ]
        }
        if { [ regexp { clocked by } $line ] == 1 } {
            if { $from_clock == "" } {
                set from_clock $line
                regsub -all {^.*\(.* clocked by } $from_clock "" from_clock
                regsub -all {\)\s*$}              $from_clock "" from_clock
                regsub -all {,\s*$}               $from_clock "" from_clock
            }
            if { $to_clock == "" } {
                set to_clock $line
                regsub -all {^.*\(.* clocked by } $to_clock "" to_clock
                regsub -all {\)\s*$}              $to_clock "" to_clock
                regsub -all {,\s*$}               $to_clock "" to_clock
            }
        }
        if { [ regexp { Path Group: } $line ] == 1 } {
            set path_group [ lindex $line 2 ]
        }

        ########################################################################
        # count violations for each range
        #
        if { ( [ regexp {^\s*slack \(VIOLATED.*\)\s+} $line ] == 1 ) || ( [ regexp {^\s*slack \(MET\)\s+} $line ] == 1 ) } {
            set slack [ lindex $line end ]
            set violation [ expr $slack * -1.000 ]
            if { [ info exists significant_digits ] == 1 } {
                set violation [ format "%.${significant_digits}f" $violation ]
            }
            foreach range $range_list {
                set more_than [ lindex [ split $range "-" ] 0 ]
                set less_than [ lindex [ split $range "-" ] 1 ]
                if { $more_than == "" } {
                    set more_than 999999
                }
                if { ( $violation > $more_than ) && ( $violation <= $less_than ) } {
                    incr count($range)
                   #continue
                }
            }
            set path_slack($startpoint,$endpoint) [ lindex $line end ]
            if { $path_slack($startpoint,$endpoint) <= 0 } {
                incr count(total)
            }

            if { [ info exists path_group_error_count($path_group) ] == 0 } {
                set path_group_error_count($path_group) 0
            }
            incr path_group_error_count($path_group)
            if { [ info exists path_group_worst_slack($path_group) ] == 0 } {
                set path_group_worst_slack($path_group) 999999
            }
            if { $slack < $path_group_worst_slack($path_group) } {
                set path_group_worst_slack($path_group) $slack
            }

            set clock_group $from_clock,$to_clock
            if { [ info exists clock_group_error_count($clock_group) ] == 0 } {
                set clock_group_error_count($clock_group) 0
            }
            incr clock_group_error_count($clock_group)
            if { [ info exists clock_group_worst_slack($clock_group) ] == 0 } {
                set clock_group_worst_slack($clock_group) 999999
            }
            if { $slack < $clock_group_worst_slack($clock_group) } {
                set clock_group_worst_slack($clock_group) $slack
            }
        }
    }
    close $file
    puts [ format "Information: Parsing %s ..." $file_name ]

    ########################################################################
    # print histogram
    #
    set file [ open $file_name.histogram w ]

    puts $file [ format " +------------------------------------+" ]
    puts $file [ format " | %-11s | %20s |" "Range" "Number of violations" ]
    puts $file [ format " |-------------+----------------------|" ]
    foreach range $range_list {
        puts $file [ format " | %-11s | %20s |" $range $count($range) ]
    }
    puts $file [ format " |-------------+----------------------|" ]
    puts $file [ format " | %-11s | %20s |" "Total" $count(total) ]
    puts $file [ format " +------------------------------------+" ]

    close $file

    set file [ open $file_name.histogram r ]
    while { [ gets $file line ] >= 0 } {
        puts $line
    }
    close $file

    puts [ format "Information: %s.histogram generated." $file_name ]

    ########################################################################
    # print path group table
    #
    set file [ open $file_name.path_group w ]

    puts $file [ format " +--------------------------------------------------------------------+" ]
    puts $file [ format " | %-20s | %20s | %20s |" "Path group" "Number of violations" "Wrost slack" ]
    puts $file [ format " |----------------------+----------------------+----------------------|" ]
    set error_count 0
    set worst_slack 999999
    foreach path_group [ array names path_group_error_count ] {
        puts $file [ format " | %-20s | %20s | %20s |" $path_group $path_group_error_count($path_group) $path_group_worst_slack($path_group) ]
        set error_count [ expr $error_count + $path_group_error_count($path_group) ]
        if { $path_group_worst_slack($path_group) < $worst_slack } {
            set worst_slack $path_group_worst_slack($path_group)
        }
    }
    puts $file [ format " |----------------------+----------------------+----------------------|" ]
    puts $file [ format " | %-20s | %20s | %20s |" "*" $error_count $worst_slack ] 
    puts $file [ format " +--------------------------------------------------------------------+" ]
    close $file

    set file [ open $file_name.path_group r ]
    while { [ gets $file line ] >= 0 } {
        puts $line
    }
    close $file

    puts [ format "Information: %s.path_group generated." $file_name ]

    ########################################################################
    # print clock group table
    #
    set file [ open $file_name.clock_group w ]

    puts $file [ format " +-------------------------------------------------------------------------------------------+" ]
    puts $file [ format " | %-20s | %-20s | %20s | %20s |" "From clock" "To clock" "Number of violations" "Wrost slack" ]
    puts $file [ format " |----------------------+----------------------+----------------------+----------------------|" ]
    set error_count 0
    set worst_slack 999999
    foreach clock_group [ array names clock_group_error_count ] {
        set from_clock [ lindex [ split $clock_group "," ] 0 ]
        set to_clock   [ lindex [ split $clock_group "," ] 1 ]
        puts $file [ format " | %-20s | %-20s | %20s | %20s |" $from_clock $to_clock $clock_group_error_count($clock_group) $clock_group_worst_slack($clock_group) ]
        set error_count [ expr $error_count + $clock_group_error_count($clock_group) ]
        if { $clock_group_worst_slack($clock_group) < $worst_slack } {
            set worst_slack $clock_group_worst_slack($clock_group)
        }
    }
    puts $file [ format " |----------------------+----------------------+----------------------+----------------------|" ]
    puts $file [ format " | %-20s | %-20s | %20s | %20s |" "*" "*" $error_count $worst_slack ]
    puts $file [ format " +-------------------------------------------------------------------------------------------+" ]
    close $file

    set file [ open $file_name.clock_group r ]
    while { [ gets $file line ] >= 0 } {
        puts $line
    }
    close $file

    puts [ format "Information: %s.clock_group generated." $file_name ]

    ########################################################################
    # print endpoints foreach startpoint
    #
    set file [ open $file_name.endpoints w ]
 
    set startpoint_index_list ""
    foreach startpoint [ array names endpoints ] {
        lappend startpoint_index_list [ concat [ llength $endpoints($startpoint) ] $startpoint ]
    }
    set startpoint_index_list [ lsort -decreasing -index 0 -integer $startpoint_index_list ]
 
    foreach startpoint_index $startpoint_index_list {
        set startpoint [ lindex $startpoint_index 1 ]
        puts $file [ format "%s  %s" [ llength $endpoints($startpoint) ] $startpoint ]
        foreach endpoint $endpoints($startpoint) {
            puts $file [ format "%8s  %s" $path_slack($startpoint,$endpoint) $endpoint ]
        }
        puts $file [ format "" ]
    }
 
    close $file
 
    puts [ format "Information: %s.endpoints generated." $file_name ]
}

