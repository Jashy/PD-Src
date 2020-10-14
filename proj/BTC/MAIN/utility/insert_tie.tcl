remove_attribute sc9mcpp84_ln14lpp_base_lvt_c16_ss_nominal_max_0p59v_125c/TIEHI_X1N_A9PP84TL_C16 dont_use
remove_attribute sc9mcpp84_ln14lpp_base_lvt_c16_ss_nominal_max_0p59v_125c/TIELO_X1N_A9PP84TL_C16 dont_use
set_attribute sc9mcpp84_ln14lpp_base_lvt_c16_ss_nominal_max_0p59v_125c/TIEHI_X1N_A9PP84TL_C16/Y max_fanout 5
set_attribute sc9mcpp84_ln14lpp_base_lvt_c16_ss_nominal_max_0p59v_125c/TIELO_X1N_A9PP84TL_C16/Y max_fanout 5
set_attribute sc9mcpp84_ln14lpp_base_lvt_c16_ss_nominal_max_0p59v_125c/TIEHI_X1N_A9PP84TL_C16/Y max_capacitance 0.2 -type float
set_attribute sc9mcpp84_ln14lpp_base_lvt_c16_ss_nominal_max_0p59v_125c/TIELO_X1N_A9PP84TL_C16/Y max_capacitance 0.2 -type float

remove_attribute sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p76v_125c/TIEHI_X1N_A9PP84TL_C14 dont_use
remove_attribute sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p76v_125c/TIELO_X1N_A9PP84TL_C14 dont_use
set_attribute sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p76v_125c/TIEHI_X1N_A9PP84TL_C14/Y max_fanout 5
set_attribute sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p76v_125c/TIELO_X1N_A9PP84TL_C14/Y max_fanout 5
set_attribute sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p76v_125c/TIEHI_X1N_A9PP84TL_C14/Y max_capacitance 0.2 -type float
set_attribute sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p76v_125c/TIELO_X1N_A9PP84TL_C14/Y max_capacitance 0.2 -type float

remove_tie_cells -use_default_tie_net [remove_from_collection [all_tieoff_cells ] [get_flat_cells * -filter "ref_name =~ TIE* &&  dont_touch == true"]]
derive_pg_connection -power_net VDD -ground_net VSS -tie
derive_pg_connection -power_net VDD_HIGH -tie -cells "u_pll_pd"
derive_pg_connection -power_net VDD_HIGH -tie -cells "u_pad"

set cells [get_flat_cells -of [get_flat_pins -of_objects  [get_flat_nets -all [ list VDD_HIGH VDD VSS ]] -filter "name!~VDD && name!~VSS"]] 
connect_tie_cells -objects [get_flat_cells $cells] -obj_type cell_inst -tie_high_lib_cell TIEHI_X1N_A9PP84TL_C16 -tie_low_lib_cell TIELO_X1N_A9PP84TL_C16 -max_wirelength 15 -incremental true

#-#-  set cells [get_flat_cells -of [get_flat_pins -of_objects  [get_flat_nets -all [ list VDD_HIGH]] -filter "name!~VDD && name!~VSS"]] 
#-#-  connect_tie_cells -objects [get_flat_cells $cells] -obj_type cell_inst -tie_high_lib_cell TIEHI_X1N_A9PP84TL_C14 -tie_low_lib_cell TIELO_X1N_A9PP84TL_C16 -max_wirelength 15 -incremental true
#-#-  set_attr [get_flat_cells -filter "ref_name=~TIE*"] is_soft_fixed true

legalize_placement -incr
save_mw_cel -as insert_tie_cells 
