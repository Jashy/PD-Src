#!/bin/csh
set icc_type = 0707c
set pt_type = focal_opt
mkdir -p $pt_type
sed -e s/focal_size4/$pt_type/g -e s/0707c/$icc_type/g /proj/ARM926EJS/AG11/WORK/carsonl/TEMPLATES/run_pt.sdf.csh > $pt_type/run_pt.sdf.csh
sed -e s/focal_size4/$pt_type/g -e s/0707c/$icc_type/g /proj/ARM926EJS/AG11/WORK/carsonl/TEMPLATES/run_pt.sta.csh > $pt_type/run_pt.sta.csh
