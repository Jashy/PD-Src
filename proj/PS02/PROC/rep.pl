#! /usr/bin/perl -w
#@pins = #u_pcie_front_u_localbus_rx_5to1_u_mcmd_xbarsel_u0_5to1_mcmd_sel_u_inport_fifo_u_inport_fifo_u_mcmd_fifo_r_data_out_reg_6_\/D u_pcie_front_u_localbus_rx_5to1_u_mcmd_xbarsel_u0_5to1_mcmd_sel_u_inport_fifo_u_mcmd_sync_out_r_write_data_lock_reg_0_\/D u_pcie_front_u_rxdma_u_data_if_u_start_point_r_read_pointer_reg_2_\/D#;
#$pins = "wo/xx a/xx";
#@pins = (split /\s+/, $pins);
my $i = 0;
my @b;
my $a = "u_pcie_front_u_localbus_rx_5to1_u_mcmd_xbarsel_u0_5to1_mcmd_sel_u_inport_fifo_u_mcmd_sync_out_r_write_data_lock_reg_0_/D u_pcie_front_u_localbus_rx_5to1_u_mcmd_xbarsel_u0_5to1_mcmd_sel_u_inport_fifo_u_inport_fifo_u_mcmd_fifo_r_data_out_reg_6_/D  u_pcie_front_u_rxdma_u_data_if_u_start_point_r_read_pointer_reg_2_/D ";
my @a = split /\s+/,$a; 

foreach $r (@a) {
open IN , "<report_timing_internal.rep";
 while (<IN>) {
 chomp;
$i++;
$b[$i] = $_;
   if (/$r/) {
print "$b[$i-3]\n";
$i = 0;
# print "$_\n";
  }
 }
}
