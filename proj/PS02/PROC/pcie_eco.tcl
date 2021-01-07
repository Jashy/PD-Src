#****************************************
#Report : clock timing
#	-type latency
#	-verbose
#	-launch
#	-nworst 1
#	-setup
#Design : pezy1_wrapper
#Version: C-2009.06-SP3-1
#Date   : Tue Nov 15 16:32:46 2011
#****************************************
#
#  Clock: u4_pipe_pcs_mac_tx_clk
#
#  Endpoint: u_pcs_sds/u_pcssds/pcs/lane_0/pcie_rx/pcs_mac_rx_pcie_data_reg_9_
#               (rising edge-triggered flip-flop clocked by u4_pipe_pcs_mac_tx_clk)
#
#
#  Point                                                                                     Trans     Incr       Path
#  ----------------------------------------------------------------------------------------------------------------------
#  clock u4_pipe_pcs_mac_tx_clk (rise edge)
#  clock u4_pipe_pll_pcs_clk (source latency)                                                        0.0000     0.0000
#  u_pcs_sds/u_pcssds/serdes/global/o_pll_pcs_clk (rby_fc_global)         0.0000   0.0000     0.0000 r
#  u_pcs_sds/u_pcssds/serdes/u_ScanClock_global_o_pll_pcs_clk_Mux/I0 (CKMUX2D2BWP12T)   0.0000   0.0000 *   0.0000 r
#  u_pcs_sds/u_pcssds/serdes/u_ScanClock_global_o_pll_pcs_clk_Mux/Z (CKMUX2D2BWP12T)   0.0000   0.0213 *   0.0213 r
#  u_pcs_sds/u_pcssds/pcs/tx_clkgen/pcs_mac_tx_clk_cgate/CP (CKLNQD4BWP12T)   0.0000   0.0011 *   0.0224 r
#  u_pcs_sds/u_pcssds/pcs/tx_clkgen/pcs_mac_tx_clk_cgate/Q (CKLNQD4BWP12T)   0.0000   0.0202 *   0.0426 r
#  u_pcs_sds/u_pcssds/pcs/tx_clkgen/pcs_mac_tx_clk_dft_mux/I0 (MUX2D4BWP12T)   0.0000   0.0000 *   0.0426 r
#  u_pcs_sds/u_pcssds/pcs/tx_clkgen/pcs_mac_tx_clk_dft_mux/Z (MUX2D4BWP12T)   0.0000   0.0179 *   0.0605 r
#  u_pcs_sds/u_pcssds/pcs/tx_clkgen/pcs_mac_tx_clk_mux/I0 (MUX2D4BWP12T)   0.0000   0.0000 *   0.0605 r
#  u_pcs_sds/u_pcssds/pcs/tx_clkgen/pcs_mac_tx_clk_mux/Z (MUX2D4BWP12T)   0.0000   0.0213 *   0.0818 r
#  u_pcs_sds/u_pcssds/pcs/tx_clkgen/pcs_mac_tx_clk_buf/I (CKBD32BWP12T)   0.0000   0.0000 *   0.0818 r
#  u_pcs_sds/u_pcssds/pcs/tx_clkgen/pcs_mac_tx_clk_buf/Z (CKBD32BWP12T) (gclock source)   0.0000   0.0157 *   0.0974 r
#  u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0_I_MATCH_ECO_2_U0/I (CKBD4BWP12T)   0.0000   0.0000 *   0.0974 r
source /proj/Pezy-1/WORK/Peter/ICC/N2N/SWAP_LOC.tcl

create_cell u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0_I_MATCH_ECO_2_MUX [get_model CKMUX2D4BWP12T]
SWAP_LOCATION u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0_I_MATCH_ECO_2_MUX u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0_I_MATCH_ECO_2_U1
remove_buffer u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0_I_MATCH_ECO_2_U1
remove_buffer u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0_I_MATCH_ECO_2_U2
create_net u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0_I_MATCH_ECO_2_n_mux
connect_net u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0_I_MATCH_ECO_2_n_mux u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0_I_MATCH_ECO_2_MUX/Z
REWIRE u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0_I_MATCH_ECO_2_MUX/Z u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0_I_MATCH_ECO_2_U3/I
connect_net [get_nets -of u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0_I_MATCH_ECO_2_U0/Z] u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0_I_MATCH_ECO_2_MUX/I0
connect_net [get_nets -of u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0_I_MATCH_ECO_2_U0/Z] u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0_I_MATCH_ECO_2_MUX/I1
connect_pin -from ALCP_U154PLCOPT/Z -to u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0_I_MATCH_ECO_2_MUX/S -port_name SCAN_MODE

INSERT_BUFFER u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0_I_MATCH_ECO_2_MUX/I0  CKBD2BWP12T -place_on_pin
INSERT_BUFFER u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0_I_MATCH_ECO_2_MUX/I0  CKBD2BWP12T -place_on_pin
INSERT_BUFFER u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0_I_MATCH_ECO_2_MUX/I0  CKBD2BWP12T -place_on_pin
INSERT_BUFFER u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0_I_MATCH_ECO_2_MUX/I0  CKBD2BWP12T -place_on_pin
INSERT_BUFFER u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0_I_MATCH_ECO_2_MUX/I0  CKBD2BWP12T -place_on_pin
INSERT_BUFFER u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0_I_MATCH_ECO_2_MUX/I0  CKBD2BWP12T -place_on_pin
INSERT_BUFFER u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0_I_MATCH_ECO_2_MUX/I0  CKBD2BWP12T -place_on_pin
INSERT_BUFFER u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0_I_MATCH_ECO_2_MUX/I0  CKBD2BWP12T -place_on_pin
INSERT_BUFFER u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0_I_MATCH_ECO_2_MUX/I0  CKBD2BWP12T -place_on_pin
INSERT_BUFFER u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0_I_MATCH_ECO_2_MUX/I0  CKBD2BWP12T -place_on_pin

