#-#-  set RVT_LIBs "\
#-#-          /proj/BTC/LIB/SC/sc9mcpp84_base_rvt_c14/arm/samsung/ln14lpp/sc9mcpp84_base_rvt_c14/r3p2/milkyway/9M_3Mx_4Cx_2Gx_LB/sc9mcpp84_ln14lpp_base_rvt_c14 \
#-#-          /proj/BTC/LIB/SC/sc9mcpp84_base_rvt_c16/arm/samsung/ln14lpp/sc9mcpp84_base_rvt_c16/r3p2/milkyway/9M_3Mx_4Cx_2Gx_LB/sc9mcpp84_ln14lpp_base_rvt_c16 \
#-#-          /proj/BTC/LIB/SC/HPK/sc9mcpp84_hpk_rvt_c14/arm/samsung/ln14lpp/sc9mcpp84_hpk_rvt_c14/r3p0/milkyway/9M_3Mx_4Cx_2Gx_LB/sc9mcpp84_ln14lpp_hpk_rvt_c14 \
#-#-          /proj/BTC/LIB/SC/HPK/sc9mcpp84_hpk_rvt_c16/arm/samsung/ln14lpp/sc9mcpp84_hpk_rvt_c16/r3p0/milkyway/9M_3Mx_4Cx_2Gx_LB/sc9mcpp84_ln14lpp_hpk_rvt_c16 \
#-#-  	/proj/BTC/LIB/SC/ECO/sc9mcpp84/arm/samsung/ln14lpp/sc9mcpp84_eco_rvt_c14/r3p0/milkyway/9M_3Mx_4Cx_2Gx_LB/sc9mcpp84_ln14lpp_eco_rvt_c14 \
#-#-          "
#-#-  set RVT_SPARE "FILLECOSGCAP22_A9PP84TR_C14 FILLECOSGCAP11_A9PP84TR_C14"
#-#-  set LVT_LIBs "\
#-#-          /proj/BTC/LIB/SC/sc9mcpp84_base_lvt_c14/arm/samsung/ln14lpp/sc9mcpp84_base_lvt_c14/r3p2/milkyway/9M_3Mx_4Cx_2Gx_LB/sc9mcpp84_ln14lpp_base_lvt_c14 \
#-#-          /proj/BTC/LIB/SC/HPK/sc9mcpp84_hpk_lvt_c14/arm/samsung/ln14lpp/sc9mcpp84_hpk_lvt_c14/r3p0/milkyway/9M_3Mx_4Cx_2Gx_LB/sc9mcpp84_ln14lpp_hpk_lvt_c14 \
#-#-          /proj/BTC/LIB/SC/sc9mcpp84_base_lvt_c16/arm/samsung/ln14lpp/sc9mcpp84_base_lvt_c16/r3p2/milkyway/9M_3Mx_4Cx_2Gx_LB/sc9mcpp84_ln14lpp_base_lvt_c16 \
#-#-          /proj/BTC/LIB/SC/HPK/sc9mcpp84_hpk_lvt_c16/arm/samsung/ln14lpp/sc9mcpp84_hpk_lvt_c16/r3p0/milkyway/9M_3Mx_4Cx_2Gx_LB/sc9mcpp84_ln14lpp_hpk_lvt_c16 \
#-#-  	/proj/BTC/LIB/SC/Supplemental_cell_kits/SC9MCPP84_C14_PMK_YO_LVT/arm/samsung/ln14lpp/sc9mcpp84_pmkyo_lvt_c14/r1p0/milkyway/9M_3Mx_4Cx_2Gx_LB/sc9mcpp84_ln14lpp_pmkyo_lvt_c14 \
#-#-          "
#-#-  foreach RVT_LIB $RVT_LIBs { set_cell_vt_type -library $RVT_LIB -vt_type RVT_TYPE }
#-#-  foreach LVT_LIB $LVT_LIBs { set_cell_vt_type -library $LVT_LIB -vt_type LVT_TYPE }
#-#-  
#-#-  set_vt_filler_rule -threshold_voltage {RVT_TYPE} -lib_cell $RVT_SPARE
#-#-  set_vt_filler_rule -threshold_voltage {LVT_TYPE} -lib_cell $RVT_SPARE
#-#-  set_vt_filler_rule -threshold_voltage {RVT_TYPE RVT_TYPE} -lib_cell $RVT_SPARE
#-#-  set_vt_filler_rule -threshold_voltage {LVT_TYPE LVT_TYPE} -lib_cell $RVT_SPARE
#-#-  set_vt_filler_rule -threshold_voltage {RVT_TYPE LVT_TYPE} -lib_cell $RVT_SPARE
#-#-  
#-#-  insert_stdcell_filler -no_1x -respect_overlap -ignore_soft_placement_blockage
#-#-  remove_zrt_filler_with_violation
#-#-  
#-#-  remove_vt_filler_rule -threshold_voltage {RVT_TYPE}
#-#-  remove_vt_filler_rule -threshold_voltage {LVT_TYPE}
#-#-  remove_vt_filler_rule -threshold_voltage {RVT_TYPE RVT_TYPE}
#-#-  remove_vt_filler_rule -threshold_voltage {LVT_TYPE LVT_TYPE}
#-#-  remove_vt_filler_rule -threshold_voltage {RVT_TYPE LVT_TYPE}

