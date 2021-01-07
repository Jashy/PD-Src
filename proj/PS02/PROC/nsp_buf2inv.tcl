set file [open eco_list_1022.list w]
set bufs [get_cells -hier -filter "ref_name =~ BUF_*M* || ref_name =~ BUFH_*M* "]
#set bufs [get_cells {REP_LARGE_BUF__cmu2_l2t45_l2b45_l2d4_ISOH_NET_l2b4_l2d4_fbdecc_c4_206_0 \
#			REP_LARGE_BUF__cmu2_l2t45_l2b45_l2d4_ISOH_NET_l2b4_l2d4_fbdecc_c4_202_0 \
#			REP_LARGE_BUF__cmu2_l2t45_l2b45_l2d4_ISOH_NET_l2b4_l2d4_fbdecc_c4_205_0} \
#	]
while { [sizeof_collection $bufs ]>0 } {
	set buf_collection_list ""
	set flag_not_buff 0
	foreach_in_collection buf $bufs {
	  #set buf_collection_list [add_to_collection $buf_collection_list $buf]
	  set buf_pin [get_pins -of [get_cells $bufs] -filter "direction == out"]
	  set all_loading [all_fanout -only_cells -flat -levels 1 -from  $buf_pin]
	  foreach_in_collection cell_type $all_loading {
	    set buf_type [get_attribute $cell_type ref_name]
	    if { [regexp {BUF} $buf_type]} {
		set buf_collection_list  [add_to_collection $buf_collection_list $cell_type]
	    } else { 
	      set flag_not_buff 1
	    }
	  }
	  if { $flag_not_buff ==1 } {
	    set bufs [remove_from_collection $bufs $buf_inv]
	    set flag_not_buff 0
	    continue
	  }
	  if { $flag_not_buff ==0 } {
	    set cell_name [get_attribute $buf full_name ]
	    puts  $file $cell_name
	    set bufs [remove_from_collection $bufs $buf_inv]
	  }
	  foreach_in_collection buf_inv $buf_collection_list {
	    set cell_name [get_attribute $buf_inv full_name ]
	    set bufs [remove_from_collection $bufs $buf_inv]
	    puts  $file $cell_name
	  }
	  set buf_collection_list ""
	
	}
}
close $file

