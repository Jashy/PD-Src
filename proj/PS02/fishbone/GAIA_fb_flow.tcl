##GAIA fishbone flow##
source /proj/PS02/TEMPLATE/FB/PS02_fb_include.tcl
source /proj/PS02/TEMPLATE/FB/clk_tcl/SPLIT_BY_WINDOW.tcl
source /filer/home/tiwent/PS02/FB/preplace_fb_loading.tcl
source /filer/home/tiwent/PS02/FB/create_mul_inv.tcl
source /filer/home/tiwent/PS02/FB/create_fb_DCAP.tcl
source /filer/home/tiwent/PS02/FB/create_fb_via_PS02.tcl
source /filer/home/tiwent/PS02/FB/route_fb_new.tcl

## 1.1 insert dummy gating ##
perl /proj/PS02/WORK/jasons/Block/GAIA/FB_1230/fishbone/grep_dummy_point.pl  clk_structure.rpt > insert_dummy.tcl

source insert_dummy.tcl in ICC

## 1.2 duplicate ICG for loading > 50 and window > 60x60 ##
source /proj/PS02/WORK/jasons/Block/GAIA/FB_1230/fishbone/duplicate_enbale_1213.tcl

## 1.3 balance clock level count ##
source /filer/home/tiwent/PS02/FB/insert_dummy_gating_for_FF.tcl	;# insert dummy for FF

insert_dummy_gating_for_FF clk
insert_dummy_gating_for_FF hclk

source /filer/home/tiwent/PS02/FB/insert_dummy_gating_for_all.tcl	;# insert dummy for all loadings 
insert_dummy_gating_for_all eco_cell_0/Y
insert_dummy_gating_for_all eco_cell/Y

source /filer/home/tiwent/PS02/FB/insert_dummy_gating_for_dummy.tcl	;# insert dummy for dummy buffer

#### fb2. add iso cel for your clk in 062_MDB.
source /proj/PS02/WORK/jasons/Block/GAIA/FB_1230/fishbone/create_iso_cell.tcl   ;# need change the port value setting
## 2.1 fix fanout 
report_constraint -max_fanout -all_violators -nosplit > ./max_fanout.rpt
compile_clock_tree -high_fanout_net  $fanout_rootpin

## 2.2 add iso cel for your clk in 062_MDB
insert_buffer hclk BUF_X20B_A8TR -new_cell_names HCLK_ALCP_ISO_BUF -new_net_names HCLK_ALCP_ISO_BUF_n0
insert_buffer clk BUF_X20B_A8TR -new_cell_names CLK_ALCP_ISO_BUF -new_net_names CLK_ALCP_ISO_BUF_n0

#source /proj/PS02/WORK/jasons/Block/GAIA/FB_1230/fishbone/create_iso_cell.tcl   ;# need change the port value setting
#change_link [get_cells clk_iso_cell] INV_X20B_A8TR
#change_link [get_cells hclk_iso_cell] INV_X20B_A8TR

## 2.3 split by window
SPLIT_BY_WINDOW CLK_ALCP_ISO_BUF/Y BUF_X20B_A8TR -window {0 0 605 2945} -eco_string split_buf1 ;# edit
SPLIT_BY_WINDOW CLK_ALCP_ISO_BUF/Y BUF_X20B_A8TR -window {600 0 605 2945} -eco_string split_buf2 ;# edit
SPLIT_BY_WINDOW CLK_ALCP_ISO_BUF/Y BUF_X20B_A8TR -window {1200 0 605 2945} -eco_string split_buf3 ;# edit
SPLIT_BY_WINDOW CLK_ALCP_ISO_BUF/Y BUF_X20B_A8TR -window {1800 0 605 2945} -eco_string split_buf4 ;# edit
SPLIT_BY_WINDOW CLK_ALCP_ISO_BUF/Y BUF_X20B_A8TR -window {2400 0 605 2945} -eco_string split_buf5 ;# edit
SPLIT_BY_WINDOW CLK_ALCP_ISO_BUF/Y BUF_X20B_A8TR -window {3000 0 605 2945} -eco_string split_buf6 ;# edit
SPLIT_BY_WINDOW CLK_ALCP_ISO_BUF/Y BUF_X20B_A8TR -window {3600 0 770 2945} -eco_string split_buf7 ;# edit

