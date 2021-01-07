set BUF tcbn65lpwcl/CKBD1
set eco_string CLOCK_ECO_PRE_BUFFER 
set new_root_cells [list ]
catch { unset prebuf_name }


set prebuf_name(wyvern1_0/wcrgen_0/pcke_edia/cke_cell/Q) CKA_E_1_CTSBUF
set prebuf_name(wyvern1_0/wcrgen_0/pcke_fdia/cke_cell/Q) CKA_F_1_CTSBUF
set prebuf_name(wyvern1_0/wcrgen_0/pcke_fdiaa/cke_cell/Q) CKA_F_2_CTSBUF
set prebuf_name(wyvern1_0/wcrgen_0/pcke_fpsp/cke_cell/Q) CKA_F_3_CTSBUF
set prebuf_name(wyvern1_0/wcrgen_0/pcke_cfc/cke_cell/Q) CKA_F_4_CTSBUF
#set prebuf_name(wyvern1_0/pcksel_tck/Z)                 CKA_F_5_CTSBUF
set prebuf_name(wyvern1_0/wcrgen_0/pcke_cfp/cke_cell/Q) CKA_F_6_CTSBUF
set prebuf_name(wyvern1_0/wcrgen_0/pcke_cfcw/cke_cell/Q) CKA_F_7_CTSBUF
set prebuf_name(wyvern1_0/wcrgen_0/pcke_cfr/cke_cell/Q) CKA_F_8_CTSBUF
set prebuf_name(wyvern1_0/wcrgen_0/pcke_ddia/cke_cell/Q) CKA_D_1_CTSBUF
set prebuf_name(wyvern1_0/wcrgen_0/pcke_sdia/cke_cell/Q) CKA_S_1_CTSBUF
set prebuf_name(wyvern1_0/SALSACTRL/SALSAGCK_TCK/U2/Z)  STCK_CTSBUF


set of [ open fishbone_prebuffer.tcl w+ ]
set count 0

puts $of "#--------------------------------------------"

foreach pin [ array names prebuf_name ] {
	incr count
	set buffer_name $prebuf_name($pin)
	if { [ get_attribute $pin object_class ] == "port" || [ get_attribute $pin object_class ] == "pin" } {
	} else {
		puts "ERROR: Wrong Pin or Port of $pin"
		return
	}
	set coor [get_attribute $pin center]
	set coor "\{$coor\}"
	set pin_hiers [ split $pin "/" ]
	set pin_hier_num [ llength $pin_hiers ]
	set net_name_piece [ lindex $pin_hiers [ expr $pin_hier_num - 2 ] ] 
	set buffer_hiers [ concat [ lrange $pin_hiers 0 [ expr $pin_hier_num -2 ]  ]  $buffer_name ]
	set buffer_hier [ join $buffer_hiers "/" ]
    puts $of "### $count  pin: $pin" 
        
	### insert_buffer
	set cmd "insert_buffer $pin $BUF -new_cell_names $buffer_name -new_net_names ${eco_string}_${net_name_piece}_n_0 -location $coor -legalize"
	puts $of "puts \"INFO: $cmd\""
	puts $of $cmd
	
	puts $of ""
	
	lappend new_root_cells $buffer_hier
}

close $of
