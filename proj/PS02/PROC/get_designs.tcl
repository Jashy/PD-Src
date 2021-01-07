proc list_design { rpt_file } {
	set design [get_designs]
	foreach_in_collection cell $design {
		set name [get_attribute $cell name]
		redirect -append $rpt_file { echo "$name" }
		echo $name
	}
}
