#create_bounds  -name "bound_TTUSDA" -coordinate {204 2824 229 2869 } -type soft [get_cells io_controller_ALCHIP_DFT_U/TTUSDA_C_* ]
#create_bounds  -name "bound_TTUSCL" -coordinate {205 2765 230 2795 } -type soft [get_cells  io_controller_ALCHIP_DFT_U/TTUSCL_C_* ]
#create_bounds  -name "bound_PLLBP_X" -coordinate {221 2554 260 2600  } -type soft [get_cells io_controller_ALCHIP_DFT_U/PLLBP_X_C_* ]
#create_bounds  -name "bound_TSDATA3" -coordinate {3730 1740 3760 1770 } -type soft [get_cells io_controller_ALCHIP_DFT_U/TSDATA3_C_* ]
#create_bounds  -name "bound_GPIO0" -coordinate {1168 206 1200 246 } -type soft [get_cells io_controller_ALCHIP_DFT_U/GPIO0_C_* ]
#create_bounds  -name "bound_TSDATA1" -coordinate {3474 1655 3504 1695 } -type soft [get_cells io_controller_ALCHIP_DFT_U/TSDATA1_C_* ]

create_bounds  -name "bound_AC1" -coordinate { 1304.110000 3743.750000 1400.045000 3820.095000 } -type soft [get_cells { zhui_0/zmtsel_0/U20   zhui_0/zmtsel_0/U21   zhui_0/zmtsel_0/U24   zhui_0/zmtsel_0/U25   zhui_0/zmtsel_0/U26   zhui_0/zmtsel_0/U28   zhui_0/zmtsel_0/U31   zhui_0/zmtsel_0/U32   zhui_0/zmtsel_0/U33   zhui_0/zmtsel_0/U36   zhui_0/zmtsel_0/U37   zhui_0/zmtsel_0/U41   zhui_0/zmtsel_0/U42   zhui_0/zmtsel_0/U44   zhui_0/zmtsel_0/U46   zhui_0/zmtsel_0/U60   zhui_0/zmtsel_0/U61   zhui_0/zmtsel_0/U73   zhui_0/zosel_0/U18   zhui_0/zosel_0/U45   zhui_0/zosel_0/U46   zhui_0/zosel_0/U47   zhui_0/zosel_0/U48   zhui_0/zosel_0/U49   zhui_0/zosel_0/U50   zhui_0/zosel_0/U51   zhui_0/zosel_0/U52   zhui_0/zosel_0/U53   zhui_0/zosel_0/U55   zhui_0/zosel_0/U57   zhui_0/zosel_0/U59   zhui_0/zosel_0/U60 }]

create_bounds  -name "bound_AC2" -coordinate { 1304.110000 3343.750000 1500.045000 3720.095000 } -type soft [get_cells -hier * -filter "full_name =~ zhui_0/zout_0/* && is_hierarchical == false" ]
