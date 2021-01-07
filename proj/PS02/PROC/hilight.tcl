proc hilight_net { net } {
	gui_select_by_name -highlight -object_type Nets -pattern {$net} -replace
}
alias hn hilight_net
