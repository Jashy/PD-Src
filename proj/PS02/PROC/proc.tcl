source /filer/home/jasons/useful/scripts/icc_proc.tcl
source /filer/home/jasons/useful/scripts/get_loading.tcl
foreach tcl [glob /filer/home/jasons/useful/utility/*.tcl] {
	echo $tcl
	source $tcl
}
#source /filer/home/skoo/hj_fb_include.tcl
