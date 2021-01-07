
set TOP [get_attribute [current_mw_cel] name]

#sh echo "Info: saving cell before export gds..."
#save_mw_cel 
#sh echo "Info: exporting gds, don't save after gds ready..."

set mapfile  /proj/PS02/LIB/20150116/DK_PS02/lib/tech_rev03/stream_out_layer_map
set gds     ./release/${TOP}.gds
set ready   ./release/gds_ready

sh mkdir -p release
if {[file exist $ready ]}        {sh rm $ready}
if {[file exist ${gds}] || [file exist ${gds}.gz]}  {sh rm ${gds}*}

set_write_stream_options -reset
set_write_stream_options -max_name_length 256
set_write_stream_options \
   -output_pin {text geometry}\
   -output_filling {FILL} \
   -keep_fill_cell_prefix \
   -output_outdated_fill \
   -keep_data_type \
   -contact_prefix ${TOP}_via_ \
   -map_layer $mapfile

write_stream -cells ${TOP} -format gds $gds
sh gzip  $gds
sh touch $ready
