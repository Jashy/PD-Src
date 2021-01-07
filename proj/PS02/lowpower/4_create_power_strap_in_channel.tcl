# create power strap in channel
derive_placement_blockages -thin_channel_width 30 -apply
set chan [ get_placement_blockage -filter "full_name=~*THIN_CHAN*" -type hard ]

source /DELL/proj/PS02/WORK/jasons/Block/GAIA/scripts/power_plan/utility/create_power_strap_in_channel.tcl
create_power_strap_in_channel $chan

