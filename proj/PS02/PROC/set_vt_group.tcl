#set lvt_lib "/filer/home/jasonw/wuxi/icc/arm/LIB/sc/milkyway/tcbn45gsbwp12tlvt"
set lvt_lib tcbn45gsbwp12tlvtwcz_ccs
set_attribute [ get_libs $lvt_lib ] default_threshold_voltage_group LVt -type string
#set nvt_lib "/filer/home/jasonw/wuxi/icc/arm/LIB/sc/milkyway/tcbn45gsbwp12t" 
set nvt_lib tcbn45gsbwp12twcz_ccs
set_attribute [ get_libs $nvt_lib ] default_threshold_voltage_group NVt -type string

set hvt_lib tcbn45gsbwp12thvtwcz_ccs 
set_attribute [ get_libs $hvt_lib ] default_threshold_voltage_group HVt -type string
