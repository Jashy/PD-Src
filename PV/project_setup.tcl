set GFVAR_DESIGN(name)   "ltc_asic_top"
set GFVAR_DESIGN_TYPE "TOP"
set GFVAR_TECH_PROCESS "22FDSOI"
set GFVAR_PDK_HOME "/proj/dc_bwl6000_001/library/PDK/PDK_22FDX_V1.3_1.0_-_FOR_MENTOR20180123T111414"
set GFVAR_STDCELL_LIB_HOME "/proj/dc_bwl6000_001/asiclibs"
set GFVAR_STACK "9M_2Mx_5Cx_1Jx_1Ox_LB"
set GFVAR_DESIGN_GDS "/proj/dc_bwl6000_001/work/user/wjiao/ltc_asic_top_new/output/0225/ltc_asic_top.hier.gds.gz"
set GFVAR_DESIGN_NETLIST "/proj/dc_bwl6000_001/work/user/wjiao/ltc_asic_top_new/output/0225/ltc_asic_top.v.pg"
set GFVAR_STDCELL_GDS  " \
/proj/dc_bwl6000_001/incoming/20180223/0223_block_final/0223_coRomix_final/gds/co_romix_shareram_fouronecore.final.toTOP.0223_coRomix_final.gds.gz \
/proj/dc_bwl6000_001/incoming/20180223/0223_block_final/0223_romix_final/gds/romix_shareram_fouronecore.final.toTOP.0223_romix_final.gds.gz \
/proj/dc_bwl6000_001/asiclibs/hpk_8t_lvt/latest/gds/GF22FDX_SC8T_104CPP_HPK_CSL.gds \
/proj/dc_bwl6000_001/asiclibs/hpk_8t_slvt/latest/gds/GF22FDX_SC8T_104CPP_HPK_CSSL.gds \
/proj/dc_bwl6000_001/asiclibs/io_gpio_1p8/latest/gds/IN22FDX_GPIO18_9M11S30P.gds \
/proj/dc_bwl6000_001/asiclibs/ls_8t_lvt/latest/gds/GF22FDX_SC8T_104CPP_SHIFT_CSL.gds \
/proj/dc_bwl6000_001/asiclibs/ls_8t_slvt/latest/gds/GF22FDX_SC8T_104CPP_SHIFT_CSSL.gds \
/proj/dc_bwl6000_001/asiclibs/mem_R1DH_0p80v/latest/gds/IN22FDX_R1DH_NFLN_W00512B128M02C256.gds \
/proj/dc_bwl6000_001/asiclibs/mem_RPDH_0p80v/latest/gds/IN22FDX_RPDH_NFLN_W00040B128M02C256.gds \
/proj/dc_bwl6000_001/asiclibs/pci/latest/GDSII/TGPCI_9M_2Mx_5Cx_1Jx_1Ox_LB.gds \
/proj/dc_bwl6000_001/asiclibs/pll/latest/gds/IN22FDSOIPLL.gds \
/proj/dc_bwl6000_001/asiclibs/sc_8t_lvt_c20/latest/gds/GF22FDX_SC8T_104CPP_BASE_CSC20L.gds \
/proj/dc_bwl6000_001/asiclibs/sc_8t_lvt_c24/latest/gds/GF22FDX_SC8T_104CPP_BASE_CSC24L.gds \
/proj/dc_bwl6000_001/asiclibs/sc_8t_lvt_c28/latest/gds/GF22FDX_SC8T_104CPP_BASE_CSC28L.gds \
/proj/dc_bwl6000_001/asiclibs/sc_8t_slvt_c20/latest/gds/GF22FDX_SC8T_104CPP_BASE_CSC20SL.gds \
/proj/dc_bwl6000_001/asiclibs/sc_8t_slvt_c24/latest/gds/GF22FDX_SC8T_104CPP_BASE_CSC24SL.gds \
/proj/dc_bwl6000_001/asiclibs/sc_8t_slvt_c28/latest/gds/GF22FDX_SC8T_104CPP_BASE_CSC28SL.gds \
/proj/dc_bwl6000_001/asiclibs/ga_8t_lvt/latest/gds/GF22FDX_SC8T_104CPP_ECO_CSL.gds \
/proj/dc_bwl6000_001/asiclibs/ga_8t_slvt/latest/gds/GF22FDX_SC8T_104CPP_ECO_CSSL.gds  \
/proj/dc_bwl6000_001/asiclibs/crackstop/latest/gds/BWL6000Crackstop.gds \
/proj/dc_bwl6000_001/asiclibs/c4_bump_ase/latest/gds/C4_BUMP.gds \
/proj/dc_bwl6000_001/asiclibs/BW6000_logo/latest/gds/BW6000_logo.gds.gz \
"

