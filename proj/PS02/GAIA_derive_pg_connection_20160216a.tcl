## global VDD_PD24 & VSS & VDD ##
derive_pg_connection -power_net VDD_PD24 -power_pin VDD -reconnect -verbose
derive_pg_connection -ground_net VSS -ground_pin VSS  -reconnect -verbose
derive_pg_connection -ground_net VSS -ground_pin VSSG  -reconnect -verbose
derive_pg_connection -power_net VDD -power_pin BIASNW -reconnect -verbose
## Power Switch cells ## 
derive_pg_connection -power_net VDD -power_pin VDDG -reconnect -verbose
## MEM ##
derive_pg_connection -power_net VDD -power_pin VDDPE -reconnect -verbose
derive_pg_connection -power_net VDD1V_MEM -power_pin VDDCE -reconnect -verbose
derive_pg_connection -ground_net VSS -ground_pin VSSE  -reconnect -verbose
source /proj/PS02/WORK/jasons/Block/GAIA/Level_shift_1216/GAIA.vio.list_dft
derive_pg_connection -power_net VDD1V_MEM -power_pin VDDPE -reconnect -cells [get_cells $mems] -verbose
## Level shift cells ##
derive_pg_connection -power_net VDD1V_MEM -power_pin VDDO -reconnect -verbose
source /proj/PS02/WORK/jasons/Block/GAIA/data/lvluo_pgen.lis
derive_pg_connection -power_net VDD -power_pin VDD -reconnect -verbose -cells [get_cells $cells]

##  1v BUFFERS ##
source /DELL/proj/PS02/WORK/lukez/pt/0224/1v_buffer.tcl

derive_pg_connection -power_net VDD1V_MEM -power_pin VDD -reconnect -verbose -cells [get_cells $buffer_1v]

## 0.9v filler & endcap cells ##
#source /proj/PS02/WORK/jasons/Block/GAIA/Final_drc_0313a/0.9v_filler.lis

#derive_pg_connection -power_net VDD -power_pin VDD -reconnect -verbose -cells [get_cells $cells -all]

source /proj/PS02/WORK/jasons/Block/GAIA/data/0.9v_endcap.lis

derive_pg_connection -power_net VDD -power_pin VDD -reconnect -verbose -cells [get_cells $cells -all]

## 1.0v filler & endcap cells ##
source /proj/PS02/WORK/jasons/Block/GAIA/data/1.0v_endcap.lis

derive_pg_connection -power_net VDD1V_MEM -power_pin VDD -reconnect -verbose -cells [get_cells $cells -all]

#source /proj/PS02/WORK/jasons/Block/GAIA/Final_drc_0313a/1.0v_filler.lis

#derive_pg_connection -power_net VDD1V_MEM -power_pin VDD -reconnect -verbose -cells [get_cells $cells -all]

## PCLAMP ##
derive_pg_connection -power_net VDD -power_pin VDD11 -reconnect -verbose -cells [get_cells ESDCLAMP_GAIA_1 -all]



set always_on_cells [get_flat_cell abdcdsedfg -quiet]
set 1v_cells [get_flat_cell absdsdfdssd -quiet]

set always_on_blockages [remove_from_collection [get_placement_blockage *jasons*] [get_placement_blockage *jasons*DUMMY_BUFFER*]]

foreach_in_collection always_on_blockage $always_on_blockages  {
set bbox [get_attr  $always_on_blockage bbox]
set lx [lindex [lindex $bbox 0] 0]
set ly [lindex [lindex $bbox 0] 1]
set rx [lindex [lindex $bbox 1] 0]
set ry [lindex [lindex $bbox 1] 1]

set lx_new [expr ($lx - 0.1)]
set ly_new [expr ($ly - 0.1)]
set rx_new [expr ($rx + 0.1)]
set ry_new [expr ($ry + 0.1)]


set always_on_cells [add_to_collection $always_on_cells [get_cells -within "{$lx_new $ly_new} {$rx_new $ry_new}" -all]]

}
derive_pg_connection -power_net VDD -power_pin VDD -reconnect -cells [get_cells $always_on_cells -all ] -verbose




set 1v_blockages [get_placement_blockage *jasons*DUMMY_BUFFER*]
foreach_in_collection 1v_blockage $1v_blockages  {
	set bbox [get_attr  $1v_blockage bbox]
	set lx [lindex [lindex $bbox 0] 0]
	set ly [lindex [lindex $bbox 0] 1]
	set rx [lindex [lindex $bbox 1] 0]
	set ry [lindex [lindex $bbox 1] 1]

	set lx_new [expr ($lx - 0.1)]
	set ly_new [expr ($ly - 0.1)]
	set rx_new [expr ($rx + 0.1)]
	set ry_new [expr ($ry + 0.1)]


	set 1v_cells [add_to_collection $1v_cells [get_cells -within "{$lx_new $ly_new} {$rx_new $ry_new}" -all]]

}
derive_pg_connection -power_net VDD1V_MEM -power_pin VDD -reconnect -cells [get_cells $1v_cells -all] -verbose





 source /proj/PS02/WORK/jasons/Block/GAIA/data/1.0v_endcap.lis
 
 derive_pg_connection -power_net VDD1V_MEM -power_pin VDD -reconnect -verbose -cells [get_cells $cells -all]

