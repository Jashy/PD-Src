template : core_IA_IB {
        layer : IB {
                direction : vertical
                width : 4
                spacing : 0.8
                number :
                pitch : 14.4
                offset_start : {0 0}
                offset : 0
                trim_strap : false
        }

        layer : IA {
                direction : horizontal
                width : 3.6
                spacing : 1.6
                number :
                pitch : 24
                offset_start : {0 0}
                offset : 0
                trim_strap : false
        }



	advanced_rule : on {
	no_vias : on
	}
}

template : core_M5 {
        layer : M5 {
                direction : vertical
                width : 1.2
                spacing : 0.28
                number :
                pitch : 60.06
                offset_start : {0 0}
                offset : 0
                trim_strap : false
        }


        advanced_rule : on {
        no_vias : on
        }
}

template : core_M5_VSS {
        layer : M5 {
                direction : vertical
                width : 1.2
                spacing : 0.28
                number :
                pitch : 60.06
                offset_start : {30 0}
                offset : 0
                trim_strap : false
        }


        advanced_rule : on {
        no_vias : on
        }
}


template : core_M6 {
        layer : M6 {
                direction : horizontal
                width : 1.2
                spacing : 0.28
                number :
                pitch : 60
                offset_start : {0 0}
                offset : 0
                trim_strap : false
        }


        advanced_rule : on {
        no_vias : on
        }
}

template : core_M7 {
        layer : M7 {
                direction : vertical
                width : 1.2
                spacing : 0.28
                number :
                pitch : 60.06
                offset_start : {0 0}
                offset : 0
                trim_strap : false
        }

        advanced_rule : on {
        no_vias : on
        }
}

