#
#	Copyright (C) 2009 Alchip Technologies, Limited
#
#	$Id: PIN_NET.tcl,v 1.2 2009/10/14 09:02:05 minato Exp $
#

proc PIN_NET { args } {

  ########################################################################
  # GLOBAL
  #

  ########################################################################
  # USAGE
  #
  proc usage_PIN_NET { } {
    puts {Usage: PIN_NET [ -flat_net ] <pin_name>}
  }

  ########################################################################
  # GET ARGUMENTS
  #
  set quiet       false
  set flat_net    false

  set arg_count 0
  while { $arg_count < [ llength $args ] } {
    if { [ regexp -- {^-} [ lindex $args $arg_count ] ] == 1 } {
      if { [ string compare [ lindex $args $arg_count ] {-help} ] == 0 } {
	usage_PIN_NET
	return 0
      }
      if { [ string compare [ lindex $args $arg_count ] {-quiet} ] == 0 } {
	set quiet true
	incr arg_count
	continue
      }
      if { [ string compare [ lindex $args $arg_count ] {-flat_net} ] == 0 } {
	set flat_net true
	incr arg_count
	continue
      }
      puts [format "Error: Invalid option '%s'." [lindex $args $arg_count]]
      usage_PIN_NET
      return 0
    } else {
      if { [ info exists pin_name_list ] == 0 } {
	set pin_name_list [ lindex $args $arg_count ]
	incr arg_count
	continue
      }
    }
    puts [format "Error: Extra positional option '%s'." [lindex $args $arg_count]]
    usage_PIN_NET
    return 0
  }

  if { [ info exists pin_name_list ] == 0 } {
    usage_PIN_NET
    return 0
  }

  if {! $quiet} {puts [ format "# PIN_NET %s" $args ]}

  ########################################################################
  # CHECK OBJECTS
  #
  set pin_col [get_pins -quiet $pin_name_list]

  if {[sizeof_collection $pin_col] == 0} {
    puts [format "Error: Cannot find pin '%s'." $pin_name_list]
    return {}
  }

  ########################################################################
  # MAKE CHANGE
  #
  proc pin_net {pin flat_net} {
    if {$flat_net == true} {
      return [get_flat_nets -of $pin]
    } else {
      return [get_nets -of $pin]
    }
  }

  if {[sizeof_collection $pin_col] == 1} {
    return [pin_net $pin_col $flat_net]
  }

  set ret_list {}
  foreach_in_collection pin $pin_col {
    lappend ret_list [get_object_name $pin]
    lappend ret_list [pin_net $pin $flat_net]
  }

  return $ret_list
}

# eof