SPLIT_BY_WINDOW HCLK_ALCP_ISO_BUF/Y BUF_X20B_A8TR -window {0 0 1455 2945} -eco_string split_buf1 ;# edit
SPLIT_BY_WINDOW HCLK_ALCP_ISO_BUF/Y BUF_X20B_A8TR -window {1450 0 1455 2945} -eco_string split_buf2 ;# edit
SPLIT_BY_WINDOW HCLK_ALCP_ISO_BUF/Y BUF_X20B_A8TR -window {2900 0 1470 2945} -eco_string split_buf3 ;# edit

## 2.4 change link all icg to X4B
echo "set icgs {" > ./size_icg.tcl
listout [get_flat_cells -filter ref_name=~PREICG*] >> ./size_icg.tcl   ;#source size_icgs in icc.
echo "}" >> ./size_icg.tcl
echo "foreach icg \$icgs {" >> ./size_icg.tcl
echo "	change_link \$icg PREICG_X4B_A8TR" >> ./size_icg.tcl
echo "}" >> ./size_icg.tcl

source ./size_icg.tcl

## 2.5 preplace fb loading
source /filer/home/tiwent/PS02/FB/preplace_fb_loading.tcl
preplace_FB_loads  CLK_ALCP_ISO_BUF_Y_split_buf1_U0/Y                               ;# edit.
preplace_FB_loads  CLK_ALCP_ISO_BUF_Y_split_buf2_U0/Y                                ;# edit.
preplace_FB_loads  CLK_ALCP_ISO_BUF_Y_split_buf3_U0/Y                                ;# edit.
preplace_FB_loads  CLK_ALCP_ISO_BUF_Y_split_buf4_U0/Y                                ;# edit.
preplace_FB_loads  CLK_ALCP_ISO_BUF_Y_split_buf5_U0/Y                                 ;# edit.
preplace_FB_loads  CLK_ALCP_ISO_BUF_Y_split_buf6_U0/Y                                ;# edit.
preplace_FB_loads  CLK_ALCP_ISO_BUF_Y_split_buf7_U0/Y                               ;# edit.

preplace_FB_loads   HCLK_ALCP_ISO_BUF_Y_split_buf1_U0/Y                           ;# edit.
preplace_FB_loads   HCLK_ALCP_ISO_BUF_Y_split_buf2_U0/Y                           ;# edit.
preplace_FB_loads   HCLK_ALCP_ISO_BUF_Y_split_buf3_U0/Y                           ;# edit.

save_mw_cel -as b4_fb
## 2.6 create fb draw
create_mul_inv CLK_ALCP_ISO_BUF_Y_split_buf1_U0/Y 40    ;# edit
create_mul_inv CLK_ALCP_ISO_BUF_Y_split_buf2_U0/Y 40    ;# edit
create_mul_inv CLK_ALCP_ISO_BUF_Y_split_buf3_U0/Y 40    ;# edit
create_mul_inv CLK_ALCP_ISO_BUF_Y_split_buf4_U0/Y 40    ;# edit
create_mul_inv CLK_ALCP_ISO_BUF_Y_split_buf5_U0/Y 40    ;# edit
create_mul_inv CLK_ALCP_ISO_BUF_Y_split_buf6_U0/Y 40    ;# edit
create_mul_inv CLK_ALCP_ISO_BUF_Y_split_buf7_U0/Y 40    ;# edit

create_mul_inv HCLK_ALCP_ISO_BUF_Y_split_buf1_U0/Y 40    ;# edit
create_mul_inv HCLK_ALCP_ISO_BUF_Y_split_buf2_U0/Y 40    ;# edit
create_mul_inv HCLK_ALCP_ISO_BUF_Y_split_buf3_U0/Y 40    ;# edit

#change by manual {1.change all drivers to inv  2. change trunk & trub width & location}               ;# edit

### 2.6.1 change link for all buf to inv
change_link [get_cells CLK_ALCP_ISO_BUF_Y_split_buf*] INV_X20B_A8TR
change_link [get_cells HCLK_ALCP_ISO_BUF_Y_split_buf*] INV_X20B_A8TR

## 2.7 create DCAP for drivers
create_fb_DCAP CLK_ALCP_ISO_BUF_Y_split_buf1_U0/Y                                                    ;# edit.  
create_fb_DCAP CLK_ALCP_ISO_BUF_Y_split_buf2_U0/Y                                                    ;# edit.  
create_fb_DCAP CLK_ALCP_ISO_BUF_Y_split_buf3_U0/Y                                                    ;# edit.  
create_fb_DCAP CLK_ALCP_ISO_BUF_Y_split_buf4_U0/Y                                                    ;# edit.  
create_fb_DCAP CLK_ALCP_ISO_BUF_Y_split_buf5_U0/Y                                                    ;# edit.  
create_fb_DCAP CLK_ALCP_ISO_BUF_Y_split_buf6_U0/Y                                                    ;# edit.  
create_fb_DCAP CLK_ALCP_ISO_BUF_Y_split_buf7_U0/Y                                                    ;# edit.  

