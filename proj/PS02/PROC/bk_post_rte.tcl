##open_design
#set DATE 0904
#source ../tcl/design_settings.tcl
#set MW_CEL routed
#source ../tcl/open.tcl
##
#save_mw_cel -as WYVERN1IO
#close_mw_cel
#open_mw_cel WYVERN1IO

set STEP post_route_opt

##set derating
source ../tcl/timing_derate.tcl

##set more derating on critical paths
set critical_paths { \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtaucore_0/dtnicam_0/dtnicintp_0/dtnicfirintp_0/intp2x127lrefir_0/rams_0/ts1n65lpa160x18m4_0/ram/CLK \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtqssn8_0/dtqssintp_2/fircsymr2a_0/pdlyre_0_dreg_reg_1__6_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtqssn8_0/cordicfsc16_r8_0/cordicrot_r8_1/pdffr_0_OUT_reg_3_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacoreif_0/diachslct_0/diacloopf_0/decm2x2iqr4_0/pdffre_0_OUT_reg_1_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacoreif_0/dtvibbconv_0/dtvibgdeq_0/dtiirap2or2f2_2/pdffre_0_OUT_reg_13_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacoreif_0/diachslct_0/diapll_0/dianest_0/dtlp01r_0/pdlyre_1_dreg_reg_0__0_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacoreif_0/dtvibbconv_0/dtifadj80_0/fircsymr4a_5/pdffr_0_OUT_reg_0_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtqssn8_0/dtqssdecm_0/fircsymr8_0/pdffr_3_OUT_reg_2_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtaucore_0/dtausrc_0/dtnicfarinterp_0/pdffr_10_OUT_reg_1_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacore4_0/diavideodemodulator_0/diavsbf_0/dthilb30or4_0/fircasyr4_2/pdffr_1_OUT_reg_28_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtqssn8_0/pdffr_22_OUT_reg_0_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtqssn8_0/cordicfsc12_r2_0/cordicrot_r2_2/pdffr_0_OUT_reg_1_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacore4_0/diavideodemodulator_0/dtvpll2_0/diaplp2_0/pdffr_1_OUT_reg_0_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacore4_0/diavideodemodulator_0/dtvdintp_0/fircsymr4a_1/pdffr_0_OUT_reg_0_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtaucore_0/dtnicam_0/dtnicdemod_0/pdffre_1_OUT_reg_0_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacoreif_0/diachslct_0/cordicfsc16_1/cordicrot_r4_1/pdffr_0_OUT_reg_2_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacore4_0/diavideodemodulator_0/dtvpll2_0/diaplp2_0/dtlp01or_0/pdffre_0_OUT_reg_14_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacoreif_0/diachslct_0/diapll_0/cordicfsc12vpll_0/cordicrot_4it_0/pdffr_2_OUT_reg_1_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtqssn8_0/dtqsslp_0/fircsymr8_0/pdffr_1_OUT_reg_13_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacore4_0/diaueq_0/diagdeq2_1/dtiirap2or2f2_3/pdffre_0_OUT_reg_9_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtqssn8_0/cordicfsc12_r2_0/cordicrot_r2_2/pdffr_0_OUT_reg_0_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacore4_0/diavideodemodulator_0/pdffre_0_OUT_reg_0_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacoreif_0/dtvibbconv_0/dtvibcordic_0/pdffre_0_OUT_reg_21_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtqssn8_0/pdffr_15_OUT_reg_14_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtqssn8_0/dtqssdecm_0/fircsymr8_0/pdffr_3_OUT_reg_0_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtqssn8_0/cordicfsc12_r2_0/cordicrot_r2_1/pdffre_0_OUT_reg_21_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacoreif_0/dtvibbconv_0/dtifadj80_0/fircsymr4a_0/pdffr_0_OUT_reg_1_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacore4_0/diavideodemodulator_0/dtvdintp_0/fircsymr4a_0/pdffr_1_OUT_reg_30_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacoreif_0/diachslct_0/diacloopf_0/cordicfsc16_r4_0/cordicrot_r4_2/pdffr_0_OUT_reg_1_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacoreif_0/diachslct_0/diavisionsoundsplit_0/cordicfsc16_r4_0/cordicrot_r4_1/pdffr_0_OUT_reg_3_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacoreif_0/diachslct_0/diavisionsoundsplit_0/cordicfsc16_r4_0/cordicrot_r4_2/pdffr_0_OUT_reg_2_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacore4_0/diavideodemodulator_0/diagdeq2_0/dtiirap2or2f2_2/pdffr_0_OUT_reg_14_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtaucore_0/dtnicam_0/dtnicdemod_0/dtnicrrc_0/fircsymr32_0/pdffr_0_OUT_reg_2_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacore4_0/diaueq_0/diagdeq2_0/dtiirap2or2f2_3/pdffr_2_OUT_reg_2_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacoreif_0/dtvibbconv_0/dtifadj80_0/fircsymr4a_7/pdffr_0_OUT_reg_1_/CP \
wyvern1_0/wcore_0/wccore_0/ccwampdet_0/pdff_0_OUT_reg_25_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacore4_0/diaueq_0/dtfirsym48or4_0/fircsymr4_2/pdffr_0_OUT_reg_1_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtaucore_0/diaSoundChannelSelectionUS_0/cordicfsc16_r4_0/cordicrot_r4_1/pdffr_0_OUT_reg_1_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacore4_0/diavideodemodulator_0/dtvdintp_0/fircsymr4a_2/pdffr_0_OUT_reg_1_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtqssn8_0/cordicfsc16_r8_0/cordicrot_r8_0/pdffre_2_OUT_reg_0_/CP \
wyvern1_0/wcore_0/wccore_0/ccwampdet_0/cordic_rot_0/ccwrot_0/dq_09_reg_OUT_reg_7_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacoreif_0/diachslct_0/diavisionsoundsplit_0/dtvssadj_0/fircsymr2_5/pdffr_0_OUT_reg_0_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtaucore_0/diaAudioDemodulationUS_0/diasoftclip_1/lp1oe_2_0/pdffre_0_OUT_reg_1_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacore4_0/diavideodemodulator_0/dtvpll2_0/cordicfsc16_r4_0/cordicrot_r4_2/pdffr_0_OUT_reg_1_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtaucore_0/dtnicam_0/dtnicdemod_0/dtnicrrc_0/fircsymr32_1/pdffr_0_OUT_reg_2_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacoreif_0/diachslct_0/diapll_0/dtmuls_r2_0/pdffre_2_OUT_reg_4_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacore4_0/diavideodemodulator_0/dtvpll2_0/cordicfsc16_r4_0/cordicrot_r4_0/pdffr_0_OUT_reg_3_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacore4_0/diaueq_0/diagdeq2_1/dtiirap2or2f2_3/pdffr_2_OUT_reg_2_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacore4_0/diavideodemodulator_0/pdffr_18_OUT_reg_12_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacoreif_0/dtvibbconv_0/dtifadj80_0/fircsymr4a_3/pdffr_0_OUT_reg_0_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacore4_0/diaueq_0/dtfirsym48or4_0/fircsymr4_4/pdffr_0_OUT_reg_1_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtaucore_0/diaSoundChannelSelectionUS_0/cordicfsc16_r4_0/cordicrot_r4_3/pdffr_0_OUT_reg_3_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtaucore_0/dtnicam_0/dtnicdemod_0/dtniceq_0/counter_0/pdffre_0_OUT_reg_0_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacoreif_0/dtvibbconv_0/dtifadj80_0/fircsymr4a_6/pdffr_0_OUT_reg_1_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacoreif_0/diachslct_0/iirlp1o_0/pdffre_1_OUT_reg_1_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacore4_0/diaueq_0/pdffr_4_OUT_reg_0_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacoreif_0/dtvibbconv_0/dtifadj80_0/fircsymr4a_1/pdffr_0_OUT_reg_0_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacore4_0/diaueq_0/diagdeq2_0/pdffr_1_OUT_reg_0_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacore4_0/diaueq_0/dtfirsym48or4_0/dtmuls_r4_0/pdffr_0_OUT_reg_0_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacoreif_0/dtvibbconv_0/dtifadj80_0/fircsymr4a_4/pdffr_0_OUT_reg_1_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacoreif_0/dtvibbconv_0/dtfeq_0/fircasyr4a_0/pdffr_0_OUT_reg_0_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacoreif_0/dtvibbconv_0/dtfeq_0/iqmuxee3_0/pdffr_1_OUT_reg_0_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacore4_0/diaueq_0/diagdeq2_0/dtiirap2or2f2_2/pdffr_2_OUT_reg_0_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacore4_0/diaueq_0/dtfirsym48or4_0/fircsymr4_0/pdffr_1_OUT_reg_27_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacoreif_0/dtvibbconv_0/dtvibgdeq_0/dtiirap2or2f2_0/pdffr_2_OUT_reg_1_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacoreif_0/dtvibbconv_0/dtvibgdeq_0/dtiirap2or2f2_2/pdffre_0_OUT_reg_28_/CP \
wyvern1_0/wcrgen_0/lutw_reg_OUT_reg_14_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacoreif_0/diachslct_0/cordicfsc16_1/cordicrot_r4_3/pdffr_0_OUT_reg_2_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtaucore_0/dtnicam_0/dtnicdemod_0/dtnicagc_0/pdffre_7_OUT_reg_12_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacore4_0/diavideodemodulator_0/diavsbf_0/pdffr_0_OUT_reg_0_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacore4_0/diavideodemodulator_0/dtvpll2_0/diaplp2_0/dtlp01or_0/pdffre_0_OUT_reg_4_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacoreif_0/dtvibbconv_0/dtifadj80_0/fircsymr4a_5/pdffr_1_OUT_reg_32_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacore4_0/diavideodemodulator_0/diagdeq2_0/dtiirap2or2f2_3/pdffr_2_OUT_reg_0_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacoreif_0/diachslct_0/diapll_0/cordicfsc12vpll_0/cordicrot_4it_1/pdffr_0_OUT_reg_15_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacoreif_0/diachslct_0/diapll_0/dialoopa_0/pdffre_1_OUT_reg_10_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacore4_0/diavideodemodulator_0/dtvpll2_0/diaplp2_0/iirlp1o_0/pdffr_0_OUT_reg_4_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacore4_0/diavideodemodulator_0/dtvpll2_0/cordicfsc16_r4_0/cordicrot_r4_3/pdffr_0_OUT_reg_1_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacore4_0/diaueq_0/diagdeq2_0/dtiirap2or2f2_2/pdffre_0_OUT_reg_7_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacore4_0/diaueq_0/dtfirsym48or4_0/pdffr_0_OUT_reg_0_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtqssn8_0/pdffr_18_OUT_reg_2_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacoreif_0/diachslct_0/diavisionsoundsplit_0/cordicfsc16_r4_0/cordicrot_r4_3/pdffr_0_OUT_reg_3_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacoreif_0/dtvibbconv_0/diabdecm_0/pdffr_20_OUT_reg_0_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtaucore_0/diaIFDADS_0/intpdads3_0/pdffre_2_OUT_reg_1_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacoreif_0/dtvibbconv_0/dtmuls_r4_0/pdffr_0_OUT_reg_2_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtqssn8_0/cordicfsc12_r2_0/cordicrot_r4_5/pdffr_0_OUT_reg_1_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacore4_0/diavdagc_0/dtmuls_r2_0/pdffre_2_OUT_reg_16_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacoreif_0/diachslct_0/diapll_0/cordicfsc12vpll_0/pdffr_2_OUT_reg_11_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacore4_0/diaueq_0/dtfirsym48or4_0/fircsymr4_1/pdffr_0_OUT_reg_1_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacore4_0/diaueq_0/diagdeq2_1/dtiirap2or2f2_2/pdffr_0_OUT_reg_15_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacore4_0/diavideodemodulator_0/dtvpll2_0/cordicfsc16_r4_0/cordicrot_r4_1/pdffr_0_OUT_reg_0_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtqssn8_0/cordicfsc12_r2_0/cordicrot_r2_4/pdffr_0_OUT_reg_1_/CP \
wyvern1_0/wcore_0/wccore_0/ccwampdet_0/cordic_rot_0/ccwrot_0/dq_12_reg_OUT_reg_3_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtqssn8_0/dtqssintp_3/fircsymr2a_0/pdlyre_0_dreg_reg_1__3_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtaucore_0/dtnicam_0/dtnicdemod_0/dtnicfsync_0/cordicrot12_r4/cordicrot_r16_0/pdffr_0_OUT_reg_1_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacore4_0/dtdagcmul_0/pdffr_5_OUT_reg_6_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacoreif_0/pdffr_23_OUT_reg_5_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtqssn8_0/cordicenvdete_0/PDFFRCOUNTER_OUT_reg_3_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacoreif_0/dtvibbconv_0/dtifadj80_0/fircsymr4a_2/pdffr_0_OUT_reg_1_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacore4_0/diaueq_0/dtfirsym48or4_0/fircsymr4_0/pdffr_0_OUT_reg_0_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacore4_0/diavideodemodulator_0/diavsbf_0/dthilb30or4_0/fircasyr4_0/pdffr_0_OUT_reg_0_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtqssn8_0/pdffre_0_OUT_reg_27_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacoreif_0/diachslct_0/diavisionsoundsplit_0/diastrp_0/fircsymr8_0/pdffr_3_OUT_reg_0_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtqssn8_0/cordicfsc12_r2_0/pdffre_0_OUT_reg_21_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtaucore_0/dtnicam_0/dtnicintp_0/dtnictmgctrl_0/dtlp01or_0/pdlyre_1_dreg_reg_0__0_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacoreif_0/dtvibbconv_0/dtvibgdeq_0/pdffr_1_OUT_reg_0_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtqssn8_0/dtqsslp_0/fircsymr8_0/pdffr_3_OUT_reg_0_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacoreif_0/diachslct_0/diapll_0/cordicfsc12vpll_0/pdffr_2_OUT_reg_3_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacore4_0/diavideodemodulator_0/diavsbf_0/dthilb30or4_0/fircasyr4_3/pdffr_0_OUT_reg_1_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacoreif_0/diachslct_0/diapll_0/cordicfsc12vpll_0/cordicrot_4it_0/pdffr_1_OUT_reg_2_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacoreif_0/dtvibbconv_0/dtifadj80_0/fircsymr4a_1/pdffr_0_OUT_reg_1_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacoreif_0/dtvibbconv_0/pdffr_12_OUT_reg_13_/CP \
wyvern1_0/wcore_0/wccore_0/ccwampdet_0/cordic_rot_0/ccwrot_0/di_12_reg_OUT_reg_5_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtaucore_0/dtnicam_0/dtnicintp_0/dtnictmgctrl_0/dtcounter_shared/pdffre_0_OUT_reg_0_/CP \
wyvern1_0/wcore_0/dtwcocore_0/dtwcore_0/dtvicore_0/diacore4_0/diavideodemodulator_0/dtvpll2_0/cordicfsc16_r4_0/cordicrot_r4_1/pdffr_0_OUT_reg_1_/CP \
wyvern1_0/wcore_0/wccore_0/ccwampdet_0/cordic_rot_0/ccwrot_0/di_09_reg_OUT_reg_5_/CP \
	}

