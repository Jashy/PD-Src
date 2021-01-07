set MIN_m "1"
set MAX_m "4"
set WIDTH "m1 0.8 m2 0.8 m3 0.8 m4 0.8 m5 0.8 m6 1.6"
set SPACE "m1 0.8 m2 0.4 m3 0.4 m4 0.8 m5 0.8 m6 1.6"
set MINLENGTH "m1 0.5 m2 0.4 m3 0.4 m4 2 m5 2 m6 2"
set MAXLENGTH "m1 4 m2 8 m3 8 m4 4 m5 4 m6 4"
set SPACE_TO_ROUTE "m1 0.5 m2 0.4 m3 0.4 m4 0.4 m5 0.4 m6 0.4"

set_distributed_route
set_route_zrt_common_options -max_number_of_threads 4
set droute_numCPUs 4


set_parameter -name fillDataType -module droute -value 1
insert_metal_filler -from_metal $MIN_m -to_metal $MAX_m -width $WIDTH -min_length $MINLENGTH -max_length $MAXLENGTH -space_to_route $SPACE_TO_ROUTE
