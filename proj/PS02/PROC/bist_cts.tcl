bist_clk_100m
bist_clk_50m
set bist_list { U_i_ren3ot_0_Alchip_pinshare_eco0_4/U1/Z U_i_rxtlen_0_Alchip_pinshare_eco0_5/U1/Z }
remove_buffer_tree -from $bist_list
set_clock_tree_references -references  {BUFFD16 BUFFD12 BUFFD8 BUFFD6 BUFFD4 }

#compile_clock_tree -high_fanout_net ${hfn_list}
compile_clock_tree -high_fanout_net ${bist_list}


