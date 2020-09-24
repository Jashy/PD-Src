#!/bin/tcsh
# assuming $PDK_HOME is set properly
# assuming $BEOL_STACK is set properly
# example: setenv BEOL_STACK 8U1x_2T16x_LB

source ../calibre_sourceme
#calibre -64 -spice $LAYOUT_PRIMARY.extracted.net -automatch -lvs $CALIBRE_LVS_DECK -hier -hcell $HCELL_LIST 

## The -turbo and -hype requires more licenses
#calibre -64 -turbo ${CPU_COUNT} -hyper -spice $LAYOUT_PRIMARY.extracted.net -automatch -lvs ../scripts/lvs.inc.tvf -hier -hcell $HCELL_LIST 
calibre -64 -turbo ${CPU_COUNT} -hyper -spice $LAYOUT_PRIMARY.extracted.net -lvs ../scripts/lvs.inc.tvf -hier  -hcell $HCELL_LIST 
