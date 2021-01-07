#CHANGE_CELL o_rx_pipe_12__ISO_U0 BUFFD20BWP12TLVT
CHANGE_CELL o_rx_pipe_92__ISO_U0 BUFFD20BWP12TLVT
CHANGE_CELL u_pcs_sds/u_pcssds/pcs/ALCP_U171RTEOPT BUFFD20BWP12TLVT
CHANGE_CELL u_pcs_sds/u_pcssds/pcs/ALCP_U171RTEOPT_I_ALCHIP_111004_U0 BUFFD20BWP12TLVT
CHANGE_CELL u_pcs_sds/u_pcssds/pcs/ALCP_U197PSYNOPT INVD20BWP12TLVT
#CHANGE_CELL u_pcs_sds/u_pcssds/pcs/ALCP_U257RTEOPT INVD20BWP12TLVT
#CHANGE_CELL u_pcs_sds/u_pcssds/pcs/ALCP_U258RTEOPT INVD20BWP12TLVT
CHANGE_CELL u_pcs_sds/u_pcssds/pcs/ALCP_U259RTEOPT INVD20BWP12TLVT
CHANGE_CELL u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U131RTEOPT INVD20BWP12TLVT
CHANGE_CELL u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U154PSYNOPT BUFFD20BWP12TLVT
CHANGE_CELL u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U295RTEOPT RCAOI211D8BWP12TLVT
CHANGE_CELL u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U296RTEOPT INVD20BWP12TLVT
CHANGE_CELL u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U297RTEOPT OAI211D4BWP12TLVT
CHANGE_CELL u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U298RTEOPT INVD20BWP12TLVT
#CHANGE_CELL u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U299RTEOPT INVD20BWP12TLVT
CHANGE_CELL u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/U37 ND2D8BWP12TLVT
CHANGE_CELL u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/rdet_ack_reg SDFQD4BWP12TLVT
CHANGE_CELL u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/sync_mptx_ctl_ack/ALCP_U4RTEOPT INVD20BWP12TLVT
CHANGE_CELL u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/sync_mptx_ctl_ack/ALCP_U5RTEOPT INVD20BWP12TLVT
CHANGE_CELL u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/sync_mptx_ctl_ack/dout_reg SEDFCNQD4BWP12TLVT
CHANGE_CELL u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/sync_mptx_hold_ack/dout_reg SDFQD4BWP12TLVT
#CHANGE_CELL u_pcs_sds/u_pcssds/pcs/lane_3/pcie_rx/ALCP_U218PLCOPT BUFFD20BWP12TLVT
#CHANGE_CELL u_pcs_sds/u_pcssds/pcs/lane_3/pcie_rx/ALCP_U228PLCOPT BUFFD20BWP12TLVT
CHANGE_CELL u_pcs_sds/u_pcssds/pcs/lane_3/pcie_rx/pcs_mac_rx_pcie_data_reg_5_ SDFCNQD4BWP12TLVT
CHANGE_CELL u_pcs_sds/u_pcssds/pcs/mgmt_cmn/reset_mgmt_mptx_reg SDFSND8BWP12TLVT
#****************************************
#Report : timing
#	-path_type full
#	-delay_type max
#	-input_pins
#	-nets
#	-nworst 100
#	-max_paths 99999
#	-unique_pins
#Design : pcs_sds_pipe
#Version: C-2009.06-SP3-1
#Date   : Wed Nov 16 12:32:13 2011
#****************************************
#
#
#  Startpoint: u_pcs_sds/u_pcssds/pcs/mgmt_cmn/reset_mgmt_mptx_reg
#               (rising edge-triggered flip-flop clocked by pcs_mac_tx_clk)
#  Endpoint: o_rx_pipe[92]
#               (output port clocked by pcs_mac_tx_clk)
#  Path Group: REGOUT
#  Path Type: max
#  Min Clock Paths Derating Factor : 0.9500
#
#  Point                                                                                   Fanout       Incr       Path
#  ---------------------------------------------------------------------------------------------------------------------------
#  clock pcs_mac_tx_clk (rise edge)                                                                   0.0000     0.0000
#  clock network delay (propagated)                                                                   1.1810 *   1.1810
#  u_pcs_sds/u_pcssds/pcs/mgmt_cmn/reset_mgmt_mptx_reg/CP (SDFSND8BWP12T)                             0.0000     1.1810 r
#  u_pcs_sds/u_pcssds/pcs/mgmt_cmn/reset_mgmt_mptx_reg/Q (SDFSND8BWP12T)                              0.1280 *   1.3090 f
#  u_pcs_sds/u_pcssds/pcs/mgmt_cmn/reset_mgmt_mptx (net)                                      4 
#  u_pcs_sds/u_pcssds/pcs/mgmt_cmn/reset_mgmt_mptx (prism_pcs_mgmt_cmn_pcie)                          0.0000 *   1.3090 f
#  u_pcs_sds/u_pcssds/pcs/reset_mgmt_mptx (net) 
#  u_pcs_sds/u_pcssds/pcs/ALCP_U197PSYNOPT/I (INVD18BWP12T)                                           0.0030 *   1.3120 f
#  u_pcs_sds/u_pcssds/pcs/ALCP_U197PSYNOPT/ZN (INVD18BWP12T)                                          0.0190 *   1.3310 r
#  u_pcs_sds/u_pcssds/pcs/n198 (net)                                                          2 
INSERT_BUFFER u_pcs_sds/u_pcssds/pcs/ALCP_U99PSYNOPT/I BUFFD8BWP12T -location [get_location u_pcs_sds/u_pcssds/pcs/ALCP_U197PSYNOPT/ZN]