set_false_path -from [all_inputs]
set_false_path -to [all_outputs]
 report_timing -max 10000 -slack_less 0 -net -tran -cap -input > ${SESSION}.run/post_route_bf_opt_wo_derate_max.rpt
 report_timing -max 10000 -slack_less 0 -net -tran -cap -input > ${SESSION}.run/post_route_bf_opt_wo_derate_max.rpt
 exec /proj/M4ES/TEMPLATES/PT/check_violation_summary.pl  ${SESSION}.run/post_route_bf_opt_wo_derate_max.rpt > ${SESSION}.run/post_route_bf_opt_wo_derate_max.rpt.summary

foreach start_point $critical_paths {
	set start_point_ff [get_attr [get_cells -of $start_point] full_name]
	set_timing_derate -max -late 3 $start_point_ff
	puts "set_timing_derate -late 3 ${start_point_ff}"
	}

set_false_path -from [all_inputs]
set_false_path -to [all_outputs]

 report_timing -max 10000 -slack_less 0 -net -tran -cap -input > ${SESSION}.run/post_route_bf_opt_max.rpt
 report_timing -max 10000 -slack_less 0 -net -tran -cap -input > ${SESSION}.run/post_route_bf_opt_max.rpt
 exec /proj/M4ES/TEMPLATES/PT/check_violation_summary.pl  ${SESSION}.run/post_route_bf_opt_max.rpt > ${SESSION}.run/post_route_bf_opt_max.rpt.summary

