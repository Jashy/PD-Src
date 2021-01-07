#!/bin/csh -f

set ECO_STRING  = "ECO_38"
set MDB         = "./MDB_ruby_top"
set ECO_SCRIPTS = "/proj/VISIC/WORK/marshals/ICC/timing_eco_fix_assign/eco_script/eco_38.tcl  /proj/Garnet/WORK/jasonw/PT/STA/20091030/ECO/top.tcl "
set ECO_ROUTE   = 1
set via_opt     = 0
set do_dummy    = 1
set ROUTE_RULE = "./analog_rte.tcl /proj/Garnet/WORK/jimmyx/ASTRO/analog_routing.skip"

set from_mw_lib = "/proj/VISIC/WORK/seanz/ICC_top/1030/MDB_ruby_top"
set from_mw_cel = "ruby_top"
set VNET_LIST  = ""
set FP_DEF     = ""
set VNET_READY = "/proj/Garnet/WORK/jasonw/PT/STA/20091030/ECO/top_eco_ready /proj/VISIC/WORK/seanz/ICC_top/1030/mdb_ready"


set DATE        =  `date +%Y%m%d`
set TCL         =  `pwd`/tcl
set SRC         =  source

if ( "$VNET_READY" != "" ) then
  foreach file ( $VNET_READY )
    while ( ! ( -e ${file} ) )
      echo "Waiting ${file} get ready."
      sleep 1
    end
  end
endif

set path = ( /proj/Garnet/WORK/marshals/bak/icc_sp2/amd64/syn/bin  $path)
mkdir -p LOG


########### eco
cat << EOF > ./.run_eco_${ECO_STRING}.tcl

set DATE $DATE

echo [exec date]
set start [ exec date +%s ]

$SRC -e ./des.tcl

set ECO_STRING  $ECO_STRING

set ECO_SCRIPTS "$ECO_SCRIPTS"

set ECO_ROUTE   $ECO_ROUTE

set via_opt     $via_opt

set ROUTE_RULE "$ROUTE_RULE"

set MDB $MDB

set from_mw_lib "$from_mw_lib"
set from_mw_cel "$from_mw_cel"

set VNET_LIST "$VNET_LIST"
set FP_DEF    "$FP_DEF"

if { \$VNET_LIST != "" } {
  $SRC -e $TCL/rebuild_mdb.tcl
}

$SRC -e $TCL/eco.tcl

echo [exec date]

set end [ exec date +%s ]

puts "*INFO* Totally run [ expr ( \$end - \$start ) / 3600.00 ] Hours "

set ECO_STRING $ECO_STRING

$SRC -e $TCL/gds_out_wo_dummy.tcl

exit

EOF

icc_shell -64  -f ./.run_eco_${ECO_STRING}.tcl | tee ./LOG/run_eco_${ECO_STRING}.tcl.log

######## add filler / dummy / gds out

if ( $do_dummy == 1 ) then

while ( ! ( -e ${ECO_STRING}.ready ) )
  echo "Waiting ${ECO_STRING}.ready get ready."
  sleep 1
end

cat << EOF > ./.run_eco_${ECO_STRING}_dummy.tcl

set DATE $DATE
set ECO_STRING $ECO_STRING

echo [exec date]
set start [ exec date +%s ]

$SRC -e ./des.tcl

if { [ file exists \${MW_LIB}_dummy ] != 1 }
  create_mw_lib -tech \$TECH_FILE \${MW_LIB}_dummy
  set_mw_lib_reference -mw_reference_library \$MW_REF_LIB ./\${MW_LIB}_dummy
}

open_mw_lib \${MW_LIB}_dummy
copy_mw_cel -from_library \${MW_LIB} -from \$MW_CEL -to \$MW_CEL
open_mw_cel \$MW_CEL

$SRC -e /proj/Garnet/WORK/jimmyx/ICC/timing_eco_fix_assign/rg_dmy.tcl

$SRC -e $TCL/add_filler.tcl
$SRC -e $TCL/add_dmy.tcl
save_mw_cel -as ${ECO_STRING}_dummy
save_mw_cel
exec touch  ./${ECO_STRING}_dummy.ready
source /proj/Garnet/WORK/jimmyx/ICC/tcl/add_dmy_area.tcl
$SRC -e $TCL/gds_out.tcl

set end [ exec date +%s ]

verify_lvs -max_error 2000

puts "*INFO* Totally run [ expr ( \$end - \$start ) / 3600.00 ] Hours "


exit

EOF

icc_shell -64  -f ./.run_eco_${ECO_STRING}_dummy.tcl | tee ./LOG/run_eco_${ECO_STRING}_dummy.tcl.log

endif