#  u_pcs_sds/u_pcssds/pcs/ALCP_U171RTEOPT_I_ALCHIP_111004_U0/I (BUFFD12BWP12T)                        0.0130 *   1.3440 r
CHANGE_BUF2INV u_pcs_sds/u_pcssds/pcs/ALCP_U171RTEOPT_I_ALCHIP_111004_U0	INVD20BWP12TLVT
CHANGE_BUF2INV u_pcs_sds/u_pcssds/pcs/ALCP_U171RTEOPT				INVD20BWP12TLVT 
#  u_pcs_sds/u_pcssds/pcs/ALCP_U171RTEOPT_I_ALCHIP_111004_U0/Z (BUFFD12BWP12T)                        0.0350 *   1.3790 r
#  u_pcs_sds/u_pcssds/pcs/ALCP_U171RTEOPT_I_ALCHIP_111004_n0 (net)                            1 
#  u_pcs_sds/u_pcssds/pcs/ALCP_U171RTEOPT/I (BUFFD16BWP12T)                                           0.0610 *   1.4400 r
#  u_pcs_sds/u_pcssds/pcs/ALCP_U171RTEOPT/Z (BUFFD16BWP12T)                                           0.0510 *   1.4910 r
#  u_pcs_sds/u_pcssds/pcs/n1118 (net)                                                         1 
#  u_pcs_sds/u_pcssds/pcs/ALCP_U259RTEOPT/I (INVD18BWP12T)                                            0.0230 *   1.5140 r
#  u_pcs_sds/u_pcssds/pcs/ALCP_U259RTEOPT/ZN (INVD18BWP12T)                                           0.0200 *   1.5340 f

# 0.417000       pezy1_top/u5_pipe/u_pcs_sds/u_pcssds/pcs/lane_1/cmn_lane_regs/ALCP_U111PSYNOPT/I
	# 1.041400       pezy1_top/u5_pipe/u_pcs_sds/u_pcssds/pcs/lane_1/ALCP_U43PSYNOPT/I
	# 1.025400       pezy1_top/u5_pipe/u_pcs_sds/u_pcssds/pcs/lane_0/ALCP_U43PSYNOPT/I
# 0.348350       pezy1_top/u5_pipe/u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U105PSYNOPT/I
# -0.165650      pezy1_top/u5_pipe/u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/U37/A2
# -0.131649      pezy1_top/u5_pipe/u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U297RTEOPT/A1

REWIRE u_pcs_sds/u_pcssds/pcs/lane_1/cmn_lane_regs/ALCP_U111PSYNOPT/Z u_pcs_sds/u_pcssds/pcs/lane_1/ALCP_U43PSYNOPT/I
REWIRE u_pcs_sds/u_pcssds/pcs/lane_1/cmn_lane_regs/ALCP_U111PSYNOPT/Z u_pcs_sds/u_pcssds/pcs/lane_0/ALCP_U43PSYNOPT/I
REWIRE u_pcs_sds/u_pcssds/pcs/lane_1/cmn_lane_regs/ALCP_U111PSYNOPT/Z u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U105PSYNOPT/I

#  u_pcs_sds/u_pcssds/pcs/n1119 (net)                                                         6 
#  u_pcs_sds/u_pcssds/pcs/lane_0/reset_mgmt_mptx (prism_pcs_pezy_pcie_lane_3_pcie)                    0.0000 *   1.5340 f
#  u_pcs_sds/u_pcssds/pcs/lane_0/reset_mgmt_mptx (net) 
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/reset_mgmt_mptx (prism_pcs_cmn_lane_regs_3_pcie)       0.0000 *   1.5340 f
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/reset_mgmt_mptx (net) 
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/U37/A2 (ND2D3BWP12T)                                   0.0640 *   1.5980 f
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/U37/ZN (ND2D3BWP12T)                                   0.0470 *   1.6450 r
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/n316 (net)                                     1 
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U297RTEOPT/B (OAI211D2BWP12T)                     0.0050 *   1.6500 r
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U297RTEOPT/ZN (OAI211D2BWP12T)                    0.0480 *   1.6980 f



# done 



#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U298RTEOPT/I (INVD3BWP12T)                        0.0000 *   1.6980 f
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U298RTEOPT/ZN (INVD3BWP12T)                       0.0280 *   1.7260 r
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/n3610 (net)                                    1 
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U299RTEOPT/I (INVD4BWP12T)                        0.0000 *   1.7260 r
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U299RTEOPT/ZN (INVD4BWP12T)                       0.0160 *   1.7420 f

REWIRE u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U298RTEOPT/ZN o_rx_pipe_92__ISO_U0/I
CHANGE_BUF2INV o_rx_pipe_92__ISO_U0 INVD20BWP12TLVT

