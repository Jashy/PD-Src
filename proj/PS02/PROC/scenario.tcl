set OPCOND_MAX                  "WCCOML"
set OPCOND_MIN                  "WCCOML"
set OPCOND_LIB                  "tcbn65lphvtwcl"
set OPCOND_2_LIB                "tcbn65lpwcl"
set TLIPLUS_MAX                 $TLUP_MAX
# set TLIPLUS_MIN                 $TLUP_MIN
set TLIPLUS_MIN                 $TLUP_MAX

set SCENARIO_1                  "func_ww"
set SDC_1                       $FUNC_SDC

set SCENARIO_2                  ""
set SDC_2                       $AC_SCAN_CAP

set SCENARIO_3                  ""
set SDC_3                       $AC_SCAN_SHIFT

set SCENARIO_4                  ""
set SDC_4                       $DC_SCAN_CAP

set SCENARIO_5                  ""
set SDC_5                       $DC_SCAN_SHIFT

set SCENARIO_6                  ""
set SDC_6                       $MBIST


set OPCOND_MACRO		./tcl/set_operating_conditions.tcl


if {$SCENARIO_1 != "" && $SDC_1 != ""} {
    echo "SCRIPT-Info : Setting up scenario $SCENARIO_1"
    create_scenario $SCENARIO_1

    set_operating_conditions -analysis_type on_chip_variation -max $OPCOND_MAX -min $OPCOND_MIN -library $OPCOND_LIB
    set_operating_conditions -analysis_type on_chip_variation -max $OPCOND_MAX -min $OPCOND_MIN -library $OPCOND_2_LIB
    set_tlu_plus_files -max_tluplus $TLIPLUS_MAX -min_tluplus $TLIPLUS_MIN -tech2itf_map $TLUP_MAP
    source $OPCOND_MACRO
    set auto_link_disable true
    source -e $SDC_1 >> ${SESSION}.run/read_function_sdc.log
    source $DERATE

        foreach_in_collection test_clock [all_clocks] {
                set_input_delay 4 [remove_from_collection [all_inputs] {SCL RST_X SLVADR SDA STUSCL TTUSCL TSDATA6 TSCLK}] -clock ${test_clock}
                set_output_delay 4 [all_outputs] -clock ${test_clock}
        }
        foreach_in_collection test_clock [all_clocks] {
                set_output_delay -363 -clock $test_clock  -max [get_ports {SDA}]
                set_output_delay -3   -clock $test_clock  -max [get_ports {STUSCL}]
                set_output_delay -3   -clock $test_clock  -max [get_ports {STUSDA}]
                set_output_delay -3   -clock $test_clock  -max [get_ports {TTUSCL}]
                set_output_delay -3   -clock $test_clock  -max [get_ports {TTUSDA}]
                set_input_delay -2   -clock $test_clock  -max [get_ports {RST_X}]
                set_input_delay -1   -clock $test_clock  -max [get_ports {SLVADR}]
                set_input_delay -16   -clock $test_clock  -max [get_ports {SCL}]
                set_input_delay -16   -clock $test_clock  -max [get_ports {SDA}]
        }

    # constraint for layout
    set_clock_uncertainty -setup 0.7 [ all_clocks ]
    set_clock_uncertainty -hold  0.2 [ all_clocks ]

    set auto_link_disable false


}

if {$SCENARIO_2 != "" && $SDC_2 != ""} {
    echo "SCRIPT-Info : Setting up scenario $SCENARIO_2"
    create_scenario $SCENARIO_2

    set_operating_conditions -analysis_type on_chip_variation -max $OPCOND_MAX -min $OPCOND_MAX -library $OPCOND_LIB
    set_operating_conditions -analysis_type on_chip_variation -max $OPCOND_MAX -min $OPCOND_MAX -library $OPCOND_2_LIB
    source $OPCOND_MACRO
    set_tlu_plus_files -max_tluplus $TLIPLUS_MAX -min_tluplus $TLIPLUS_MIN -tech2itf_map $TLUP_MAP

    set auto_link_disable true
    source -e $SDC_2 >> ${SESSION}.run/read_scan1_sdc.log
    source $DERATE

    set auto_link_disable false
        foreach_in_collection test_clock [all_clocks] {
                set_input_delay -2   -clock $test_clock  -max [get_ports {RST_X}]
                set_input_delay -1   -clock $test_clock  -max [get_ports {SLVADR}]
                set_input_delay -16   -clock $test_clock  -max [get_ports {SCL}]
                set_input_delay -16   -clock $test_clock  -max [get_ports {SDA}]
        }

}

