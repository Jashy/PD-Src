
foreach {cel new} {
	AN2XD1		AN2D1
	AN3XD1		AN3D1
	AN4XD1		AN4D1
	AOI211XD1	AOI211D1
	OR3XD1		OR3D1
	OR4XD1		OR4D1
} {
  puts "searching $cel inst..."
  set col [ get_flat_cells -filter "ref_name == $cel" * ]
  if {[sizeof_collection $col] == 0} {
    puts " none."
  } else {
    foreach_in_collection i $col {
      set cmd "size_cell [get_object_name $i] tcbn65lpwcl/$new"
      puts "    $cmd"
      eval $cmd
    }
  }
}


foreach {cel new} {
	AN2XD1HVT	AN2D1HVT
	AN3XD1HVT	AN3D1HVT
	AN4XD1HVT	AN4D1HVT
	AOI211XD1HVT	AOI211D1HVT
	INR2XD1HVT	INR2D1HVT
	NR2XD1HVT	NR2D1HVT
	OR2XD1HVT	OR2D1HVT
	OR3XD1HVT	OR3D1HVT
	OR4XD1HVT	OR4D1HVT
} {
  puts "searching $cel inst..."
  set col [ get_flat_cells -filter "ref_name == $cel" * ]
  if {[sizeof_collection $col] == 0} {
    puts " none."
  } else {
    foreach_in_collection i $col {
      set cmd "size_cell [get_object_name $i] tcbn65lphvtwcl/$new"
      puts "    $cmd"
      eval $cmd
    }
  }
}

#SUBST_CELLS ${REPLACE}     "tcbn65lpwcl"
#SUBST_CELLS ${REPLACE_HVT} "tcbn65lphvtwcl"