INSERT_BUFFER u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0_I_MATCH_ECO_2_MUX/I0  CKBD2BWP12T -place_on_pin
INSERT_BUFFER u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0_I_MATCH_ECO_2_MUX/I0  CKBD2BWP12T -place_on_pin
INSERT_BUFFER u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0_I_MATCH_ECO_2_MUX/I0  CKBD2BWP12T -place_on_pin
INSERT_BUFFER u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0_I_MATCH_ECO_2_MUX/I0  CKBD2BWP12T -place_on_pin
INSERT_BUFFER u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0_I_MATCH_ECO_2_MUX/I0  CKBD2BWP12T -place_on_pin
INSERT_BUFFER u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0_I_MATCH_ECO_2_MUX/I0  CKBD2BWP12T -place_on_pin
INSERT_BUFFER u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0_I_MATCH_ECO_2_MUX/I0  CKBD2BWP12T -place_on_pin
INSERT_BUFFER u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0_I_MATCH_ECO_2_MUX/I0  CKBD2BWP12T -place_on_pin
INSERT_BUFFER u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0_I_MATCH_ECO_2_MUX/I0  CKBD2BWP12T -place_on_pin
INSERT_BUFFER u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0_I_MATCH_ECO_2_MUX/I0  CKBD2BWP12T -place_on_pin

INSERT_BUFFER u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0_I_MATCH_ECO_2_MUX/I0  CKBD2BWP12T -place_on_pin
INSERT_BUFFER u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0_I_MATCH_ECO_2_MUX/I0  CKBD2BWP12T -place_on_pin

#  u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0_I_MATCH_ECO_2_U0/Z (CKBD4BWP12T)   0.0000   0.0112 *   0.1086 r
	#  u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0_I_MATCH_ECO_2_U1/I (CKBD4BWP12T)   0.0000   0.0000 *   0.1086 r
	#  u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0_I_MATCH_ECO_2_U1/Z (CKBD4BWP12T)   0.0000   0.0101 *   0.1187 r
	#  u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0_I_MATCH_ECO_2_U2/I (CKBD4BWP12T)   0.0000   0.0000 *   0.1187 r
	#  u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0_I_MATCH_ECO_2_U2/Z (CKBD4BWP12T)   0.0000   0.0101 *   0.1288 r
#  u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0_I_MATCH_ECO_2_U3/I (CKBD4BWP12T)   0.0000   0.0000 *   0.1288 r
#  u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0_I_MATCH_ECO_2_U3/Z (CKBD4BWP12T)   0.0000   0.0112 *   0.1400 r
#  u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0_I_MATCH_ECO_2_U4/I (CKBD4BWP12T)   0.0000   0.0000 *   0.1400 r
#  u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0_I_MATCH_ECO_2_U4/Z (CKBD4BWP12T)   0.0000   0.0112 *   0.1512 r
#  u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0_I_MATCH_ECO_2_U5/I (CKBD4BWP12T)   0.0000   0.0000 *   0.1512 r
#  u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0_I_MATCH_ECO_2_U5/Z (CKBD4BWP12T)   0.0000   0.0101 *   0.1613 r
#  u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0_I_MATCH_ECO_2_U6/I (CKBD4BWP12T)   0.0000   0.0000 *   0.1613 r
#  u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0_I_MATCH_ECO_2_U6/Z (CKBD4BWP12T)   0.0000   0.0101 *   0.1714 r
#  u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0_I_MATCH_ECO_2_U7/I (CKBD4BWP12T)   0.0000   0.0000 *   0.1714 r
#  u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0_I_MATCH_ECO_2_U7/Z (CKBD4BWP12T)   0.0000   0.0123 *   0.1837 r
#  u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0/I (CKBD20BWP12T)   0.0000   0.0000 *   0.1837 r
#  u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0/Z (CKBD20BWP12T)   0.0000   0.0179 *   0.2016 r
#  u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0_Z_FB_L1_DRIVE02/I (CKBD20BWP12T)   0.0000   0.0000 *   0.2016 r
#  u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0_Z_FB_L1_DRIVE02/Z (CKBD20BWP12T)   0.0000   0.0179 *   0.2195 r
#  u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0_Z_FB_L2_DRIVE06/I (CKBD20BWP12T)   0.0000   0.0056 *   0.2251 r
#  u_pcs_sds/u_pcssds/pcs/tx_clkgen_pcs_mac_tx_clk_CLOCK_ECO_U0_Z_FB_L2_DRIVE06/Z (CKBD20BWP12T)   0.0000   0.0190 *   0.2442 r
#  u_pcs_sds/u_pcssds/pcs/lane_0/pcie_rx/pcs_mac_rx_pcie_data_reg_9_/CP (SDFCND2BWP12T)   0.0000   0.0347 *   0.2789 r
#  total clock latency                                                                                          0.2789
#
#1
