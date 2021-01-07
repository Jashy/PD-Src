set eco_string SPLIT
set ECO_STRING CLOCK_REPEATER
set h_nets ""

proc INSERT_REPATER {pin_name num ref} {
        global ECO_STRING
        set tmp_ECO_STRING $ECO_STRING
        #set ECO_STRING CLOCK_REPEATER
        set ECO_STRING CLOCK_PREBUFFER
        set i 0
        for { set i 0 } {$i < $num} {incr i} {
                INSERT_BUFFER $pin_name $ref -place_on_pin
        }
        set ECO_STRING $tmp_ECO_STRING
}

##############################
## examples:
##############################
## ###########################
## ## 1  bp_clk_buf/C
## set pin_name bp_clk_buf/C
## set split_buf1 [SPLIT_BY_WINDOW $pin_name tcb013ghpwc/CKBD20 -window {3610.925000 4800.750000 3959.365 2361.53} -eco_string $eco_string]
## set h_nets [concat $h_nets [ insert_clock_buffer $split_buf1/C ] ]
## insert_clock_buffer $pin_name
## REWIRE $pin_name $split_buf1/CLK
## 
## ###########################
## ## 2  ckbblk_o_fclk_SCAN_ECO_U0/Z
## set pin_name ckbblk_o_fclk_SCAN_ECO_U0/Z
## set split_buf1 [SPLIT_BY_WINDOW $pin_name tcb013ghpwc/CKBD20 -window {3029.170000 3437.245000 1406.54 850.15} -eco_string $eco_string]
## set split_buf2 [SPLIT_BY_WINDOW $pin_name tcb013ghpwc/CKBD20 -window {3500.170000 2730.245000 240.54 250.15} -eco_string $eco_string]
## insert_clock_buffer $split_buf1/C
## set h_nets [concat $h_nets [ insert_clock_buffer $pin_name ] ]
## REWIRE $pin_name $split_buf1/CLK
## REWIRE $pin_name $split_buf2/CLK
####################################

## End Example

#############################################SOC16d:
## ###################################
## 3. u_clk_gen_amba/U103_ZN_SCAN_ECO_U0/Z (MUX) MUX=3 CMB=1 SEQ=15116
set pin_name u_clk_gen_amba/U103_ZN_SCAN_ECO_U0/Z
#set split_buf1 [SPLIT_BY_WINDOW $pin_name tcb013ghpwc/CKBD20 -window {196 623 900 1650} -eco_string $eco_string]
insert_clock_buffer $pin_name
#insert_clock_buffer $split_buf1/C
#REWIRE $pin_name $split_buf1/CLK

## 4. u_clk_gen_amba/U110_ZN_SCAN_ECO_U0/Z (MUX) CMB=1 SEQ=4468
set pin_name  u_clk_gen_amba/U110_ZN_SCAN_ECO_U0/Z
insert_clock_buffer $pin_name

## 5. u_clk_gen_amba/U33_Z_SCAN_ECO_U0/Z (MUX) CMB=1 SEQ=2055
set pin_name u_clk_gen_amba/U33_Z_SCAN_ECO_U0/Z
#insert_clock_buffer $pin_name
set h_nets [concat $h_nets [ insert_clock_buffer $pin_name ] ]

## 6. u_clk_gen_amba/U33_Z_SCAN_ECO_U1/Z (MUX) SEQ=121
set pin_name u_clk_gen_amba/U33_Z_SCAN_ECO_U1/Z
insert_clock_buffer $pin_name

