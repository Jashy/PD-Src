group_path -default      -weight 1.0 -critical_range 9.999
group_path -name from_in -weight 0.5 -critical_range 9.999 -from [ all_inputs  ]
group_path -name to_out  -weight 0.5 -critical_range 9.999 -to   [ all_outputs ]

