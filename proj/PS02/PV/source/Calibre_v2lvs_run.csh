#!/bin/csh -f


source ./common_setting.csh
source /proj/PS02/RELEASE/PV/PV_RULE_rev05/source_lvs
source $lic_global

set ready = "../Merge/oa_ready"
while ( !( -e ${ready} ) )
  echo "Wating ${ready} get ready."
  sleep 30
end


if ( "$TOP" =~ "*GEVB" ) then 
./ast_change_netlist.pl \
${icc_pg_netlist} ${lvs_pg_netlist}
else if  ( "$TOP" =~ "*_VOU_*" )  then
./ast_change_netlist.pl \
${icc_pg_netlist} ${lvs_pg_netlist}
else if  ( "$TOP" =~ "*JPU" )  then
./ast_change_netlist.pl \
${icc_pg_netlist} ${lvs_pg_netlist}
else if  ( "$TOP" =~ "*ADU" )  then
./ast_change_netlist.pl \
${icc_pg_netlist} ${lvs_pg_netlist}
else if  ( "$TOP" =~ "*LCU" )  then
./ast_change_netlist.pl \
${icc_pg_netlist} ${lvs_pg_netlist}
else
./change_netlist.pl \
${icc_pg_netlist} ${lvs_pg_netlist}
endif


v2lvs  \
-w o \
-v ${lvs_pg_netlist} \
-s /proj/PS02/LIB/CURRENT/DK_PS02/lib/OPUS_tech_rev02/oa/cmos28lp/.resources/devices.cdl \
-s /proj/PS02/LIB/20150116/DK_PS02/lib/CDL/6_CIR/cdl_20160201a.lib \
-o ${lvs_pg_spice}

eval "sed -i 's?.GLOBAL VDD??'    ./${lvs_pg_spice}" 
eval "sed -i 's?.GLOBAL VDD1V_MEM??'    ./${lvs_pg_spice}" 
eval "sed -i 's?.GLOBAL VSS??'    ./${lvs_pg_spice}" 

touch spi_ready
