set TOP LKB11
sh rm -rf ./OUTPUT/${TOP}.gds.gz
save_mw_cel -as pv_trial

set_write_stream_options -reset
set_write_stream_options -contact_prefix ${TOP}
set_write_stream_options -rename_cell ./flow_btc/tcl/rename_cell
set_write_stream_options -map_layer /proj/BTC/WORK/jasons/ICC/BTC/0803_8M/icv_stream_out_layer_map
set_write_stream_options -keep_data_type -child_depth 0 -max_name_length 128 -output_pin {geometry text}  -output_filling FILL -output_outdated_fill

write_stream -cells pv_trial -format gds ./OUTPUT/${TOP}.gds
sh gzip ./OUTPUT/${TOP}.gds 
sh touch ./Ready/icc_for_virtuso.ready
