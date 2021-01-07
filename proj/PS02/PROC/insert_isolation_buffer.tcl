set fr [ open LOG/insert_isolation_buffer.tcl w ]

# ADC12
set analog_ADC1_pin [ get_pins { gaia_0/gadc_0/adc12_0/CLKH gaia_0/gadc_0/adc12_0/VSSAGNDH1 gaia_0/gadc_0/adc12_0/CLK gaia_0/gadc_0/adc12_0/VDDAVDDH1 gaia_0/gadc_0/adc12_0/INM gaia_0/gadc_0/adc12_0/INP gaia_0/gadc_0/adc12_0/VSSAGNDH0 gaia_0/gadc_0/adc12_0/VDDAVDDH0 gaia_0/gadc_0/adc12_0/AREGOUT gaia_0/gadc_0/adc12_0/VSSGUARD gaia_0/gadc_0/adc12_0/ATBHP gaia_0/gadc_0/adc12_0/ATBHM gaia_0/gadc_0/adc12_0/CLKHcheckpin1 gaia_0/gadc_0/adc12_0/CLKcheckpin1 gaia_0/gadc_0/adc12_0/VSSDGND gaia_0/gadc_0/adc12_0/VDDDVDD gaia_0/gadc_0/adc12_0/TIEHI gaia_0/gadc_0/adc12_0/TIELO gaia_0/gadc_0/adc12_0/CLKSEL} ]