#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/pcs_mac_ctl_ack (net)                          1 
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/pcs_mac_ctl_ack (prism_pcs_cmn_lane_regs_3_pcie)       0.0000 *   1.7420 f
#  u_pcs_sds/u_pcssds/pcs/lane_0/pcs_mac_ctl_ack (net) 
#  u_pcs_sds/u_pcssds/pcs/lane_0/pcs_mac_ctl_ack (prism_pcs_pezy_pcie_lane_3_pcie)                    0.0000 *   1.7420 f
#  u_pcs_sds/u_pcssds/pcs/n90 (net) 
#  u_pcs_sds/u_pcssds/pcs/ALCP_U257RTEOPT/I (INVD9BWP12T)                                             0.0000 *   1.7420 f
#  u_pcs_sds/u_pcssds/pcs/ALCP_U257RTEOPT/ZN (INVD9BWP12T)                                            0.0150 *   1.7570 r
#  u_pcs_sds/u_pcssds/pcs/n1116 (net)                                                         1 
#  u_pcs_sds/u_pcssds/pcs/ALCP_U258RTEOPT/I (INVD18BWP12T)                                            0.0010 *   1.7580 r
#  u_pcs_sds/u_pcssds/pcs/ALCP_U258RTEOPT/ZN (INVD18BWP12T)                                           0.0110 *   1.7690 f
#  u_pcs_sds/u_pcssds/pcs/pcs_mac_ctl0_ack (net)                                              2 
#  u_pcs_sds/u_pcssds/pcs/pcs_mac_ctl0_ack (prism_pcs_pezy_pcie_quad_pcie)                            0.0000 *   1.7690 f
#  u_pcs_sds/u_pcssds/pcs_mac_ctl0_ack (net) 
#  u_pcs_sds/u_pcssds/pcs_mac_ctl0_ack (prism_pcssds_pezy_pcie_quad_pcie)                             0.0000 *   1.7690 f
#  u_pcs_sds/phystatus0 (net) 
#  u_pcs_sds/phystatus0 (pcs_sds_pcie)                                                                0.0000 *   1.7690 f
#  o_rx_pipe_92__ISO_n0 (net) 
#  o_rx_pipe_92__ISO_U0/I (BUFFD20BWP12T)                                                             0.0080 *   1.7770 f
#  o_rx_pipe_92__ISO_U0/Z (BUFFD20BWP12T)                                                             0.0330 *   1.8100 f
#  o_rx_pipe[92] (net)                                                                        1 
#  o_rx_pipe[92] (out)                                                                                0.0010 *   1.8110 f
#  data arrival time                                                                                             1.8110
#
#  clock pcs_mac_tx_clk (rise edge)                                                                   2.0000     2.0000
#  clock network delay (propagated)                                                                   0.2166     2.2166
#  clock uncertainty                                                                                 -0.3000     1.9166
#  output external delay                                                                             -1.7000     0.2166
#  data required time                                                                                            0.2166
#  ---------------------------------------------------------------------------------------------------------------------------
#  data required time                                                                                            0.2166
#  data arrival time                                                                                            -1.8110
#  ---------------------------------------------------------------------------------------------------------------------------
#  slack (VIOLATED)                                                                                             -1.5944
#
#
#  Startpoint: u_pcs_sds/u_pcssds/pcs/mgmt_cmn/reset_mgmt_mptx_reg
#               (rising edge-triggered flip-flop clocked by pcs_mac_tx_clk)
#  Endpoint: o_rx_pipe[92]
#               (output port clocked by pcs_mac_tx_clk)
#  Path Group: REGOUT
#  Path Type: max
#  Min Clock Paths Derating Factor : 0.9500
#
#  Point                                                                                   Fanout       Incr       Path
#  ---------------------------------------------------------------------------------------------------------------------------
#  clock pcs_mac_tx_clk (rise edge)                                                                   0.0000     0.0000
#  clock network delay (propagated)                                                                   1.1810 *   1.1810
#  u_pcs_sds/u_pcssds/pcs/mgmt_cmn/reset_mgmt_mptx_reg/CP (SDFSND8BWP12T)                             0.0000     1.1810 r
#  u_pcs_sds/u_pcssds/pcs/mgmt_cmn/reset_mgmt_mptx_reg/Q (SDFSND8BWP12T)                              0.1280 *   1.3090 f
#  u_pcs_sds/u_pcssds/pcs/mgmt_cmn/reset_mgmt_mptx (net)                                      4 
#  u_pcs_sds/u_pcssds/pcs/mgmt_cmn/reset_mgmt_mptx (prism_pcs_mgmt_cmn_pcie)                          0.0000 *   1.3090 f
#  u_pcs_sds/u_pcssds/pcs/reset_mgmt_mptx (net) 
#  u_pcs_sds/u_pcssds/pcs/ALCP_U197PSYNOPT/I (INVD18BWP12T)                                           0.0030 *   1.3120 f
#  u_pcs_sds/u_pcssds/pcs/ALCP_U197PSYNOPT/ZN (INVD18BWP12T)                                          0.0190 *   1.3310 r
#  u_pcs_sds/u_pcssds/pcs/n198 (net)                                                          2 
#  u_pcs_sds/u_pcssds/pcs/ALCP_U171RTEOPT_I_ALCHIP_111004_U0/I (BUFFD12BWP12T)                        0.0130 *   1.3440 r
#  u_pcs_sds/u_pcssds/pcs/ALCP_U171RTEOPT_I_ALCHIP_111004_U0/Z (BUFFD12BWP12T)                        0.0350 *   1.3790 r
#  u_pcs_sds/u_pcssds/pcs/ALCP_U171RTEOPT_I_ALCHIP_111004_n0 (net)                            1 
#  u_pcs_sds/u_pcssds/pcs/ALCP_U171RTEOPT/I (BUFFD16BWP12T)                                           0.0610 *   1.4400 r
#  u_pcs_sds/u_pcssds/pcs/ALCP_U171RTEOPT/Z (BUFFD16BWP12T)                                           0.0510 *   1.4910 r
#  u_pcs_sds/u_pcssds/pcs/n1118 (net)                                                         1 
#  u_pcs_sds/u_pcssds/pcs/ALCP_U259RTEOPT/I (INVD18BWP12T)                                            0.0230 *   1.5140 r
#  u_pcs_sds/u_pcssds/pcs/ALCP_U259RTEOPT/ZN (INVD18BWP12T)                                           0.0200 *   1.5340 f
#  u_pcs_sds/u_pcssds/pcs/n1119 (net)                                                         6 
#  u_pcs_sds/u_pcssds/pcs/lane_0/reset_mgmt_mptx (prism_pcs_pezy_pcie_lane_3_pcie)                    0.0000 *   1.5340 f
#  u_pcs_sds/u_pcssds/pcs/lane_0/reset_mgmt_mptx (net) 
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/reset_mgmt_mptx (prism_pcs_cmn_lane_regs_3_pcie)       0.0000 *   1.5340 f
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/reset_mgmt_mptx (net) 
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U297RTEOPT/A1 (OAI211D2BWP12T)                    0.0640 *   1.5980 f
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U297RTEOPT/ZN (OAI211D2BWP12T)                    0.0730 *   1.6710 r



# done 



