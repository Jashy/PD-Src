#!/bin/csh -f

set path=($path /apps/synopsys/fm_vJ-2014.09-SP2/bin )
source /apps/setenv_license.csh

rm -r FM_WORK* *.lck *.log
mkdir LOG -p

fm_shell -file FM_run.tcl | tee ./LOG/run_fm.log
