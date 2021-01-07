set library /DELL/proj/PS02/WORK/jasons/Data/release/1110_lef/GAIA.mdb
set cell GAIA.FRAM
write_lef -lib_name $library -output_cell $cell -output_version 5.7 ${cell}.lef
