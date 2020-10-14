#!/bin/csh -f

source /filer/home/jasons/.cshrc
source /filer/home/jasons/cal_2014.lic
set mydate	= `date +%m-%d`

set gds       = ../merge/LKB11.gds.gz
set ready     = ../merge/gds.ready
set block     = LKB11
set rule_dir  = /proj/BTC/WORK/jasons/Techfile/DRC
set rule      = cmos14_config.drc.cal

source ./sourceme.14lpp

#echo LAYOUT ERROR ON INPUT NO >> ${block}_${rule}.run
cat ${rule_dir}/${rule} \
	| sed "s#TOPCELLNAME#${block}#g" \
	| sed "s#GDSFILENAME#${gds}#g" \
>  ${block}_${rule}.run
#echo "DRC ICSTATION YES " >> ${block}_${rule}.run
#echo "DRC MAXIMUM VERTEX ALL " >> ${block}_${rule}.run


#-#-echo "GROUP PART_CHECK  M? VIA? LUP?" >> ${block}_${rule}.run
#-#-echo "DRC SELECT CHECK PART_CHECK" >> ${block}_${rule}.run
#-#-echo "GROUP UNCHECK  ESD? IND?  " >> ${block}_${rule}.run
#-#-echo "DRC UNSELECT CHECK  UNCHECK  " >> ${block}_${rule}.run


while(!(-e $ready))
echo "waiting $ready "
sleep 100
end

echo `date` > runtime
calibre  -64 -drc -hier -turbo 32 ${block}_${rule}.run | tee ${block}_calibre.log

echo `date` >> runtime

## /proj/Aurora/WORK/arckeonw/ICC/template/getR90db.pl DRC_RES.db icc.db
grep -v "NOT EXECUTED" DRC.rep | grep -v "TOTAL Result Count = 0"> final.rpt
#touch drc.ready
