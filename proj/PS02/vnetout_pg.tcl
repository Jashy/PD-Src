
set TOP [get_attribute [current_mw_cel] name]

set vnet    ./release/${TOP}_icc_pg.v
set ready   ./release/${TOP}_vnet_pg_ready


sh mkdir -p release
if {[file exist ${ready}]}  {sh rm ${ready}}
if {[file exist ${vnet}]}   {sh rm ${vnet}}


set no_output_ref1  "N28_DMY_TCD_FH N28_DMY_TCD_FV ddr106_h ddr109_h PCLAMPC_V_G"
set no_output_ref   "FILLTIE4_A8TR ENDCAPTIE5_A8TR ENDCAPBIASNW5_A8TR FILLBIASNW4_A8TR PAVDDPAD_E33_33_NT_DR PAVDDSEC_18_18_NT_DR PAVSSPA_E33_33_NT_DR PAVSSSEC_18_18_NT_DR PBRKSEC_18_18_NT_DRPBRKSOPD_E33_33_NT_DR PBRKSOPDF_E33_33_NT_DR PBRKSOP_E33_33_NT_DR PBRKSOPF_E33_33_NT_DR PDVDD_E33_33_NT_DR PDVDDPAD_E33_33_NT_DR PDVSS_E33_33_NT_DR PDVSSPAD_E33_33_NT_DR PFILL10_18_18_NT_DR PFILL10_E33_33_NT_DR PFILL5_E33_33_NT_DR  PFILLLINK_E33_33_NT_DR_2R10U PFILLLINK_E33_33_NT_DR_3R10U PVBIASAT_E33_33_NT_DR PVDDILAD_E33_33_NT_DR PVDDILSEC_18_18_NT_DR PVDDLAD_E33_33_NT_DR PVDDPAD_E33_33_NT_DR PVSENSE_E33_33_NT_DR PVSENSETIE_E33_33_NT_DR PVSSLA_E33_33_NT_DR PVSSSEC_18_18_NT_DR PFILL5_18_18_NT_DR BUMP71 BUMP81"

##################################################
## - Change name
##################################################
#define_name_rules verilog -check_bus_indexing -allowed {a-zA-Z0-9_} -reserved_words {int} \
			  -remove_internal_net_bus -flatten_multi_dimension_busses -first_restricted "\\0-9_"
#change_names -rules verilog -hierarchy


##################################################
## - Verilog
##################################################

#write_verilog -no_physical_only_cells ./release/${SEV(design_name)}.v
#sh gzip ./release/${SEV(design_name)}.v

write_verilog -pg -force_output_references { \
     FILLCAP128_A8TR FILLCAP64_A8TR FILLCAP32_A8TR \
     FILLCAP16_A8TR FILLCAP8_A8TR FILLCAP4_A8TR \
     FILLCAP128_A8TL FILLCAP64_A8TL FILLCAP32_A8TL \
     FILLCAP16_A8TL FILLCAP8_A8TL FILLCAP4_A8TL \
     FILLCAP128_A8TH FILLCAP64_A8TH FILLCAP32_A8TH \
     FILLCAP16_A8TH FILLCAP8_A8TH FILLCAP4_A8TH \
     FILLSGCAP128_WP_A8TR FILLSGCAP64_WP_A8TR \
     FILLSGCAP32_WP_A8TR FILLSGCAP16_WP_A8TR \
     FILLSGCAP8_WP_A8TR \
     FILLSGCAP128_WP_A8TL FILLSGCAP64_WP_A8TL \
     FILLSGCAP32_WP_A8TL FILLSGCAP16_WP_A8TL \
     FILLSGCAP8_WP_A8TL \
     FILLSGCAP128_WP_A8TH FILLSGCAP64_WP_A8TH \
     FILLSGCAP32_WP_A8TH FILLSGCAP16_WP_A8TH \
     FILLSGCAP8_WP_A8TH FILLSGCAP64_A8TH \
     FILLCAP128_WP_A8TR FILLCAP64_WP_A8TR FILLCAP32_WP_A8TR \
     FILLCAP16_WP_A8TR FILLCAP8_WP_A8TR \
     FILLCAP128_WP_A8TL FILLCAP64_WP_A8TL FILLCAP32_WP_A8TL \
     FILLCAP16_WP_A8TL FILLCAP8_WP_A8TL \
     FILLCAP128_WP_A8TH FILLCAP64_WP_A8TH FILLCAP32_WP_A8TH \
     FILLCAP16_WP_A8TH FILLCAP8_WP_A8TH FILLSGCAP64_A8TR \
     FILLECOCAP48_A8TR FILLECOCAP24_A8TR FILLECOCAP12_A8TR FILLECOCAP6_A8TR \
     ESDCLAMP11V ESDCLAMP18V} \
     -no_physical_only_cells -no_pad_filler_cells $vnet

#sh gzip $vnet
sh touch $ready

