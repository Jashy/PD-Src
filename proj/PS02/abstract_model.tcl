set sh_output_log_file icc_log_abstract
set SEV(src)      020_icc_crt_design
set SEV(dst)      060_icc_place_opt
set SEV(dst_key)  place_opt       ; # for lib_model/lib_vt selection; icc_crt_design use the same setting as place_opt
set SEV(work_dir) [ pwd ]
set CLOCK_MODE "ideal" ; #ideal for place_opt
source $SEV(work_dir)/scripts/des.tcl

set SVAR(src,sdc)                        "/proj/PS02/RELEASE/From_top/CF/SDC_From_marshal/20151126_update_mcu/all_sdc/"
set CLOCK_MODE ideal ; # set propagated if route_opt database
sproc_source -file $SEV(scripts_dir)/scripts/generic/mcmm.scenarios.tcl
create_macro_fram
create_block_abstraction
save_mw_cel -as $SEV(design_name) 
