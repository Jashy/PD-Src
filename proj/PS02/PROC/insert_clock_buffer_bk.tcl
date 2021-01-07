proc insert_clock_buffer { root_pin_names } {

  ####################################################################################################
  # DESIGN DEPENDENT CONFIGURATION
  #

#set structure_list(d2993/top/CKsusbh)		     { { { CQBNIVX32H 1 } } { { CQBNIVX32H 1 } { CQBNIVX32H 6 } } { { CQBNIVX48H 10 } { CQBNIVX48H  0 } } }
 

  ####################################################################################################
  # TECHNOLOGY DEPENDENT CONFIGURATION
  #
  ####################################################################################################
  # TECHNOLOGY DEPENDENT CONFIGURATION
  #
  #  tcb013ghpwc/CKBD24
  #    capacitance : 0.0386;
  #
  #CKND6
  #    capacitance : 0.0404;

  proc get_model { model_name } {
    if { [regexp {\/} $model_name ] == 1} {
      if { [ sizeof_collection [ get_lib_cells $model_name -quiet ] ] != 0 } {
        return [ get_lib_cells $model_name ]
      } else {
        return 0
      }
    } else {
      foreach_in_collection lib [get_libs *] {
        set lib_name [ get_object_name $lib ]
        if { [ sizeof_collection [ get_lib_cells $lib_name/$model_name -quiet ] ] != 0 } {
          return [ get_lib_cells $lib_name/$model_name ]
        }
      }
      return 0
    }
  }

  proc get_structure_list { pin_count } {

    if       { $pin_count <=    50 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  1 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24   3 } { tcb013ghpwc/CKND4  0 } } }
    } elseif { $pin_count <=   100 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  1 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24   4 } { tcb013ghpwc/CKND4  0 } } }
    } elseif { $pin_count <=   150 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  1 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24   5 } { tcb013ghpwc/CKND4  0 } } }
    } elseif { $pin_count <=   200 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  1 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24   6 } { tcb013ghpwc/CKND4  0 } } }
    } elseif { $pin_count <=   250 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  2 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24   7 } { tcb013ghpwc/CKND4  0 } } }
    } elseif { $pin_count <=   300 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  2 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24   8 } { tcb013ghpwc/CKND4  0 } } }
    } elseif { $pin_count <=   400 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  2 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24   9 } { tcb013ghpwc/CKND4  0 } } }
    } elseif { $pin_count <=   500 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  2 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  10 } { tcb013ghpwc/CKND4  0 } } }
    } elseif { $pin_count <=   600 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  2 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  12 } { tcb013ghpwc/CKND4  0 } } }
    } elseif { $pin_count <=   700 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  2 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  13 } { tcb013ghpwc/CKND4  0 } } }
    } elseif { $pin_count <=   800 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  2 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  14 } { tcb013ghpwc/CKND4  0 } } }
    } elseif { $pin_count <=   900 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  3 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  15 } { tcb013ghpwc/CKND4  0 } } }
    } elseif { $pin_count <=  1000 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  3 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  16 } { tcb013ghpwc/CKND4  0 } } }
    } elseif { $pin_count <=  1100 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  3 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  17 } { tcb013ghpwc/CKND4  0 } } }
    } elseif { $pin_count <=  1200 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  3 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  18 } { tcb013ghpwc/CKND4  0 } } }
    } elseif { $pin_count <=  1300  } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  3 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24 19 } { tcb013ghpwc/CKND4  0 } } }
    } elseif { $pin_count <=  1400 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  4 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  20 } { tcb013ghpwc/CKND4  0 } } }
    } elseif { $pin_count <=  1600  } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  4 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  22 } { tcb013ghpwc/CKND4  0 } } }
    } elseif { $pin_count <=  1800 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  4 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  24 } { tcb013ghpwc/CKND4  0 } } }
    } elseif { $pin_count <=  2000 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  5 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  26 } { tcb013ghpwc/CKND4  0 } } }
    } elseif { $pin_count <=  2500 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  5 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  28 } { tcb013ghpwc/CKND4  0 } } }
    } elseif { $pin_count <=  3000 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  6 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  32 } { tcb013ghpwc/CKND4  0 } } }
    } elseif { $pin_count <=  3500 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  6 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  35 } { tcb013ghpwc/CKND4  0 } } }
    } elseif { $pin_count <=  4000 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  7 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  40 } { tcb013ghpwc/CKND4  0 } } }
    } elseif { $pin_count <=  6000 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  8 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  60 } { tcb013ghpwc/CKND4  0 } } }
    } elseif { $pin_count <=  8000 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  9 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  80 } { tcb013ghpwc/CKND4  0 } } }
    } elseif { $pin_count <= 10000 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24 10 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24 100 } { tcb013ghpwc/CKND4  0 } } }
    } elseif { $pin_count <= 15000 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24 12 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24 120 } { tcb013ghpwc/CKND4  0 } } }
    } elseif { $pin_count <= 20000 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24 16 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24 160 } { tcb013ghpwc/CKND4  0 } } }
    } elseif { $pin_count <= 30000 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24 20 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24 200 } { tcb013ghpwc/CKND4  0 } } }
    } elseif { $pin_count <= 40000 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24 20 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24 200 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  1060 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  4 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  32 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  1110 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  4 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  33 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  1160 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  4 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  34 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  1210 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  4 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  35 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  1260 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  4 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  36 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  1310 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  4 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  37 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  1360 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  4 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  38 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  1410 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  4 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  39 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  1460 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  4 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  40 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  1510 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  5 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  41 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  1560 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  5 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  42 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  1610 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  5 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  43 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  1660 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  5 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  44 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  1710 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  5 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  45 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  1760 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  5 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  46 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  1810 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  5 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  47 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  1860 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  5 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  48 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  1910 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  5 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  49 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  1960 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  5 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  50 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  2010 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  6 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  51 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  2070 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  6 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  52 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  2130 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  6 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  53 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  2190 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  6 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  54 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  2250 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  6 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  55 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  2310 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  6 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  56 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  2370 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  6 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  57 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  2430 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  6 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  58 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  2490 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  6 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  59 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  2550 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  6 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  60 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  2610 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  7 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  61 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  2670 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  7 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  62 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  2730 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  7 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  63 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  2790 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  7 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  64 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  2850 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  7 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  65 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  2910 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  7 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  66 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  2970 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  7 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  67 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  3030 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  7 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  68 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  3110 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  7 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  69 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  3190 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  7 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  70 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  3270 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  8 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  71 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  3350 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  8 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  72 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  3430 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  8 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  73 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  3510 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  8 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  74 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  3590 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  8 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  75 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  3670 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  8 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  76 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  3750 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  8 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  77 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  3830 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  8 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  78 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  3910 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  8 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  79 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  3990 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  8 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  80 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  4070 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  9 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  81 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  4150 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  9 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  82 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  4230 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  9 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  83 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  4310 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  9 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  84 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  4390 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  9 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  85 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  4470 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  9 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  86 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  4550 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  9 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  87 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  4630 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  9 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  88 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  4710 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  9 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  89 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  4790 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24  9 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  90 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  4870 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24 10 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  91 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  4950 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24 10 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  92 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  5030 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24 10 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  93 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  5110 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24 10 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  94 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  5190 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24 10 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  95 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  5270 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24 10 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  96 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  5350 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24 10 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  97 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  5430 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24 10 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  98 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  5510 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24 10 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24  99 } { tcb013ghpwc/CKND4  0 } } }
