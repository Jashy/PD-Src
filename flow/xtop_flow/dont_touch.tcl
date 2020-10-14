set_dont_touch [get_cells -hier *d0nt*]
set feedthrough_cell  [get_cells -hier *FEED_ONROUTE_BUF_* -quiet]
set_dont_touch [get_pins -of $feedthrough_cell]
set boundary_cell [get_cells -hier *BOUNDARY* -quiet]
set_dont_touch [get_pins -of $boundary_cell]
set_dont_touch [get_io_path_pins]


redirect -variable hier_path_name {set codec_hier [get_cells -hierarchical  *compressor_*Compression -quiet]}
if {[sizeof_collection $codec_hier] > 0} {
  #regsub -all ", " $hier_path_name " " hier_path_name
  #set_hier_path_dont_touch $hier_path_name
  set pins [get_pins -of_objects  $codec_hier -quiet]
  set nets [get_nets -of $pins -quiet]
  if {[sizeof_collection $nets] > 0} {
    set_dont_touch $nets
  }
}


### dont use hs/pmk/hvt/svt/lvt_c11/ulvt ###
set_dont_use {HSB*}
set_dont_use {HDP*}
set_dont_use {HD*HVT08_*}
set_dont_use {HD*HVT11_*}
#set_dont_use {HD*SVT08_*}
#set_dont_use {HD*SVT11_*}
#set_dont_use {HD*LVT11_*}
#set_dont_use {HD*ULT08_*}
#set_dont_use {HD*ULT11_*}

### dff ###
set_dont_use {*_FD*_V2MY2_*}
set_dont_use {*_FSD*_V2MY2_*}
set_dont_use {*QB_*}
set_dont_use {*QBO_*}
set_dont_use {*QO_*}
set_dont_use {*QM2*}
set_dont_use {*QM4*}
set_dont_use {*QM4SS*}
set_dont_use {*QM8*}
set_dont_use {*QOM4SS*}
set_dont_use {*QOM2*}
set_dont_use {*QOM4*}
set_dont_use {*QOM8*}
set_dont_use {*FSDPQBM4SS_*}
set_dont_use {*LP*}
set_dont_use {*_F4Y4_*}
set_dont_use {*_CBF4Y4_*}
set_dont_use {*_PPF4Y4_*}
set_dont_use {*_F4Y8_*}
set_dont_use {*_F4Y16_*}
set_dont_use {*_F4Y16FS_*}
set_dont_use {*_F4SU*}
set_dont_use {*_CBF4SU*}
set_dont_use {*_V2FSU*}
set_dont_use {*_V2FY2_*}
set_dont_use {*_CBV2FSU*}
set_dont_use {*_PPV2FSU*}
set_dont_use {*_PPV2FY2_*}
set_dont_use {*_V2PLBY2_*}

### physical cell ###
set_dont_use {*_TIE*}
set_dont_use {*_CAP*}
set_dont_use {*_DCAP*}
set_dont_use {*_TAP*}
set_dont_use {*_FILL*}
set_dont_use {*_V7_*}

### delay cell ###
set_dont_use {*_DEL*}

### symmetric/cts cell ###
set_dont_use {*_MM*}
set_dont_use {*_CBMM*}
set_dont_use {*_V2MMY2_*}
set_dont_use {*_CK_*}
set_dont_use {*_CKST_*}
set_dont_use {*_CKY*}
set_dont_use {*_CKV*}
set_dont_use {*_RCK_*}
set_dont_use {*_S_*}
set_dont_use {*_CBS_*}
set_dont_use {*_SY2_*}
set_dont_use {*_SY4*}
set_dont_use {*_SY8*}
set_dont_use {*_SYPY2_*}
set_dont_use {*_SDY2_*}
set_dont_use {*_SM_*}
set_dont_use {*_SMY2_*}
set_dont_use {*_SMP_*}
set_dont_use {*_SD_*}
set_dont_use {*_CBV7Y2_*}
set_dont_use {*_V8Y2_*}

### eco cell ###
set_dont_use {*ECO*}

### large/small stength cell ###
set_dont_use {*_0P5}
set_dont_use {*_9}
set_dont_use {*_10}
set_dont_use {*_12}
set_dont_use {*_14}
set_dont_use {*_15}
set_dont_use {*_16}
set_dont_use {*_18}
set_dont_use {*_20}
set_dont_use {*_24}
set_dont_use {*_32}
set_dont_use {*_48}
set_dont_use {*_64}
set_dont_use {*_96}
set_dont_use {*_128}

### multi height ###
set_dont_use {*Y8*}

### latch ###
set_dont_use {*_LD*}

