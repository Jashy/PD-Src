
exec rm -f garow.def
exec awk -f bin/mkgarow.awk $DEF > garow.def

remove_site_row *ROW*
read_def garow.def
remove_site_row STD_ROW*
insert_stdcell_filler -cell_without_metal "GDCAP10 GDCAP4 GDCAP3HVT GDCAP2HVT GDCAPHVT" \
        -connect_to_power VDD -connect_to_ground VSS

#remove_stdcell_filler  -stdcell -bounding_box {{136.935 2039.835} {195.070 2085.315}}

remove_site_row *ROW*
read_def garow.def
remove_site_row GA_ROW*
insert_stdcell_filler -cell_without_metal "FILL8 FILL6 FILL4 FILL3 FILL2 FILL1" \
         -connect_to_power VDD -connect_to_ground VSS

