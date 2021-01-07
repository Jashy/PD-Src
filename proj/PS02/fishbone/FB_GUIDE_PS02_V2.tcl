###################################### PS02 Fishbone Final Flow ########################################

                                 +-----> focal0
                                 |
                    timing?      |
pre0 ----> pre1 ---------------->+
                                 |
                                 |
                                 +-----> fb1 ---> fb2 ---> fb3 ---> fb3.5 ---> fb4 ---> fb5 ---> fb6 ---> fb7 ---> fb8 ---> fb9 ---> +
								      								     |
								  								     |   PT result?
 								   								     + -------------> fix tran 	
#########################################################################################################

#### pre0.finish 062_icc_rst_opt
run onepiece flow and finish the step 062_icc_rst_opt

#### pre1.check the timing and choice the next step
03_psyn_ss28lpp_ideal  to check the ideal timing for our block.
Flow_Setting/Flow common/Clockmode --> ideal.
copy your finished 062 database/summary to 060 and then run other steps. when PT results ready, check timing.
if timing is ok. next step fb0.
if timing is not ok. next step focal0.

#### focal0
a. perl /filer/home/tiwent/PS02/get_endpoint_for_focal.pl $PT_timing_summary.rep
b.chage clock uncertainty +500ps
c.focal_opt -effort high -setup_endpoints $end_point_for_focal
d.legalize_placement -incremental  
e.route_zrt_eco 
f.write verilog & star-RC & PT.

#### fb1.duplicated & dummy
a.insert dummy after the ICG whose loading include both icg and FF.
	perl /filer/home/tiwent/PS02/FB/grep_dummy_point.pl > insert_dummy.tcl
	source insert_dummy.tcl in ICC.
b.Duplicated for ICG.
	source /filer/home/tiwent/PS02/FB/duplicate_enbale_1213.tcl             ;# Duplicated
c.balance clock.
	source /filer/home/tiwent/PS02/FB/insert_dummy_gating_for_FF.tcl	;# insert dummy for FF
	source /filer/home/tiwent/PS02/FB/insert_dummy_gating_for_all.tcl	;# insert dummy for all loadings 
	source /filer/home/tiwent/PS02/FB/insert_dummy_gating_for_dummy.tcl	;# insert dummy for dummy buffer

#### fb1.5 fix_fanout
report_constraint -max_fanout -all_violators -nosplit > ./max_fanout.rpt
compile_clock_tree -high_fanout_net  $fanout_rootpin

#### fb2. add iso cel for your clk in 062_MDB.
source /proj/PS02/WORK/jasons/Block/GAIA/FB_1230/fishbone/create_iso_cell.tcl   ;# need change the port value setting

#### fb3.split by window
source /proj/PS02/TEMPLATE/FB/PS02_fb_include.tcl
source /proj/PS02/TEMPLATE/FB/clk_tcl/SPLIT_BY_WINDOW.tcl
SPLIT_BY_WINDOW clk_iso_cell/Y BUF_X20B_A8TR -window {0 0 605 2945} -eco_string split_buf1 ;# edit
SPLIT_BY_WINDOW clk_iso_cell/Y BUF_X20B_A8TR -window {600 0 605 2945} -eco_string split_buf2 ;# edit
SPLIT_BY_WINDOW clk_iso_cell/Y BUF_X20B_A8TR -window {1200 0 605 2945} -eco_string split_buf3 ;# edit
SPLIT_BY_WINDOW clk_iso_cell/Y BUF_X20B_A8TR -window {1800 0 605 2945} -eco_string split_buf4 ;# edit
SPLIT_BY_WINDOW clk_iso_cell/Y BUF_X20B_A8TR -window {2400 0 605 2945} -eco_string split_buf5 ;# edit
SPLIT_BY_WINDOW clk_iso_cell/Y BUF_X20B_A8TR -window {3000 0 605 2945} -eco_string split_buf6 ;# edit
SPLIT_BY_WINDOW clk_iso_cell/Y BUF_X20B_A8TR -window {3600 0 770 2945} -eco_string split_buf7 ;# edit

#### fb3.5 change link all icg to X4B
echo "set icgs {" > ./size_icg.tcl
listout [get_flat_cells -filter ref_name=~PREICG*] >> ./size_icg.tcl   ;#source size_icgs in icc.
echo "}" >> ./size_icg.tcl
echo "foreach icg \$icgs {" >> ./size_icg.tcl
echo "	change_link \$icg PREICG_X4B_A8TR" >> ./size_icg.tcl
echo "}" >> ./size_icg.tcl

