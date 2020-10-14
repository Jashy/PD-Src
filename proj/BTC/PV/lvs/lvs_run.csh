#!/bin/csh -f
source ~/cal_2014.lic

set gds       =  ../icv/MERGED_OUTPUT/LKB11_DummyMerge.gds
set sch       =  ../lvs/source/LKB11_top_09-09.spi
set ready     =  ;

set gds_cell  = LKB11 ;#final gds primary cell
set sch_cell  = LKB11 ;#spice primary cell 
set block     = LKB11 ;#block top

set rule_dir  = /proj/BTC/LIB_NEW/TechFile/EDA_Techfile/mentor/CalibreLVS/LVS
set rule      = ln14lpp.lvs.cal

set text_layout	= /DELL/proj/BTC/WORK/dongleia/ICC/text/150909_BTC_layout.text;
set hcell	= /proj/BTC/WORK/jasons/Techfile/hcell;

source ./sourceme_asic

rm -rf *run svdb
rm -rf runtime

cat <<CONTROL >  ${block}_${rule}.run
#!tvf

tvf::VERBATIM {

LAYOUT PRIMARY "${gds_cell}"
LAYOUT PATH "${gds}"
LAYOUT SYSTEM GDSII
//LAYOUT SYSTEM SPICE

SOURCE PRIMARY "${sch_cell}"
SOURCE PATH "${sch}"
SOURCE SYSTEM SPICE

LVS REPORT "${block}.lvs.err"

LVS REPORT OPTION S
DRC ICSTATION YES

INCLUDE "${text_layout}"
}
CONTROL

cat ${rule_dir}/${rule}  >>./${block}_${rule}.run

#while(!(-e $ready))
#echo "waiting $ready "
#sleep 100
#end

echo `date` > runtime

calibre  -lvs \
         -hier \
         -hyper \
         -hcell $hcell \
	 -spice ${block}.layout.spice \
	 -turbo 32 \
         -64 ${block}_${rule}.run | tee ${block}_calibre.log

echo `date` >> runtime