#    } elseif { $pin_count <=  5590 } { set structure_list { { { tcb013ghpwc/CKBD24 1 } } { { tcb013ghpwc/CKBD24 10 } { tcb013ghpwc/CKND4  0 } } { { tcb013ghpwc/CKBD24 100 } { tcb013ghpwc/CKND4  0 } } }
    } else                          {
      puts "Not supported pin count > 40000"
    }
    return $structure_list
  }

  #   Cell name         Type  Drive size   Input cap   Cell area
  #   ----------  ----------  ----------  ----------  ----------
  #   CQBIVX20H          INV          20   17.860 fF   9.720 um2
  #   CQBIVX16H          INV          16   14.088 fF   7.920 um2
  #   CQBIVX12H          INV          12   10.697 fF   6.120 um2
  #   CQBIVX8H           INV           8    6.816 fF   4.320 um2
  #   CQBNIVX20H         BUF          20    3.699 fF  12.600 um2
  #   CQBIVX4H           INV           4    3.192 fF   2.520 um2
  #   CQBNIVX16H         BUF          16    3.035 fF  10.440 um2
  #   CQBNIVX12H         BUF          12    2.328 fF   7.920 um2
  #   CQBNIVX8H          BUF           8    1.698 fF   5.400 um2
  #   CQBNIVX4H          BUF           4    0.947 fF   3.240 um2

  ####################################################################################################
  # MAIN
  #
  foreach root_pin_name $root_pin_names {
    set root_pin [ get_pins $root_pin_name ]
    set root_net [ get_nets -of $root_pin -top -seg ]
    set root_cell [ get_cell -of $root_pin ]
    set root_cell_name [ get_attr $root_cell full_name ]
    set root_model_pin_name [ lindex [ split $root_pin_name "/" ] end ]
    set base_cell_name      [ lindex [ split $root_cell_name "/" ] end ]
    set base_prefix [ format "%s_%s" $base_cell_name $root_model_pin_name ]
    set full_prefix [ format "%s_%s" $root_cell_name $root_model_pin_name ]

    # Define clock structure by pin count
    set pins [ add_to_collection "" "" ]
    #foreach_in_collection pin [ get_loads $root_net ] {
    #  set pin_name [ get_attr $pin full_name ]
    #  if { [ string match d2993/top/ck/*                 $pin_name ] == 1 } { continue }
    #  if { [ string match d2993/top/me/mavc/*            $pin_name ] == 1 } { continue }
    #  if { [ string match d2993/top/me/mcpu/*            $pin_name ] == 1 } { continue }
    #  if { [ string match d2993/top/me/mvme/*            $pin_name ] == 1 } { continue }
    #  if { [ string match d2993/top/sc/saw_a/*           $pin_name ] == 1 } { continue }
    #  if { [ string match d2993/top/sc/scpu/*            $pin_name ] == 1 } { continue }
    #  set pins [ add_to_collection $pins $pin ]
    #}
    set pins [ filter_collection [ get_loads $root_net ] " \
                                                          full_name !~ d2993/top/ck/* \
                                                       && full_name !~ d2993/top/me/mavc/* \
                                 " ]

    set pin_count [ sizeof_collection $pins ]
    if { [ info exists structure_list($root_pin_name) ] == 0 } {
      set structure_list($root_pin_name) [ get_structure_list $pin_count ]
    }

    # Insert L3 buffer
    #set new_cell_name [ format "%s_FB_L3_DRIVE01" $base_prefix ]
    #set new_net_name  [ format "%s_FB_L3"         $base_prefix ]
    set new_cell_name [ format "%s_FB_L3_DRIVE01" $full_prefix ]
    set new_net_name  [ format "%s_FB_L3"         $full_prefix ]
    set model [ lindex [ lindex [ lindex $structure_list($root_pin_name) 2 ] 0 ] 0 ]
    set model_name [ get_model $model ]
    #set FB_L3 [insert_buffer $root_pin_name  $model_name -new_cell_names $new_cell_name -new_net_names $new_net_name]
    puts "create_cell $new_cell_name $model_name"
    #puts "create_cell $new_cell_name $model"
    create_cell $new_cell_name $model_name
    #create_cell $new_cell_name $model
    create_net $new_net_name
    set orgi_net [ get_nets -of $root_pin_name -boundary_type lower ]
    disconnect_net $orgi_net $root_pin_name
    connect_net $new_net_name [ get_pins -of $new_cell_name -filter "direction == in" ]
    connect_net $new_net_name $root_pin_name
    connect_net $orgi_net [ get_pins -of $new_cell_name -filter "direction == out" ]
    set_cell_location $new_cell_name -coordinates { 0 0 }

    # Insert L2 buffer
    #set new_cell_name [ format "%s_FB_L2_DRIVE01" $base_prefix ]
    #set new_net_name  [ format "%s_FB_L2"         $base_prefix ]
    set new_cell_name [ format "%s_FB_L2_DRIVE01" $full_prefix ]
    set new_net_name  [ format "%s_FB_L2"         $full_prefix ]
    set model [ lindex [ lindex [ lindex $structure_list($root_pin_name) 1 ] 0 ] 0 ]
    set model_name [ get_model $model ]
    #set FB_L2 [insert_buffer $root_pin_name  $model_name -new_cell_names $new_cell_name -new_net_names $new_net_name]
    create_cell $new_cell_name $model_name
    #create_cell $new_cell_name $model
    create_net $new_net_name
    set orgi_net [ get_nets -of $root_pin_name -boundary_type lower ]
    disconnect_net $orgi_net $root_pin_name
    connect_net $new_net_name [ get_pins -of $new_cell_name -filter "direction == in" ]
    connect_net $new_net_name $root_pin_name
    connect_net $orgi_net [ get_pins -of $new_cell_name -filter "direction == out" ]
    set_cell_location $new_cell_name -coordinates { 0 0 }

    # Insert L1 buffer
    #set new_cell_name [ format "%s_FB_L1_DRIVE01" $base_prefix ]
    #set new_net_name  [ format "%s_FB_L1"         $base_prefix ]
    set new_cell_name [ format "%s_FB_L1_DRIVE01" $full_prefix ]
    set new_net_name  [ format "%s_FB_L1"         $full_prefix ]
    set model [ lindex [ lindex [ lindex $structure_list($root_pin_name) 0 ] 0 ] 0 ]
    set model_name [ get_model $model ]
    #set FB_L1 [insert_buffer $root_pin_name  $model_name -new_cell_names $new_cell_name -new_net_names $new_net_name]
    create_cell $new_cell_name $model_name
    #create_cell $new_cell_name $model
    create_net $new_net_name
    set orgi_net [ get_nets -of $root_pin_name -boundary_type lower ]
    disconnect_net $orgi_net $root_pin_name
    connect_net $new_net_name [ get_pins -of $new_cell_name -filter "direction == in" ]
    connect_net $new_net_name $root_pin_name
    connect_net $orgi_net [ get_pins -of $new_cell_name -filter "direction == out" ]
    set_cell_location $new_cell_name -coordinates { 0 0 }

    # Insert L3 parallel driver
    for { set i 2 } { $i <= [ lindex [ lindex [ lindex $structure_list($root_pin_name) 2 ] 0 ] 1 ] } { incr i } {
      set new_cell_name [ format "%s_FB_L3_DRIVE%02d" $full_prefix $i ]
      set model [ lindex [ lindex [ lindex $structure_list($root_pin_name) 2 ] 0 ] 0 ]
      set model_name [ get_model $model ]
      create_cell $new_cell_name $model_name
      #create_cell $new_cell_name $model
      set bpin_i [ get_pins -of [ format "%s_FB_L3_DRIVE%02d" $full_prefix 1  ] -filter "direction == in"  ]
      set bpin_o [ get_pins -of [ format "%s_FB_L3_DRIVE%02d" $full_prefix 1  ] -filter "direction == out" ]
      set ppin_i [ get_pins -of [ format "%s_FB_L3_DRIVE%02d" $full_prefix $i ] -filter "direction == in"  ]
      set ppin_o [ get_pins -of [ format "%s_FB_L3_DRIVE%02d" $full_prefix $i ] -filter "direction == out" ]
      connect_net [ get_nets -of $bpin_i -boundary_type lower ] $ppin_i
      connect_net [ get_nets -of $bpin_o -boundary_type lower ] $ppin_o
    }

    # Insert L3 dummy loading
    for { set i 1 } { $i <= [ lindex [ lindex [ lindex $structure_list($root_pin_name) 2 ] 1 ] 1 ] } { incr i } {
      set new_cell_name [ format "%s_FB_L3_DUMMY%02d" $full_prefix $i ]
      set model [ lindex [ lindex [ lindex $structure_list($root_pin_name) 2 ] 1 ] 0 ]
      set model_name [ get_model $model ]
      create_cell $new_cell_name $model_name
      #create_cell $new_cell_name $model
      set bpin_i [ get_pins -of [ format "%s_FB_L3_DRIVE%02d" $full_prefix 1  ] -filter "direction == in"  ]
      set bpin_o [ get_pins -of [ format "%s_FB_L3_DRIVE%02d" $full_prefix 1  ] -filter "direction == out" ]
      set ppin_i [ get_pins -of [ format "%s_FB_L3_DUMMY%02d" $full_prefix $i ] -filter "direction == in"  ]
      set ppin_o [ get_pins -of [ format "%s_FB_L3_DUMMY%02d" $full_prefix $i ] -filter "direction == out" ]
      connect_net [ get_nets -of $bpin_i -boundary_type lower ] $ppin_i
      #connect_net [ get_nets -of $bpin_o -top -seg ] $ppin_o
    }

    # Insert L2 parallel driver
    for { set i 2 } { $i <= [ lindex [ lindex [ lindex $structure_list($root_pin_name) 1 ] 0 ] 1 ] } { incr i } {
      set new_cell_name [ format "%s_FB_L2_DRIVE%02d" $full_prefix $i ]
      set model [ lindex [ lindex [ lindex $structure_list($root_pin_name) 1 ] 0 ] 0 ]
      set model_name [ get_model $model ]
      create_cell $new_cell_name $model_name
      #create_cell $new_cell_name $model
      set bpin_i [ get_pins -of [ format "%s_FB_L2_DRIVE%02d" $full_prefix 1  ] -filter "direction == in"  ]
      set bpin_o [ get_pins -of [ format "%s_FB_L2_DRIVE%02d" $full_prefix 1  ] -filter "direction == out" ]
      set ppin_i [ get_pins -of [ format "%s_FB_L2_DRIVE%02d" $full_prefix $i ] -filter "direction == in"  ]
      set ppin_o [ get_pins -of [ format "%s_FB_L2_DRIVE%02d" $full_prefix $i ] -filter "direction == out" ]
      connect_net [ get_nets -of $bpin_i -boundary_type lower ] $ppin_i
      connect_net [ get_nets -of $bpin_o -boundary_type lower ] $ppin_o
    }

    # Insert L3 dummy loading
    for { set i 1 } { $i <= [ lindex [ lindex [ lindex $structure_list($root_pin_name) 1 ] 1 ] 1 ] } { incr i } {
      set new_cell_name [ format "%s_FB_L2_DUMMY%02d" $full_prefix $i ]
      set model [ lindex [ lindex [ lindex $structure_list($root_pin_name) 1 ] 1 ] 0 ]
      set model_name [ get_model $model ]
      create_cell $new_cell_name $model_name
      #create_cell $new_cell_name $model
      set bpin_i [ get_pins -of [ format "%s_FB_L2_DRIVE%02d" $full_prefix 1  ] -filter "direction == in"  ]
      set bpin_o [ get_pins -of [ format "%s_FB_L2_DRIVE%02d" $full_prefix 1  ] -filter "direction == out" ]
      set ppin_i [ get_pins -of [ format "%s_FB_L2_DUMMY%02d" $full_prefix $i ] -filter "direction == in"  ]
      set ppin_o [ get_pins -of [ format "%s_FB_L2_DUMMY%02d" $full_prefix $i ] -filter "direction == out" ]
      connect_net [ get_nets -of $bpin_i -boundary_type lower ] $ppin_i
      #connect_net [ get_nets -of $bpin_o -top -seg ] $ppin_o
    }

  }

  ####################################################################################################
  # LOG
  #
  set fb_nets ""
  set log_file insert_clock_tree.log
  set log [ open $log_file a ]
  foreach root_pin_name $root_pin_names {
    puts $log [ format "####################################################################################################" ]
    puts $log [ format "# %s" $root_pin_name ]
    puts $log [ format "#" ]
    puts $log [ format "set structure_list($root_pin_name) { { { %s %d } } { { %s %d } { %s %d } } { { %s %d } { %s %d } } }" \
      [ lindex [ lindex [ lindex $structure_list($root_pin_name) 0 ] 0 ] 0 ] [ lindex [ lindex [ lindex $structure_list($root_pin_name) 0 ] 0 ] 1 ] \
      [ lindex [ lindex [ lindex $structure_list($root_pin_name) 1 ] 0 ] 0 ] [ lindex [ lindex [ lindex $structure_list($root_pin_name) 1 ] 0 ] 1 ] \
      [ lindex [ lindex [ lindex $structure_list($root_pin_name) 1 ] 1 ] 0 ] [ lindex [ lindex [ lindex $structure_list($root_pin_name) 1 ] 1 ] 1 ] \
      [ lindex [ lindex [ lindex $structure_list($root_pin_name) 2 ] 0 ] 0 ] [ lindex [ lindex [ lindex $structure_list($root_pin_name) 2 ] 0 ] 1 ] \
      [ lindex [ lindex [ lindex $structure_list($root_pin_name) 2 ] 1 ] 0 ] [ lindex [ lindex [ lindex $structure_list($root_pin_name) 2 ] 1 ] 1 ] \
    ]

    set root_pin [ get_pins $root_pin_name ]
    set root_net [ get_nets -of $root_pin -top -seg ]
    set root_cell [ get_cell -of $root_pin ]
    set root_cell_name [ get_attr $root_cell full_name ]
    set root_model_pin_name [ lindex [ split $root_pin_name "/" ] end ]
    set base_cell_name      [ lindex [ split $root_cell_name "/" ] end ]
    set base_prefix [ format "%s_%s" $base_cell_name $root_model_pin_name ]
    set full_prefix [ format "%s_%s" $root_cell_name $root_model_pin_name ]

    # root pin -> L1
    puts $log [ format "#---------------------------------------------------------------------------------------------------" ]
    set pin [ get_pins $root_pin_name ]
    set net [ get_nets -of $pin -top -seg ]
    set net_name [ get_attr $net full_name ]
    set source_pins [ sort_collection [ get_drivers $net ] {full_name} ]
    set sink_pins   [ sort_collection [ get_loads $net   ] {full_name} ]
    foreach_in_collection pin $source_pins  {
      set pin_name   [ get_attr $pin full_name ]
      set model_name [ get_attr [get_cells -of $pin] ref_name ]
      puts $log [ format "# %s (%s)" $pin_name $model_name ]
    }
    puts $log [ format "# %s (net) %s" $net_name [ sizeof_collection $sink_pins ] ]
    foreach_in_collection pin $sink_pins  {
      set pin_name   [ get_attr $pin full_name ]
      set model_name [ get_attr [ get_cells -of $pin ] ref_name ]
      puts $log [ format "# %s (%s)" $pin_name $model_name ]
    }

    # L1 -> L2
    puts $log [ format "#---------------------------------------------------------------------------------------------------" ]
    set pin [ get_pins -of [ format "%s_FB_L1_DRIVE01" $full_prefix ] -filter "direction == out" ]
    set net [ get_nets -of $pin -top -seg]
    set net_name [ get_attr $net full_name ]
    set source_pins [ sort_collection [ get_drivers $net ] {full_name} ]
    set sink_pins   [ sort_collection [ get_loads $net   ] {full_name} ]
    foreach_in_collection pin $source_pins  {
      set pin_name   [ get_attr $pin full_name ]
      set model_name [ get_attr [get_cells -of $pin] ref_name ]
      puts $log [ format "# %s (%s)" $pin_name $model_name ]
    }
    puts $log [ format "# %s (net) %s" $net_name [ sizeof_collection $sink_pins ] ]
    foreach_in_collection pin $sink_pins  {
      set pin_name   [ get_attr $pin full_name ]
      set model_name [ get_attr [ get_cells -of $pin ] ref_name ]
      puts $log [ format "# %s (%s)" $pin_name $model_name ]
    }

    # L2 -> L3
    puts $log [ format "#---------------------------------------------------------------------------------------------------" ]
    set pin [ get_pins -of [ format "%s_FB_L2_DRIVE01" $full_prefix ] -filter "direction == out" ]
    set net [ get_nets -of $pin -top -seg]
    set net_name [ get_attr $net full_name ]
    set source_pins [ sort_collection [ get_drivers $net ] {full_name} ]
    set sink_pins   [ sort_collection [ get_loads $net   ] {full_name} ]
    foreach_in_collection pin $source_pins  {
      set pin_name   [ get_attr $pin full_name ]
      set model_name [ get_attr [get_cells -of $pin] ref_name ]
      puts $log [ format "# %s (%s)" $pin_name $model_name ]
    }
    puts $log [ format "# %s (net) %s" $net_name [ sizeof_collection $sink_pins ] ]
    foreach_in_collection pin $sink_pins  {
      set pin_name   [ get_attr $pin full_name ]
      set model_name [ get_attr [ get_cells -of $pin ] ref_name ]
      puts $log [ format "# %s (%s)" $pin_name $model_name ]
    }

    # L3 -> leaf pin
    puts $log [ format "#---------------------------------------------------------------------------------------------------" ]
    set pin [ get_pins -of [ format "%s_FB_L3_DRIVE01" $full_prefix ] -filter "direction == out" ]
    set net [ get_nets -of $pin -top -seg]
    set net_name [ get_attr $net full_name ]
    set source_pins [ sort_collection [ get_drivers $net ] {full_name} ]
    set sink_pins   [ sort_collection [ get_loads $net   ] {full_name} ]
    foreach_in_collection pin $source_pins  {
      set pin_name   [ get_attr $pin full_name ]
      set model_name [ get_attr [get_cells -of $pin] ref_name ]
      puts $log [ format "# %s (%s)" $pin_name $model_name ]
    }
    puts $log [ format "# %s (net) %s" $net_name [ sizeof_collection $sink_pins ] ]
    set fb_nets [concat $fb_nets $net_name]
    #foreach_in_collection pin $sink_pins  {
    #  set pin_name   [ get_attr $pin full_name ]
    #  set model_name [ get_attr [ get_cells -of $pin ] ref_name ]
    #  puts $log [ format "# %s (%s)" $pin_name $model_name ]
    #}

  }
  close $log
  set top_fb_nets [ get_attr [ get_nets $fb_nets -top -seg] full_name ]
  return $top_fb_nets

}