#### fb4.preplace fb loading
source /filer/home/tiwent/PS02/FB/preplace_fb_loading.tcl
preplace_FB_loads  clk_iso_cell_Y_split_buf1_U0/Y                               ;# edit.
preplace_FB_loads  clk_iso_cell_Y_split_buf2_U0/Y                                ;# edit.
preplace_FB_loads  clk_iso_cell_Y_split_buf3_U0/Y                                ;# edit.
preplace_FB_loads  clk_iso_cell_Y_split_buf4_U0/Y                                ;# edit.
preplace_FB_loads  clk_iso_cell_Y_split_buf5_U0/Y                                 ;# edit.
preplace_FB_loads  clk_iso_cell_Y_split_buf6_U0/Y                                ;# edit.
preplace_FB_loads  clk_iso_cell_Y_split_buf7_U0/Y                               ;# edit.

#### fb5.create fb draw
save_mw_cel -as b4_fb
source /filer/home/tiwent/PS02/FB/create_mul_inv.tcl
create_mul_inv clk_iso_cell_Y_split_buf1_U0/Y 40    ;# edit
create_mul_inv clk_iso_cell_Y_split_buf2_U0/Y 40    ;# edit
create_mul_inv clk_iso_cell_Y_split_buf3_U0/Y 40    ;# edit
create_mul_inv clk_iso_cell_Y_split_buf4_U0/Y 40    ;# edit
create_mul_inv clk_iso_cell_Y_split_buf5_U0/Y 40    ;# edit
create_mul_inv clk_iso_cell_Y_split_buf6_U0/Y 40    ;# edit
create_mul_inv clk_iso_cell_Y_split_buf7_U0/Y 40    ;# edit

change by manual {1.change all drivers to inv  2. change trunk & trub width & location}               ;# edit

#### fb6. create DCAP for drivers
source /filer/home/tiwent/PS02/FB/create_fb_DCAP.tcl
create_fb_DCAP clk_iso_cell_Y_split_buf1_U0/Y                                                    ;# edit.  
create_fb_DCAP clk_iso_cell_Y_split_buf2_U0/Y                                                    ;# edit.  
create_fb_DCAP clk_iso_cell_Y_split_buf3_U0/Y                                                    ;# edit.  
create_fb_DCAP clk_iso_cell_Y_split_buf4_U0/Y                                                    ;# edit.  
create_fb_DCAP clk_iso_cell_Y_split_buf5_U0/Y                                                    ;# edit.  
create_fb_DCAP clk_iso_cell_Y_split_buf6_U0/Y                                                    ;# edit.  
create_fb_DCAP clk_iso_cell_Y_split_buf7_U0/Y                                                    ;# edit.  

#### fb7. create fb via
source /filer/home/tiwent/PS02/FB/create_fb_via_PS02.tcl
create_fb_via_PS02  clk_iso_cell_Y_split_buf1_U0/Y							;# edit. 
create_fb_via_PS02  clk_iso_cell_Y_split_buf2_U0/Y							;# edit. 
create_fb_via_PS02  clk_iso_cell_Y_split_buf3_U0/Y							;# edit. 
create_fb_via_PS02  clk_iso_cell_Y_split_buf4_U0/Y							;# edit. 
create_fb_via_PS02  clk_iso_cell_Y_split_buf5_U0/Y							;# edit. 
create_fb_via_PS02  clk_iso_cell_Y_split_buf6_U0/Y							;# edit. 
create_fb_via_PS02  clk_iso_cell_Y_split_buf7_U0/Y							;# edit. 

#### fb8. create multi driver to drive FB .
create_mul_inv clk_iso_cell/Y 60 BUF_X20B_A8TR     ;# edit
change by manual {1.change all drivers to inv  2. change trunk & trub width & location}               ;# edit
create_fb_via_PS02 clk_iso_cell/Y
#### fb9. FB route
source /filer/home/tiwent/PS02/FB/route_fb_new.tcl
route_fb_PS02_28hpm {$fb_net}                                                       ;# edit

#### fix tran
foreach_in_collection cell [get_cell -hier -filter "ref_name =~ *ICG*"] { 
        set tran [get_attribute [get_pins [get_attribute $cell full_name]/ECK] actual_transition_max] ; 
        if {$tran > 0.15} { 
            echo "size_cell [get_attribute $cell full_name] PREICG_X6B_A8TR ;\#[get_attribute $cell ref_name]"
        }
} > size_ICG_drv.tcl



