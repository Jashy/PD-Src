set_parameter -name doAntennaConx -value 4
set_route_zrt_detail_options -antenna_on_iteration 10

set lib [current_mw_lib]
remove_antenna_rules $lib
define_antenna_rule $lib -mode 3 -diode_mode 2 -metal_ratio 400 -cut_ratio 20
define_antenna_layer_rule $lib -mode 3 -layer "METAL1"  -ratio 500 -diode_ratio {0.125 0  500.00  43900}
define_antenna_layer_rule $lib -mode 3 -layer "METAL2"  -ratio 500 -diode_ratio {0.125 0  500.00  43900}
define_antenna_layer_rule $lib -mode 3 -layer "METAL3"  -ratio 500 -diode_ratio {0.125 0  500.00  43900}
define_antenna_layer_rule $lib -mode 3 -layer "METAL4"  -ratio 500 -diode_ratio {0.125 0  500.00  43900}
define_antenna_layer_rule $lib -mode 3 -layer "METAL5"  -ratio 500 -diode_ratio {0.125 0  500.00  43900}
define_antenna_layer_rule $lib -mode 3 -layer "METAL6"  -ratio 500 -diode_ratio {0.125 0  500.00  43900}
#define_antenna_layer_rule $lib -mode 3 -layer "TM2" -ratio 500 -diode_ratio {0.125 0  9984.00 54400}
define_antenna_layer_rule $lib -mode 3 -layer "VIA12"  -ratio 20  -diode_ratio {0.125 0  200.00  980}
define_antenna_layer_rule $lib -mode 3 -layer "VIA23"  -ratio 20  -diode_ratio {0.125 0  200.00  980}
define_antenna_layer_rule $lib -mode 3 -layer "VIA34"  -ratio 20  -diode_ratio {0.125 0  200.00  980}
define_antenna_layer_rule $lib -mode 3 -layer "VIA45"  -ratio 20  -diode_ratio {0.125 0  200.00  980}
define_antenna_layer_rule $lib -mode 3 -layer "VIA56"  -ratio 20  -diode_ratio {0.125 0  200.00  980}
#define_antenna_layer_rule $lib -mode 3 -layer "TV2" -ratio 20  -diode_ratio {0.125 0  200.00  980}