create_fb_DCAP HCLK_ALCP_ISO_BUF_Y_split_buf1_U0/Y                                                    ;# edit.  
create_fb_DCAP HCLK_ALCP_ISO_BUF_Y_split_buf2_U0/Y                                                    ;# edit.  
create_fb_DCAP HCLK_ALCP_ISO_BUF_Y_split_buf3_U0/Y                                                    ;# edit.  

## 2.8 create fb vias
create_fb_via_PS02  CLK_ALCP_ISO_BUF_Y_split_buf1_U0/Y							;# edit. 
create_fb_via_PS02  CLK_ALCP_ISO_BUF_Y_split_buf2_U0/Y							;# edit. 
create_fb_via_PS02  CLK_ALCP_ISO_BUF_Y_split_buf3_U0/Y							;# edit. 
create_fb_via_PS02  CLK_ALCP_ISO_BUF_Y_split_buf4_U0/Y							;# edit. 
create_fb_via_PS02  CLK_ALCP_ISO_BUF_Y_split_buf5_U0/Y							;# edit. 
create_fb_via_PS02  CLK_ALCP_ISO_BUF_Y_split_buf6_U0/Y							;# edit. 
create_fb_via_PS02  CLK_ALCP_ISO_BUF_Y_split_buf7_U0/Y							;# edit. 

create_fb_via_PS02  HCLK_ALCP_ISO_BUF_Y_split_buf1_U0/Y							;# edit. 
create_fb_via_PS02  HCLK_ALCP_ISO_BUF_Y_split_buf2_U0/Y							;# edit. 
create_fb_via_PS02  HCLK_ALCP_ISO_BUF_Y_split_buf3_U0/Y							;# edit. 

## 2.9 create multi driver to drive FB

insert_buffer HCLK_ALCP_ISO_BUF/Y BUF_X20B_A8TR -new_cell_names HCLK_ISO_MUL_DRI_BUF -new_net_names HCLK_ISO_MUL_DRI_BUF_n0
insert_buffer CLK_ALCP_ISO_BUF/Y BUF_X20B_A8TR -new_cell_names CLK_ISO_MUL_DRI_BUF -new_net_names CLK_ISO_MUL_DRI_BUF_n0

create_mul_inv CLK_ALCP_ISO_BUF/Y 10 BUF_X20B_A8TR     ;# edit
create_mul_inv HCLK_ALCP_ISO_BUF/Y 8 BUF_X20B_A8TR     ;# edit

create_mul_inv HCLK_ISO_MUL_DRI_BUF/Y 20 BUF_X20B_A8TR
create_mul_inv CLK_ISO_MUL_DRI_BUF/Y 30 BUF_X20B_A8TR

#change by manual {1.change all drivers to inv  2. change trunk & trub width & location}               ;# edit

create_fb_via_PS02 CLK_ALCP_ISO_BUF/Y
create_fb_via_PS02 HCLK_ALCP_ISO_BUF/Y
create_fb_via_PS02 CLK_ISO_MUL_DRI_BUF/Y
create_fb_via_PS02 HCLK_ISO_MUL_DRI_BUF/Y

save_mw_cel -as FB_done

## 3.0 legalize placement, for GAIA need save and re-open mdb cell to do this step
legalize_placement -incremental
save_mw_cel -as b4_fb_route


source /filer/home/tiwent/PS02/FB/route_fb_new.tcl
route_fb_PS02_28hpm {CLK_ALCP_ISO_BUF_Y_split_buf1_n0 CLK_ALCP_ISO_BUF_Y_split_buf2_n0 CLK_ALCP_ISO_BUF_Y_split_buf3_n0 CLK_ALCP_ISO_BUF_Y_split_buf4_n0 CLK_ALCP_ISO_BUF_Y_split_buf5_n0 CLK_ALCP_ISO_BUF_Y_split_buf6_n0 CLK_ALCP_ISO_BUF_Y_split_buf7_n0 HCLK_ALCP_ISO_BUF_Y_split_buf1_n0 HCLK_ALCP_ISO_BUF_Y_split_buf2_n0 HCLK_ALCP_ISO_BUF_Y_split_buf3_n0}
save_mw_cel -as fb_route


