#################################################################################################################
#
#	2013/9/11	1. added "wcl"
#			2. changed "CCS" to "NLDM" for city_top 
#       2013/9/24	1. changed "NLDM" to "CCS" for city_top 
#       2013/10/21	1. added Virage memory 
#
#------------------------------------------------------------ \
# path \


#------------------------------------------------------------ 
set USE_C14	0
set USE_C16	0
set USE_RVT	0
set USE_LVT	0



if { [ info exists LIB_COND] == 0 } { set LIB_COND  "" }
if { [ info exists MODE ] == 0 } { set MODE normal } 
set search_path "
    .
    /proj/BTC/LIB/from_sh/library1/samsung/14nm/SC/ARM/SC9/sc9mcpp78_base_rvt_c14/arm/samsung/ln14lpp/sc9mc_base_rvt_c14/r3p0/db \
    /proj/BTC/LIB/from_sh/library1/samsung/14nm/SC/ARM/SC9/sc9mcpp78_base_lvt_c14/arm/samsung/ln14lpp/sc9mc_base_lvt_c14/r3p0/db
    "
#------------------------------------------------------------ 
# lib \
#------------------------------------------------------------ 
#
#  link library:
# 	1. wz 
# 	2. bc 
#
#  target_library:
#       1. ^tcb*
#
set link_library {*}
  foreach path $search_path {
	  if { [regexp {SC} $path] == 1} {
        foreach file [ glob -nocomplain $path/*.db ] {
                        if { $LIB_COND == "wcz" } {
				if { [ regexp {.*ss0p85v0c.*\.db$} $file ] == 1 } {
				  echo $file
				  set link_library [ concat $link_library $file ]
				}
                        }
                        if { $LIB_COND == "wc" } {
 				if { [ regexp {.*ss0p81v125c.*\.db$} $file ] == 1 } {
				  echo $file
				  set link_library [ concat $link_library $file ]
				}
                        }
                       if { $LIB_COND == "ml" } { 
				     if {  [ regexp {.*ff0p99v125c.*\.db$} $file ] == 1 } {
				       echo $file
				       set link_library [ concat $link_library $file ]
				 }
                        }
                        if { $LIB_COND == "bc" } {
				     if {  [ regexp {.*ff0p99v0c.*\.db$} $file ] == 1 } { 
				       echo $file
				       set link_library [ concat $link_library $file ]
				 }
                        }
	}
  } else {
        foreach file [ glob -nocomplain $path/*.db ] {
                        if { $LIB_COND == "wcz" } {
				if { [ regexp {.*ss0p81v0c.*\.db$} $file ] == 1 } {
				  echo $file
				  set link_library [ concat $link_library $file ]
				}
                        }
                        if { $LIB_COND == "wc" } {
 				if { [ regexp {.*ss0p81v125c.*\.db$} $file ] == 1 } {
				  echo $file
				  set link_library [ concat $link_library $file ]
				}
                        }
                       if { $LIB_COND == "ml" } { 
				     if {  [ regexp {.*ff0p99v125c.*\.db$} $file ] == 1 } {
				       echo $file
				       set link_library [ concat $link_library $file ]
				 }
                        }
                        if { $LIB_COND == "bc" } {
				     if {  [ regexp {.*ff0p99v0c.*\.db$} $file ] == 1 } { 
				       echo $file
				       set link_library [ concat $link_library $file ]
				 }
                        }
	}
}
}
set link_library [concat $link_library /proj/BTC/LIB/SC/sc9mcpp84_base_lvt_c14/arm/samsung/ln14lpp/sc9mcpp84_base_lvt_c14/r3p2/db/sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p59v_125c.db ]
set link_library [concat $link_library /proj/BTC/LIB/SC/HPK/sc9mcpp84_hpk_lvt_c14/arm/samsung/ln14lpp/sc9mcpp84_hpk_lvt_c14/r3p0/db/sc9mcpp84_ln14lpp_hpk_lvt_c14_ss_nominal_max_0p59v_125c.db ]
set link_library [concat $link_library /proj/BTC/LIB/SC/HPK/sc9mcpp84_hpk_lvt_c14/arm/samsung/ln14lpp/sc9mcpp84_hpk_lvt_c14/r3p0/db/sc9mcpp84_ln14lpp_hpk_lvt_c14_ff_nominal_min_0p80v_85c.db ]
set link_library [concat $link_library /proj/BTC/LIB/SC/sc9mcpp84_base_lvt_c14/arm/samsung/ln14lpp/sc9mcpp84_base_lvt_c14/r3p2/db/sc9mcpp84_ln14lpp_base_lvt_c14_ff_nominal_min_0p80v_85c.db ]

set link_library [concat $link_library /proj/BTC/LIB/SC/sc9mcpp84_base_rvt_c14/arm/samsung/ln14lpp/sc9mcpp84_base_rvt_c14/r3p2/db/sc9mcpp84_ln14lpp_base_rvt_c14_ss_nominal_max_0p59v_125c.db ]
set link_library [concat $link_library /proj/BTC/LIB/SC/sc9mcpp84_base_lvt_c16/arm/samsung/ln14lpp/sc9mcpp84_base_lvt_c16/r3p2/db/sc9mcpp84_ln14lpp_base_lvt_c16_ss_nominal_max_0p59v_125c.db ]
set link_library [concat $link_library /proj/BTC/LIB/SC/sc9mcpp84_base_rvt_c16/arm/samsung/ln14lpp/sc9mcpp84_base_rvt_c16/r3p2/db/sc9mcpp84_ln14lpp_base_rvt_c16_ss_nominal_max_0p59v_125c.db ]
set link_library [concat $link_library /proj/BTC/LIB/SC/HPK/sc9mcpp84_hpk_rvt_c14/arm/samsung/ln14lpp/sc9mcpp84_hpk_rvt_c14/r3p0/db/sc9mcpp84_ln14lpp_hpk_rvt_c14_ss_nominal_max_0p59v_125c.db ]
set link_library [concat $link_library /proj/BTC/LIB/SC/HPK/sc9mcpp84_hpk_lvt_c16/arm/samsung/ln14lpp/sc9mcpp84_hpk_lvt_c16/r3p0/db/sc9mcpp84_ln14lpp_hpk_lvt_c16_ss_nominal_max_0p59v_125c.db ]
set link_library [concat $link_library /proj/BTC/LIB/SC/HPK/sc9mcpp84_hpk_rvt_c16/arm/samsung/ln14lpp/sc9mcpp84_hpk_rvt_c16/r3p0/db/sc9mcpp84_ln14lpp_hpk_rvt_c16_ss_nominal_max_0p59v_125c.db ]
set link_library [concat $link_library /proj/BTC/LIB/SC/sc9mcpp84_base_rvt_c14/arm/samsung/ln14lpp/sc9mcpp84_base_rvt_c14/r3p2/db/sc9mcpp84_ln14lpp_base_rvt_c14_ff_nominal_min_0p80v_85c.db ]
set link_library [concat $link_library /proj/BTC/LIB/SC/sc9mcpp84_base_lvt_c16/arm/samsung/ln14lpp/sc9mcpp84_base_lvt_c16/r3p2/db/sc9mcpp84_ln14lpp_base_lvt_c16_ff_nominal_min_0p80v_85c.db ]
set link_library [concat $link_library /proj/BTC/LIB/SC/sc9mcpp84_base_rvt_c16/arm/samsung/ln14lpp/sc9mcpp84_base_rvt_c16/r3p2/db/sc9mcpp84_ln14lpp_base_rvt_c16_ff_nominal_min_0p80v_85c.db ]
set link_library [concat $link_library /proj/BTC/LIB/SC/HPK/sc9mcpp84_hpk_rvt_c14/arm/samsung/ln14lpp/sc9mcpp84_hpk_rvt_c14/r3p0/db/sc9mcpp84_ln14lpp_hpk_rvt_c14_ff_nominal_min_0p80v_85c.db ]
set link_library [concat $link_library /proj/BTC/LIB/SC/HPK/sc9mcpp84_hpk_lvt_c16/arm/samsung/ln14lpp/sc9mcpp84_hpk_lvt_c16/r3p0/db/sc9mcpp84_ln14lpp_hpk_lvt_c16_ff_nominal_min_0p80v_85c.db ]
set link_library [concat $link_library /proj/BTC/LIB/SC/HPK/sc9mcpp84_hpk_rvt_c16/arm/samsung/ln14lpp/sc9mcpp84_hpk_rvt_c16/r3p0/db/sc9mcpp84_ln14lpp_hpk_rvt_c16_ff_nominal_min_0p80v_85c.db ]

set target_library [list \
	/proj/BTC/LIB/SC/sc9mcpp84_base_lvt_c14/arm/samsung/ln14lpp/sc9mcpp84_base_lvt_c14/r3p2/db/sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p59v_125c.db \
	/proj/BTC/LIB/SC/HPK/sc9mcpp84_hpk_lvt_c14/arm/samsung/ln14lpp/sc9mcpp84_hpk_lvt_c14/r3p0/db/sc9mcpp84_ln14lpp_hpk_lvt_c14_ss_nominal_max_0p59v_125c.db \
	/proj/BTC/LIB/SC/sc9mcpp84_base_lvt_c14/arm/samsung/ln14lpp/sc9mcpp84_base_lvt_c14/r3p2/db/sc9mcpp84_ln14lpp_base_lvt_c14_ff_nominal_min_0p80v_85c.db \
	/proj/BTC/LIB/SC/HPK/sc9mcpp84_hpk_lvt_c14/arm/samsung/ln14lpp/sc9mcpp84_hpk_lvt_c14/r3p0/db/sc9mcpp84_ln14lpp_hpk_lvt_c14_ff_nominal_min_0p80v_85c.db ]

if {$USE_C14 == 1 && $USE_RVT == 1} { set target_library [concat $target_library /proj/BTC/LIB/SC/sc9mcpp84_base_rvt_c14/arm/samsung/ln14lpp/sc9mcpp84_base_rvt_c14/r3p2/db/sc9mcpp84_ln14lpp_base_rvt_c14_ss_nominal_max_0p59v_125c.db ] }
if {$USE_C14 == 1 && $USE_RVT == 1} { set target_library [concat $target_library /proj/BTC/LIB/SC/HPK/sc9mcpp84_hpk_rvt_c14/arm/samsung/ln14lpp/sc9mcpp84_hpk_rvt_c14/r3p0/db/sc9mcpp84_ln14lpp_hpk_rvt_c14_ss_nominal_max_0p59v_125c.db ] }

if {$USE_C16 == 1 && $USE_LVT == 1} { set target_library [concat $target_library /proj/BTC/LIB/SC/sc9mcpp84_base_lvt_c16/arm/samsung/ln14lpp/sc9mcpp84_base_lvt_c16/r3p2/db/sc9mcpp84_ln14lpp_base_lvt_c16_ss_nominal_max_0p59v_125c.db ] }
if {$USE_C16 == 1 && $USE_LVT == 1} { set target_library [concat $target_library /proj/BTC/LIB/SC/HPK/sc9mcpp84_hpk_lvt_c16/arm/samsung/ln14lpp/sc9mcpp84_hpk_lvt_c16/r3p0/db/sc9mcpp84_ln14lpp_hpk_lvt_c16_ss_nominal_max_0p59v_125c.db ] }

if {$USE_C16 == 1 && $USE_RVT == 1} { set target_library [concat $target_library /proj/BTC/LIB/SC/sc9mcpp84_base_rvt_c16/arm/samsung/ln14lpp/sc9mcpp84_base_rvt_c16/r3p2/db/sc9mcpp84_ln14lpp_base_rvt_c16_ss_nominal_max_0p59v_125c.db ] }
if {$USE_C16 == 1 && $USE_RVT == 1} { set target_library [concat $target_library /proj/BTC/LIB/SC/HPK/sc9mcpp84_hpk_rvt_c16/arm/samsung/ln14lpp/sc9mcpp84_hpk_rvt_c16/r3p0/db/sc9mcpp84_ln14lpp_hpk_rvt_c16_ss_nominal_max_0p59v_125c.db ] }

if {$USE_C14 == 1 && $USE_RVT == 1} { set target_library [concat $target_library /proj/BTC/LIB/SC/sc9mcpp84_base_rvt_c14/arm/samsung/ln14lpp/sc9mcpp84_base_rvt_c14/r3p2/db/sc9mcpp84_ln14lpp_base_rvt_c14_ff_nominal_min_0p80v_85c.db ] }
if {$USE_C14 == 1 && $USE_RVT == 1} { set target_library [concat $target_library /proj/BTC/LIB/SC/HPK/sc9mcpp84_hpk_rvt_c14/arm/samsung/ln14lpp/sc9mcpp84_hpk_rvt_c14/r3p0/db/sc9mcpp84_ln14lpp_hpk_rvt_c14_ff_nominal_min_0p80v_85c.db ] }

if {$USE_C16 == 1 && $USE_LVT == 1} { set target_library [concat $target_library /proj/BTC/LIB/SC/sc9mcpp84_base_lvt_c16/arm/samsung/ln14lpp/sc9mcpp84_base_lvt_c16/r3p2/db/sc9mcpp84_ln14lpp_base_lvt_c16_ff_nominal_min_0p80v_85c.db ] }
if {$USE_C16 == 1 && $USE_LVT == 1} { set target_library [concat $target_library /proj/BTC/LIB/SC/HPK/sc9mcpp84_hpk_lvt_c16/arm/samsung/ln14lpp/sc9mcpp84_hpk_lvt_c16/r3p0/db/sc9mcpp84_ln14lpp_hpk_lvt_c16_ff_nominal_min_0p80v_85c.db ] }

if {$USE_C16 == 1 && $USE_RVT == 1} { set target_library [concat $target_library /proj/BTC/LIB/SC/sc9mcpp84_base_rvt_c16/arm/samsung/ln14lpp/sc9mcpp84_base_rvt_c16/r3p2/db/sc9mcpp84_ln14lpp_base_rvt_c16_ff_nominal_min_0p80v_85c.db ] }
if {$USE_C16 == 1 && $USE_RVT == 1} { set target_library [concat $target_library /proj/BTC/LIB/SC/HPK/sc9mcpp84_hpk_rvt_c16/arm/samsung/ln14lpp/sc9mcpp84_hpk_rvt_c16/r3p0/db/sc9mcpp84_ln14lpp_hpk_rvt_c16_ff_nominal_min_0p80v_85c.db ] }

echo $target_library
echo $target_library >> ${SESSION}.run/target_library.list
