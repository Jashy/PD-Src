set library	"/proj/BTC/WORK/arckeonw/ICC/TOP/floorplan/MDB_LKB11"
set CELL 	"VNET_20150901_fp"

set place_without_LVT_psyn_with_LVT	0

set run_place_opt			1
set run_psynopt				1
set run_cts				1
set run_route				1
set run_route_opt			0

set Mytime	[sh  date +%m-%d_%H:%M]

source -e	./flow_btc/open.tcl  

if { $run_place_opt == 1 } {
	source -e	./flow_btc/02_place.tcl	
	}

echo "arckeonw check"
if { $place_without_LVT_psyn_with_LVT == 1 } {
	remove_attribute [get_lib_cells */*LVT] dont_use
	set_dont_use [get_lib_cells */*D0]
	set_dont_use [get_lib_cells */*D0*]
	set_dont_use [get_lib_cells */*D24]
	set_dont_use [get_lib_cells */*D24*]
	set_dont_use [get_lib_cells */*DEL*]
	set_dont_use [get_lib_cells */BUFFD1]
	set_dont_use [get_lib_cells */INVD1]
	set_dont_use [get_lib_cells */CK*]
	}

if { $run_psynopt == 1 } {
	source -e	./flow_btc/03_psynopt.tcl	
	}

echo "arckeonw check"
if { $run_cts == 1 } {
	source -e	./flow_btc/CTS.tcl	
	}

echo "arckeonw check"
if { $run_route == 1 } {
	source -e	./flow_btc/05_route.tcl	
	}

echo "arckeonw check"
if { $run_route_opt == 1 } {
	source -e	./flow_btc/07_route_opt.tcl	
}

close_mw_cel 
close_mw_lib
exit