#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U298RTEOPT/I (INVD3BWP12T)                        0.0000 *   1.6710 r
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U298RTEOPT/ZN (INVD3BWP12T)                       0.0190 *   1.6900 f
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/n3610 (net)                                    1 
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U299RTEOPT/I (INVD4BWP12T)                        0.0000 *   1.6900 f
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U299RTEOPT/ZN (INVD4BWP12T)                       0.0180 *   1.7080 r
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/pcs_mac_ctl_ack (net)                          1 
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/pcs_mac_ctl_ack (prism_pcs_cmn_lane_regs_3_pcie)       0.0000 *   1.7080 r
#  u_pcs_sds/u_pcssds/pcs/lane_0/pcs_mac_ctl_ack (net) 
#  u_pcs_sds/u_pcssds/pcs/lane_0/pcs_mac_ctl_ack (prism_pcs_pezy_pcie_lane_3_pcie)                    0.0000 *   1.7080 r
#  u_pcs_sds/u_pcssds/pcs/n90 (net) 
#  u_pcs_sds/u_pcssds/pcs/ALCP_U257RTEOPT/I (INVD9BWP12T)                                             0.0000 *   1.7080 r
#  u_pcs_sds/u_pcssds/pcs/ALCP_U257RTEOPT/ZN (INVD9BWP12T)                                            0.0140 *   1.7220 f
#  u_pcs_sds/u_pcssds/pcs/n1116 (net)                                                         1 
#  u_pcs_sds/u_pcssds/pcs/ALCP_U258RTEOPT/I (INVD18BWP12T)                                            0.0010 *   1.7230 f
#  u_pcs_sds/u_pcssds/pcs/ALCP_U258RTEOPT/ZN (INVD18BWP12T)                                           0.0120 *   1.7350 r
#  u_pcs_sds/u_pcssds/pcs/pcs_mac_ctl0_ack (net)                                              2 
#  u_pcs_sds/u_pcssds/pcs/pcs_mac_ctl0_ack (prism_pcs_pezy_pcie_quad_pcie)                            0.0000 *   1.7350 r
#  u_pcs_sds/u_pcssds/pcs_mac_ctl0_ack (net) 
#  u_pcs_sds/u_pcssds/pcs_mac_ctl0_ack (prism_pcssds_pezy_pcie_quad_pcie)                             0.0000 *   1.7350 r
#  u_pcs_sds/phystatus0 (net) 
#  u_pcs_sds/phystatus0 (pcs_sds_pcie)                                                                0.0000 *   1.7350 r
#  o_rx_pipe_92__ISO_n0 (net) 
#  o_rx_pipe_92__ISO_U0/I (BUFFD20BWP12T)                                                             0.0080 *   1.7430 r
#  o_rx_pipe_92__ISO_U0/Z (BUFFD20BWP12T)                                                             0.0310 *   1.7740 r
#  o_rx_pipe[92] (net)                                                                        1 
#  o_rx_pipe[92] (out)                                                                                0.0010 *   1.7750 r
#  data arrival time                                                                                             1.7750
#
#  clock pcs_mac_tx_clk (rise edge)                                                                   2.0000     2.0000
#  clock network delay (propagated)                                                                   0.2166     2.2166
#  clock uncertainty                                                                                 -0.3000     1.9166
#  output external delay                                                                             -1.7000     0.2166
#  data required time                                                                                            0.2166
#  ---------------------------------------------------------------------------------------------------------------------------
#  data required time                                                                                            0.2166
#  data arrival time                                                                                            -1.7750
#  ---------------------------------------------------------------------------------------------------------------------------
#  slack (VIOLATED)                                                                                             -1.5584
#
#
#  Startpoint: u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/sync_mptx_ctl_ack/dout_reg
#               (rising edge-triggered flip-flop clocked by pcs_mac_tx_clk)
#  Endpoint: o_rx_pipe[92]
#               (output port clocked by pcs_mac_tx_clk)
#  Path Group: REGOUT
#  Path Type: max
#  Min Clock Paths Derating Factor : 0.9500
#
#  Point                                                                                       Fanout       Incr       Path
#  -------------------------------------------------------------------------------------------------------------------------------
#  clock pcs_mac_tx_clk (rise edge)                                                                       0.0000     0.0000
#  clock network delay (propagated)                                                                       1.2110 *   1.2110
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/sync_mptx_ctl_ack/dout_reg/CP (SEDFCNQD1BWP12THVT)         0.0000     1.2110 r
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/sync_mptx_ctl_ack/dout_reg/Q (SEDFCNQD1BWP12THVT)          0.1950 *   1.4060 f
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/sync_mptx_ctl_ack/n18 (net)                        1 
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/sync_mptx_ctl_ack/ALCP_U4RTEOPT/I (INVD3BWP12T)            0.0000 *   1.4060 f
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/sync_mptx_ctl_ack/ALCP_U4RTEOPT/ZN (INVD3BWP12T)           0.0250 *   1.4310 r
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/sync_mptx_ctl_ack/n16 (net)                        1 
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/sync_mptx_ctl_ack/ALCP_U5RTEOPT/I (INVD9BWP12T)            0.0000 *   1.4310 r
REWIRE u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/sync_mptx_ctl_ack/dout_reg/Q u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U295RTEOPT/C

#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/sync_mptx_ctl_ack/ALCP_U5RTEOPT/ZN (INVD9BWP12T)           0.0180 *   1.4490 f
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/sync_mptx_ctl_ack/dout (net)                       4 
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/sync_mptx_ctl_ack/dout (prism_sync_1shot_stb_7_pcie)       0.0000 *   1.4490 f
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/pcs_mac_ctl_ack_uq (net) 
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U295RTEOPT/C (RCAOI211D2BWP12T)                       0.0020 *   1.4510 f
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U295RTEOPT/ZN (RCAOI211D2BWP12T)                      0.0490 *   1.5000 r
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/n3606 (net)                                        1 
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U296RTEOPT/I (INVD1P75BWP12T)                         0.0000 *   1.5000 r
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U296RTEOPT/ZN (INVD1P75BWP12T)                        0.0170 *   1.5170 f
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/n3608 (net)                                        1 
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U131RTEOPT/I (INVD2BWP12T)                            0.0000 *   1.5170 f
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U131RTEOPT/ZN (INVD2BWP12T)                           0.0160 *   1.5330 r
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/n2361 (net)                                        1 
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U154PSYNOPT/I (BUFFD4BWP12T)                          0.0000 *   1.5330 r
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U154PSYNOPT/Z (BUFFD4BWP12T)                          0.0260 *   1.5590 r
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/n127 (net)                                         1 
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U297RTEOPT/A2 (OAI211D2BWP12T)                        0.0010 *   1.5600 r
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U297RTEOPT/ZN (OAI211D2BWP12T)                        0.0260 *   1.5860 f



