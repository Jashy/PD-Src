
source -echo -verbose /proj/ARM926EJS/TEMPLATE/PT/PT_lib_all_pt.tcl

#read_verilog /proj/SARADEC2/WORK/jasonw/icc/denali_ddr_20110829/denali_mc_asic.run/for_power.v
#read_verilog /proj/SARADEC2/WORK/jasonw/icc/denali_ddr_20110905/denali_mc_asic.run/fishbone.v
#read_verilog /proj/SARADEC2/WORK/jasonw/icc/denali_ddr_20111120/denali_mc_asic.run/3_FB_route_1025A.v
read_verilog /proj/ARM926EJS/WORK_PTILE/carson/ICC/0307a/ptile_top.run/ptile_top.v

current_design ptile_top

link_design > link.log

#source /proj/SARADEC2/WORK/jasonw/icc/denali_ddr_20110829/syn/denali_mc_databahn_dll_phy_top.con.dc
#source /proj/SARADEC2/WORK/jasonw/icc/sdc/syn/user_setup_top_phy.dc
#source /proj/SARADEC2/WORK/jasonw/icc/denali_ddr_20110829/syn/user_setup_top_phy.dc
source  /proj/ARM926EJS/WORK_PTILE/carson/ICC/template/ptile_top_pt.sdc
#source ./denali_mc_databahn_dll_phy_top.con.dc
set_propagated_clock [all_clocks]
#read_parasitics /proj/SARADEC2/WORK/jasonw/starrc/denali_ddr_20111120/cworst/denali_mc_asic_cworst_couple.spef.gz
read_parasitics /proj/ARM926EJS/WORK_PTILE/carson/STAR/0308a/cworst_0C/ptile_top_cworst_0C_couple.spef.gz

set ADS_ALLOWED_PCT_OF_NON_CLOCKED_REGISTERS 50

#source  ./slew.tcl
update_timing

source -echo -verbose /proj/ARM926EJS/WORK_PTILE/carson/RH/templete/pt2timing.tcl
#source -echo -verbose /apps/apache/RedHawk_Suites_V10.2.3/bin/pt2timing.tcl

getSTA *
