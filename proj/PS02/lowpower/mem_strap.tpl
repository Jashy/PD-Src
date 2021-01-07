template : mem_strap_M5 {
        layer : M5 {
                direction : vertical
                width : 1.2
                spacing : 0.28
                number : 2 
                pitch : 12
                offset_start : {0 0}
                offset :
                trim_strap : true
        }



        advanced_rule : on {
        no_vias : on
        }
}

template : mem_strap_M7 {
        layer : M7 {
                direction : vertical
                width : 1.2
                spacing : 0.28
                number :2
                pitch : 12
                offset_start : {0 0}
                offset :
                trim_strap : true
        }

        advanced_rule : on {
        no_vias : on
        }
}

template : mem_strap_M6 {
        layer : M6 {
                direction : horizontal
                width : 1.2
                spacing : 0.28
                number :
                pitch : 60
                offset_start : {0 0}
                offset :
                trim_strap : true
        }

        advanced_rule : on {
        no_vias : on
        }
}

