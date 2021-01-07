
##  convert_blockage
    set orgi_blkgs [ get_placement_blockages * ]
    foreach_in_collection blkg $orgi_blkgs {
      set bbox [ get_attr $blkg bbox ]
      set llx  [ lindex [ lindex $bbox 0 ] 0 ]
      set lly  [ lindex [ lindex $bbox 0 ] 1 ]
      set urx  [ lindex [ lindex $bbox 1 ] 0 ]
      set ury  [ lindex [ lindex $bbox 1 ] 1 ]
      create_placement_blockage -type soft -coordinate "$llx $lly $urx $ury"
    }
    remove_placement_blockage $orgi_blkgs

    change_selection [get_cells * -hierarchical -filter "is_fixed == true && full_name !~ UUruby_dft/ruby_core/image_proc/*" ]
    change_selection [ all_physical_only_cells] -a
    set ang "garnet_slowdacq8 S90NPLLGS_SSZP1600 CI12323kmio garnet_ref_and_reset"
    foreach_in_collection macro [ get_selection ] {
      set ref_name [ get_attr $macro ref_name ]
      set keepoutmargin 10
      if { [ lsearch $ang $ref_name ] != -1 } { set keepoutmargin 150 }
      if { $ref_name == "CI12323kmio" } { set keepoutmargin 200 }
      set bbox [ get_attr $macro bbox ]
      set llx  [ expr [ lindex [ lindex $bbox 0 ] 0 ] - $keepoutmargin ]
      set lly  [ expr [ lindex [ lindex $bbox 0 ] 1 ] - $keepoutmargin ]
      set urx  [ expr [ lindex [ lindex $bbox 1 ] 0 ] + $keepoutmargin ]
      set ury  [ expr [ lindex [ lindex $bbox 1 ] 1 ] + $keepoutmargin ]
      create_placement_blockage -type hard -coordinate "$llx $lly $urx $ury"
    }


set of [ open soft_blkg.tcl w+ ]
puts $of "remove_placement_blockage -all"
foreach_in_collection blkg [get_placement_blockages *] {
  set type [ get_attr $blkg type]
  set bbox [ get_attr $blkg bbox ]
  puts $of "create_placement_blockage -type $type -coordinate { $bbox }"
}
close $of
