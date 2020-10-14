#fix control, 1--fix ; 0 -- not fix
set fix_tran 0
set fix_setup 0
set fix_hold 1
set opt_leakage 0

#set the thread number, recommend to set the thread number >= scenario number. 
#However the more thread number is setting, the more license is needed. 
#So if you got license shortage isssue, please set it to a smaller number
set thread_number 48


#The keyword is an unique tag for the work space, report dir, eco dir, and the new instance name
set keyword [exec date +%m%d_%H_%M]
puts "the keyword for this run $keyword"
set lib_version lib_C_0.2

set tile_name "scu_fuse_t"

#pd input
set input_dir "/proj1/pd/tiles/feng/tile/eco/20200324/t0/t0_scu_fuse_t"
set verilog_files "${input_dir}/SynPnr/data/${tile_name}.forICE.vg.gz"
set def_files     "${input_dir}/SynPnr/data/${tile_name}.forICE.def.gz"
set sta_data_dir  "${input_dir}/STA/sta_data/"
#set sta_data_dir  "/project/PD/tiles/jiasong/BI/ECO/scu_pvtc_t/xtop/sta_data"


#if scenarios list is empty, xtop will read all the data in the sta_data_dir

set scenarios  {Pt-Func.TT0p85v-tt0p85v85c-typical-85c-Stp-nonSi Pt-Func.SSGNP0p675v-ssgnp0p675v0c-cworst_CCworst-125c-Stp-nonSi Pt-Func.SSGNP0p675v-ssgnp0p675v0c-cworst_CCworst-0c-Hld-Si Pt-Scanshift.FFGNP1p045v-ffgnp1p045v0c-cbest_CCbest-0c-Hld-Si Pt-Scanshift.FFGNP1p045v-ffgnp1p045v0c-cworst_CCworst-0c-Hld-Si Pt-Scanshift.FFGNP1p045v-ffgnp1p045v0c-rcworst_CCworst-0c-Hld-Si Pt-Scanshift.FFGNP1p045v-ffgnp1p045v125c-cbest_CCbest-125c-Hld-Si Pt-Scanshift.FFGNP1p045v-ffgnp1p045v125c-cworst_CCworst-125c-Hld-Si Pt-Scanshift.FFGNP1p045v-ffgnp1p045v125c-rcworst_CCworst-125c-Hld-Si Pt-Scanshift.SSGNP0p675v-ssgnp0p675v0c-cworst_CCworst-0c-Hld-Si Pt-Scanshift.SSGNP0p675v-ssgnp0p675v0c-rcworst_CCworst-0c-Hld-Si Pt-Scanshift.SSGNP0p675v-ssgnp0p675v125c-cworst_CCworst-125c-Hld-Si Pt-Scanshift.SSGNP0p675v-ssgnp0p675v125c-rcworst_CCworst-125c-Hld-Si}

# setup margin when fixing hold
set eco_setup_slack_margin 0.005
# hold margin when fixing setup. At the very beginning of the eco stage, it is allowed to set the hold margin < 0. 
# most of the hold violation caused by setup fixing could be fixed by the subseuential hold fixing
set eco_hold_slack_margin -0.005
#removable filler cells
##set removable_fillers [list DBLVT08_DCAP_* HDBLVT08_DCAP_* HDBLVT08_FILL* HDBULT08_DCAP_* HDBULT08_FILL*]
set removable_fillers []

#candidates buffer/delay cell for hold fix
set eco_buffer_list_for_hold [list \
HDBLVT08_BUF_2 \
HDBSVT08_BUF_2 \
HDBLVT08_BUF_3 \
HDBSVT08_BUF_3 \
HDBLVT08_DEL_R2V1_1  \
HDBLVT08_DEL_R2V1_2  \
HDBLVT08_DEL_R2V2_1  \
HDBLVT08_DEL_R2V2_2  \
HDBLVT08_DEL_R2V3_1  \
HDBLVT08_DEL_R2V3_2  \
HDBLVT08_DEL_R2V4_1  \
HDBLVT08_DEL_R2V5_1  \
HDBLVT08_DEL_L4D20_1 \
HDBLVT08_DEL_L4D20_2 \
HDBLVT08_DEL_L4D20_4 \
HDBLVT08_DEL_L4D20_8 \
HDBLVT08_DEL_L4D225_2 \
HDBLVT08_DEL_L4D25_1 \
HDBLVT08_DEL_L4D25_2 \
HDBLVT08_DEL_L4D25_4 \
HDBLVT08_DEL_L4D25_8 \
HDBLVT08_DEL_L4D30_1 \
HDBLVT08_DEL_L4D30_2 \
HDBLVT08_DEL_L4D30_4 \
HDBLVT08_DEL_L4D30_8 \
HDBLVT08_DEL_L4D35_1 \
HDBLVT08_DEL_L4D35_2 \
HDBLVT08_DEL_L4D35_4 \
HDBLVT08_DEL_L4D35_8 \
HDBLVT08_DEL_L4D45_1 \
HDBLVT08_DEL_L4D45_2 \
HDBLVT08_DEL_L4D45_4 \
HDBLVT08_DEL_L4D45_8 \
HDBLVT08_DEL_L6D50_1 \
HDBLVT08_DEL_L6D50_2 \
HDBLVT08_DEL_L6D50_4 \
HDBLVT08_DEL_L6D50_8 \
HDBLVT08_DEL_L6D60_1 \
HDBLVT08_DEL_L6D60_2 \
HDBLVT08_DEL_L6D60_4 \
HDBLVT08_DEL_L6D60_8 \
]

#setup buffer
set eco_buffer_list_for_setup [list \
HDBLVT08_BUF_4 \
HDBLVT08_BUF_6 \
HDBLVT08_BUF_8 \
HDBLVT08_BUF_10 \
HDBLVT08_BUF_12 \
HDBLVT08_BUF_14 \
]

proc find_necssary_lib {all_libs pt_link_path} {
  set f [open $pt_link_path r] 
  set necessary_libs {}
  while {[gets $f line]>=0} {
    set db_name [file root [file tail $line]]
    set lib [lsearch -all -inline -regex $all_libs $db_name]
    if {[llength $lib]==0} {
       if {[file exist /proj/library/BI/$lib_version/rams/timing/$db_name.lib]} {
         lappend necessary_libs /proj/library/BI/$lib_version//rams/timing/$db_name.lib
       } elseif {[file exist /proj/library/BI/$lib_version//rom/timing/$db_name.lib]} {
         lappend necessary_libs /proj/library/BI/$lib_version//rom/timing/$db_name.lib
       } elseif {[file exist /proj/library/BI/$lib_version//ctip/timing/$db_name.lib]} {
         lappend necessary_libs /proj/library/BI/$lib_version//ctip/timing/$db_name.lib
       } else {
         puts "ERROR, can not find corresbonding lib for $line"
       }
    }
    foreach l $lib {
      set lib_name [file rootname [file rootname [file tail $l]]]
      set idb [glob -nocomp /project/PD/signoff/fct/fullchip_timing/BI/XTOP_TRAIL/liuqingli/idb/stdcel/timing_lvf/$lib_name.idb]
      if {[llength $idb] > 0 } {
        lappend necessary_libs $idb
      } else {
        lappend necessary_libs $l
      }
    }
  }
  return $necessary_libs
}

