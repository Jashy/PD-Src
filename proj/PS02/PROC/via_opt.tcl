## via opt
echo "via opt begin" >> time.log
exec date
define_zrt_redundant_vias -from_via {VIA1 VIA2 VIA3 VIA4 VIA5 VIA6} -to_via {VIA1 VIA2 VIA3 VIA4 VIA5 VIA6} -to_via_x_size {1 1 1 1 1 1} \
-to_via_y_size {2 2 2 2 2 2} 
#insert_zrt_redundant_vias

insert_zrt_redundant_vias 

exec date
echo "via opt end" >> time.log