# done 



#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U298RTEOPT/I (INVD3BWP12T)                            0.0000 *   1.5860 f
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U298RTEOPT/ZN (INVD3BWP12T)                           0.0280 *   1.6140 r
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/n3610 (net)                                        1 
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U299RTEOPT/I (INVD4BWP12T)                            0.0000 *   1.6140 r
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U299RTEOPT/ZN (INVD4BWP12T)                           0.0160 *   1.6300 f
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/pcs_mac_ctl_ack (net)                              1 
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/pcs_mac_ctl_ack (prism_pcs_cmn_lane_regs_3_pcie)           0.0000 *   1.6300 f
#  u_pcs_sds/u_pcssds/pcs/lane_0/pcs_mac_ctl_ack (net) 
#  u_pcs_sds/u_pcssds/pcs/lane_0/pcs_mac_ctl_ack (prism_pcs_pezy_pcie_lane_3_pcie)                        0.0000 *   1.6300 f
#  u_pcs_sds/u_pcssds/pcs/n90 (net) 
#  u_pcs_sds/u_pcssds/pcs/ALCP_U257RTEOPT/I (INVD9BWP12T)                                                 0.0000 *   1.6300 f
#  u_pcs_sds/u_pcssds/pcs/ALCP_U257RTEOPT/ZN (INVD9BWP12T)                                                0.0150 *   1.6450 r
#  u_pcs_sds/u_pcssds/pcs/n1116 (net)                                                             1 
#  u_pcs_sds/u_pcssds/pcs/ALCP_U258RTEOPT/I (INVD18BWP12T)                                                0.0010 *   1.6460 r
#  u_pcs_sds/u_pcssds/pcs/ALCP_U258RTEOPT/ZN (INVD18BWP12T)                                               0.0110 *   1.6570 f
#  u_pcs_sds/u_pcssds/pcs/pcs_mac_ctl0_ack (net)                                                  2 
#  u_pcs_sds/u_pcssds/pcs/pcs_mac_ctl0_ack (prism_pcs_pezy_pcie_quad_pcie)                                0.0000 *   1.6570 f
#  u_pcs_sds/u_pcssds/pcs_mac_ctl0_ack (net) 
#  u_pcs_sds/u_pcssds/pcs_mac_ctl0_ack (prism_pcssds_pezy_pcie_quad_pcie)                                 0.0000 *   1.6570 f
#  u_pcs_sds/phystatus0 (net) 
#  u_pcs_sds/phystatus0 (pcs_sds_pcie)                                                                    0.0000 *   1.6570 f
#  o_rx_pipe_92__ISO_n0 (net) 
#  o_rx_pipe_92__ISO_U0/I (BUFFD20BWP12T)                                                                 0.0080 *   1.6650 f
#  o_rx_pipe_92__ISO_U0/Z (BUFFD20BWP12T)                                                                 0.0330 *   1.6980 f
#  o_rx_pipe[92] (net)                                                                            1 
#  o_rx_pipe[92] (out)                                                                                    0.0010 *   1.6990 f
#  data arrival time                                                                                                 1.6990
#
#  clock pcs_mac_tx_clk (rise edge)                                                                       2.0000     2.0000
#  clock network delay (propagated)                                                                       0.2166     2.2166
#  clock uncertainty                                                                                     -0.3000     1.9166
#  output external delay                                                                                 -1.7000     0.2166
#  data required time                                                                                                0.2166
#  -------------------------------------------------------------------------------------------------------------------------------
#  data required time                                                                                                0.2166
#  data arrival time                                                                                                -1.6990
#  -------------------------------------------------------------------------------------------------------------------------------
#  slack (VIOLATED)                                                                                                 -1.4824
#
#
#  Startpoint: u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/sync_mptx_hold_ack/dout_reg
#               (rising edge-triggered flip-flop clocked by pcs_mac_tx_clk)
#  Endpoint: o_rx_pipe[92]
#               (output port clocked by pcs_mac_tx_clk)
#  Path Group: REGOUT
#  Path Type: max
#  Min Clock Paths Derating Factor : 0.9500
#
#  Point                                                                                   Fanout       Incr       Path
#  ---------------------------------------------------------------------------------------------------------------------------
#  clock pcs_mac_tx_clk (rise edge)                                                                   0.0000     0.0000
#  clock network delay (propagated)                                                                   1.2110 *   1.2110
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/sync_mptx_hold_ack/dout_reg/CP (SDFQD1BWP12THVT)       0.0000     1.2110 r
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/sync_mptx_hold_ack/dout_reg/Q (SDFQD1BWP12THVT)        0.2030 *   1.4140 f

set BUF [INSERT_BUFFER u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/sync_mptx_hold_ack_ret/din_sync1_reg_SI_ECO_8_U0/I BUFFD2BWP12T -location [get_location u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/sync_mptx_hold_ack/dout_reg/Q] ]REWIRE ${BUF}/Z u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/sync_mptx_hold_ack_ret/din_sync1_reg_D_ECO_7_U0/I

