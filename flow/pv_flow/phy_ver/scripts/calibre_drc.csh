#!/bin/tcsh
#assuming $PDK_HOME is set properly

source ../calibre_sourceme

calibre -64 -drc -hier -turbo ${CPU_COUNT} -hyper $CALIBRE_DRC_DECK
