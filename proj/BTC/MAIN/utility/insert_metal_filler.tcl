echo insert dummy metal
echo [exec date]
set_ignored_layers  -min_routing_layer M1 -max_routing_layer M7
set FILL_CEL [get_attribute [current_mw_cel ] name]

set_parameter -type int -name fillDataType -value 1 -module droute
insert_metal_filler -out ${FILL_CEL}.FILL -tie_to_net none -routing_space 3 -from_metal 1 -to_metal 7 \
        -width          { M1 0.8 M2 0.8 M3 0.8 M4 0.8 M5 0.8 M6 2 M7 2 } \
        -space          { M1 0.8 M2 0.5 M3 0.5 M4 0.8 M5 0.8 M6 2 M7 2 } \
        -space_to_route { M1 1.5 M2 0.5 M3 1.5 M4 1.5 M5 1.5 M6 2 M7 2 } \
        -min_length     { M1 1   M2 1   M3 1   M4 1   M5 1   M6 2 M7 2 } \
        -max_length     { M1 5   M2 5   M3 5   M4 5   M5 5   M6 2 M7 2 }

echo insert dummy metal finish
echo [exec date]

set_ignored_layers  -min_routing_layer M1 -max_routing_layer M6
