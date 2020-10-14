#!/bin/csh -f

# ;***************************************************************************************************
# ;* Calibre Version    : v2014.4_18.13
# ;* FILE Name     : RUN_LN14LPP_PM
# ;* FILE UPDATE    : 2015. 07. 17 (released by Jeon junsu)
# ;***************************************************************************************************

# --------------------------------------------------------------------------------
#   user setting value : You have to fill out these variables for stand-alone mode
# --------------------------------------------------------------------------------

setenv TECHDIR  "/proj/BTC/LIB_NEW/TechFile/EDA_Techfile/mentor/CalibrePM/PM"              ;# Specifies the path of standard run set
setenv PROJECT_NAME    "BTC"                                                               ;# Specifies the title name
setenv LAYOUT_SYSTEM   "GDSII"                                                             ;# GDSII, OASIS
setenv LAYOUT_PATH     "../icv/MERGED_OUTPUT/LKB11_DummyMerge.gds"   ;# Specifies the path and gds name of the layout design file
setenv BEOL_STACK      "8M_3Mx_4Cx_1Gx_LB"                                            ;# 9M_3Mx_4Cx_2Gx_LB, 9M_3Mx_2Cx_2Kx_2Gx_LB, 11M_3Mx_4Cx_2Kx_2Gx_LB, 10M_5Mx_3Cx_2Gx_LB, 9M_3Mx_5Cx_1Gx_LB, 10M_3Mx_4Cx_2Kx_1Gx_LB, , 8M_3Mx_4Cx_1Gx_LB
setenv LAYOUT_PRIMARY  "LKB11"                                                               ;# Top cell name
setenv OUTPUT_DIR       `pwd`                                ;# Specifies the path of output results.
setenv SKIP_CELL       ''                                                                  ;# Specifies the name of hard macro that do not need to be inspected. Do not use skip cell for Sign-off
setenv  RUN_METHOD      "LOCAL"                                                            ;# For running inside SEC set to "LSF" / For running at customer set to "LOCAL"
setenv  CPU_COUNT       "16"                                                                ;# Specifies the cpu count for job


