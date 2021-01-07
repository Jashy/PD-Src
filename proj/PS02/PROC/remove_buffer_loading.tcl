
source /user/home/marshals/for_jason/DELETE_BUFFER.tcl

proc remove_buffer_loading_sub { driver } {
  set loading [ get_loads $driver ]

  set exists_buf 0
  set delete ""
  foreach_in_collection load $loading {
    set cell [ get_cells -of $load ]
    set ref_name [ get_attr $cell ref_name ]
    if { [ regexp {BUFV|INV|CLKNV} $ref_name ] != 1 } { continue }
    puts "*INFO* DELETE_BUFFER [ get_attr $cell full_name ]"
    set delete [ concat $delete [ get_attr $cell full_name ] ]
    set exists_buf 1
  }
  foreach cell $delete {
    DELETE_BUFFER $cell
  }
  return $exists_buf
}

proc remove_buffer_loading { driver } {
  set loading [ get_loads $driver ]
  set exists_buf 0

  foreach_in_collection load $loading {
    set cell [ get_cells -of $load ]
    set ref_name [ get_attr $cell ref_name ]
    if { [ regexp {BUFV|INV|CLKNV} $ref_name ] != 1 } { continue }
    set exists_buf 1
  }

  while { $exists_buf } {
    set exists_buf [ remove_buffer_loading_sub $driver ]
  }
}


remove_buffer_loading UUruby_dft/ruby_core/sys/sys_ctrl/garnet_ref_and_reset/VBG
remove_buffer_loading UUruby_dft/ruby_core/sys/sys_ctrl/garnet_ref_and_reset/IREFO_1
remove_buffer_loading UUruby_dft/ruby_core/sys/sys_ctrl/garnet_ref_and_reset/IREFO_2
remove_buffer_loading UUruby_dft/ruby_core/sys/sys_ctrl/garnet_ref_and_reset/IREFO_3
remove_buffer_loading UUruby_dft/ruby_core/sys/sys_ctrl/garnet_ref_and_reset/IREFO_4
remove_buffer_loading UUruby_dft/ruby_core/sys/sys_ctrl/garnet_ref_and_reset/IREFO_5
remove_buffer_loading UUruby_dft/ruby_core/sys/sys_ctrl/garnet_ref_and_reset/IREFO_6
remove_buffer_loading UUruby_dft/ruby_core/sys/sys_ctrl/garnet_ref_and_reset/IREFO_7
remove_buffer_loading UUruby_dft/ruby_core/sys/sys_ctrl/garnet_ref_and_reset/IREFO_8
remove_buffer_loading UUruby_dft/ruby_core/sys/sys_ctrl/garnet_ref_and_reset/IREFO_9
remove_buffer_loading UUruby_dft/ruby_core/sys/sys_ctrl/garnet_ref_and_reset/IREFO_10
remove_buffer_loading UUruby_dft/ruby_core/sys/sys_ctrl/garnet_ref_and_reset/IREFO_11
remove_buffer_loading UUruby_dft/ruby_core/sys/sys_ctrl/garnet_ref_and_reset/IREFO_12

