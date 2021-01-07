
set TOP [get_attribute [current_mw_cel] name]

set mwcel   $SEV(design_name)
set mapfile /proj/PS02/LIB/CURRENT/DK_PS02/lib/tech_rev03/stream_out_layer_map
set gds     $SEV(out_dir)/$SEV(design_name).gds
set ready   $SEV(out_dir)/gds_ready

#sh mkdir -p release
if {[file exist $ready ]}        {sh rm $ready}
if {[file exist ${gds}*]}  {sh rm ${gds}*}

set_write_stream_options -reset
set_write_stream_options -max_name_length 256
set_write_stream_options \
   -output_pin {text geometry}\
   -keep_data_type \
   -contact_prefix $SEV(design_name)_via_ \
   -map_layer $mapfile

write_stream -cells $mwcel \
             -format gds $gds
sh gzip  $gds
sh touch $ready

#open_mw_lib $mwlib
#open_mw_cel $SEV(design_name)_before_gds
#save_mw_cel -as $SEV(design_name)



