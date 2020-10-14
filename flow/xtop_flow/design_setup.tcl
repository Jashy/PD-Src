# Set multiple threads
set_parameter max_thread_number $thread_number

# Create Workspace
#create_workspace -overwrite ./workspace_$keyword
exec rm -rf ./workspace
create_workspace -overwrite ./workspace

#find lef files
#set tech_lef /proj/library/BI/$lib_version/tech/cadence/PRTF_Innovus_N7_13M_1X1Xa1Ya5Y2Yy2Z_UTRDL_M1P57_M2P40_M3P44_M4P80_M5P76_M6P80_M7P76_M8P80_M9P76_H240.12a.tlef

set lib_version lib_C.0.2
set tech_lef /proj/library/BI/lib_C.0.0/tech/cadence/PRTF_Innovus_N7_13M_1X1Xa1Ya5Y2Yy2Z_UTRDL_M1P57_M2P40_M3P44_M4P80_M5P76_M6P80_M7P76_M8P80_M9P76_H240.12a.tlef
set std_lef [glob -nocomp /proj/library/BI/$lib_version/stdcel/lef/*.lef]
set ctip_lef [glob -nocomp /proj/library/BI/$lib_version/ctip/lef/*.lef]
set rams_lef [glob -nocomp /proj/library/BI/$lib_version/rams/lef/*.plef]
set rom_lef [glob -nocomp /proj/library/BI/$lib_version/rom/lef/*.plef]

# Link LEF files: technology lef and all cell lef
link_reference_library -format lef [concat $tech_lef $std_lef $ctip_lef $rams_lef $rom_lef]

# Define verilog and def file. 
puts "define_designs -verilogs $verilog_files -defs $def_files"
define_designs -verilogs $verilog_files -defs $def_files

# Set site map
#set_site_map {unit core}
set_site_map {unit TS07_DST}

# Import design data
import_designs

set_removable_fillers $removable_fillers 
save_workspace

