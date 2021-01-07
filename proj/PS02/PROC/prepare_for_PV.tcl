###
#legalize_placement -eco -inc
##
## add filler cell
#source ../scripts/insert_filler_cell.tcl
#
#route_zrt_eco -max_detail_route_iterations 100 -reuse_existing_global_route true -open_net_driven true
###
#derive_pg_connection -power_net VDD -power_pin VDD -ground_net VSS -ground_pin VSS
###
#derive_pg_connection -tie
###
#save_mw_cel -as dlu_ni_llp
#
# insert dummy metal
insert_metal_filler \
	-purge

insert_metal_filler \
	-timing_driven \
	-from_metal 2 \
	-to_metal 6 \
	-width {M2 0.2 M3 0.2 M4 0.2 M5 0.2 M6 0.2} \
	-space {M2 0.2 M3 0.2 M4 0.2 M5 0.2 M6 0.2} \
	-space_to_route {M2 0.2 M3 0.2 M4 0.2 M5 0.2 M6 0.2} \
	-min_length {M2 3 M3 3 M4 3 M5 3 M6 3} \
	-max_length {M2 5 M3 5 M4 5 M5 5 M6 3} \
	-distance_to_boundary 1

# save cells 
save_mw_cel -as dlu_ni_llp

# stream out gds file from ICC
set_write_stream_options \
	-output_filling {fill} \
	-output_outdated_fill \
	-output_pin {text geometry} \
	-map_layer /proj/NSP/CURRENT/ELE/brucel/ICC/scripts/gdsout_5X2Z.map \
	-max_name_length 64

write_stream \
	-format gds \
	-cells {dlu_ni_llp} \
	dlu_ni_llp_for_pv.gds

change_names -rule verilog -hier

set fillcap_cell [list FILLCAP128_A12TR FILLCAP64_A12TR FILLCAP32_A12TR FILLCAP16_A12TR FILLCAP8_A12TR FILLCAP4_A12TR FILLCAP3_A12TR]

write_verilog \
	-pg \
	-no_core_filler_cells \
	-force_output_references $fillcap_cell \
	${SESSION}.run/dlu_for_lvs.v


write_verilog \
	-no_core_filler_cells \
	${SESSION}.run/dlu_syn.v

sh touch ./icc_ready
