proc push { stack value } {
	upvar $stack list
	lappend list $value
}

proc pop { stack } {
	upvar $stack list
	set value [lindex $list end]
	set list [lrange $list 0 [expr [llength $list] -2]]
	return $value
}