#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/sync_mptx_hold_ack/dout (net)                  3 
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/sync_mptx_hold_ack/dout (prism_sync_1b_109_pcie)       0.0000 *   1.4140 f
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/txctlifc_hold_ack_mptx (net) 
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U295RTEOPT/A1 (RCAOI211D2BWP12T)                  0.0000 *   1.4140 f
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U295RTEOPT/ZN (RCAOI211D2BWP12T)                  0.0330 *   1.4470 r
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/n3606 (net)                                    1 
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U296RTEOPT/I (INVD1P75BWP12T)                     0.0000 *   1.4470 r
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U296RTEOPT/ZN (INVD1P75BWP12T)                    0.0170 *   1.4640 f
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/n3608 (net)                                    1 
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U131RTEOPT/I (INVD2BWP12T)                        0.0000 *   1.4640 f
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U131RTEOPT/ZN (INVD2BWP12T)                       0.0160 *   1.4800 r
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/n2361 (net)                                    1 
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U154PSYNOPT/I (BUFFD4BWP12T)                      0.0000 *   1.4800 r
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U154PSYNOPT/Z (BUFFD4BWP12T)                      0.0260 *   1.5060 r
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/n127 (net)                                     1 
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U297RTEOPT/A2 (OAI211D2BWP12T)                    0.0010 *   1.5070 r
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U297RTEOPT/ZN (OAI211D2BWP12T)                    0.0260 *   1.5330 f



# done 



#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U298RTEOPT/I (INVD3BWP12T)                        0.0000 *   1.5330 f
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U298RTEOPT/ZN (INVD3BWP12T)                       0.0280 *   1.5610 r
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/n3610 (net)                                    1 
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U299RTEOPT/I (INVD4BWP12T)                        0.0000 *   1.5610 r
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U299RTEOPT/ZN (INVD4BWP12T)                       0.0160 *   1.5770 f
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/pcs_mac_ctl_ack (net)                          1 
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/pcs_mac_ctl_ack (prism_pcs_cmn_lane_regs_3_pcie)       0.0000 *   1.5770 f
#  u_pcs_sds/u_pcssds/pcs/lane_0/pcs_mac_ctl_ack (net) 
#  u_pcs_sds/u_pcssds/pcs/lane_0/pcs_mac_ctl_ack (prism_pcs_pezy_pcie_lane_3_pcie)                    0.0000 *   1.5770 f
#  u_pcs_sds/u_pcssds/pcs/n90 (net) 
#  u_pcs_sds/u_pcssds/pcs/ALCP_U257RTEOPT/I (INVD9BWP12T)                                             0.0000 *   1.5770 f
#  u_pcs_sds/u_pcssds/pcs/ALCP_U257RTEOPT/ZN (INVD9BWP12T)                                            0.0150 *   1.5920 r
#  u_pcs_sds/u_pcssds/pcs/n1116 (net)                                                         1 
#  u_pcs_sds/u_pcssds/pcs/ALCP_U258RTEOPT/I (INVD18BWP12T)                                            0.0010 *   1.5930 r
#  u_pcs_sds/u_pcssds/pcs/ALCP_U258RTEOPT/ZN (INVD18BWP12T)                                           0.0110 *   1.6040 f
#  u_pcs_sds/u_pcssds/pcs/pcs_mac_ctl0_ack (net)                                              2 
#  u_pcs_sds/u_pcssds/pcs/pcs_mac_ctl0_ack (prism_pcs_pezy_pcie_quad_pcie)                            0.0000 *   1.6040 f
#  u_pcs_sds/u_pcssds/pcs_mac_ctl0_ack (net) 
#  u_pcs_sds/u_pcssds/pcs_mac_ctl0_ack (prism_pcssds_pezy_pcie_quad_pcie)                             0.0000 *   1.6040 f
#  u_pcs_sds/phystatus0 (net) 
#  u_pcs_sds/phystatus0 (pcs_sds_pcie)                                                                0.0000 *   1.6040 f
#  o_rx_pipe_92__ISO_n0 (net) 
#  o_rx_pipe_92__ISO_U0/I (BUFFD20BWP12T)                                                             0.0080 *   1.6120 f
#  o_rx_pipe_92__ISO_U0/Z (BUFFD20BWP12T)                                                             0.0330 *   1.6450 f
#  o_rx_pipe[92] (net)                                                                        1 
#  o_rx_pipe[92] (out)                                                                                0.0010 *   1.6460 f
#  data arrival time                                                                                             1.6460
#
#  clock pcs_mac_tx_clk (rise edge)                                                                   2.0000     2.0000
#  clock network delay (propagated)                                                                   0.2166     2.2166
#  clock uncertainty                                                                                 -0.3000     1.9166
#  output external delay                                                                             -1.7000     0.2166
#  data required time                                                                                            0.2166
#  ---------------------------------------------------------------------------------------------------------------------------
#  data required time                                                                                            0.2166
#  data arrival time                                                                                            -1.6460
#  ---------------------------------------------------------------------------------------------------------------------------
#  slack (VIOLATED)                                                                                             -1.4294
#
#
#  Startpoint: u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/rdet_ack_reg
#               (rising edge-triggered flip-flop clocked by pcs_mac_tx_clk)
#  Endpoint: o_rx_pipe[92]
#               (output port clocked by pcs_mac_tx_clk)
#  Path Group: REGOUT
#  Path Type: max
#  Min Clock Paths Derating Factor : 0.9500
#
#  Point                                                                                   Fanout       Incr       Path
#  ---------------------------------------------------------------------------------------------------------------------------
#  clock pcs_mac_tx_clk (rise edge)                                                                   0.0000     0.0000
#  clock network delay (propagated)                                                                   1.2120 *   1.2120
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/rdet_ack_reg/CP (SDFQD4BWP12T)                         0.0000     1.2120 r
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/rdet_ack_reg/Q (SDFQD4BWP12T)                          0.1050 *   1.3170 f
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/rdet_ack (net)                                 3 
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U295RTEOPT/B (RCAOI211D2BWP12T)                   0.0010 *   1.3180 f
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U295RTEOPT/ZN (RCAOI211D2BWP12T)                  0.0420 *   1.3600 r
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/n3606 (net)                                    1 
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U296RTEOPT/I (INVD1P75BWP12T)                     0.0000 *   1.3600 r
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U296RTEOPT/ZN (INVD1P75BWP12T)                    0.0170 *   1.3770 f
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/n3608 (net)                                    1 
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U131RTEOPT/I (INVD2BWP12T)                        0.0000 *   1.3770 f
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U131RTEOPT/ZN (INVD2BWP12T)                       0.0160 *   1.3930 r
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/n2361 (net)                                    1 
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U154PSYNOPT/I (BUFFD4BWP12T)                      0.0000 *   1.3930 r
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U154PSYNOPT/Z (BUFFD4BWP12T)                      0.0260 *   1.4190 r
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/n127 (net)                                     1 
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U297RTEOPT/A2 (OAI211D2BWP12T)                    0.0010 *   1.4200 r
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U297RTEOPT/ZN (OAI211D2BWP12T)                    0.0260 *   1.4460 f



