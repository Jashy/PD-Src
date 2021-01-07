####################################################################################################
# PROGRAM     : check_clock_cell_type.tcl
# DESCRIPTION : Check clock cell type based on user defined attribute 'is_extracted_clock_pin".
# WRITTEN BY  : Mitsuya Takashima <mitsuya@alchip.com>
# LAST UPDATE : Fri Oct 23 19:35:37 JST 2009
# TESTED ON   : Version C-2009.06-ICC for amd64 -- May 28, 2009
####################################################################################################

proc check_clock_cell_type { } {
	#set clock_pins [ get_pins */* -hierarchical -filter "is_extracted_clock_pin == true && is_clock_pin != true" ]
	#set clock_cells [ get_cells -of_objects $clock_pins ]
	set clock_cells ""
	foreach_in_collection pin [ get_pins */* -hierarchical -filter "is_extracted_clock_pin == true" ] {
		set cell [ get_cells -of_objects $pin ]
		set is_leaf_pin "false"
		#if { ( [ get_attribute $cell is_sequential ] == "true" ) && ( [ get_attribute $cell clock_gating_integrated_cell -quiet ] == "" ) } { set is_leaf_pin "true" }
		if {([get_attribute $cell is_sequential] == "true") && ([get_attribute $cell clock_gating_integrated_cell -quiet] == "") && ([get_attribute $pin direction] == "in")} { 
			set is_leaf_pin "true" 
		}
		if { $is_leaf_pin == "true" } { 
			continue 
		}
		set clock_cells [ add_to_collection -unique $clock_cells $cell ]
	}

	set min_size_limit 2
	set max_size_limit 20
	set max_multi_drive_size_limit 48

	set cell_type_error_count 0
	set min_size_error_count 0
	set max_size_error_count 0
	set vt_class_error_count 0

	foreach_in_collection cell $clock_cells {
		set cell_name [ get_attribute $cell full_name ]
		set ref_name [ get_attribute $cell ref_name ]
		if {[regexp {^()(.+)D([0-9][0-9]*)BWP12T(...)$}              $ref_name "" prefix base_name size vt_class revision ] == 1 \
		|| [ regexp {^()(.+)D([0-9][0-9]*)BWP12T()$}                 $ref_name "" prefix base_name size vt_class revision ] == 1  } {
			set new_base_name $base_name
			if { $base_name == "AN2" } {
				set new_base_name "CKAN2"
			}
			if { $base_name == "MUX2" } {
				set new_base_name "CKMUX2"
			}
			if { $base_name == "ND2" } {
				set new_base_name "CKND2"
			}
			if { $base_name == "XOR2" } {
				set new_base_name "CKXOR2"
			}
			if { $base_name == "BUFF" } {
				set new_base_name "CKB"
			}
			if { [regexp {DEL} $base_name ""] } {
				set new_base_name "CKB"
			}
			if { $base_name == "INV" } {
				set new_base_name "CKN"
			}
			if { $new_base_name != $base_name } {
				echo [ format "# Error: Clock cell type error '%s' on cell '%s'." $ref_name $cell_name ]
				incr cell_type_error_count
			}

			set new_size $size
			if { $size < $min_size_limit } {
				set new_size $min_size_limit
				echo [ format "# Error: Min size error '%s' on cell '%s'." $ref_name $cell_name ]
				incr min_size_error_count
			}
			if { [ regexp {_FB_L[0-9]_DRIVE[0-9]+$} $cell_name ] == 0 } {
				if { $size > $max_size_limit } {
					  set new_size $max_size_limit
					  echo [ format "# Error: Max size error '%s' on cell '%s'." $ref_name $cell_name ]
					  incr max_size_error_count
				}
			} else {
				if { $size > $max_multi_drive_size_limit } {
					set new_size $max_size_limit
					echo [ format "# Error: Max size error '%s' on cell '%s'." $ref_name $cell_name ]
					incr max_size_error_count
				}
			}

			set new_vt_class $vt_class
			if { $vt_class == "HVT" } {
				set new_vt_class ""
				echo [ format "# Error: Vt class error '%s' on cell '%s'." $ref_name $cell_name ]
				incr vt_class_error_count
			}

			set new_ref_name [ format "%sD%dBWP12T%s" $new_base_name $new_size $new_vt_class ]
			if { $new_ref_name != $ref_name } {
				echo [ format "CHANGE_CELL %s %s ; # %s" $cell_name $new_ref_name $ref_name ]
			}
		}
	}

	echo [ format "####################################################################################################" ]
	echo [ format "# SUMMARY" ]
	echo [ format "#" ]
	echo [ format "# Cell type error count = %10d" $cell_type_error_count ]
	echo [ format "# Min size error count  = %10d" $min_size_error_count ]
	echo [ format "# Max size error count  = %10d" $max_size_error_count ]
	echo [ format "# Vt class error count  = %10d" $vt_class_error_count ]
}

