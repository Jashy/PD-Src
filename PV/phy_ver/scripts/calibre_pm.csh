#!/bin/tcsh
#assuming $PDK_HOME is set properly

source ../calibre_sourceme
source RUN_LN22FDX_PM

calibre -drc -hier -64 -hyper -turbo ${CPU_COUNT}  ${PM_MAIN_RULE_FILE} | tee ${OUTPUT_DIR}/log_file/${MODULE_NAME}_PM.log