# done 



#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U298RTEOPT/I (INVD3BWP12T)                        0.0000 *   1.4460 f
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U298RTEOPT/ZN (INVD3BWP12T)                       0.0280 *   1.4740 r
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/n3610 (net)                                    1 
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U299RTEOPT/I (INVD4BWP12T)                        0.0000 *   1.4740 r
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/ALCP_U299RTEOPT/ZN (INVD4BWP12T)                       0.0160 *   1.4900 f
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/pcs_mac_ctl_ack (net)                          1 
#  u_pcs_sds/u_pcssds/pcs/lane_0/cmn_lane_regs/pcs_mac_ctl_ack (prism_pcs_cmn_lane_regs_3_pcie)       0.0000 *   1.4900 f
#  u_pcs_sds/u_pcssds/pcs/lane_0/pcs_mac_ctl_ack (net) 
#  u_pcs_sds/u_pcssds/pcs/lane_0/pcs_mac_ctl_ack (prism_pcs_pezy_pcie_lane_3_pcie)                    0.0000 *   1.4900 f
#  u_pcs_sds/u_pcssds/pcs/n90 (net) 
#  u_pcs_sds/u_pcssds/pcs/ALCP_U257RTEOPT/I (INVD9BWP12T)                                             0.0000 *   1.4900 f
#  u_pcs_sds/u_pcssds/pcs/ALCP_U257RTEOPT/ZN (INVD9BWP12T)                                            0.0150 *   1.5050 r
#  u_pcs_sds/u_pcssds/pcs/n1116 (net)                                                         1 
#  u_pcs_sds/u_pcssds/pcs/ALCP_U258RTEOPT/I (INVD18BWP12T)                                            0.0010 *   1.5060 r
#  u_pcs_sds/u_pcssds/pcs/ALCP_U258RTEOPT/ZN (INVD18BWP12T)                                           0.0110 *   1.5170 f
#  u_pcs_sds/u_pcssds/pcs/pcs_mac_ctl0_ack (net)                                              2 
#  u_pcs_sds/u_pcssds/pcs/pcs_mac_ctl0_ack (prism_pcs_pezy_pcie_quad_pcie)                            0.0000 *   1.5170 f
#  u_pcs_sds/u_pcssds/pcs_mac_ctl0_ack (net) 
#  u_pcs_sds/u_pcssds/pcs_mac_ctl0_ack (prism_pcssds_pezy_pcie_quad_pcie)                             0.0000 *   1.5170 f
#  u_pcs_sds/phystatus0 (net) 
#  u_pcs_sds/phystatus0 (pcs_sds_pcie)                                                                0.0000 *   1.5170 f
#  o_rx_pipe_92__ISO_n0 (net) 
#  o_rx_pipe_92__ISO_U0/I (BUFFD20BWP12T)                                                             0.0080 *   1.5250 f
#  o_rx_pipe_92__ISO_U0/Z (BUFFD20BWP12T)                                                             0.0330 *   1.5580 f
#  o_rx_pipe[92] (net)                                                                        1 
#  o_rx_pipe[92] (out)                                                                                0.0010 *   1.5590 f
#  data arrival time                                                                                             1.5590
#
#  clock pcs_mac_tx_clk (rise edge)                                                                   2.0000     2.0000
#  clock network delay (propagated)                                                                   0.2166     2.2166
#  clock uncertainty                                                                                 -0.3000     1.9166
#  output external delay                                                                             -1.7000     0.2166
#  data required time                                                                                            0.2166
#  ---------------------------------------------------------------------------------------------------------------------------
#  data required time                                                                                            0.2166
#  data arrival time                                                                                            -1.5590
#  ---------------------------------------------------------------------------------------------------------------------------
#  slack (VIOLATED)                                                                                             -1.3424
#
#
#1
#****************************************
#Report : timing
#	-path_type full
#	-delay_type max
#	-input_pins
#	-nets
#	-nworst 100
#	-max_paths 99999
#	-unique_pins
#Design : pcs_sds_pipe
#Version: C-2009.06-SP3-1
#Date   : Wed Nov 16 12:38:26 2011
#****************************************
#
#
#  Startpoint: u_pcs_sds/u_pcssds/pcs/lane_3/pcie_rx/pcs_mac_rx_pcie_data_reg_5_
#               (rising edge-triggered flip-flop clocked by pcs_mac_tx_clk)
#  Endpoint: o_rx_pipe[12]
#               (output port clocked by pcs_mac_tx_clk)
#  Path Group: REGOUT
#  Path Type: max
#  Min Clock Paths Derating Factor : 0.9500
#
#  Point                                                                               Fanout       Incr       Path
#  -----------------------------------------------------------------------------------------------------------------------
#  clock pcs_mac_tx_clk (rise edge)                                                               0.0000     0.0000
#  clock network delay (propagated)                                                               1.2130 *   1.2130
#  u_pcs_sds/u_pcssds/pcs/lane_3/pcie_rx/pcs_mac_rx_pcie_data_reg_5_/CP (SDFCNQD4BWP12T)          0.0000     1.2130 r
#  u_pcs_sds/u_pcssds/pcs/lane_3/pcie_rx/pcs_mac_rx_pcie_data_reg_5_/Q (SDFCNQD4BWP12T)           0.1080 *   1.3210 f
#  u_pcs_sds/u_pcssds/pcs/lane_3/pcie_rx/n2905 (net)                                      3 
#  u_pcs_sds/u_pcssds/pcs/lane_3/pcie_rx/ALCP_U218PLCOPT/I (BUFFD16BWP12T)                        0.0010 *   1.3220 f
#  u_pcs_sds/u_pcssds/pcs/lane_3/pcie_rx/ALCP_U218PLCOPT/Z (BUFFD16BWP12T)                        0.0340 *   1.3560 f
#  u_pcs_sds/u_pcssds/pcs/lane_3/pcie_rx/n763 (net)                                       2 
#  u_pcs_sds/u_pcssds/pcs/lane_3/pcie_rx/ALCP_U228PLCOPT/I (BUFFD16BWP12T)                        0.0180 *   1.3740 f
#  u_pcs_sds/u_pcssds/pcs/lane_3/pcie_rx/ALCP_U228PLCOPT/Z (BUFFD16BWP12T)                        0.0440 *   1.4180 f
#  u_pcs_sds/u_pcssds/pcs/lane_3/pcie_rx/pcs_mac_rx_pcie_data[5] (net)                    1 
#  u_pcs_sds/u_pcssds/pcs/lane_3/pcie_rx/pcs_mac_rx_pcie_data[5] (prism_pcs_pcie_rx_0_pcie)       0.0000 *   1.4180 f
#  u_pcs_sds/u_pcssds/pcs/lane_3/pcs_mac_rx_pcie_data[5] (net) 
#  u_pcs_sds/u_pcssds/pcs/lane_3/pcs_mac_rx_pcie_data[5] (prism_pcs_pezy_pcie_lane_0_pcie)        0.0000 *   1.4180 f
#  u_pcs_sds/u_pcssds/pcs/pcs_mac_rx3_pcie_data[5] (net) 
#  u_pcs_sds/u_pcssds/pcs/pcs_mac_rx3_pcie_data[5] (prism_pcs_pezy_pcie_quad_pcie)                0.0000 *   1.4180 f
#  u_pcs_sds/u_pcssds/pcs_mac_rx3_pcie_data[5] (net) 
#  u_pcs_sds/u_pcssds/pcs_mac_rx3_pcie_data[5] (prism_pcssds_pezy_pcie_quad_pcie)                 0.0000 *   1.4180 f
#  u_pcs_sds/rxdata3[5] (net) 
#  u_pcs_sds/rxdata3[5] (pcs_sds_pcie)                                                            0.0000 *   1.4180 f
#  o_rx_pipe_12__ISO_n0 (net) 
#  o_rx_pipe_12__ISO_U0/I (BUFFD20BWP12T)                                                         0.0630 *   1.4810 f
#  o_rx_pipe_12__ISO_U0/Z (BUFFD20BWP12T)                                                         0.0620 *   1.5430 f
#  o_rx_pipe[12] (net)                                                                    1 
#  o_rx_pipe[12] (out)                                                                            0.0010 *   1.5440 f
#  data arrival time                                                                                         1.5440
#
#  clock pcs_mac_tx_clk (rise edge)                                                               2.0000     2.0000
#  clock network delay (propagated)                                                               0.2166     2.2166
#  clock uncertainty                                                                             -0.3000     1.9166
#  output external delay                                                                         -1.7000     0.2166
#  data required time                                                                                        0.2166
#  -----------------------------------------------------------------------------------------------------------------------
#  data required time                                                                                        0.2166
#  data arrival time                                                                                        -1.5440
#  -----------------------------------------------------------------------------------------------------------------------
#  slack (VIOLATED)                                                                                         -1.3274
#
#
#         Driver(pin): u_pcs_sds/u_pcssds/pcs/lane_3/pcie_rx/pcs_mac_rx_pcie_data_reg_5_/Q
# ===> Load num: 3
#         Load(pin): u_pcs_sds/u_pcssds/pcs/lane_3/pcie_rx/ALCP_U218PLCOPT/I
#         Load(pin): u_pcs_sds/u_pcssds/pcs/lane_3/pcie_rx/pcs_mac_rx_pcie_data_reg_6__SI_ECO_7_U0/I
#         Load(pin): u_pcs_sds/u_pcssds/pcs/lane_3/pcie_rx/udtp_sink_1242_TDGO_reg_D_ECO_7_U0/I
REWIRE u_pcs_sds/u_pcssds/pcs/lane_3/pcie_rx/ALCP_U218PLCOPT/Z u_pcs_sds/u_pcssds/pcs/lane_3/pcie_rx/pcs_mac_rx_pcie_data_reg_6__SI_ECO_7_U0/I
REWIRE u_pcs_sds/u_pcssds/pcs/lane_3/pcie_rx/ALCP_U218PLCOPT/Z u_pcs_sds/u_pcssds/pcs/lane_3/pcie_rx/udtp_sink_1242_TDGO_reg_D_ECO_7_U0/I
REWIRE u_pcs_sds/u_pcssds/pcs/lane_3/pcie_rx/pcs_mac_rx_pcie_data_reg_5_/Q o_rx_pipe_12__ISO_U0/I

INSERT_BUFFER o_rx_pipe_12__ISO_U0/I INVD20BWP12TLVT -location {2 1584}
INSERT_BUFFER o_rx_pipe_12__ISO_U0/I INVD20BWP12TLVT -location {2 1794}
INSERT_BUFFER o_rx_pipe_12__ISO_U0/I INVD20BWP12TLVT -location {1 2004}
CHANGE_BUF2INV o_rx_pipe_12__ISO_U0 INVD20BWP12TLVT

