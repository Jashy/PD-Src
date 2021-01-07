proc report_std_cell_area {cells} {
  set total_area 0
  foreach_in_collection cell $cells {
    set cell_area  [get_attribute [get_cells $cell] area -quiet]
    if {$cell_area != ""} {
      set total_area [expr $total_area + $cell_area]
    }
  }
  return $total_area
}

proc report_std_cell_count {cells} {
  set cell_count [sizeof_collection [get_cells $cells]]
  return $cell_count
}

proc report_cell_area {rpt} {
  set ALL_STD_CELL [get_cells -hierarchical -filter "ref_name=~*BWP*"]
  set total_count [sizeof_collection $ALL_STD_CELL]
  set total_area  [report_std_cell_area $ALL_STD_CELL]
  set ND2D1_area  [lindex [get_attribute [get_lib_cells */ND2D1BWP*] area] 0]

  set nvt_cells [get_cells $ALL_STD_CELL -filter "ref_name =~ *BWP35"]
  set hvt_cells [get_cells $ALL_STD_CELL -filter "ref_name =~ *BWP35HVT"]
  set lvt_cells [get_cells $ALL_STD_CELL -filter "ref_name =~ *BWP35LVT"]
  set ulvt_cells [get_cells $ALL_STD_CELL -filter "ref_name =~ *BWP35ULVT"]
#  set lvt22_cells [get_cells $ALL_STD_CELL -filter "ref_name =~ *BWP22P90LVT"]
#  set lvt24_cells [get_cells $ALL_STD_CELL -filter "ref_name =~ *BWP24P90LVT"]
#  set ulvt20_cells [get_cells $ALL_STD_CELL -filter "ref_name =~ *BWP20P90ULVT"]
#  set ulvt22_cells [get_cells $ALL_STD_CELL -filter "ref_name =~ *BWP22P90ULVT"]
#  set ulvt24_cells [get_cells $ALL_STD_CELL -filter "ref_name =~ *BWP24P90ULVT"]
#  set elvt24_cells [get_cells $ALL_STD_CELL -filter "ref_name =~ *BWP24P90ELVT"]

  set nvt_area [report_std_cell_area $nvt_cells]
  set hvt_area [report_std_cell_area $hvt_cells]
  set lvt_area [report_std_cell_area $lvt_cells]
  set ulvt_area [report_std_cell_area $ulvt_cells]
#  set lvt22_area [report_std_cell_area $lvt22_cells]
#  set lvt24_area [report_std_cell_area $lvt24_cells]
#  set ulvt20_area [report_std_cell_area $ulvt20_cells]
#  set ulvt22_area [report_std_cell_area $ulvt22_cells]
#  set ulvt24_area [report_std_cell_area $ulvt24_cells]
#  set elvt24_area [report_std_cell_area $elvt24_cells]

  set nvt_count [report_std_cell_count $nvt_cells]
  set hvt_count [report_std_cell_count $hvt_cells]
  set lvt_count [report_std_cell_count $lvt_cells]
  set ulvt_count [report_std_cell_count $ulvt_cells]
#  set lvt22_count [report_std_cell_count $lvt22_cells]
#  set lvt24_count [report_std_cell_count $lvt24_cells]
#  set ulvt20_count [report_std_cell_count $ulvt20_cells]
#  set ulvt22_count [report_std_cell_count $ulvt22_cells]
#  set ulvt24_count [report_std_cell_count $ulvt24_cells]
#  set elvt24_count [report_std_cell_count $elvt24_cells]

echo "" > ./$rpt
echo [format " nvt cell area:  %13.3f (%7.3f" $nvt_area   [expr ($nvt_area*0.1) / ($total_area*0.1) *100]]%)    [format " nvt cell count:  %13d (%7.3f" $nvt_count  [expr ($nvt_count*0.1) / ($total_count*0.1) *100]]%)  >> ./$rpt
echo [format " hvt cell area:  %13.3f (%7.3f" $hvt_area   [expr ($hvt_area*0.1) / ($total_area*0.1) *100]]%)    [format " hvt cell count:  %13d (%7.3f" $hvt_count  [expr ($hvt_count*0.1) / ($total_count*0.1) *100]]%)  >> ./$rpt
echo [format " lvt cell area:  %13.3f (%7.3f" $lvt_area   [expr ($lvt_area*0.1) / ($total_area*0.1) *100]]%)    [format " lvt cell count:  %13d (%7.3f" $lvt_count  [expr ($lvt_count*0.1) / ($total_count*0.1) *100]]%)  >> ./$rpt
echo [format " ulvt cell area:  %13.3f (%7.3f" $ulvt_area   [expr ($ulvt_area*0.1) / ($total_area*0.1) *100]]%)    [format " ulvt cell count:  %13d (%7.3f" $ulvt_count  [expr ($ulvt_count*0.1) / ($total_count*0.1) *100]]%)  >> ./$rpt
#echo [format " lvt22 cell area:  %13.3f (%7.3f" $lvt22_area   [expr ($lvt22_area*0.1) / ($total_area*0.1) *100]]%)    [format " lvt22 cell count:  %13d (%7.3f" $lvt22_count  [expr ($lvt22_count*0.1) / ($total_count*0.1) *100]]%)  >> ./$rpt
#echo [format " lvt24 cell area:  %13.3f (%7.3f" $lvt24_area   [expr ($lvt24_area*0.1) / ($total_area*0.1) *100]]%)    [format " lvt24 cell count:  %13d (%7.3f" $lvt24_count  [expr ($lvt24_count*0.1) / ($total_count*0.1) *100]]%)  >> ./$rpt
#echo [format " ulvt20 cell area:  %13.3f (%7.3f" $ulvt20_area   [expr ($ulvt20_area*0.1) / ($total_area*0.1) *100]]%)    [format " ulvt20 cell count:  %13d (%7.3f" $ulvt20_count  [expr ($ulvt20_count*0.1) / ($total_count*0.1) *100]]%)  >> ./$rpt
#echo [format " ulvt22 cell area:  %13.3f (%7.3f" $ulvt22_area   [expr ($ulvt22_area*0.1) / ($total_area*0.1) *100]]%)    [format " ulvt22 cell count:  %13d (%7.3f" $ulvt22_count  [expr ($ulvt22_count*0.1) / ($total_count*0.1) *100]]%)  >> ./$rpt
#echo [format " ulvt24 cell area:  %13.3f (%7.3f" $ulvt24_area   [expr ($ulvt24_area*0.1) / ($total_area*0.1) *100]]%)    [format " ulvt24 cell count:  %13d (%7.3f" $ulvt24_count  [expr ($ulvt24_count*0.1) / ($total_count*0.1) *100]]%)  >> ./$rpt
#echo [format " elvt24 cell area:  %13.3f (%7.3f" $elvt24_area   [expr ($elvt24_area*0.1) / ($total_area*0.1) *100]]%)    [format " elvt24 cell count:  %13d (%7.3f" $elvt24_count  [expr ($elvt24_count*0.1) / ($total_count*0.1) *100]]%)  >> ./$rpt
#$#
echo [format " Total    area:  %13.3f (%7.3f" $total_area [expr ($total_area*0.1) / ($total_area*0.1) *100]]%)  [format " Total    count:  %13d (%7.3f" $total_count [expr ($total_count*0.1) / ($total_count*0.1) *100]]%) >> ./$rpt
echo [format " Gate    Count:  %13.3f" [expr ($total_area*0.1) / ($ND2D1_area * 0.1) ]] >> ./$rpt
}