if {$SCENARIO_3 != "" && $SDC_3 != ""} {
    echo "SCRIPT-Info : Setting up scenario $SCENARIO_3"
    create_scenario $SCENARIO_3

    set_operating_conditions -analysis_type on_chip_variation -max $OPCOND_MAX -min $OPCOND_MIN -library $OPCOND_LIB
    set_operating_conditions -analysis_type on_chip_variation -max $OPCOND_MAX -min $OPCOND_MAX -library $OPCOND_2_LIB
    source $OPCOND_MACRO
    set_tlu_plus_files -max_tluplus $TLIPLUS_MAX -min_tluplus $TLIPLUS_MIN -tech2itf_map $TLUP_MAP

    set auto_link_disable true
    source -e $SDC_3 >> ${SESSION}.run/read_scan2_sdc.log
    source $DERATE
    set_false_path -from [get_ports TSDATA* ] -to [ get_ports GPIO* ]
    set_false_path -from [get_ports TSDATA* ] -to [ get_ports STUSDA ]
    set_false_path -from [get_ports TSDATA* ] -to [ get_ports SAGC ]
    set_false_path -from [get_ports TSDATA* ] -to [ get_ports STUSCL ]
		set_false_path -from [ get_ports OSCMODE ] -to [ get_ports STUSCL ]
		set_false_path -from [ get_ports OSCMODE ] -to [ get_ports STUSDA ]
		set_false_path -from [ get_ports TSDATA* ] -to [ get_ports GPIO* ]
		set_false_path -from [ get_ports TSDATA* ] -to [ get_ports SAGC ]
		set_false_path -from [ get_ports TSDATA* ] -to [ get_ports STUSDA ]
		set_false_path -from [ get_ports TSDATA* ] -to [ get_ports STUSCL ]
    set auto_link_disable false
}

if {$SCENARIO_5 != "" && $SDC_5 != ""} {
    echo "SCRIPT-Info : Setting up scenario $SCENARIO_5"
    create_scenario $SCENARIO_5

    set_operating_conditions -analysis_type on_chip_variation -max $OPCOND_MAX -min $OPCOND_MIN -library $OPCOND_LIB
    set_operating_conditions -analysis_type on_chip_variation -max $OPCOND_MAX -min $OPCOND_MAX -library $OPCOND_2_LIB
    source $OPCOND_MACRO
    set_tlu_plus_files -max_tluplus $TLIPLUS_MAX -min_tluplus $TLIPLUS_MIN -tech2itf_map $TLUP_MAP

    set auto_link_disable true
    source -e $SDC_5 >> ${SESSION}.run/read_scan4_sdc.log
    source $DERATE
    set auto_link_disable false
    set_false_path -from [get_ports TSDATA* ] -to [ get_ports GPIO* ]
    set_false_path -from [get_ports TSDATA* ] -to [ get_ports STUSDA ]
    set_false_path -from [get_ports TSDATA* ] -to [ get_ports SAGC ]
    set_false_path -from [get_ports TSDATA* ] -to [ get_ports STUSCL ]
		set_false_path -th [ get_pin b_tsdata*_0/C ] -th [ get_pins b_gpio*_0/I  ]
		set_false_path -th [ get_pin b_tsdata*_0/C ] -th [ get_pins b_stuscl_0/I ]
		set_false_path -th [ get_pin b_tsdata*_0/C ] -to [ get_pins b_stusda_0/I ]
		set_false_path -th [ get_pin b_tsdata*_0/C ] -to [ get_pins o_sagc_0/I ]
}

if {$SCENARIO_6 != "" && $SDC_6 != ""} {
    echo "SCRIPT-Info : Setting up scenario $SCENARIO_6"
    create_scenario $SCENARIO_6

    set_operating_conditions -analysis_type on_chip_variation -max $OPCOND_MAX -min $OPCOND_MAX -library $OPCOND_LIB
    set_operating_conditions -analysis_type on_chip_variation -max $OPCOND_MAX -min $OPCOND_MAX -library $OPCOND_2_LIB
    source $OPCOND_MACRO
    set_tlu_plus_files -max_tluplus $TLIPLUS_MAX -min_tluplus $TLIPLUS_MIN -tech2itf_map $TLUP_MAP

    set auto_link_disable true
    source -e $SDC_6 >> ${SESSION}.run/read_scan1_sdc.log
    source $DERATE
        foreach_in_collection test_clock [all_clocks] {
                set_input_delay -2   -clock $test_clock  -max [get_ports {RST_X}]
                set_output_delay 0   -clock $test_clock  -max [get_ports {TSVALID}]
                set_input_delay -1   -clock $test_clock  -max [get_ports {SLVADR}]
                set_input_delay -16   -clock $test_clock  -max [get_ports {SCL}]
                set_input_delay -16   -clock $test_clock  -max [get_ports {SDA}]

		
        }
		set_false_path -from [ get_ports OSCMODE ] -to [ get_ports STUSCL ]
		set_false_path -from [ get_ports OSCMODE ] -to [ get_ports STUSDA ]
		set_false_path -from [ get_ports TSDATA* ] -to [ get_ports GPIO* ]
		set_false_path -from [ get_ports TSDATA* ] -to [ get_ports SAGC ]
		set_false_path -from [ get_ports TSDATA* ] -to [ get_ports STUSDA ]
		set_false_path -from [ get_ports TSDATA* ] -to [ get_ports STUSCL ]
		set_false_path -from [ get_ports TSDATA* ] -to [ get_ports STUSCL ]
		set_false_path -th [ get_pin b_tsdata*_0/C ] -to [ get_ports STUSCL ]
		set_false_path -th [ get_pin b_tsdata*_0/C ] -to [ get_ports STUSDA ]
		set_false_path -th [ get_pin b_tsdata*_0/C ] -to [ get_ports GPIO* ]
		set_false_path -th [ get_pin b_tsdata*_0/C ] -to [ get_ports SAGC* ]

    # for layout constraint

    set auto_link_disable false
}

