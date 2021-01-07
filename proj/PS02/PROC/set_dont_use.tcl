########################################################################
# dont_use & dont_touch
#
foreach_in_collection lib [ get_libs tcb013* ] {
  set lib_name [ get_attribute $lib name ]
  foreach_in_collection lib_cell [ get_lib_cells $lib_name/* ] {
    set lib_cell_name [ get_attribute $lib_cell name ]

    set dont_use 0
    set dont_touch 0

    # Weak Cell
    if { ( [ regexp {^.*X1.*$} $lib_cell_name ] == 1 ) } {
      set dont_use 1
      set comment "Weak Cell"
    }
    if { ( [ regexp {^.*XL.*$} $lib_cell_name ] == 1 ) } {
       set dont_use 1
       set comment "Weak Cell"
     }


    # Big Cell
    if { ( [ regexp {^.*D24.*$} $lib_cell_name ] == 1 ) || \
         ( [ regexp {^.*D24HVT$} $lib_cell_name ] == 1 ) || \
         ( [ regexp {^.*D0HVT$} $lib_cell_name ] == 1 ) || \
         ( [ regexp {^.*D0$} $lib_cell_name ] == 1 ) } {
      set dont_use 1
      set comment "Big Cell"
    }

    # Balanced Cell
#    if { [ regexp {^CK.*$} $lib_cell_name ] == 1 } {
#      set dont_use 1
#      set dont_touch 1
#      set comment "Balanced Cell"
#    }

   # GateArray Cell
    if { [ regexp {^G.*$} $lib_cell_name ] == 1 } {
      set dont_use 1
      set dont_touch 1
      set comment "GateArray Cell"
    }

    # Delay Cell LVT
    if { [ regexp {^DLY[0-9]*$} $lib_cell_name ] == 1 } {
      set dont_use 1
      set dont_touch 1
      set comment "Delay Cell"
    }

    # Negtive Sequential Cell
#    if { [ regexp {^DFN.*} $lib_cell_name ] == 1 } {
#      set dont_use 1
#      set dont_touch 1
#    }
    # always buffers
#    if { [ regexp {^PTBUF.*} $lib_cell_name ] == 1 } {
#      set dont_use 1
#      set dont_touch 1
#    }
    # RETENT REGISTER
#    if { [ regexp {^RF.*} $lib_cell_name ] == 1 } {
#      set dont_use 1
#      set dont_touch 1
#    }
    # MTCMOS
    if { [ regexp {^PTDFC.*} $lib_cell_name ] == 1 } {
      set dont_use 1
      set dont_touch 1
    }
    #TBUF
     if { [ regexp {^TBUF.*$} $lib_cell_name ] == 1 } {
       set dont_use 1
     }

#    if { [ regexp {^HDRDI.*} $lib_cell_name ] == 1 } {
#      set dont_use 1
#      set dont_touch 1
#    }
#    if { [ regexp {^HDRSI.*} $lib_cell_name ] == 1 } {
#            set dont_use 1
#            set dont_touch 1
#    }
                        
    # Clock Enabler
 #   if { [ regexp {^TLATNCAX[0-9]+$} $lib_cell_name ] == 1 ||
 #        [ regexp {^TLATNTSCAX[0-9]+} $lib_cell_name ] == 1 } {
 #     set dont_use 1
 #     set dont_touch 1
 #   }

    # Register File
  #  if { [ regexp {^RFRDX[0-9]+$} $lib_cell_name ] == 1 ||
  #       [ regexp {^RF[0-9]R1WX1$} $lib_cell_name ] == 1 } {
  #    set dont_use 1
  #    set dont_touch 1
  #  }

    # Latch
#   if { [ regexp {^LH.*[0-9]$} $lib_cell_name ] == 1 ||
#         [ regexp {^LN.*[0-9]$} $lib_cell_name ] == 1 } {
#      set dont_use 1
#      set dont_touch 1
#   }

#   Tie Cell
    if { [ regexp {^TIE.*$} $lib_cell_name ] == 1 } {
      set dont_use 1
      set dont_touch 1
    }

    # Hold cell
  #  if { [ regexp {^HOLD.*$} $lib_cell_name ] == 1 } {
  #    set dont_use 1
  #    set dont_touch 1
  #  }

    if { $dont_use == 1 } {
      echo "set_dont_use   \[ get_lib_cells $lib_name/$lib_cell_name \]"
      eval "set_dont_use   \[ get_lib_cells $lib_name/$lib_cell_name \]"
     eval "set_attribute \[ get_lib_cells $lib_name/$lib_cell_name \] dont_touch false" 
    }
    if { $dont_touch == 1 } {
      echo "set_dont_touch \[ get_lib_cells $lib_name/$lib_cell_name \]"
      eval "set_dont_touch \[ get_lib_cells $lib_name/$lib_cell_name \]"
    }
  }
}