set RVT_LIBs "\
	/proj/BTC/LIB/SC/sc9mcpp84_base_rvt_c14/arm/samsung/ln14lpp/sc9mcpp84_base_rvt_c14/r3p2/milkyway/9M_3Mx_4Cx_2Gx_LB/sc9mcpp84_ln14lpp_base_rvt_c14 \
	/proj/BTC/LIB/SC/sc9mcpp84_base_rvt_c16/arm/samsung/ln14lpp/sc9mcpp84_base_rvt_c16/r3p2/milkyway/9M_3Mx_4Cx_2Gx_LB/sc9mcpp84_ln14lpp_base_rvt_c16 \
	/proj/BTC/LIB/SC/HPK/sc9mcpp84_hpk_rvt_c14/arm/samsung/ln14lpp/sc9mcpp84_hpk_rvt_c14/r3p0/milkyway/9M_3Mx_4Cx_2Gx_LB/sc9mcpp84_ln14lpp_hpk_rvt_c14 \
	/proj/BTC/LIB/SC/HPK/sc9mcpp84_hpk_rvt_c16/arm/samsung/ln14lpp/sc9mcpp84_hpk_rvt_c16/r3p0/milkyway/9M_3Mx_4Cx_2Gx_LB/sc9mcpp84_ln14lpp_hpk_rvt_c16 \
	/proj/BTC/LIB/SC/ECO/sc9mcpp84/arm/samsung/ln14lpp/sc9mcpp84_eco_rvt_c14/r3p0/milkyway/9M_3Mx_4Cx_2Gx_LB/sc9mcpp84_ln14lpp_eco_rvt_c14 \
	"
set RVT_Decap "FILLSGCAPD128_A9PP84TR_C14 FILLSGCAPD64_A9PP84TR_C14 FILLSGCAPD32_A9PP84TR_C14 FILLSGCAPD16_A9PP84TR_C14 FILLSGCAPD8_A9PP84TR_C14 FILLSGCAPD4_A9PP84TR_C14 FILLSGCAPD3_A9PP84TR_C14 FILLSGCAPD2_A9PP84TR_C14" 
set LVT_LIBs "\
	/proj/BTC/LIB/SC/sc9mcpp84_base_lvt_c14/arm/samsung/ln14lpp/sc9mcpp84_base_lvt_c14/r3p2/milkyway/9M_3Mx_4Cx_2Gx_LB/sc9mcpp84_ln14lpp_base_lvt_c14 \
	/proj/BTC/LIB/SC/HPK/sc9mcpp84_hpk_lvt_c14/arm/samsung/ln14lpp/sc9mcpp84_hpk_lvt_c14/r3p0/milkyway/9M_3Mx_4Cx_2Gx_LB/sc9mcpp84_ln14lpp_hpk_lvt_c14 \
	/proj/BTC/LIB/SC/sc9mcpp84_base_lvt_c16/arm/samsung/ln14lpp/sc9mcpp84_base_lvt_c16/r3p2/milkyway/9M_3Mx_4Cx_2Gx_LB/sc9mcpp84_ln14lpp_base_lvt_c16 \
	/proj/BTC/LIB/SC/HPK/sc9mcpp84_hpk_lvt_c16/arm/samsung/ln14lpp/sc9mcpp84_hpk_lvt_c16/r3p0/milkyway/9M_3Mx_4Cx_2Gx_LB/sc9mcpp84_ln14lpp_hpk_lvt_c16 \
	/proj/BTC/LIB/SC/Supplemental_cell_kits/SC9MCPP84_C14_PMK_YO_LVT/arm/samsung/ln14lpp/sc9mcpp84_pmkyo_lvt_c14/r1p0/milkyway/9M_3Mx_4Cx_2Gx_LB/sc9mcpp84_ln14lpp_pmkyo_lvt_c14 \
	"
set LVT_Decap "FILLSGCAPD128_A9PP84TL_C14 FILLSGCAPD64_A9PP84TL_C14 FILLSGCAPD32_A9PP84TL_C14 FILLSGCAPD16_A9PP84TL_C14 FILLSGCAPD8_A9PP84TL_C14 FILLSGCAPD4_A9PP84TL_C14 FILLSGCAPD3_A9PP84TL_C14 FILLSGCAPD2_A9PP84TL_C14 " 

foreach RVT_LIB $RVT_LIBs { set_cell_vt_type -library $RVT_LIB -vt_type RVT_TYPE }
foreach LVT_LIB $LVT_LIBs { set_cell_vt_type -library $LVT_LIB -vt_type LVT_TYPE }

set_vt_filler_rule -threshold_voltage {RVT_TYPE} -lib_cell $RVT_Decap
set_vt_filler_rule -threshold_voltage {LVT_TYPE} -lib_cell $LVT_Decap
set_vt_filler_rule -threshold_voltage {RVT_TYPE RVT_TYPE} -lib_cell $RVT_Decap
set_vt_filler_rule -threshold_voltage {LVT_TYPE LVT_TYPE} -lib_cell $LVT_Decap
set_vt_filler_rule -threshold_voltage {RVT_TYPE LVT_TYPE} -lib_cell $RVT_Decap

insert_stdcell_filler -no_1x -respect_overlap -ignore_soft_placement_blockage

remove_vt_filler_rule -threshold_voltage {RVT_TYPE}
remove_vt_filler_rule -threshold_voltage {LVT_TYPE}
remove_vt_filler_rule -threshold_voltage {RVT_TYPE RVT_TYPE}
remove_vt_filler_rule -threshold_voltage {LVT_TYPE LVT_TYPE}
remove_vt_filler_rule -threshold_voltage {RVT_TYPE LVT_TYPE}