# output clock: CLKDOUT
foreach_in_collection pins [ remove_from_collection [ get_pins gaia_0/gadc_0/adc12_0/* ] $analog_ADC1_pin ] {
    set pin [ get_attr $pins full_name ]
    set pin_basename [ get_attr $pins name ] 
    #set net [ get_attr [ get_nets -of_objects [ get_pins $pin ] ] full_name ]
    set x [ lindex [ get_location $pin ] 0 ]
    set y [ lindex [ get_location $pin ] 1 ]
    set coordinates [ concat $x $y ]
    set new_net_name ISO_IP_ADC12_$pin_basename
    set new_cell_name ISO_IP_ADC12_$pin_basename
    set lib_cell tcbn65lpwcl/BUFFD6
    if { [ regexp "CLKDOUT" $pin_basename ] } { set lib_cell tcbn65lpwcl/CKBD12 }
    puts $fr "# $pin"
    puts $fr "insert_buffer -new_net_names $new_net_name -new_cell_names $new_cell_name $pin $lib_cell  -location {$coordinates}"
    #eval "insert_buffer -new_net_names $new_net_name -new_cell_names $new_cell_name $pin $lib_cell  -location {$coordinates}"
}
# ADC8
set analog_ADC2_pin [ get_pins { gaia_0/gramon_0/adc10_0/DVS  gaia_0/gramon_0/adc10_0/DVD  gaia_0/gramon_0/adc10_0/VMONI  gaia_0/gramon_0/adc10_0/AIN  gaia_0/gramon_0/adc10_0/AVD  gaia_0/gramon_0/adc10_0/AVS  gaia_0/gramon_0/adc10_0/VRT  gaia_0/gramon_0/adc10_0/VRB gaia_0/gramon_0/adc10_0/CLK} ]
#VDD VSS? CLK
foreach_in_collection pins [ remove_from_collection [ get_pins gaia_0/gramon_0/adc10_0/* ] $analog_ADC2_pin ] {
    set pin [ get_attr $pins full_name ]
    set pin_basename [ get_attr $pins name ] 
    #set net [ get_attr [ get_nets -of_objects [ get_pins $pin ] ] full_name ]
    set x [ lindex [ get_location $pin ] 0 ]
    set y [ lindex [ get_location $pin ] 1 ]
    set coordinates [ concat $x $y ]
    set new_net_name ISO_IP_ADC10_$pin_basename
    set new_cell_name ISO_IP_ADC10_$pin_basename
    set lib_cell tcbn65lpwcl/BUFFD6
    puts $fr "# $pin"
    puts $fr "insert_buffer -new_net_names $new_net_name -new_cell_names $new_cell_name $pin $lib_cell  -location {$coordinates}"
    #eval "insert_buffer -new_net_names $new_net_name -new_cell_names $new_cell_name $pin $lib_cell  -location {$coordinates}"
}

#OSC
set analog_OSC_pin [ get_pins { osc_0/ATB_HM osc_0/ATB_HP osc_0/AVDD_H osc_0/GUARD osc_0/AGND_H osc_0/XTALIN osc_0/XTALOUT osc_0/DVDD osc_0/DGND osc_0/CLKDIV2_H osc_0/TIEHI osc_0/TIELO osc_0/CLK_H osc_0/CLK} ]

#CLKDIV2_H floating clock CLK CLK_H 
foreach_in_collection pins [ remove_from_collection [ get_pins osc_0/* ] $analog_OSC_pin ] {
    set pin [ get_attr $pins full_name ]
    set pin_basename [ get_attr $pins name ] 
    #set net [ get_attr [ get_nets -of_objects [ get_pins $pin ] ] full_name ]
    set x [ lindex [ get_location $pin ] 0 ]
    set y [ lindex [ get_location $pin ] 1 ]
    set coordinates [ concat $x $y ]
    set new_net_name ISO_IP_OSC_$pin_basename
    set new_cell_name ISO_IP_OSC_$pin_basename
    set lib_cell tcbn65lpwcl/BUFFD6
    ### CLK, CLK_H
    if { [ regexp "CLK" $pin_basename ] } { set lib_cell tcbn65lpwcl/CKBD8 }
    puts $fr "# $pin"
    puts $fr "insert_buffer -new_net_names $new_net_name -new_cell_names $new_cell_name $pin $lib_cell  -location {$coordinates}"
    #eval "insert_buffer -new_net_names $new_net_name -new_cell_names $new_cell_name $pin $lib_cell  -location {$coordinates}"
}
#PLL
   set pin gaia_0/gclkgen_0/pll_0/FOUT
   set pin_basename [ get_attr $pin name ]
   set x [ lindex [ get_location $pin ] 0 ]
   set y [ lindex [ get_location $pin ] 1 ]
   set coordinates [ concat $x $y ]
   set new_net_name ISO_IP_PLL_$pin_basename
   set new_cell_name ISO_IP_PLL_$pin_basename
   set lib_cell tcbn65lpwcl/CKBD16
   puts $fr "# $pin"
   puts $fr "insert_buffer -new_net_names $new_net_name -new_cell_names $new_cell_name $pin $lib_cell  -location {$coordinates}"

# IO

set ports [ get_nets {TSDATA3 TSDATA4 TSDATA5 TSDATA6 TSDATA7 DVBT2ENBN DVBTENBN DVBCENBN SCL SDA TESTMODE TSDATA2 PLLBPN A0 TSDATA1 OSCENBN TSDATA0 RESETN TSCLK OSCMODE TSVALID TSSYNC TSERR_GPIO2_OSCOUT INTRPTN_GPIO0 IFAGC RFAGC_GPIO1 TUNERDAT } ] 

set BUFF12_IN "SCL|SDA|A0|TSDATA3|TSDATA3|TSDATA4|TUNERDAT|RFAGC_GPIO1"
set BUFF16_IN "INTRPTN_GPIO0|TSERR_GPIO2_OSCOUT"
set BUFF8_OUT "TSDATA7"
set BUFF12_OUT "TSDATA4|TSDATA5|TSDATA6"

foreach_in_collection port1 $ports {
       set port [ get_attr $port1 full_name ] 
       set cell [ get_attr [ get_cell -of_objects [ get_nets $port ] ] full_name  ]
       set x_coordinate [ lindex [ get_location $cell ] 0 ]
       set y_coordinate [ lindex [ get_location $cell ] 1 ]
       set coordinates [ concat $x_coordinate $y_coordinate ]
       set net1 [ get_attr [ get_nets -of_objects [ get_pins $cell/I ] ] full_name  ]
       set net2 [ get_attr [ get_nets -of_objects [ get_pins $cell/C ] ] full_name  ]
       set pin1 [ get_attr  [ get_pins $cell/I ]  full_name  ]
       set pin2 [ get_attr  [ get_pins $cell/C ]  full_name  ]
       set new_net_name1 ISO_IO_${cell}_I
       set new_cell_name1 ISO_IO_${cell}_I
       set new_net_name2 ISO_IO_${cell}_C
       set new_cell_name2 ISO_IO_${cell}_C
       set BUFF_OUT BUFFD6
       set BUFF_IN BUFFD6
       if { [ regexp "$BUFF12_IN" $port ] } { set BUFF_IN tcbn65lpwcl/BUFFD12 }
       if { [ regexp "$BUFF16_IN" $port ] } { set BUFF_IN tcbn65lpwcl/BUFFD16 }
       if { [ regexp "$BUFF8_OUT" $port ] } { set BUFF_OUT tcbn65lpwcl/BUFFD8 }
       if { [ regexp "$BUFF12_OUT" $port ] } { set BUFF_OUT tcbn65lpwcl/BUFFD12 }
       if { [ regexp "TSDATA0|TSDATA1|TSDATA2" $port ] } {
           puts $fr "# $cell"
           puts $fr "insert_buffer -new_net_names $new_net_name1 -new_cell_names $new_cell_name1  $pin1  tcbn65lpwcl/BUFFD8 -location {$coordinates} "
           puts $fr "insert_buffer -new_net_names special_out_${new_cell_name1}_I -new_cell_names special_out_${new_cell_name1}_I \[ get_pins $new_cell_name1/I\]  -no_of_cells 4 tcbn65lpwcl/BUFFD20 -location {4743 2178 5204.9 1570.4 5200 848 5195.6 151} "
       } elseif {[ regexp "TSDATA3" $port ]} {
           puts $fr "# $cell"
           puts $fr "insert_buffer -new_net_names $new_net_name1 -new_cell_names $new_cell_name1 $pin1 tcbn65lpwcl/BUFFD8  -location {$coordinates}"
           puts $fr "insert_buffer -new_net_names special_out_${new_cell_name1}_I -new_cell_names special_out_${new_cell_name1}_I \[ get_pins $new_cell_name1/I\] tcbn65lpwcl/BUFFD16  -location {5215.9 1400}"
           #eval "insert_buffer -new_net_names ISO_IO -new_cell_names ISO_IO $pin1 BUFFD16  -location {5215.9 1400}"
       } elseif {[ regexp "TSVALID" $port ]} {
           puts $fr "# $cell"
           puts $fr "insert_buffer -new_net_names $new_net_name1 -new_cell_names $new_cell_name1 $pin1 tcbn65lpwcl/BUFFD8  -location {$coordinates}"
           puts $fr "insert_buffer -new_net_names special_out_${new_cell_name1}_I -new_cell_names special_out_${new_cell_name1}_I \[ get_pins $new_cell_name1/I\] tcbn65lpwcl/BUFFD20  -location {1383.5 1144.5}"
           #eval"insert_buffer -new_net_names ISO_IO -new_cell_names ISO_IO $pin1 BUFFD16  -location {1383.5 1144.5}"
       } elseif {[ regexp "TSSYNC" $port ]} {
           puts $fr "# $cell"
           puts $fr "insert_buffer -new_net_names $new_net_name1 -new_cell_names $new_cell_name1 $pin1 BUFFD8  -location {$coordinates}"
           puts $fr "insert_buffer -new_net_names special_out_${new_cell_name1}_I -new_cell_names special_out_${new_cell_name1}_I \[ get_pins $new_cell_name1/I\] tcbn65lpwcl/BUFFD20  -location {901 1000}"
           #eval "insert_buffer -new_net_names ISO_IO -new_cell_names ISO_IO $pin1 BUFFD16  -location {901 1000}"
       } elseif {[ regexp "TSERR_GPIO2_OSCOUT" $port ]} {
           puts $fr "# $cell"
           puts $fr "insert_buffer -new_net_names $new_net_name1 -new_cell_names $new_cell_name1 $pin1 BUFFD8  -location {$coordinates}"
           puts $fr "insert_buffer -new_net_names special_out_${new_cell_name1}_I -new_cell_names special_out_${new_cell_name1}_I \[ get_pins $new_cell_name1/I\] tcbn65lpwcl/BUFFD20  -location {968 1026}"
           #eval "insert_buffer -new_net_names ISO_IO -new_cell_names ISO_IO $pin1 BUFFD16  -location {901 1000}"
       } else {
           puts $fr "# $cell"
           puts $fr "insert_buffer -new_net_names $new_net_name1 -new_cell_names $new_cell_name1 $pin1 $BUFF_OUT  -location {$coordinates}"
           #eval "insert_buffer -new_net_names ISO_IO -new_cell_names ISO_IO $pin1 $BUFF_OUT  -location {$coordinates}"
       }
       if { [ regexp "TSDATA1|TSDATA2" $port ]} {
          puts $fr "# $cell"
          puts $fr "insert_buffer -new_net_names special_in_$new_net_name2 -new_cell_names special_in_$new_net_name2  -no_of_cells 3 $pin2 tcbn65lpwcl/BUFFD16 -location {$coordinates 5195.6 466.7 5204.9 1570.4} "
          #eval "insert_buffer -new_net_names ISO_IO -new_cell_names ISO_IO -no_of_cells 3 $pin2 {$coordinates 5195.6 466.7 5204.9 1570.4} BUFFD16"
       } else {
          puts $fr "# $cell"
          puts $fr "insert_buffer -new_net_names $new_net_name2 -new_cell_names $new_net_name2 $pin2 $BUFF_IN  -location {$coordinates}"
          #eval "insert_buffer -new_net_names ISO_IO -new_cell_names ISO_IO $pin2 {$BUFF_IN} -location {$coordinates}" 
      }
}
close $fr
