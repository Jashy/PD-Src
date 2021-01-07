proc report_transition_distribution { } {
	set gap 0.05

	set range1 0
        set range2 0
        set range3 0
	set range4 0
        set range5 0
        set range6 0
        set range7 0
	set range8 0
        set range9 0
        set range10 0
        set range11 0
        set range12 0
        set range13 0
        set range14 0
        set range15 0
        set range16 0
        set range17 0
	set limit1  [format %0.3f [expr $gap * 1 ] ]
	set limit2  [format %0.3f [expr $gap * 2 ] ]
	set limit3  [format %0.3f [expr $gap * 3 ] ]
	set limit4  [format %0.3f [expr $gap * 4 ] ]
	set limit5  [format %0.3f [expr $gap * 5 ] ]
	set limit6  [format %0.3f [expr $gap * 6 ] ]
	set limit7  [format %0.3f [expr $gap * 7 ] ]
	set limit8  [format %0.3f [expr $gap * 8 ] ]
	set limit9  [format %0.3f [expr $gap * 9 ] ]
	set limit10 [format %0.3f [expr $gap * 10 ] ]
	set limit11 [format %0.3f [expr $gap * 11 ] ]
	set limit12 [format %0.3f [expr $gap * 12 ] ]
	set limit13 [format %0.3f [expr $gap * 13 ] ]
	set limit14 [format %0.3f [expr $gap * 14 ] ]
	set limit15 [format %0.3f [expr $gap * 15 ] ]
	set limit16 [format %0.3f [expr $gap * 16 ] ]
	set limit17 [format %0.3f [expr $gap * 17 ] ]

	set all_pins [ get_pins -hierarchical -filter {is_hierarchical == false} ]
	
	foreach_in_collection pin $all_pins {
		set pin_name [ get_attri [ get_pins $pin ] full_name ]
		set pin_tran_rise_max [ get_attri [ get_pins $pin ] actual_rise_transition_max ]
		set pin_tran_fall_max [ get_attri [ get_pins $pin ] actual_fall_transition_max ]
		if { $pin_tran_rise_max > $pin_tran_fall_max } {
			set pin_tran_max $pin_tran_rise_max
		} else {
			set pin_tran_max $pin_tran_fall_max
		}

		if { $pin_tran_max < $limit1 } {
			set range1 [expr $range1+1]
		} elseif { $pin_tran_max < $limit2 } {
			set range2 [expr $range2+1]
		} elseif { $pin_tran_max < $limit3 } {
			set range3 [expr $range3+1]
		} elseif { $pin_tran_max < $limit4 } {
			set range4 [expr $range4+1]
		} elseif { $pin_tran_max < $limit5 } {
			set range5 [expr $range5+1]
		} elseif { $pin_tran_max < $limit6 } {
			set range6 [expr $range6+1]
		} elseif { $pin_tran_max < $limit7 } {
			set range7 [expr $range7+1]
			echo "$pin_name : $pin_tran_max"
		} elseif { $pin_tran_max < $limit8 } {
			set range8 [expr $range8+1]
			echo "$pin_name : $pin_tran_max"
		} elseif { $pin_tran_max < $limit9 } {
			set range9 [expr $range9+1]
			echo "$pin_name : $pin_tran_max"
		} elseif { $pin_tran_max < $limit10 } {
			set range10 [expr $range10+1]
			echo "$pin_name : $pin_tran_max"
		} elseif { $pin_tran_max < $limit11 } {
			set range11 [expr $range11+1]
			echo "$pin_name : $pin_tran_max"
		} elseif { $pin_tran_max < $limit12 } {
			set range12 [expr $range12+1]
			echo "$pin_name : $pin_tran_max"
		} elseif { $pin_tran_max < $limit13 } {
			set range13 [expr $range13+1]
			echo "$pin_name : $pin_tran_max"
		} elseif { $pin_tran_max < $limit14 } {
			set range14 [expr $range14+1]
			echo "$pin_name : $pin_tran_max"
		} elseif { $pin_tran_max < $limit15 } {
			set range15 [expr $range15+1]
			echo "$pin_name : $pin_tran_max"
		} elseif { $pin_tran_max < $limit16 } {
			set range16 [expr $range16+1]
			echo "$pin_name : $pin_tran_max"
		} else {
			set range17 [expr $range17+1]
			echo "$pin_name : $pin_tran_max"
		}
	}
	
	echo "transition range	num of pins"
	echo "0.000 < $limit1		$range1"
	echo "$limit1 < $limit2		$range2"
	echo "$limit2 < $limit3		$range3"
	echo "$limit3 < $limit4		$range4"
	echo "$limit4 < $limit5		$range5"
	echo "$limit5 < $limit6		$range6"
	echo "$limit6 < $limit7		$range7"
	echo "$limit7 < $limit8		$range8"
	echo "$limit8 < $limit9		$range9"
	echo "$limit9 < $limit10		$range10"
	echo "$limit10 < $limit11		$range11"
	echo "$limit11 < $limit12		$range12"
	echo "$limit12 < $limit13		$range13"
	echo "$limit13 < $limit14		$range14"
	echo "$limit14 < $limit15		$range15"
	echo "$limit15 < $limit16		$range16"
	echo "$limit16 <  		$range17"
}

echo "please run report_transition_distribution"
