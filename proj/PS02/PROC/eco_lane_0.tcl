# u_pcs_sds/u_pcssds/pcs/lane_0/pcie_rx/fifo_init_prx_reg/CP -0.559
# u_pcs_sds/u_pcssds/pcs/lane_0/pcie_rx/fifo_init_prx_reg/CP
create_cell u_pcs_sds/u_pcssds/pcs/lane_0/pcie_rx/fifo_init_prx_reg_CP_MUX_U0 CKMUX2D2BWP12T
set location [get_location u_pcs_sds/u_pcssds/pcs/lane_3/pcie_rx/fifo_init_prx_reg ]
move_object u_pcs_sds/u_pcssds/pcs/lane_0/pcie_rx/fifo_init_prx_reg_CP_MUX_U0 -to $location
create_net  u_pcs_sds/u_pcssds/pcs/lane_0/pcie_rx/fifo_init_prx_reg_CP_MUX_n1
set net [ get_nets -of u_pcs_sds/u_pcssds/pcs/lane_0/pcie_rx/fifo_init_prx_reg/CP ]
connect_net $net u_pcs_sds/u_pcssds/pcs/lane_0/pcie_rx/fifo_init_prx_reg_CP_MUX_U0/I1
connect_net $net u_pcs_sds/u_pcssds/pcs/lane_0/pcie_rx/fifo_init_prx_reg_CP_MUX_U0/I0
connect_net u_pcs_sds/u_pcssds/pcs/lane_0/pcie_rx/fifo_init_prx_reg_CP_MUX_n1 u_pcs_sds/u_pcssds/pcs/lane_0/pcie_rx/fifo_init_prx_reg_CP_MUX_U0/Z
disconnect_net $net u_pcs_sds/u_pcssds/pcs/lane_0/pcie_rx/fifo_init_prx_reg/CP
connect_net u_pcs_sds/u_pcssds/pcs/lane_0/pcie_rx/fifo_init_prx_reg_CP_MUX_n1 u_pcs_sds/u_pcssds/pcs/lane_0/pcie_rx/fifo_init_prx_reg/CP
connect_net u_pcs_sds/u_pcssds/pcs/lane_0/pcie_rx/fifo_init_prx_reg_CP_MUX_n1 u_pcs_sds/u_pcssds/pcs/lane_0/pcie_rx/fifo_init_prx_reg_CP_MUX_U0/S
REWIRE ScanMode_ISO_U0/Z u_pcs_sds/u_pcssds/pcs/lane_0/pcie_rx/fifo_init_prx_reg_CP_MUX_U0/S
INSERT_BUFFER u_pcs_sds/u_pcssds/pcs/lane_0/pcie_rx/fifo_init_prx_reg_CP_MUX_U0/I0 CKBD2BWP12T -place
INSERT_BUFFER u_pcs_sds/u_pcssds/pcs/lane_0/pcie_rx/fifo_init_prx_reg_CP_MUX_U0/I0 CKBD2BWP12T -place
INSERT_BUFFER u_pcs_sds/u_pcssds/pcs/lane_0/pcie_rx/fifo_init_prx_reg_CP_MUX_U0/I0 CKBD2BWP12T -place
INSERT_BUFFER u_pcs_sds/u_pcssds/pcs/lane_0/pcie_rx/fifo_init_prx_reg_CP_MUX_U0/I0 CKBD2BWP12T -place
INSERT_BUFFER u_pcs_sds/u_pcssds/pcs/lane_0/pcie_rx/fifo_init_prx_reg_CP_MUX_U0/I0 CKBD2BWP12T -place
INSERT_BUFFER u_pcs_sds/u_pcssds/pcs/lane_0/pcie_rx/fifo_init_prx_reg_CP_MUX_U0/I0 CKBD2BWP12T -place
INSERT_BUFFER u_pcs_sds/u_pcssds/pcs/lane_0/pcie_rx/fifo_init_prx_reg_CP_MUX_U0/I0 CKBD2BWP12T -place
INSERT_BUFFER u_pcs_sds/u_pcssds/pcs/lane_0/pcie_rx/fifo_init_prx_reg_CP_MUX_U0/I0 CKBD2BWP12T -place
INSERT_BUFFER u_pcs_sds/u_pcssds/pcs/lane_0/pcie_rx/fifo_init_prx_reg_CP_MUX_U0/I0 CKBD2BWP12T -place
INSERT_BUFFER u_pcs_sds/u_pcssds/pcs/lane_0/pcie_rx/fifo_init_prx_reg_CP_MUX_U0/I0 CKBD2BWP12T -place
INSERT_BUFFER u_pcs_sds/u_pcssds/pcs/lane_0/pcie_rx/fifo_init_prx_reg_CP_MUX_U0/I0 CKBD2BWP12T -place
INSERT_BUFFER u_pcs_sds/u_pcssds/pcs/lane_0/pcie_rx/fifo_init_prx_reg_CP_MUX_U0/I0 CKBD2BWP12T -place
INSERT_BUFFER u_pcs_sds/u_pcssds/pcs/lane_0/pcie_rx/fifo_init_prx_reg_CP_MUX_U0/I0 CKBD2BWP12T -place
INSERT_BUFFER u_pcs_sds/u_pcssds/pcs/lane_0/pcie_rx/fifo_init_prx_reg_CP_MUX_U0/I0 CKBD2BWP12T -place
INSERT_BUFFER u_pcs_sds/u_pcssds/pcs/lane_0/pcie_rx/fifo_init_prx_reg_CP_MUX_U0/I0 CKBD2BWP12T -place
INSERT_BUFFER u_pcs_sds/u_pcssds/pcs/lane_0/pcie_rx/fifo_init_prx_reg_CP_MUX_U0/I0 CKBD2BWP12T -place
INSERT_BUFFER u_pcs_sds/u_pcssds/pcs/lane_0/pcie_rx/fifo_init_prx_reg_CP_MUX_U0/I0 CKBD2BWP12T -place
INSERT_BUFFER u_pcs_sds/u_pcssds/pcs/lane_0/pcie_rx/fifo_init_prx_reg_CP_MUX_U0/I0 CKBD2BWP12T -place
INSERT_BUFFER u_pcs_sds/u_pcssds/pcs/lane_0/pcie_rx/fifo_init_prx_reg_CP_MUX_U0/I0 CKBD2BWP12T -place
INSERT_BUFFER u_pcs_sds/u_pcssds/pcs/lane_0/pcie_rx/fifo_init_prx_reg_CP_MUX_U0/I0 CKBD2BWP12T -place


