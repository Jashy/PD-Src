set analog_nets [list	n_rxtlb \
	n_rxtli \
	n_guard \
	n_avss_h \
	n_avdd_h \
	i_agndhdadc1 \
	i_guarddadc \
	o_bratbhp \
	o_bratbhm \
	o_irxtl25 \
	o_irainm \
	i_brregout \
	o_irainp \
	i_agndhdadc0 \
	i_avdhdadc1 \
	i_avdhdadc0 \
	i_vsspll \
	i_vddpll \
	i_avspll \
	i_avdpll \
	VDD \
	VSS \
	o_irxtl12 ]

foreach analog_net $analog_nets {
	set_net_routing_rule -rule default \
			-reroute freeze [get_nets $analog_net]
	}

