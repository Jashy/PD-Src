remove_stdcell_filler -stdcell
remove_sdc
source ./tcl/set_operating_conditions.tcl
###########################################################################################################
# Remove reduntant buffer

#remove_buffer_tree -from b_tusda2_0/C
#remove_buffer_tree -from b_scl_0/C
#remove_buffer_tree -from u_Fix_BISTR_TCK_16M_TR_AND/Z

###########################################################################################################
# Create dummy clock

create_clock -name bp_clk_41M_c -period 24 -waveform {0 12} [get_pins u_Fix_ScanClock_82M_TOP_82M_bp_clk_BUF/Z]
create_clock -name bp_clk_82M_c -period 24 -waveform {0 12} [get_pins u_Fix_MBIST_82M_TOP_ps_bist_clk_mgc_1_BUF/Z ]
create_clock -name bist_clk_mgc_1_u_c -period 24 -waveform {0 12} [get_pins whydra_0/whydracore_0/hmem_1/dram16m_wrp_0/top_16m/dram16m_wrp/top_16m/clkand/Q ] ; # u_Fix_BISTR_CLK_82M_TR_AND
create_clock -name bist_clk_mgc_2_u_c -period 24 -waveform {0 12} [get_pins whydra_0/whydracore_0/hmem_0/dram16m_wrp_0/top_16m/dram16m_wrp/top_16m/clkand/Q ] ; # u_Fix_BISTR_CLK_82M_BL_AND
create_clock -name bist_clk_mgc_3_u_c -period 24 -waveform {0 12} [get_pins u_Fix_BISTR_TCK_16M_TR_AND/Z ]	; # u_Fix_BISTR_TCK_16M_TR_AND/Z
create_clock -name bist_clk_mgc_4_u_c -period 24 -waveform {0 12} [get_pins u_Fix_BISTR_TCK_16M_BL_AND/Z] ; # u_Fix_BISTR_TCK_16M_BL_AND/Z
create_clock -name bist_clk_mgc_5_u_c -period 24 -waveform {0 12} [get_pins u_Fix_SCAN_ScanClock_41M_AND/Z ]


###########################################################################################################
#
reset_clock_tree_references
set_dont_use tcbn65lpwcl/BUF*
set_dont_use tcbn65lpwcl/INV*
remove_attribute [get_lib_cell tcbn65lpwcl/CKBD*]  dont_use
remove_attribute [get_lib_cell tcbn65lpwcl/CKND*]  dont_use

set_dont_use tcbn65lphvtwcl/*
set_dont_use tcbn65lpwcl/*D0
set_dont_use tcbn65lpwcl/*D1
set_dont_use tcbn65lpwcl/*D2
set_dont_use tcbn65lpwcl/*D3
set_dont_use tcbn65lpwcl/*D20
set_dont_use tcbn65lpwcl/*D24
set_clock_tree_references -references {CKBD4 CKBD6 CKBD8 CKBD12 CKBD16 CKND4 CKND6 CKND8 CKND12 CKND16 } -sizing_only  -delay_insertion_only
#
remove_clock_tree_exceptions -all

# Loading after u_Fix_SCAN_ScanClock_41M_AND/Z
set_clock_tree_exceptions  -dont_touch_subtrees [get_pins  u_Fix_ScanClock_41M_bp_clk_41M_BLK_BUF/I ]
set_clock_tree_exceptions  -dont_touch_subtrees [get_pins  u_Fix_SCAN_ScanClock_41M_TP_CLOCK_BLK_BUF/I]
set_clock_tree_exceptions  -dont_touch_subtrees [get_pins  whydra_0/whclkgen_0/whcdiv_0/u_FixDrc_ScanClk_41M_ckbuf_ckdb_Z_Mux/I1]
set_clock_tree_exceptions  -dont_touch_subtrees [get_pins  whydra_0/whclkgen_0/whcdiv_0/u_FixDrc_ScanClk_41M_ckbuf_ckdf_Z_Mux/I1]
set_clock_tree_exceptions  -dont_touch_subtrees [get_pins  whydra_0/whclkgen_0/whcdiv_0/u_FixDrc_ScanClk_41M_ckbuf_ckd_Z_Mux/I1]
set_clock_tree_exceptions  -dont_touch_subtrees [get_pins  whydra_0/whclkgen_0/whcdiv_0/u_FixDrc_ScanClk_41M_ckbuf_cks_Z_Mux/I1]
set_clock_tree_exceptions  -dont_touch_subtrees [get_pins  whydra_0/whclkgen_0/whcdiv_0/u_FixDrc_ScanClk_41M_ckbuf_ckf_Z_Mux/I1]
set_clock_tree_exceptions  -dont_touch_subtrees [get_pins  whydra_0/u_FixDrc_ScanClk_41M_pcksel_1_cksel_cell_Z_Mux/I1 ]

#

#set_clock_tree_exceptions -dont_buffer_nets [get_nets sa120c_core_0/sa120_clk_gen_0/sa1_clk_scan_2/clk_out_CTe_3] -dont_touch_subtrees [get_pins sa120c_core_0/sa120_clk_gen_0/sa1_clk_scan_2/U_g18_CTe_3/A]
#set_clock_tree_exceptions -exclude_pins [get_pins TOP_ci3724tg_PADRING_0/u_ci3724tg_0/clk]
#set_clock_tree_exceptions -exclude_pins [get_pins mhCOD8501_2G_PADRING_0/u_mhCOD8501_2G_0/MC_CLK]
#set_clock_tree_exceptions -exclude_pins [get_pins mhCOD8501_2G_PADRING_0/u_mhCOD8501_2G_0/MCLK]

report_clock_tree -exceptions 	>	 ${SESSION}.run/clk_exception.report
report_clock_tree -summary	>	 ${SESSION}.run/clk_tree_before_CTS.sum

#
set_clock_tree_options -target_skew 0.05 \
            -max_transition 0.3 \
            -use_default_routing_for_sinks 1 \
            -gate_sizing true \
            -gate_relocation true \
            -buffer_sizing true \
            -delay_insertion true \
            -buffer_relocation true \
            -max_fanout 12 \
            -top_mode true

#   -target_early_delay 2.3
reset_clock_tree_optimization_options -all
set_clock_tree_optimization_options -gate_sizing true \
                                    -gate_relocation false \
                                    -area_recovery false \
                                    -preserve_levels false \
                                    -relax_insertion_delay true \
                                    -balance_rc true
clock_opt -only_cts -no_clock_route
report_clock_tree -summary	>	${SESSION}.run/clk_tree_post_CTS.sum

save_mw_cel -as CTS

########################################
report_net_fanout -threshold 20 -nosplit > HF.rpt

