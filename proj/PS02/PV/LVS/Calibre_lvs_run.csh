#!/bin/csh -f


source ./common_setting.csh
source $lic_global
source /proj/PS02/RELEASE/PV/PV_RULE_rev05/source_lvs

set ready = "../Merge/oa_ready"
while ( !( -e ${ready} ) )
  echo "Wating ${ready} get ready."
  sleep 30
end
set ready2 = "../source/spi_ready"

while ( !( -e ${ready2} ) )
  echo "Wating ${ready2} get ready."
  sleep 30
end


rm -rf *run svdb
rm -rf runtime

cat <<CONTROL >  ${TOP}_lvs.run
#!tvf

namespace import tvf::*

#Setup as mini TVF rule file that calls main deck

VERBATIM {

LAYOUT ERROR ON INPUT NO
//EXCLUDE CELL ESDCLAMP11V

LAYOUT PRIMARY "${TOP}"
LAYOUT PATH    "../Merge/GAIA_oa.gds.gz"
LAYOUT SYSTEM GDSII
//LAYOUT SYSTEM SPICE

SOURCE PRIMARY "${TOP}"
SOURCE PATH    "../source/GAIA_lvs_pg.spi"
SOURCE SYSTEM SPICE
LVS ISOLATE SHORTS YES  //<LVS_REPORT>.shorts
LVS REPORT OPTION  S V R F
LVS REPORT "${TOP}.lvs.rep"

LVS REPORT MAXIMUM 2000

LVS EXECUTE ERC YES
ERC RESULTS DATABASE "${TOP}.erc.location" ASCII
ERC SUMMARY REPORT   "${TOP}.erc.rep"
ERC MAXIMUM RESULTS ALL
ERC MAXIMUM VERTEX ALL
LVS REPORT OPTION S

DRC ICSTATION YES
//LAYOUT TEXT VDD_PD24  2.6 1809  31 20 GAIA
//LAYOUT TEXT VDD1V 2.541 2.923 137 20
//LAYOUT TEXT DITX_ESD_VSS 63.452 1.372 137 20
}
source "${calibre_lvs_rule}"
source "./bbox"
CONTROL

date > runtime
calibre  -lvs -hier -turbo 100 \
         -spice ${TOP}.layout.spice \
         -hcell ${calibre_lvs_hcell} \
         -64 ${TOP}_lvs.run | tee ${TOP}.lvs.log

grep    "^Warning" ${TOP}.lvs.rep > ${TOP}.lvs.rep.warn
grep -v "^Warning" ${TOP}.lvs.rep > ${TOP}.lvs.rep.sum

date >> runtime