## for hclk ##
#### fb3.split by window
source /proj/PS02/TEMPLATE/FB/PS02_fb_include.tcl
source /proj/PS02/TEMPLATE/FB/clk_tcl/SPLIT_BY_WINDOW.tcl
SPLIT_BY_WINDOW hclk_iso_cell/Y BUF_X20B_A8TR -window {0 0 1455 2945} -eco_string split_buf1 ;# edit
SPLIT_BY_WINDOW hclk_iso_cell/Y BUF_X20B_A8TR -window {1450 0 1455 2945} -eco_string split_buf2 ;# edit
SPLIT_BY_WINDOW hclk_iso_cell/Y BUF_X20B_A8TR -window {2900 0 1470 2945} -eco_string split_buf3 ;# edit

#### fb4.preplace fb loading
source /filer/home/tiwent/PS02/FB/preplace_fb_loading.tcl
preplace_FB_loads hclk_iso_cell_Y_split_buf1_U0/Y                               ;# edit.
preplace_FB_loads hclk_iso_cell_Y_split_buf2_U0/Y                                ;# edit.
preplace_FB_loads hclk_iso_cell_Y_split_buf3_U0/Y                                ;# edit.

#### fb5.create fb draw
save_mw_cel -as b4_fb
source /filer/home/tiwent/PS02/FB/create_mul_inv.tcl
create_mul_inv hclk_iso_cell_Y_split_buf1_U0/Y 40    ;# edit
create_mul_inv hclk_iso_cell_Y_split_buf2_U0/Y 40    ;# edit
create_mul_inv hclk_iso_cell_Y_split_buf3_U0/Y 40    ;# edit

change by manual {1.change all drivers to inv  2. change trunk & trub width & location}               ;# edit

#### fb6. create DCAP for drivers
source /filer/home/tiwent/PS02/FB/create_fb_DCAP.tcl
create_fb_DCAP hclk_iso_cell_Y_split_buf1_U0/Y                                                    ;# edit.  
create_fb_DCAP hclk_iso_cell_Y_split_buf2_U0/Y                                                    ;# edit.  
create_fb_DCAP hclk_iso_cell_Y_split_buf3_U0/Y                                                    ;# edit.  

#### fb7. create fb via
source /filer/home/tiwent/PS02/FB/create_fb_via_PS02.tcl
create_fb_via_PS02  hclk_iso_cell_Y_split_buf1_U0/Y							;# edit. 
create_fb_via_PS02  hclk_iso_cell_Y_split_buf2_U0/Y							;# edit. 
create_fb_via_PS02  hclk_iso_cell_Y_split_buf3_U0/Y							;# edit. 

#### fb8. create multi driver to drive FB .
create_mul_inv hclk_iso_cell/Y 50 BUF_X20B_A8TR     ;# edit
change by manual {1.change all drivers to inv  2. change trunk & trub width & location}               ;# edit
create_fb_via_PS02 hclk_iso_cell/Y
#### fb9. FB route
source /filer/home/tiwent/PS02/FB/route_fb_new.tcl
route_fb_PS02_28hpm {$fb_net}                                                       ;# edit


save_mw_cel -as FB_done
legalize_placement -incremental
source /filer/home/tiwent/PS02/FB/route_fb_new.tcl
route_fb_PS02_28hpm clk_iso_cell_Y_split_buf1_n0
route_fb_PS02_28hpm clk_iso_cell_Y_split_buf2_n0
route_fb_PS02_28hpm clk_iso_cell_Y_split_buf3_n0
route_fb_PS02_28hpm clk_iso_cell_Y_split_buf4_n0
route_fb_PS02_28hpm clk_iso_cell_Y_split_buf5_n0
route_fb_PS02_28hpm clk_iso_cell_Y_split_buf6_n0
route_fb_PS02_28hpm clk_iso_cell_Y_split_buf7_n0
route_fb_PS02_28hpm hclk_iso_cell_Y_split_buf1_n0
route_fb_PS02_28hpm hclk_iso_cell_Y_split_buf2_n0
route_fb_PS02_28hpm hclk_iso_cell_Y_split_buf3_n0

save_mw_cel -as fb_route
###############################################################
#### NOTE!!!!!!!!!!!!!!!!!!!!:
1.Dont foget legalize_placement if necessary
2.save mw cel step if necessary.
3.if you need add fb driver count: /filer/home/tiwent/PS02/FB/add_inv_for_fb.tcl
4.if possible, delete the lonely_inv which drive the fb_drivers before fb route to reduce the clk latency. But must make sure your leval_count of inv!!!!!
