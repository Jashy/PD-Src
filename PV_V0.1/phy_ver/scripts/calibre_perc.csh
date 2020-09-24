#!/usr/bin/csh

source ../calibre_sourceme
source ./run_perc

echo ${netlist_data}
/tool/eda/apps/mentorCalibre/2017.3_29.23/aoi_cal_2017.3_29.23/bin/calibre -turbo ${CPU_COUNT} -perc -hier -auto $CONTROL_FILE | tee $outputdir/${top_level_cell_name}.perc.runlog
