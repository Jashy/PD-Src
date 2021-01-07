# $Header: /datatop/xhg0028a/wyvern/cvs/wyvern/R3/pt/common/all/timing_derate.tcl,v 1.1.1.1 2008/07/04 07:40:45 l202770a Exp $
#
# マージン設定
#

if { $mode == "ocv_setup" } {
    switch $pvt_wire {
      "wcl_cworst" {
           set HighVth_cell_early_margin 1.141
           set HighVth_cell_late_margin  1.409
           set StdVth_cell_early_margin  1.106
           set StdVth_cell_late_margin   1.251
           set net_early_margin          0.814
           set net_late_margin           0.837

           set_timing_derate -early ${StdVth_cell_early_margin} -cell_delay
           set_timing_derate -late  ${StdVth_cell_late_margin}  -cell_delay
           set_timing_derate -early ${HighVth_cell_early_margin} [get_lib_cells "tcbn65lphvtwcl/*"] -cell_delay
           set_timing_derate -late  ${HighVth_cell_late_margin}  [get_lib_cells "tcbn65lphvtwcl/*"] -cell_delay
           set_timing_derate -early ${net_early_margin}         -net_delay
           set_timing_derate -late  ${net_late_margin}          -net_delay
       }
      "wc_cworst" {
           set HighVth_cell_early_margin 1.069
           set HighVth_cell_late_margin  1.298
           set StdVth_cell_early_margin  1.070
           set StdVth_cell_late_margin   1.186
           set net_early_margin          1.270
           set net_late_margin           1.304

           set_timing_derate -early ${StdVth_cell_early_margin} -cell_delay
           set_timing_derate -late  ${StdVth_cell_late_margin}  -cell_delay
           set_timing_derate -early ${HighVth_cell_early_margin} [get_lib_cells "tcbn65lphvtwc/*"] -cell_delay
           set_timing_derate -late  ${HighVth_cell_late_margin}  [get_lib_cells "tcbn65lphvtwc/*"] -cell_delay
           set_timing_derate -early ${net_early_margin}         -net_delay
           set_timing_derate -late  ${net_late_margin}          -net_delay
       }
    } ;#end of switch

} elseif { $mode == "ocv_hold" } {
    switch $pvt_wire {
      "lt_cbest" {
           set HighVth_cell_early_margin 0.892
           set HighVth_cell_late_margin  1.095
           set StdVth_cell_early_margin  0.924
           set StdVth_cell_late_margin   1.059
           set net_early_margin          0.806
           set net_late_margin           0.848

           set_timing_derate -early ${StdVth_cell_early_margin} -cell_delay
           set_timing_derate -late  ${StdVth_cell_late_margin}  -cell_delay
           set_timing_derate -early ${HighVth_cell_early_margin} [get_lib_cells "tcbn65lphvtlt/*"] -cell_delay
           set_timing_derate -late  ${HighVth_cell_late_margin}  [get_lib_cells "tcbn65lphvtlt/*"] -cell_delay
           set_timing_derate -early ${net_early_margin}         -net_delay
           set_timing_derate -late  ${net_late_margin}          -net_delay
       }
      "ml_cbest" {
           set HighVth_cell_early_margin 0.894
           set HighVth_cell_late_margin  1.093
           set StdVth_cell_early_margin  0.926
           set StdVth_cell_late_margin   1.056
           set net_early_margin          1.259
           set net_late_margin           1.320

           set_timing_derate -early ${StdVth_cell_early_margin} -cell_delay
           set_timing_derate -late  ${StdVth_cell_late_margin}  -cell_delay
           set_timing_derate -early ${HighVth_cell_early_margin} [get_lib_cells "tcbn65lphvt_c070507ml/*"] -cell_delay
           set_timing_derate -late  ${HighVth_cell_late_margin}  [get_lib_cells "tcbn65lphvt_c070507ml/*"] -cell_delay
           set_timing_derate -early ${net_early_margin}         -net_delay
           set_timing_derate -late  ${net_late_margin}          -net_delay
       }
      "wcl_cbest" {
           set HighVth_cell_early_margin 0.878
           set HighVth_cell_late_margin  1.115
           set StdVth_cell_early_margin  0.916
           set StdVth_cell_late_margin   1.069
           set net_early_margin          0.807
           set net_late_margin           0.847

           set_timing_derate -early ${StdVth_cell_early_margin} -cell_delay
           set_timing_derate -late  ${StdVth_cell_late_margin}  -cell_delay
           set_timing_derate -early ${HighVth_cell_early_margin} [get_lib_cells "tcbn65lphvtwcl/*"] -cell_delay
           set_timing_derate -late  ${HighVth_cell_late_margin}  [get_lib_cells "tcbn65lphvtwcl/*"] -cell_delay
           set_timing_derate -early ${net_early_margin}         -net_delay
           set_timing_derate -late  ${net_late_margin}          -net_delay
       }
      "wc_cworst" {
           set HighVth_cell_early_margin 0.884
           set HighVth_cell_late_margin  1.107
           set StdVth_cell_early_margin  0.923
           set StdVth_cell_late_margin   1.060
           set net_early_margin          1.260
           set net_late_margin           1.319

           set_timing_derate -early ${StdVth_cell_early_margin} -cell_delay
           set_timing_derate -late  ${StdVth_cell_late_margin}  -cell_delay
           set_timing_derate -early ${HighVth_cell_early_margin} [get_lib_cells "tcbn65lphvtwc/*"] -cell_delay
           set_timing_derate -late  ${HighVth_cell_late_margin}  [get_lib_cells "tcbn65lphvtwc/*"] -cell_delay
           set_timing_derate -early ${net_early_margin}         -net_delay
           set_timing_derate -late  ${net_late_margin}          -net_delay
       }
    } ;#end of switch

} ;#end of if