## 7. u_clk_gen_amba/U81_ZN_SCAN_ECO_U0/Z (MUX) MUX=3 CMB=4 SEQ=2013
set pin_name u_clk_gen_amba/U81_ZN_SCAN_ECO_U0/Z
set split_buf1 [SPLIT_BY_WINDOW $pin_name tcb013ghpwc/CKBD20 -window {3178 3646 200 200} -eco_string $eco_string]
set split_buf2 [SPLIT_BY_WINDOW $pin_name tcb013ghpwc/CKBD20 -window {176 3305 1200 200} -eco_string $eco_string]
#insert_clock_buffer $pin_name 
set h_nets [concat $h_nets [ insert_clock_buffer $pin_name ] ]
REWIRE $pin_name $split_buf1/CLK
REWIRE $pin_name $split_buf2/CLK

## 8. u_clk_gen_amba/U89_ZN_SCAN_ECO_U0/Z (MUX) CMB=1 SEQ=28292 TCI=2
set pin_name u_clk_gen_amba/U89_ZN_SCAN_ECO_U0/Z
#set split_buf1 [SPLIT_BY_WINDOW $pin_name tcb013ghpwc/CKBD20 -window {1018 2151 900 1067} -eco_string $eco_string]
#set split_buf2 [SPLIT_BY_WINDOW $pin_name tcb013ghpwc/CKBD20 -window {1861 191 994 2200} -eco_string $eco_string]
insert_clock_buffer $pin_name
#insert_clock_buffer $split_buf1/C
#insert_clock_buffer $split_buf2/C
#REWIRE $pin_name $split_buf1/CLK
#REWIRE $pin_name $split_buf2/CLK

## 9. u_clk_gen_amba/U93_ZN_SCAN_ECO_U0/Z (MUX) SEQ=4999
set pin_name u_clk_gen_amba/U93_ZN_SCAN_ECO_U0/Z
set split_buf1 [SPLIT_BY_WINDOW $pin_name tcb013ghpwc/CKBD20 -window {4128 2456 300 400} -eco_string $eco_string]
insert_clock_buffer $pin_name
REWIRE $pin_name $split_buf1/CLK

## 10. u_clk_gen_top/Clk_Gen_inst/U14_ZN_SCAN_ECO_U0/Z (MUX) SEQ=384
set pin_name u_clk_gen_top/Clk_Gen_inst/U14_ZN_SCAN_ECO_U0/Z
#insert_clock_buffer $pin_name
set h_nets [concat $h_nets [ insert_clock_buffer $pin_name ] ]

## 11. u_clk_gen_top/Clk_Gen_inst/U19_ZN_SCAN_ECO_U0/Z (MUX) SEQ=1070
set pin_name u_clk_gen_top/Clk_Gen_inst/U19_ZN_SCAN_ECO_U0/Z
#insert_clock_buffer $pin_name
set h_nets [concat $h_nets [ insert_clock_buffer $pin_name ] ]

## 12. u_clk_gen_top/Clk_Gen_inst/U8_ZN_SCAN_ECO_U0/Z (MUX) MUX=18 INV=1 CMB=7 SEQ=5624
set pin_name u_clk_gen_top/Clk_Gen_inst/U8_ZN_SCAN_ECO_U0/Z
#insert_clock_buffer $pin_name
set h_nets [concat $h_nets [ insert_clock_buffer $pin_name ] ]

## 13. u_clk_gen_top/Clk_Gen_inst/U9_ZN_SCAN_ECO_U0/Z (MUX) INV=1 CMB=2 SEQ=270
set pin_name u_clk_gen_top/Clk_Gen_inst/U9_ZN_SCAN_ECO_U0/Z
#insert_clock_buffer $pin_name
set h_nets [concat $h_nets [ insert_clock_buffer $pin_name ] ]

## 14. u_clk_gen_top/Clk_Gen_inst/clk_4p5fs_reg_Q_SCAN_ECO_U0/Z (MUX) MUX=9 INV=1 CMB=1 SEQ=8850
set pin_name u_clk_gen_top/Clk_Gen_inst/clk_4p5fs_reg_Q_SCAN_ECO_U0/Z
set split_buf1 [SPLIT_BY_WINDOW $pin_name tcb013ghpwc/CKBD20 -window {190 3448 100 100} -eco_string $eco_string]
#insert_clock_buffer $pin_name
set h_nets [concat $h_nets [ insert_clock_buffer $pin_name ] ]
REWIRE $pin_name $split_buf1/CLK