#route_opt -skip_initial_route [-incremental]
#psynopt -on_route 
#psynopt 
set STEP post_route_opt
route_opt -incremental


#####################################################################
# save and reports
#
 change_names -rule verilog -hier
 save_mw_cel
 save_mw_cel -as ${STEP}
 exec touch ./${SESSION}.run/${STEP}.ready
# get_ideal_nets 40 > ${SESSION}.run/${STEP}_ideal_nets.cmd
 write -format verilog -hierarchy   -output      	  ${SESSION}.run/${STEP}.v
 report_utilization					> ${SESSION}.run/${STEP}_utilization.rpt
 report_design -physical			 		> ${SESSION}.run/${STEP}_pr_summary.rpt
 report_net_fanout -threshold  20 -nosplit      		> ${SESSION}.run/${STEP}_net_fanout.rpt
 report_congestion -congestion_effort high      		> ${SESSION}.run/${STEP}_congestion.rpt
 report_constraint -all                         		> ${SESSION}.run/${STEP}_all.rpt
 report_timing -max 10000 -nosplit  -slack_less 0  -net -tran -cap -input -nosplit -derate > ${SESSION}.run/${STEP}_max.rpt
 exec /proj/M4ES/TEMPLATES/PT/check_violation_summary.pl   ${SESSION}.run/${STEP}_max.rpt >  ${SESSION}.run/${STEP}_max.rpt.summary
 

#exit
