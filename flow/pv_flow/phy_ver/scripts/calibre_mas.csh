#!/bin/tcsh
#assuming $PDK_HOME is set properly

source ../calibre_sourceme

ln -s ../design_data/include/hcells.list hcell.list
ln -s ../design_data/include/mas_excludecells.txt excludecells.txt

$PDK_HOME/DFM/MAS/Calibre/mas_run $LAYOUT_PATH
