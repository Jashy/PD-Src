#! /bin/csh
set LIB         "MDB_ptile_top"
set TOP         "ptile_top"
set GDS         "ptile_top.run/ptile_top.gds"
#set GMAP_FILE   "/proj/Pezy-1/WORK/seanz/ARM40G/ICC/ARM_template/icc_gds.map"
set RENAME_FILE ""
#set RENAME_FILE "rename_file"
#set TOP         "antenna_fixed"
#set_write_stream_options -map_layer $GMAP_FILE
set_write_stream_options -keep_data_type
set_write_stream_options -contact_prefix ${TOP}_
set_write_stream_options -child_depth 0
set_write_stream_options -rename_cell $RENAME_FILE
set_write_stream_options -output_pin {geometry text}
set_write_stream_options -output_filling {fill} -output_outdated_fill

write_stream -lib_name $LIB -format gds -cells $TOP $GDS