## 15. u_clk_gen_top/Clk_Mux_inst/U9_ZN_SCAN_ECO_U0/Z (MUX) INV=1 CMB=2 SEQ=770
set pin_name u_clk_gen_top/Clk_Mux_inst/U9_ZN_SCAN_ECO_U0/Z
#insert_clock_buffer $pin_name
set h_nets [concat $h_nets [ insert_clock_buffer $pin_name ] ]

## 16. u_clk_gen_top/FREQ_div_inst/clk_40M_div10_reg_Q_SCAN_ECO_U0/Z (MUX) CMB=1 SEQ=63
set pin_name u_clk_gen_top/FREQ_div_inst/clk_40M_div10_reg_Q_SCAN_ECO_U0/Z
insert_clock_buffer $pin_name
#set h_nets [concat $h_nets [ insert_clock_buffer $pin_name ] ]

## 17. u_core/u_FTMAC110/itf_wrapper/g436/Z (AND) SEQ=38
set pin_name u_core/u_FTMAC110/itf_wrapper/g436/Z
#insert_clock_buffer $pin_name
set h_nets [concat $h_nets [ insert_clock_buffer $pin_name ] ]

## 18. u_core/u_FTMAC110/pwr_manage_CLKGEN/g136/ZN (CMB) SEQ=1016
set pin_name u_core/u_FTMAC110/pwr_manage_CLKGEN/g136/ZN
#insert_clock_buffer $pin_name
set h_nets [concat $h_nets [ insert_clock_buffer $pin_name ] ]

## 19. u_core/u_FTMAC110/pwr_manage_CLKGEN/g137/ZN (CMB) MUX=2 SEQ=662
set pin_name u_core/u_FTMAC110/pwr_manage_CLKGEN/g137/ZN
insert_clock_buffer $pin_name

## 20. u_core/u_FTMAC110/pwr_manage_CLKGEN/g138/ZN (CMB) SEQ=415
set pin_name u_core/u_FTMAC110/pwr_manage_CLKGEN/g138/ZN
insert_clock_buffer $pin_name

## 21. u_core/u_FTUART010/U_PSD/g700/Z (MUX) SEQ=138
set pin_name u_core/u_FTUART010/U_PSD/g700/Z
insert_clock_buffer $pin_name

## 22. u_core/u_FTUART010_1/U_PSD/g700/Z (MUX) SEQ=138
set pin_name u_core/u_FTUART010_1/U_PSD/g700/Z
#insert_clock_buffer $pin_name
set h_nets [concat $h_nets [ insert_clock_buffer $pin_name ] ]

## 23. u_pin_module/g13536/ZN (CMB) SEQ=74
set pin_name u_pin_module/g13536/ZN
insert_clock_buffer $pin_name

## 24. u_pin_module/g5997/Z (MUX) MUX=32 CMB=6 SEQ=268 IP=1
#set pin_name u_pin_module/g5997/Z
INSERT_REPATER u_pin_module/g5997/Z 1 CKBD16
set pin_name u_pin_module/g5997_Z_CLOCK_PREBUFFER_U0/C
#insert_clock_buffer $pin_name
set split_buf1 [SPLIT_BY_WINDOW $pin_name tcb013ghpwc/CKBD20 -window {674 2335 120 600} -eco_string $eco_string]
set h_nets [concat $h_nets [ insert_clock_buffer $pin_name ] ]
REWIRE u_pin_module/g5997/Z $split_buf1/CLK



