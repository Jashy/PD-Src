set i 0
while { $i < 63} {
	set x [lindex [lindex [get_attribute [get_cells u_hce_pd/u_core_clk_wrap/CAR_CORE_CLK_ICG_${i}__u_icg/u_sc_icg] bbox] 0 ] 0 ]
	set y [lindex [lindex [get_attribute [get_cells u_hce_pd/u_core_clk_wrap/CAR_CORE_CLK_ICG_${i}__u_icg/u_sc_icg] bbox] 0 ] 1 ]
	set y_new [expr $y - 110]
	insert_buffer u_hce_pd/u_core_clk_wrap/CAR_CORE_CLK_ICG_${i}__u_icg/u_sc_icg/ECK sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p59v_125c/BUFH_X6N_A9PP84TL_C14 -new_cell_names hce${i}_ALCP_CLK_ANCHOR_L1_U0 -new_net_names hce${i}_ALCP_CLK_ANCHOR_L1_n0 -location [list $x $y_new]
	set i [expr $i + 1]
}

set i 0
while { $i < 63} {
	set x [lindex [lindex [get_attribute [get_cells u_hce_pd/u_core_clk_wrap/CAR_CORE_CLK_ICG_${i}__u_icg/u_sc_icg] bbox] 0 ] 0 ]
	set y [lindex [lindex [get_attribute [get_cells u_hce_pd/u_core_clk_wrap/CAR_CORE_CLK_ICG_${i}__u_icg/u_sc_icg] bbox] 0 ] 1 ]
	set y_new [expr $y - 30]
	insert_buffer u_hce_pd/u_core_clk_wrap/CAR_CORE_CLK_ICG_${i}__u_icg/u_sc_icg/ECK sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p59v_125c/BUFH_X6N_A9PP84TL_C14 -new_cell_names hce${i}_ALCP_CLK_ANCHOR_L0_U0 -new_net_names hce${i}_ALCP_CLK_ANCHOR_L0_n0 -location [list $x $y_new]
	set i [expr $i + 1]
}

set j 13 
while {$j > -1 } {
	set i 0
	while { $i < 63} {
		set x [lindex [lindex [get_attribute [get_cells u_hce_pd/u_core_clk_wrap/CAR_CORE_CLK_CKB_${i}__u_ckb/u_sc_ckbuf] bbox] 0 ] 0 ]
		set y [lindex [lindex [get_attribute [get_cells u_hce_pd/u_core_clk_wrap/CAR_CORE_CLK_CKB_${i}__u_ckb/u_sc_ckbuf] bbox] 0 ] 1 ]
		set x_new [expr $x - 96 - 96 * $j ]
		insert_buffer u_hce_pd/u_core_clk_wrap/CAR_CORE_CLK_CKB_${i}__u_ckb/u_sc_ckbuf/A sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p59v_125c/BUFH_X8N_A9PP84TL_C14 -new_cell_names hce${i}_ALCP_CLK_PREPLACE_L${j}_U0 -new_net_names hce${i}_ALCP_CLK_PREPLACE_L${j}_n0 -location [list $x_new $y]
		set i [expr $i + 1]
	}
	set j [expr $j - 1]
}