set GFVAR_STDCELL_SPICE " \
/proj/dc_bwl6000_001/work/user/rchen7/inputs/co_romix_shareram_fouronecore.v2lvs.net \
/proj/dc_bwl6000_001/work/user/rchen7/inputs/romix_shareram_fouronecore.v2lvs.net \
/proj/dc_bwl6000_001/asiclibs/hpk_8t_lvt/latest/cdl/GF22FDX_SC8T_104CPP_HPK_CSL.cdl \
/proj/dc_bwl6000_001/asiclibs/hpk_8t_slvt/latest/cdl/GF22FDX_SC8T_104CPP_HPK_CSSL.cdl \
/proj/dc_bwl6000_001/asiclibs/io_gpio_1p8/latest/cdl/IN22FDX_GPIO18_9M11S30P.cdl \
/proj/dc_bwl6000_001/asiclibs/ls_8t_lvt/latest/cdl/GF22FDX_SC8T_104CPP_SHIFT_CSL.cdl \
/proj/dc_bwl6000_001/asiclibs/ls_8t_slvt/latest/cdl/GF22FDX_SC8T_104CPP_SHIFT_CSSL.cdl \
/proj/dc_bwl6000_001/asiclibs/mem_R1DH_0p80v/latest/cdl/IN22FDX_R1DH_NFLN_W00512B128M02C256.cdl \
/proj/dc_bwl6000_001/asiclibs/mem_RPDH_0p80v/latest/cdl/IN22FDX_RPDH_NFLN_W00040B128M02C256.cdl \
/proj/dc_bwl6000_001/asiclibs/pll/latest/cdl/IN22FDSOIPLL.cdl \
/proj/dc_bwl6000_001/asiclibs/sc_8t_lvt_c20/latest/cdl/GF22FDX_SC8T_104CPP_BASE_CSC20L.cdl \
/proj/dc_bwl6000_001/asiclibs/sc_8t_lvt_c24/latest/cdl/GF22FDX_SC8T_104CPP_BASE_CSC24L.cdl \
/proj/dc_bwl6000_001/asiclibs/sc_8t_lvt_c28/latest/cdl/GF22FDX_SC8T_104CPP_BASE_CSC28L.cdl \
/proj/dc_bwl6000_001/asiclibs/sc_8t_slvt_c20/latest/cdl/GF22FDX_SC8T_104CPP_BASE_CSC20SL.cdl \
/proj/dc_bwl6000_001/asiclibs/sc_8t_slvt_c24/latest/cdl/GF22FDX_SC8T_104CPP_BASE_CSC24SL.cdl \
/proj/dc_bwl6000_001/asiclibs/sc_8t_slvt_c28/latest/cdl/GF22FDX_SC8T_104CPP_BASE_CSC28SL.cdl \
/proj/dc_bwl6000_001/asiclibs/ga_8t_lvt/latest/cdl/GF22FDX_SC8T_104CPP_ECO_CSL.cdl \
/proj/dc_bwl6000_001/asiclibs/ga_8t_slvt/latest/cdl/GF22FDX_SC8T_104CPP_ECO_CSSL.cdl  \
"

# GFVAR_CALIBRE_USE_FILL_GDS is a control var for DRC to run Calibre DRC with and without fill.
set GFVAR_CALIBRE_USE_FILL_GDS "TRUE"
### Fill Option for Caliber Fill (please check in ${GFVAR_PDK_HOME}/Calibre/FILL_gen) documentation:
set GFVAR_CALIBRE_FILL_OPTION "OPTION11_9M_2Mx_5Cx_1Jx_1Ox_SELECT"
#exclude high metal dummy for top power stripe (create for BLOCK gds)
set GFVAR_DUMMY_EXCLUDE "YES"
#CA
set GFVAR_DUMMY_EXCLUDE_LAYER "14.2 59.2"
set GFVAR_DUMMY_EXCLUDE_LAYER_COORDINATE "0 299419  6495010  5744600"
#exclude bottom metal dummy for decreasing top dummy insertion runtime (create for BLOCK gds)
set GFVAR_DUMMY_EXCLUDE_FOR_TOP "NO"
set GFVAR_DUMMY_EXCLUDE_BOTTOM_LAYER ""

set GFVAR_VOLTAGE_TEXT "YES"
set GFVAR_ESD_MARK_LAYER "YES"

set GFVAR_CALIBRE_DRC_DECK		"${GFVAR_PDK_HOME}/DRC/Calibre/cmos22fdsoi.drc.cal"
set GFVAR_CALIBRE_LVS_DECK		"${GFVAR_PDK_HOME}/LVS/Calibre/cmos22fdsoi.lvs.cal"

set GFVAR_LVS_DECK  ""
#set GFVAR_LVS_DECK                "../scripts/edtext"
set GFVAR_V2LVS_USER_CMD_OPTIONS  ""
set GFVAR_LVS_HCELL_LIST          "/proj/dc_bwl6000_001/work/user/rchen7/top_pv_0225_final/phy_ver/design_data/include/hcells.list"
set GFVAR_LVS_INCLUDE_LIST        "/proj/dc_bwl6000_001/work/user/rchen7/top_pv_0225_final/phy_ver/design_data/include/lvs.include"


## Define number of CPUs used for DRC/LVS
set GFVAR_CALIBRE_NUM_CPU_USED 32

## Switch between OASIS and GDS database
set GFVAR_CALIBRE_LAYOUT_SYSTEM GDS
if {$GFVAR_CALIBRE_LAYOUT_SYSTEM == "OASIS"} {
    set GFVAR_CALIBRE_LAYOUT_EXT oas.gz
    set GFVAR_CALIBRE_LAYOUT_FILL_EXT oasis
} else {
    set GFVAR_CALIBRE_LAYOUT_EXT gds.gz
    set GFVAR_CALIBRE_LAYOUT_FILL_EXT gds
}


set GFVAR_LC_POWER_PAD ""
set GFVAR_HC_POWER_PAD "VDD VDDM VDD03 VDD02 PLLVDDIO"
set GFVAR_GROUND_PAD "VSS VSS03 VSS02 PLLVSSIO"
set GFVAR_FULL_ESD "VDD VSS VDDM VDD03 VSS03 VDD02 VSS02 PLLVDDIO PLLVSSIO clk_in_pad clk_out_pad rate_pad\[0\] rate_pad\[1\] rst_b_out_pad rst_b_pad sysclk_div_pad unr_pad unt_pad usr_pad ust_pad"
set GFVAR_ESD_RULES "ESDB"
