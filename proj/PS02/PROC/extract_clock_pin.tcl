####################################################################################################
# PROGRAM     : extract_clock_pin.tcl
# DESCRIPTION : Extract pin on clock network. User attribute named 'is_extracted_clock_pin" will be added.
# WRITTEN BY  : Mitsuya Takashima <mitsuya@alchip.com>
# LAST UPDATE : Sat Nov 28 12:04:19 JST 2009
# TESTED ON   : Version C-2009.06-ICC for amd64 -- May 28, 2009
####################################################################################################

proc extract_clock_pin { { clock_names * } } {
  global synopsys_program_name

  ####################################################################################################
  # DESIGN DEPENDENT CONFIGURATION
  ####################################################################################################
  set source_port_patterns {
  }

  set source_pin_patterns {
  }

  set sink_pin_patterns {
    */*CK*
    */*CLK*
    */CP
    */CPN
  }

  set sink_port_patterns {
      GPIO0
      GPIO1
      GPIO2
      TSCLK
      TTUSCL
      TTUSDA
      TIFAGC
      TSSYNC
      TSVALID
  }
  if { [ get_attribute [ current_design ] full_name ] == "T2CD" } {
    set sink_port_patterns {
      SD1CLK
      SD2CLK
      LCDDCLK
      MS1SCLK
      MS2SCLK
      DVECLK
      AU1BCLK
      PIOD22
    }
  }
  if { [ get_attribute [ current_design ] full_name ] == "CPU_MEDIA" } {
    set sink_port_patterns {
      CK_LBUS
    }
  }
  if { [ get_attribute [ current_design ] full_name ] == "T2CDS" } {
    set sink_port_patterns {
      AUCKDAC
      SD1CLK
      LCDDCLK
      MS1SCLK
      MS2SCLK
      DVECLK
      AU1BCLK
      SPI1CLK
      SPI2CLK
    }
    set sink_port_patterns {
      SD1CLK
      LCDDCLK
      MS1SCLK
      MS2SCLK
      DVECLK
      AU1BCLK
      SPI1CLK
      SPI2CLK
    }
  }

  ####################################################################################################
  # MAIN
  ####################################################################################################
  if { $synopsys_program_name == "icc_shell" } {
    foreach_in_collection port [ get_ports * -quiet ] {
      set port_net [ all_connected $port ]
      set pad_pin [ filter_collection [ all_connected $port_net ] "object_class == pin" ]
      if { [ sizeof_collection $pad_pin ] == 1 } {
        set io_cell [ get_cells -of_objects $pad_pin ]
        set io_cell_name [ get_attribute $io_cell full_name ]
        if { ( [ sizeof_collection [ get_pins $io_cell_name/I -quiet ] ] == 1 ) && ( [ sizeof_collection [ get_pins $io_cell_name/PAD -quiet ] ] == 1 ) } {
          echo [ format "set_disable_timing \[ get_cells %s \] -from I -to PAD" $io_cell_name ]
          eval [ format "set_disable_timing \[ get_cells %s \] -from I -to PAD" $io_cell_name ] > /dev/null
        }
      }
    }
  }

  set clocks [ add_to_collection -unique [ get_clocks $clock_names -quiet ] [ get_generated_clocks $clock_names -quiet ] ]
  echo [ format "Information: %d clocks found." [ sizeof_collection $clocks ] ]
  if { [ sizeof_collection $clocks ] == 0 } {
    return
  }

  set source_pins ""
  foreach_in_collection clock $clocks {
    set source_pins [ add_to_collection -unique $source_pins [ get_attribute $clock sources -quiet ] ]
   #foreach_in_collection source [ get_attribute $clock sources -quiet ] {
   #  if { ( [ get_attribute $source object_class ] == "port" ) && ( [ sizeof_collection [ get_generated_clocks [ get_attribute $clock full_name ] -quiet ] ] != 0 ) } { continue }
   #  set source_pins [ add_to_collection -unique $source_pins $source ]
   #}
  }
  if { [ llength $source_pin_patterns ] > 0 } {
    set source_pins [ add_to_collection -unique $source_pins [ get_pins $source_pin_patterns -quiet ] ]
  }
  if { [ llength $source_port_patterns ] > 0 } {
    set source_pins [ add_to_collection -unique $source_pins [ get_ports $source_port_patterns -quiet ] ]
  }
  echo [ format "Information: %d source pins found." [ sizeof_collection $source_pins ] ]
  if { [ sizeof_collection $source_pins ] == 0 } {
    return
  }

 #set sink_pins [ get_pins */* -hierarchical -filter "is_hierarchical != true && is_on_clock_network == true" -quiet ]
 #set sink_pins ""
 #foreach_in_collection pin [ get_pins */* -hierarchical -filter "is_hierarchical != true && is_on_clock_network == true" -quiet ] {
 #  if { [ get_attribute [ get_lib_pins -of_objects $pin ] clocked_on ] == "true" } {
 #    set sink_pins [ add_to_collection -unique $sink_pins $pin ]
 #  }
 #}
  set sink_pins ""
  if { [ llength $sink_pin_patterns ] > 0 } {
   #set sink_pins [ add_to_collection -unique $sink_pins [ get_pins $sink_pin_patterns -hierarchical -filter "is_hierarchical != true && is_on_clock_network != true" -quiet ] ]
    set sink_pins [ add_to_collection -unique $sink_pins [ get_pins $sink_pin_patterns -hierarchical -filter "is_hierarchical != true && direction == in" -quiet ] ]
  }
  if { [ llength $sink_port_patterns ] > 0 } {
    set sink_pins [ add_to_collection -unique $sink_pins [ get_ports $sink_port_patterns -quiet ] ]
  }
  echo [ format "Information: %d sink pins found." [ sizeof_collection $source_pins ] ]
  if { [ sizeof_collection $sink_pins ] == 0 } {
    return
  }

  set fanout_pins [ all_fanout -flat -from $source_pins ]
  set fanin_pins [ all_fanin -flat -to $sink_pins ]

  set clock_pins [ add_to_collection -unique $fanout_pins $fanin_pins ]
  set clock_pins [ remove_from_collection $clock_pins [ remove_from_collection $fanout_pins $fanin_pins ] ]
  set clock_pins [ remove_from_collection $clock_pins [ remove_from_collection $fanin_pins $fanout_pins ] ]

  # Warning: Attribute '%s' is already defined in class '%s' (UIAT-4)
  suppress_message UIAT-4
  define_user_attribute -type boolean -class port is_extracted_clock_pin
  define_user_attribute -type boolean -class pin  is_extracted_clock_pin
  unsuppress_message UIAT-4

  remove_user_attribute [ add_to_collection -unique [ get_pins */* -quiet -hierarchical -filter "is_hierarchical != true" ] [ get_ports * -quiet ] ] is_extracted_clock_pin -quiet

  if { $synopsys_program_name == "icc_shell" } {
    foreach_in_collection clock_pin $clock_pins {
      if { [ get_attribute $clock_pin object_class ] == "port" } {
        echo [ format "set_attribute \[ get_ports %s \] is_extracted_clock_pin true" [ get_attribute $clock_pin full_name ] ]
        eval [ format "set_attribute \[ get_ports %s \] is_extracted_clock_pin true" [ get_attribute $clock_pin full_name ] ]
#        echo [ format "set_attribute \[ get_ports %s \] is_extracted_clock_pin true" [ get_attribute $clock_pin full_name ] ]
#        eval [ format "set_attribute \[ get_ports %s \] is_extracted_clock_pin true" [ get_attribute $clock_pin full_name ] ]
      } else {
        if { [ get_attribute $clock_pin is_internal ] != "true" } {
          echo [ format "set_attribute \[ get_pins %s \] is_extracted_clock_pin true" [ get_attribute $clock_pin full_name ] ]
          eval [ format "set_attribute \[ get_pins %s \] is_extracted_clock_pin true" [ get_attribute $clock_pin full_name ] ]
#          echo [ format "set_attribute \[ get_pins %s \] is_extracted_clock_pin true" [ get_attribute $clock_pin full_name ] ]
#          eval [ format "set_attribute \[ get_pins %s \] is_extracted_clock_pin true" [ get_attribute $clock_pin full_name ] ]
        }
      }
    }
  } else {
    foreach_in_collection clock_pin $clock_pins {
      set_attribute $clock_pin is_extracted_clock_pin true
#      set_attribute $clock_pin is_extracted_clock_pin true
    }
  }

  if { $synopsys_program_name == "icc_shell" } {
    foreach_in_collection port [ get_ports * -quiet ] {
      set port_net [ all_connected $port ]
      set pad_pin [ filter_collection [ all_connected $port_net ] "object_class == pin" ]
      if { [ sizeof_collection $pad_pin ] == 1 } {
        set io_cell [ get_cells -of_objects $pad_pin ]
        set io_cell_name [ get_attribute $io_cell full_name ]
        if { ( [ sizeof_collection [ get_pins $io_cell_name/I -quiet ] ] == 1 ) && ( [ sizeof_collection [ get_pins $io_cell_name/PAD -quiet ] ] == 1 ) } {
          echo [ format "remove_disable_timing \[ get_cells %s \] -from I -to PAD" $io_cell_name ]
          eval [ format "remove_disable_timing \[ get_cells %s \] -from I -to PAD" $io_cell_name ] > /dev/null
        }
      }
    }
  }

}

if { 1 == 0 } {

source /proj/Zhui/CURRENT/STA/rogern/PT/ZhuiTS/20091229_check/extract_clock_pin.tcl
extract_clock_pin > extract_clock_pin.log

#source /proj/T2CDST/RELEASE/20091121_SDC/keep_model_MS_SD_EMC_DDR_CIF_clkdelay-T2CDS.sdc.1023

source /proj/Zhui/CURRENT/STA/rogern/PT/ZhuiTS/20091229_check/check_clock_cell_type.tcl
check_clock_cell_type > check_clock_cell_type.log

source /proj/Zhui/CURRENT/STA/rogern/PT/ZhuiTS/20091229_check/write_clock_pin_list.tcl
#write_clock_pin_list /proj/T2CDST_tmp/WORK/TOP/mitsuya/PT/20091127_CLOCK/T2CDS_20091130.clock_pin.list
write_clock_pin_list clock_pin.list

}

