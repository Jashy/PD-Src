remove_stdcell_filler -end_cap -tap
remove_route_by_type -pg_strap -pg_std_cell_pin_conn
remove_placement_blockage *
set_attribute [all_macro_cells ] is_fixed false
remove_terminal *
remove_placement
