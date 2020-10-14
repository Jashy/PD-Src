#-#-  insert_buffer u_pad/ui_xclkin/Y sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p59v_125c/BUFH_X2N_A9PP84TL_C14
#-#-  create_port -direction out u_pad/arc_add
#-#-  disconnect_net [get_nets -of u_hce_pd/xclk_to_hpd ] u_hce_pd/xclk_to_hpd
#-#-  connect_pin -from u_pad/ui_xclkin/Y  -to u_hce_pd/xclk_to_hpd -port_name arc_add
#-#-  disconnect_net [get_nets -of u_pad/uo_clko/A] u_pad/uo_clko/A
#-#-  connect_net [get_nets -of u_pad/ui_xclkin/Y ] u_pad/uo_clko/A 

insert_buffer u_pad/ui_xclkin/Y sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p59v_125c/BUFH_X2N_A9PP84TL_C14 -new_cell_names ALCP_FOR_LEVELSHIFT_U0 -new_net_names ALCP_FOR_LEVELSHIFT_n0
create_port -direction out u_pad/arc_add
disconnect_net [get_nets -of u_pll_pd/xclk ] u_pll_pd/xclk
connect_pin -from u_pad/ui_xclkin/Y  -to u_pll_pd/xclk -port_name arc_add
disconnect_net [get_nets -of u_pad/uo_clko/A] u_pad/uo_clko/A
connect_net [get_nets -of u_pad/ui_xclkin/Y ] u_pad/uo_clko/A 
