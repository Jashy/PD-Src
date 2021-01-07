proc list_cells { pattern rpt_file } {
        set rpt_file [open $rpt_file w]
        set cells [get_cells * -hier -filter "full_name =~ $pattern"]
        foreach_in_collection cell $cells {
                set name [get_attribute $cell full_name]
                set ref [get_attribute $cell ref_name]
                puts $rpt_file "$name $ref"
        }
}
