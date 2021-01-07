set_write_stream_options -output_filling { FILL FILL_DM } -keep_data_type -output_outdated_fill
write_stream -lib_name ${MW_LIB}_dummy -cells $MW_CEL ${SESSION}.run/${MW_CEL}_${ECO_STRING}_dummy.gds
exec touch ${SESSION}.run/${MW_CEL}_${ECO_STRING}_dummy.gds.ready
#write_stream -lib_name ${MW_LIB} -cells $MW_CEL ${SESSION}.run/${MW_CEL}_${ECO_STRING}.gds
#exec touch ${SESSION}.run/${MW_CEL}_${ECO_STRING}.gds.ready

