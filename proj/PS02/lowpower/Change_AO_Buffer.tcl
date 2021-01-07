source /proj/PS02/WORK/Goodenj/release/tcl/CHANGE_CELL_REF_ICC.tcl

set AO_Buffer [filter_collection [all_fanin -to [get_pins -of [get_flat_cells -filter "ref_name =~ LVL*"] -filter "pin_direction == in"] -flat -only_cells ] "ref_name !~ LVL*"]

echo    ""      > ./change.tcl

foreach_in_coll buffer $AO_Buffer {
	set cell_name [ get_attr [get_cells $buffer] full_name ]
	echo "CHANGE_CELL_REF_ICC  $cell_name GPGBUF_X4M_A8TR_C34" >> change.tcl
}

source ./change.tcl
