set MW_REF_LIB {  /proj/wHydra/LIB/CURRENT/SC/TSMCHOME/digital/Back_End/milkyway/tcbn65lphvt_121c/frame_only/tcbn65lphvt  /proj/wHydra/LIB/CURRENT/SC/TSMCHOME/digital/Back_End/milkyway/tcbn65lp_121c/frame_only/tcbn65lp  /proj/wHydra/LIB/CURRENT/IIC/TSMCHOME/digital/Back_End/milkyway/tpzn65lpodgv2_iic_c080214_140a/mt_2/5lm/frame_only/tpzn65lpodgv2_iic_c080214  /proj/wHydra/LIB/CURRENT/IO/TSMCHOME/digital/Back_End/milkyway/tpan65lpnv2od3_c071030_140a/mt_2/5lm/frame_only/tpan65lpnv2od3_c071030  /proj/wHydra/LIB/CURRENT/IO/TSMCHOME/digital/Back_End/milkyway/tpdn65lpnv2od3_c071030_140a/mt_2/5lm/frame_only/tpdn65lpnv2od3_c071030  /proj/wHydra/LIB/CURRENT/IO/TSMCHOME/digital/Back_End/milkyway/IO_PAD  /proj/wHydra/LIB/CURRENT/IO/TSMCHOME/digital/Back_End/milkyway/PFILLER  /proj/wHydra/LIB/CURRENT/IO/TSMCHOME/digital/Back_End/milkyway/tpzn65lpnv2od3_c071030_140a/mt_2/5lm/frame_only/tpzn65lpnv2od3_c071030  /proj/wHydra/LIB/CURRENT/CKLNQDDx/milkyway  /proj/wHydra/LIB/CURRENT/OSC/milkyway   /proj/DJIN5/LIB/CURRENT/ADC_OSC_PLL_MW/pgn65lp25mf1000a_130a.20091118  /proj/wHydra/LIB/CURRENT/DRAM/Back_End/milkyway/t1hp256kx64milr_c071129_130a0c/frame_only/t1hp256kx64milr_c071129_130a0c  /proj/wHydra/LIB/CURRENT/DRAM/Back_End/milkyway/t1hp32kx64milr_c071129_130a0c/frame_only/t1hp32kx64milr_c071129_130a0c /proj/wHydra/WORK/erich/LIB/REG10/input/milkyway  /proj/wHydra/LIB/CURRENT/SRAM/SRAM_milkyway  /proj/wHydra/LIB/CURRENT/Adapter/TSMCHOME/digital/Back_End/milkyway/tpin65nv_130b/mt/5lm/frame_only/tpin65nv  }

source /proj/wHydra/WORK/peter/RELEASE/20100730/PT_lib.tcl

open_mw_lib MDB_Dcore_BLK
open_mw_cel Dcore_BLK

create_ilm -include_xtalk 
create_macro_fram

exit
