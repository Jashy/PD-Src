source -echo flow_btc/setup.tcl
open_mw_lib MDB_hce
open_mw_cel hce
extract_rc 
write_parasitics -format spef -compress  -output hce_20150630a.spef
exit