setenv  PM_MAIN_RULE_FILE $TECHDIR/Include/LN14LPP_PM_MAIN.tvf
setenv  PM_LAYERS_MAPPING_FILE   $TECHDIR/Include/14LPP_Layermap.svrf
setenv  PM_LIBRARY_FILE1      $TECHDIR/Include/Library/PM.CA.C.1.svrf
setenv  PM_LIBRARY_FILE2      $TECHDIR/Include/Library/PM.Cx.C.1.svrf
setenv  PM_LIBRARY_FILE3      $TECHDIR/Include/Library/PM.Cx.C.2.svrf
setenv  PM_LIBRARY_FILE4      $TECHDIR/Include/Library/PM.Cx.C.3.svrf
setenv  PM_LIBRARY_FILE5      $TECHDIR/Include/Library/PM.Cx.C.4.svrf
setenv  PM_LIBRARY_FILE6      $TECHDIR/Include/Library/PM.Cx.C.5.svrf
setenv  PM_LIBRARY_FILE7      $TECHDIR/Include/Library/PM.Cx.C.6.svrf
setenv  PM_LIBRARY_FILE8      $TECHDIR/Include/Library/PM.Cx.C.7.svrf
setenv  PM_LIBRARY_FILE9      $TECHDIR/Include/Library/PM.Cx.C.8.svrf
setenv  PM_LIBRARY_FILE10     $TECHDIR/Include/Library/PM.Cx.C.9.svrf
setenv  PM_LIBRARY_FILE11     $TECHDIR/Include/Library/PM.Cx.C.10.svrf
setenv  PM_LIBRARY_FILE12     $TECHDIR/Include/Library/PM.Cx.C.11.svrf
setenv  PM_LIBRARY_FILE13     $TECHDIR/Include/Library/PM.Cx.C.12.svrf
setenv  PM_LIBRARY_FILE14     $TECHDIR/Include/Library/PM.Cx.C.13.svrf
setenv  PM_LIBRARY_FILE15     $TECHDIR/Include/Library/PM.Cx.C.14.svrf
setenv  PM_LIBRARY_FILE16     $TECHDIR/Include/Library/PM.Cx.C.15.svrf
setenv  PM_LIBRARY_FILE17     $TECHDIR/Include/Library/PM.Cx.C.16.svrf
setenv  PM_LIBRARY_FILE18     $TECHDIR/Include/Library/PM.Cx.C.17.svrf
setenv  PM_LIBRARY_FILE19     $TECHDIR/Include/Library/PM.Cx.C.18.svrf
setenv  PM_LIBRARY_FILE20     $TECHDIR/Include/Library/PM.Cx.C.19.svrf
setenv  PM_LIBRARY_FILE21     $TECHDIR/Include/Library/PM.Cx.C.20.svrf
setenv  PM_LIBRARY_FILE22     $TECHDIR/Include/Library/PM.Cx.C.21.svrf
setenv  PM_LIBRARY_FILE23     $TECHDIR/Include/Library/PM.Cx.C.22.svrf
setenv  PM_LIBRARY_FILE24     $TECHDIR/Include/Library/PM.Cx.C.23.svrf
setenv  PM_LIBRARY_FILE25      $TECHDIR/Include/Library/PM.Cx.lv2.svrf
setenv  PM_LIBRARY_FILE26      $TECHDIR/Include/Library/PM.Mx.C.3_Mx.svrf
setenv  PM_LIBRARY_FILE27      $TECHDIR/Include/Library/PM.Mx.C.4_Mx.svrf
setenv  PM_LIBRARY_FILE28      $TECHDIR/Include/Library/PM.V0.EX.M1.1.svrf
setenv  PM_LIBRARY_FILE29      $TECHDIR/Include/Library/PM.V0.EX.M1.2.svrf
setenv  PM_LIBRARY_FILE30      $TECHDIR/Include/Library/PM.V0.EX.M1.3.svrf
setenv  PM_LIBRARY_FILE31      $TECHDIR/Include/Library/PM.VIA.EX.Cx.1.svrf

setenv  RDB_DIR_PM         ${OUTPUT_DIR}/rdb/${PROJECT_NAME}
setenv  OUTPUT_DB_PM       ${RDB_DIR_PM}/${PROJECT_NAME}_PM.db
setenv  OUTPUT_RDB_PM      ${RDB_DIR_PM}/${PROJECT_NAME}_PM.rdb
setenv  OUTPUT_RDB_PM_lv2  ${RDB_DIR_PM}/${PROJECT_NAME}_PM_LV2.rdb
setenv  OUTPUT_RDB_PM_ALL  ${RDB_DIR_PM}/${PROJECT_NAME}_PM_ALL.rdb
setenv  OUTPUT_SUM_PM      ${RDB_DIR_PM}/${PROJECT_NAME}_PM.sum

mkdir -p  ${RDB_DIR_PM} ${OUTPUT_DIR}/log_file

#===============================================================================
#> PM :: PM Execution
#===============================================================================

if ($RUN_METHOD == LSF) then
    # for LSF run in SEC site
 calibredfm_sub drc -v 2014.4_18.13  -cpu  ${CPU_COUNT} -i ${PM_MAIN_RULE_FILE} -nonIs
else if ($RUN_METHOD == LOCAL) then
 #for local run  : You have to fill out these variables for stand-alone mode
    source /filer/home/jasons/cal_2015.lic
    calibre -drc -hier -64 -hyper -turbo ${CPU_COUNT}  ${PM_MAIN_RULE_FILE} | tee ${OUTPUT_DIR}/log_file/hce_PM.log
else
    echo 'ERROR: Please set the variable "RUN_METHOD" to "LSF" or "LOCAL"'
endif
endif

