#########################################################################
# hfn opt
#
#set_clock_tree_references -references  {BUFFD16 BUFFD12 BUFFD10 BUFFD8 BUFFD6 BUFFD4 INVD16 INVD12 INVD10 INVD8 INVD6}
#foreach net $hfn_list {
#       set_dont_touch $net_ISO_n false
#       reset_path -through $net_ISO_U/Z
#       compile_clock_tree -high_fanout_net $net_ISO_n
#}

