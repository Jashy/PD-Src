

set TOP         = "GAIA"  # The name of the top-design
set lic_global  = "/proj/onepiece3/SETUPS/pv_ps02"
set path        = ($path /proj/PS02/RELEASE/PV/template_20160104a/CALIBRE)

################# opus ################################################################
set opus_tech_file = "/proj/PS02/LIB/CURRENT/DK_PS02/lib/OPUS_tech_rev02/oa/cmos28lp_tech_7U1x_2T8x_LB/cmos28lp_tech_7U1x_2T8x_LB.tf"
set opus_map_file = "/proj/PS02/LIB/CURRENT/DK_PS02/lib/OPUS_tech_rev02/oa/cmos28lp_tech_7U1x_2T8x_LB/cmos28lp_tech.layermap"

set icc_gds         = "../release/${TOP}.gds.gz"
set icc_pg_netlist  = "/proj/PS02/WORK/jasons/Block/GAIA/Final_drc_0313a/GAIA-VCF_DFT_1218-FCF_DFT_1218-SCF_DFT_my_0202-jasons-ECO_0202_lukez/output/140_icc_eco_route/GAIA_icc_pg.v"
set lvs_pg_netlist  = "./${TOP}_lvs_pg.v"
set lvs_spice       = "./${TOP}_lvs.spi"
set lvs_pg_spice    = "./${TOP}_lvs_pg.spi"
set gds_ready       = "../release/gds_ready"
set vnet_ready      = "../release/vnet_ready"
set vnet_pg_ready   = "../release/vnet_pg_ready"

