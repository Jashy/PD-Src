########################################################################
#open mw lib
source -e ./flow_btc/setup.tcl
source -e ./flow_btc/00_create_mdb.tcl
copy_mw_cel -from_library $library -from $CELL -to ${TOP}
open_mw_cel ${TOP}
source ./flow_btc/UPF/pt_lib.tcl
link -force