###
set_dont_use {*CDC*}
set_dont_use {*_T_*}
set_dont_use {*_TY2_*}
set_dont_use {*_CBT_*}

### legalize critical cell ###
set_dont_use {HDBLVT08_FD2PQB_MSY3_2}
set_dont_use {HDBLVT08_FDPQM2_V2Y2_4}
set_dont_use {HDBLVT08_FDPRBQM4_V2Y4_2}
set_dont_use {HDBLVT08_FSDPQOM4SS_F4Y8_1}
set_dont_use {HDBLVT08_FSDPQOM4SS_F4Y8_2}
set_dont_use {HDBLVT08_FSDPQOM8SS_F4Y16FS_4}
set_dont_use {HDBLVT08_FSDPQOM8SS_F4Y16_4}
set_dont_use {HDBLVT08_FSDPRBQM2_V2PLBY4_1}
set_dont_use {HDBLVT08_FSDPRBQM4_V2PLBY6_1}
set_dont_use {HDBLVT08_FSDPRBQO_V2FY2_4}
set_dont_use {HDBLVT08_FSDPRBQO_V2MY2_1}
set_dont_use {HDBLVT08_FSDPRBQO_V2MY2_2}
set_dont_use {HDBLVT08_FSDPRBQO_V2SU2Y2_1}
set_dont_use {HDBLVT08_FSDPRBSBQO_V2MY2_1}
set_dont_use {HDBLVT08_FDPQ_V2Y4ECO_1}
set_dont_use {HDBLVT08_FSDNRBQO_Y2_2}
set_dont_use {HDBLVT08_FSDNRBSBQO_Y2_2}
set_dont_use {HDBLVT08_FSDPHBQ_V2Y2_1}
set_dont_use {HDBLVT08_FSDPMQ_V2Y2_1}
set_dont_use {HDBLVT08_FSDPQO_CBY2_6}
set_dont_use {HDBLVT08_FSDPQO_Y2_6}
set_dont_use {HDBLVT08_MUX4_V3Y2_4}


### from reference flow
#####################################################################################################
##  2018/04/23 Preliminary release
##  2018/05/04 Remove below command for TIE cell is not set to dont use in library 
##				remove_attribute [get_lib_cell */TIE*] dont_use	
#####################################################################################################
#set_dont_use [get_lib_cells */DEL*]}
#set_dont_use [get_lib_cells */DCCK*]}
#set_dont_use [get_lib_cells */CK*]}
#set_dont_use [get_lib_cells */G*]}
#set_dont_use [get_lib_cells */*D18*]}
#set_dont_use [get_lib_cells */*D20*]}
#set_dont_use [get_lib_cells */*D24*]}
#set_dont_use [get_lib_cells */*D24*]}
#set_dont_use [get_lib_cells */*D32*]}
#set_dont_use [get_lib_cells */*FLIP*]}
#remove_attribute [get_lib_cell */TIE*] dont_use

### added on 20190530 from Don's suggestion
set_dont_use {HDBLVT08_FD2PQB_MSY3_2       }
set_dont_use {HDBLVT08_FDPQM2_V2Y2_4       }
set_dont_use {HDBLVT08_FDPRBQM4_V2Y4_2     }
set_dont_use {HDBLVT08_FSDPQOM4SS_F4Y8_1   }
set_dont_use {HDBLVT08_FSDPQOM8SS_F4Y16FS_4}
set_dont_use {HDBLVT08_FSDPQOM8SS_F4Y16_4  }
set_dont_use {HDBLVT08_FSDPRBQM2_V2PLBY4_1 }
set_dont_use {HDBLVT08_FSDPRBQM4_V2PLBY6_1 }
set_dont_use {HDBLVT08_FSDPRBQO_V2FY2_4    }
set_dont_use {HDBLVT08_FSDPRBQO_V2MY2_1    }
set_dont_use {HDBLVT08_FSDPRBQO_V2MY2_2    }
set_dont_use {HDBLVT08_FSDPRBQO_V2SU2Y2_1  }
set_dont_use {HDBLVT08_FSDPRBSBQO_V2MY2_1  }
set_dont_use {HDBLVT08_FDPQ_V2Y4ECO_1      }
set_dont_use {HDBLVT08_FSDNRBQO_Y2_2       }
set_dont_use {HDBLVT08_FSDNRBSBQO_Y2_2     }
set_dont_use {HDBLVT08_FSDPHBQ_V2Y2_1      }
set_dont_use {HDBLVT08_FSDPMQ_V2Y2_1       }
set_dont_use {HDBLVT08_FSDPQO_CBY2_6       }
set_dont_use {HDBLVT08_FSDPQO_Y2_6         }
set_dont_use {HDBLVT08_MUX4_V3Y2_4         }

