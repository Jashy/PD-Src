###################################################################

# Created by write_floorplan on Fri Aug 21 15:22:32 2015

###################################################################
undo_config -disable
set oldSnapState [set_object_snap_type -enabled false]

#******************
#  Voltage Area  
# obj#: 3 
# objects are in positional ordering 
#******************


remove_voltage_area -all

create_voltage_area -power_domain PD_HPD \
	-color green \
	-guard_band_x 3 \
	-guard_band_y 3 \
	-coordinate {  {{300.000 250.000} {3350.000 1808.000}}  {{300.000 1830.000} {3350.000 3400.000}} } 

create_voltage_area -power_domain PD_PPD \
	-color red \
	-guard_band_x 3 \
	-guard_band_y 3 \
	-coordinate {  {{164.000 1814.000} {3474.000 1824.000}}  {{164.000 1824.000} {290.000 2750.000}}  {{3374.000 1824.000} {3474.000 2550.000}} } 

set_object_snap_type -enabled $oldSnapState
undo_config -enable
