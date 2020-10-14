define lib_name "asdsrscfs1p1024x32cm8sw8"

cmCreateLib
setFormField "Create Library" "Library Name" lib_name
setFormField "Create Library" "Set Case Sensitive" "1"
setFormField "Create Library" "Technology File Name" "/proj/Shisha/LIB/techfile/PR_techfile/PR_techfile/synopsys/PnR_Kit/New_Archive_20150608T143931/EDA-CAD-018-PR107/gf018ull_5M1T_30k_7T.rev_1b/gf018ull_5M1T_30k_7T.rev_1b/gf018ull_5M1T_30k_7T.tf"
formOK "Create Library"

;cmSetBusNameStyle
;setFormField "Set Bus Naming Style" "Library Name" lib_name
;setFormField "Set Bus Naming Style" "Bus Naming Style" "[%d]"
;formOK "Set Bus Naming Style"

define cell_name "asdsrscfs1p1024x32cm8sw8"
load "gds2mw2.scm"

