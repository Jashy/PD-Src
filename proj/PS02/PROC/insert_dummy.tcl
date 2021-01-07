set_parameter -type int -name fillDataType -value 1 -module droute
insert_metal_filler -out detail_routing.FILL -tie_to_net none -routing_space 3 -from_metal 1 -to_metal 5 \
        -width          { M1 0.4 M2 0.4 M3 0.4 M4 0.4 M5 0.8 } \
        -space          { M1 0.4 M2 0.4 M3 0.4 M4 0.4 M5 0.8 } \
        -space_to_route { M1 0.8 M2 0.8 M3 0.8 M4 0.8 M5 0.8 } \
        -min_length     { M1 1   M2 1   M3 1   M4 1   M5 1   } \
        -max_length     { M1 2   M2 2   M3 2   M4 2   M5 2   }
save_mw_cel -as detail_routing.CEL
#save_mw_cel -as GAIAIO.CEL
set_write_stream_options -map_layer /proj/Hydra5/LIB/CURRENT/Techfile/astro/gdsout_3X1Y.map
set_write_stream_options -output_filling {fill} -output_outdated_fill
write_stream -cells {for_gds.CEL} -format gds GAIAIO_withfiller.gds

