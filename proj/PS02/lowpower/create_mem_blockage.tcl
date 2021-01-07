proc create_mem_blockage { cells { keepout "10" } { type "soft" } } {
  
  foreach_in cell [ get_cells $cells ] {

    set bbox [ get_attr $cell bbox ]
    set llx  [ expr [ lindex [ lindex $bbox 0 ] 0 ] - $keepout ]
    set lly  [ expr [ lindex [ lindex $bbox 0 ] 1 ] - 1 ]
    set urx  [ expr [ lindex [ lindex $bbox 1 ] 0 ] + $keepout ]
    set ury  [ expr [ lindex [ lindex $bbox 1 ] 1 ] + 1 ]

    create_placement_blockage -type $type -coordinate "$llx $lly $urx $ury"
  }

}

proc create_mem_blockage_dcap { cells { keepout "1" } { type "soft" } } {
  
  foreach_in cell [ get_cells $cells ] {

    set bbox [ get_attr $cell bbox ]
    set llx  [ expr [ lindex [ lindex $bbox 0 ] 0 ] - $keepout ]
    set lly  [ expr [ lindex [ lindex $bbox 0 ] 1 ] - $keepout ]
    set urx  [ expr [ lindex [ lindex $bbox 1 ] 0 ] + $keepout ]
    set ury  [ expr [ lindex [ lindex $bbox 1 ] 1 ] + $keepout ]

    create_placement_blockage -type $type -coordinate "$llx $lly $urx $ury"
  }

}


proc create_mem_blockage_hard { cells { keepout "1" } { type "hard" } } {

  foreach_in cell [ get_cells $cells ] {

    set bbox [ get_attr $cell bbox ]
    set llx  [ expr [ lindex [ lindex $bbox 0 ] 0 ] - $keepout ]
    set lly  [ expr [ lindex [ lindex $bbox 0 ] 1 ] - $keepout ]
    set urx  [ expr [ lindex [ lindex $bbox 1 ] 0 ] + $keepout ]
    set ury  [ expr [ lindex [ lindex $bbox 1 ] 1 ] + $keepout ]

    create_placement_blockage -type $type -coordinate "$llx $lly $urx $ury"
  }

}

proc create_mem_route_guide_M7 { cells { keepout "1" } { no_preroute_layer "M7"} } {

  foreach_in cell [ get_cells $cells ] {

    set bbox [ get_attr $cell bbox ]
    set llx  [ expr [ lindex [ lindex $bbox 0 ] 0 ] - $keepout ]
    set lly  [ expr [ lindex [ lindex $bbox 0 ] 1 ] - $keepout ]
    set urx  [ expr [ lindex [ lindex $bbox 1 ] 0 ] + $keepout ]
    set ury  [ expr [ lindex [ lindex $bbox 1 ] 1 ] + $keepout ]

    create_route_guide -no_preroute_layers $no_preroute_layer -coordinate "$llx $lly $urx $ury"
  }

}

proc create_mem_route_guide_M6 { cells { keepout "1" } { no_preroute_layer "M6"} } {

  foreach_in cell [ get_cells $cells ] {

    set bbox [ get_attr $cell bbox ]
    set llx  [ expr [ lindex [ lindex $bbox 0 ] 0 ] - $keepout ]
    set lly  [ expr [ lindex [ lindex $bbox 0 ] 1 ] - $keepout ]
    set urx  [ expr [ lindex [ lindex $bbox 1 ] 0 ] + $keepout ]
    set ury  [ expr [ lindex [ lindex $bbox 1 ] 1 ] + $keepout ]

    create_route_guide -no_preroute_layers $no_preroute_layer -coordinate "$llx $lly $urx $ury"
  }

}

proc create_mem_route_guide_M5 { cells { keepout "1" } { no_preroute_layer "M5"} } {

  foreach_in cell [ get_cells $cells ] {

    set bbox [ get_attr $cell bbox ]
    set llx  [ expr [ lindex [ lindex $bbox 0 ] 0 ] - $keepout ]
    set lly  [ expr [ lindex [ lindex $bbox 0 ] 1 ] - $keepout ]
    set urx  [ expr [ lindex [ lindex $bbox 1 ] 0 ] + $keepout ]
    set ury  [ expr [ lindex [ lindex $bbox 1 ] 1 ] + $keepout ]

    create_route_guide -no_preroute_layers $no_preroute_layer -coordinate "$llx $lly $urx $ury"
  }

}

proc create_chan_route_guide_M5 { thin_blockage { keepout "5" } { no_preroute_layer "M5"} } {

  foreach_in cell [ get_placement_blockage  $thin_blockage ] {

    set bbox [ get_attr $cell bbox ]
    set llx  [ expr [ lindex [ lindex $bbox 0 ] 0 ] - $keepout ]
    set lly  [ expr [ lindex [ lindex $bbox 0 ] 1 ] - 0 ]
    set urx  [ expr [ lindex [ lindex $bbox 1 ] 0 ] + $keepout ]
    set ury  [ expr [ lindex [ lindex $bbox 1 ] 1 ] + 0 ]

    create_route_guide -no_preroute_layers $no_preroute_layer -coordinate "$llx $lly $urx $ury"
  }

}

proc create_chan_route_guide_M6 { thin_blockage { keepout "5" } { no_preroute_layer "M6"} } {

  foreach_in cell [ get_placement_blockage  $thin_blockage ] {

    set bbox [ get_attr $cell bbox ]
    set llx  [ expr [ lindex [ lindex $bbox 0 ] 0 ] - $keepout ]
    set lly  [ expr [ lindex [ lindex $bbox 0 ] 1 ] - 0 ]
    set urx  [ expr [ lindex [ lindex $bbox 1 ] 0 ] + $keepout ]
    set ury  [ expr [ lindex [ lindex $bbox 1 ] 1 ] + 0 ]

    create_route_guide -no_preroute_layers $no_preroute_layer -coordinate "$llx $lly $urx $ury"
  }

}

proc create_chan_route_guide_M7 { thin_blockage { keepout "5" } { no_preroute_layer "M7"} } {

  foreach_in cell [ get_placement_blockage  $thin_blockage ] {

    set bbox [ get_attr $cell bbox ]
    set llx  [ expr [ lindex [ lindex $bbox 0 ] 0 ] - $keepout ]
    set lly  [ expr [ lindex [ lindex $bbox 0 ] 1 ] - 0 ]
    set urx  [ expr [ lindex [ lindex $bbox 1 ] 0 ] + $keepout ]
    set ury  [ expr [ lindex [ lindex $bbox 1 ] 1 ] + 0 ]

    create_route_guide -no_preroute_layers $no_preroute_layer -coordinate "$llx $lly $urx $ury"
  }

}