## 25. u_pin_module/m_ioshare__u_pin_module___pad_mac_txck_input_1to3/ALCHIP_U1/Z (AND) MUX=26 INV=3 CMB=2 SEQ=1296  ## CTS
set pin_name u_pin_module/m_ioshare__u_pin_module___pad_mac_txck_input_1to3/ALCHIP_U1/Z
set split_buf1 [SPLIT_BY_WINDOW $pin_name tcb013ghpwc/CKBD20 -window {223 208 1000 600} -eco_string $eco_string]
set split_buf2 [SPLIT_BY_WINDOW $pin_name tcb013ghpwc/CKBD20 -window {334 2142 500 1200} -eco_string $eco_string]
set split_buf3 [SPLIT_BY_WINDOW $pin_name tcb013ghpwc/CKBD20 -window {1276 2105 3500 2000} -eco_string $eco_string]
set split_buf4 [SPLIT_BY_WINDOW $pin_name tcb013ghpwc/CKBD20 -window {2740 714 300 300} -eco_string $eco_string]
#REWIRE u_pin_module/m_ioshare__u_pin_module___pad_mac_txck_input_1to3/ALCHIP_U1/Z u_pin_module/g5997/Z
#REWIRE u_pin_module/m_ioshare__u_pin_module___pad_mac_txck_input_1to3/ALCHIP_U1/Z u_core/u_FTUART010/U_PSD/g700/I2
#REWIRE u_pin_module/m_ioshare__u_pin_module___pad_mac_txck_input_1to3/ALCHIP_U1/Z u_core/u_FTUART010_1/U_PSD/g700/I2
#REWIRE u_pin_module/m_ioshare__u_pin_module___pad_mac_txck_input_1to3/ALCHIP_U1/Z u_core/u_FTMAC110/pwr_manage_CLKGEN/g143/A2
#REWIRE u_pin_module/m_ioshare__u_pin_module___pad_mac_txck_input_1to3/ALCHIP_U1/Z u_clk_gen_amba/U33_Z_SCAN_ECO_U0/I1
#REWIRE u_pin_module/m_ioshare__u_pin_module___pad_mac_txck_input_1to3/ALCHIP_U1/Z u_clk_gen_amba/U110_ZN_SCAN_ECO_U0/I1
#REWIRE u_pin_module/m_ioshare__u_pin_module___pad_mac_txck_input_1to3/ALCHIP_U1/Z u_clk_gen_amba/U108_ZN_SCAN_ECO_U0/I1
#REWIRE u_pin_module/m_ioshare__u_pin_module___pad_mac_txck_input_1to3/ALCHIP_U1/Z u_clk_gen_amba/U103_ZN_SCAN_ECO_U0/I1
#REWIRE u_pin_module/m_ioshare__u_pin_module___pad_mac_txck_input_1to3/ALCHIP_U1/Z u_clk_gen_amba/bd_apb_pclk_reg_CP_SCAN_ECO_U0/I1
#REWIRE u_pin_module/m_ioshare__u_pin_module___pad_mac_txck_input_1to3/ALCHIP_U1/Z u_clk_gen_amba/U89_ZN_SCAN_ECO_U0/I1
#REWIRE u_pin_module/m_ioshare__u_pin_module___pad_mac_txck_input_1to3/ALCHIP_U1/Z u_clk_gen_amba/U81_ZN_SCAN_ECO_U0/I1
REWIRE u_pin_module/m_ioshare__u_pin_module___pad_mac_txck_input_1to3/ALCHIP_U1/Z u_pin_module/g5997/I1
REWIRE u_pin_module/m_ioshare__u_pin_module___pad_mac_txck_input_1to3/ALCHIP_U1/Z u_core/u_FTUART010/U_PSD/g700/I2
REWIRE u_pin_module/m_ioshare__u_pin_module___pad_mac_txck_input_1to3/ALCHIP_U1/Z u_core/u_FTUART010_1/U_PSD/g700/I2
REWIRE u_pin_module/m_ioshare__u_pin_module___pad_mac_txck_input_1to3/ALCHIP_U1/Z u_clk_gen_amba/U33_Z_SCAN_ECO_U0/I1
REWIRE u_pin_module/m_ioshare__u_pin_module___pad_mac_txck_input_1to3/ALCHIP_U1/Z u_clk_gen_amba/U33_Z_SCAN_ECO_INV_U0/I
REWIRE u_pin_module/m_ioshare__u_pin_module___pad_mac_txck_input_1to3/ALCHIP_U1/Z u_clk_gen_amba/U110_ZN_SCAN_ECO_U0/I1
REWIRE u_pin_module/m_ioshare__u_pin_module___pad_mac_txck_input_1to3/ALCHIP_U1/Z u_clk_gen_amba/U103_ZN_SCAN_ECO_U0/I1
REWIRE u_pin_module/m_ioshare__u_pin_module___pad_mac_txck_input_1to3/ALCHIP_U1/Z u_clk_gen_amba/U103_ZN_SCAN_ECO_INV_U0/I
REWIRE u_pin_module/m_ioshare__u_pin_module___pad_mac_txck_input_1to3/ALCHIP_U1/Z u_clk_gen_amba/U93_ZN_SCAN_ECO_U0/I1
REWIRE u_pin_module/m_ioshare__u_pin_module___pad_mac_txck_input_1to3/ALCHIP_U1/Z u_clk_gen_amba/U89_ZN_SCAN_ECO_U0/I1
REWIRE u_pin_module/m_ioshare__u_pin_module___pad_mac_txck_input_1to3/ALCHIP_U1/Z u_clk_gen_amba/U81_ZN_SCAN_ECO_U0/I1
REWIRE u_pin_module/m_ioshare__u_pin_module___pad_mac_txck_input_1to3/ALCHIP_U1/Z u_clk_gen_top/Clk_Gen_inst/clk_4p5fs_reg_Q_SCAN_ECO_U0/I1
REWIRE u_pin_module/m_ioshare__u_pin_module___pad_mac_txck_input_1to3/ALCHIP_U1/Z u_clk_gen_top/Clk_Gen_inst/U8_ZN_SCAN_ECO_U0/I1
REWIRE u_pin_module/m_ioshare__u_pin_module___pad_mac_txck_input_1to3/ALCHIP_U1/Z u_clk_gen_top/Clk_Gen_inst/U9_ZN_SCAN_ECO_U0/I1
REWIRE u_pin_module/m_ioshare__u_pin_module___pad_mac_txck_input_1to3/ALCHIP_U1/Z u_clk_gen_top/Clk_Gen_inst/U19_ZN_SCAN_ECO_U0/I1
REWIRE u_pin_module/m_ioshare__u_pin_module___pad_mac_txck_input_1to3/ALCHIP_U1/Z u_clk_gen_top/Clk_Gen_inst/U14_ZN_SCAN_ECO_U0/I1
REWIRE u_pin_module/m_ioshare__u_pin_module___pad_mac_txck_input_1to3/ALCHIP_U1/Z u_clk_gen_top/Clk_Mux_inst/U9_ZN_SCAN_ECO_U0/I1
REWIRE u_pin_module/m_ioshare__u_pin_module___pad_mac_txck_input_1to3/ALCHIP_U1/Z u_clk_gen_top/FREQ_div_inst/clk_40M_div10_reg_Q_SCAN_ECO_U0/I1
REWIRE u_pin_module/m_ioshare__u_pin_module___pad_mac_txck_input_1to3/ALCHIP_U1/Z u_clk_gen_top/Clk_Mux_inst/U9_ZN_SCAN_ECO_INV_U0/I
REWIRE u_pin_module/m_ioshare__u_pin_module___pad_mac_txck_input_1to3/ALCHIP_U1/Z u_pin_module/g13884/A1




set of [open "h_nets.tcl" w]
puts $of "set h_nets \"\""
foreach h_net $h_nets {
       puts $of "set h_nets \[ concat \$h_nets \"$h_net\"\]"
}
close $of

