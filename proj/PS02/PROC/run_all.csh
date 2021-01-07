#!/bin/csh -f

set DATE    =  1006
set TCL     =  ../tcl
set SRC     =  source
set SESSION = `date +%m.%d_%H:%M`

set crt_design = 0
set place_opt  = 1
set route      = 1
set route_opt  = 1

mkdir -p LOG
if ( $crt_design == 1 ) then
## Create Design
echo "set DATE $DATE" 		       	>   ./.crt_design.tcl
echo "echo [exec date]" 		>>  ./.crt_design.tcl
echo "$SRC -e ./design_settings.tcl"    >>  ./.crt_design.tcl
echo "$SRC -e $TCL/create_mdb.tcl" 	>>  ./.crt_design.tcl
echo "$SRC -e $TCL/read_design.tcl" 	>>  ./.crt_design.tcl
echo "$SRC -e $TCL/read_fp.tcl" 	>>  ./.crt_design.tcl
echo "echo [exec date]" 		>>  ./.crt_design.tcl
echo "exit"				>>  ./.crt_design.tcl

icc_shell -64  -f ./.crt_design.tcl | tee ./LOG/ICC_CRT_DESIGN_${SESSION}.log
if $status exit
endif

if ( $place_opt == 1 ) then
## place_opt
set SESSION = `date +%m.%d_%H:%M`
echo "set DATE $DATE" 			>   ./.place_opt.tcl
echo "echo [exec date]" 		>>  ./.place_opt.tcl
echo "$SRC -e ./design_settings.tcl"    >>  ./.place_opt.tcl
echo "$SRC -e $TCL/open.tcl"	 	>>  ./.place_opt.tcl
echo "$SRC -e $TCL/place_opt.tcl" 	>>  ./.place_opt.tcl
echo "echo [exec date]" 		>>  ./.place_opt.tcl
echo "exit"				>>  ./.place_opt.tcl

icc_shell -64  -f ./.place_opt.tcl | tee ./LOG/ICC_PLACE_OPT_${SESSION}.log
if $status exit
endif

if ( $route == 1 ) then
## route
set SESSION = `date +%m.%d_%H:%M`
echo "set DATE $DATE" 			>   ./.route.tcl
echo "echo [exec date]" 		>>  ./.route.tcl
echo "$SRC -e ./design_settings.tcl"    >>  ./.route.tcl
echo "$SRC -e $TCL/open.tcl"	 	>>  ./.route.tcl
echo "$SRC -e $TCL/route.tcl" 		>>  ./.route.tcl
echo "echo [exec date]" 		>>  ./.route.tcl
echo "exit"				>>  ./.route.tcl

icc_shell -64  -f ./.route.tcl | tee ./LOG/ICC_ROUTE_${SESSION}.log
endif

if ( $route_opt == 1 ) then
## route_opt
set SESSION = `date +%m.%d_%H:%M`
echo "set DATE $DATE" 			>   ./.route_opt.tcl
echo "echo [exec date]" 		>>  ./.route_opt.tcl
echo "$SRC -e ./design_settings.tcl"    >>  ./.route_opt.tcl
echo "$SRC -e $TCL/open.tcl"	 	>>  ./.route_opt.tcl
echo "$SRC -e $TCL/route_opt.tcl" 	>>  ./.route_opt.tcl
echo "echo [exec date]" 		>>  ./.route_opt.tcl
echo "exit"				>>  ./.route_opt.tcl

icc_shell -64  -f ./.route_opt.tcl | tee ./LOG/ICC_ROUTE_OPT_${SESSION}.log
