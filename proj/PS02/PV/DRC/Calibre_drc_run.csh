#!/bin/csh -f

source ./common_setting.csh
source /proj/PS02/RELEASE/PV/PV_RULE_rev05/source_drc
source $lic_global

set ready_file  = ../Merge/oa_ready
while ( !( -e ${ready_file} ) )
 echo "Wating ${ready_file} get ready."
 sleep 30
 end

echo `date` > runtime

setenv LAYOUT_PATH    "../Merge/GAIA_oa.gds.gz"

cat <<CONTROL > ${TOP}_drc.run

LAYOUT ERROR ON INPUT NO

//LAYOUT PATH    "../merge/${TOP}_oa.gds.gz"
LAYOUT PRIMARY "${TOP}"

DRC RESULTS DATABASE "${TOP}.err.location"
DRC SUMMARY REPORT   "${TOP}.drc.rep"

DRC ICSTATION YES

INCLUDE "$calibre_drc_rule"

CONTROL

calibre -64 -drc -hier -hyper -turbo 100 ${TOP}_drc.run | tee ${TOP}_drc.log

grep -v "NOT EXECUTED" ${TOP}.drc.rep \
     | grep -v "TOTAL Result Count = 0"> ${TOP}.drc.rep.sum

grep -v "\.DN\." ${TOP}.drc.rep.sum > ${TOP}.drc.rep.sum2
