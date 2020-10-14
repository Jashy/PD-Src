auStreamIn
setFormField "Stream In Data File" "Library Name" lib_name
setFormField "Stream In Data File" "Stream File Name" (string-append "../PHA/" cell_name ".pha")
setFormField "Stream In Data File" "Layer File" "gdsin.map"
setFormField "Stream In Data File" "Store Undefined Layers" "0"
setFormField "Stream In Data File" "Extract Only Geometries Defined in Layer File" "1"
setFormField "Stream In Data File" "Use Layer for Boundary" "1"
setFormField "Stream In Data File" "Overwrite Existing Cells" "1"
setFormField "Stream In Data File" "Boundary Layer" "255"
formOK "Stream In Data File"

;auStreamIn
;setFormField "Stream In Data File" "Stream File Name" "/proj/Trinity/CURRENT/FROM_CUSTOMER/080529/20080530_IO_GDSII_for_Trinity/cs101_io_for_trinity.gds"
;formApply "Stream In Data File"
;formCancel "Stream In Data File"

dbTruncateText (dbOpenLib lib_name) " "
dbSetCellPortTypes lib_name cell_name '(
("VSSAIO" "Ground")
("VSSD" "Ground")
("VSSA" "Ground")
("VDDAIO" "Power")
("VDDD" "Power")
("VDDA" "Power")
) #f


cmSmash
setFormField "Smash" "Library Name" lib_name
setFormField "Smash" "Child View" "Original"
setFormField "Smash" "Cell Name" cell_name
formOK "Smash"

cmMarkCellType
setFormField "Mark Cell Type" "Cell Name"  (string-append cell_name ".CEL")
setFormField "Mark Cell Type" "Library Name" lib_name
setFormField "Mark Cell Type" "pattern match" "1"
setFormField "Mark Cell Type" "Cell Type" "macro"
formOK "Mark Cell Type"

geNewMakeMacro
setFormField "Make Macro" "Library Name" lib_name 
setFormField "Make Macro" "Cell Name" (string-append cell_name ".CEL")
setFormField "Make Macro" "Routing Blockage Output Layer" "metBlk"
formButton "Make Macro" "extractPin"
setFormField "Make Macro" "Identify Macro Pin By Pin Text" "1"
setToggleField "Make Macro" "through" "polyCont" 1
setFormField "Make Macro" "Metal1 Text" "131"
setFormField "Make Macro" "Metal2 Text" "132"
setFormField "Make Macro" "Metal3 Text" "133"
setFormField "Make Macro" "Metal4 Text" "134"
setFormField "Make Macro" "Metal5 Text" "135"
setFormField "Make Macro" "Metal6 Text" "136"
setFormField "Make Macro" "Metal7 Text" "137"
formButton "Make Macro" "extractBlkg"
setFormField "Make Macro" "Poly" "block all"
setFormField "Make Macro" "Metal 1" "block all"
setFormField "Make Macro" "Metal 2" "block all"
setFormField "Make Macro" "Metal 3" "block all"
setFormField "Make Macro" "Metal 4" "block all"
setFormField "Make Macro" "Metal 5" "block all"
setFormField "Make Macro" "Metal 6" "block all"
setFormField "Make Macro" "Metal 7" "block all"
formOK "Make Macro"

geOpenCell
setFormField "Open Cell" "Cell Name" (string-append cell_name ".FRAM")
formOK "Open Cell"
dbSetPortDirection (geGetEditCell) "VSSAIO" "inputoutput"
dbSetPortDirection (geGetEditCell) "VSSD" "inputoutput"
dbSetPortDirection (geGetEditCell) "VSSA" "inputoutput"
dbSetPortDirection (geGetEditCell) "VDDAIO" "inputoutput"
dbSetPortDirection (geGetEditCell) "VDDD" "inputoutput"
dbSetPortDirection (geGetEditCell) "VDDA" "inputoutput"

(dbSaveCell (geGetEditCell))
geCloseWindow
formButton "Close Window" "DiscardAll"
formOK "Close Window"
;dbCreateCellBoundary (geGetEditCell) '( (820.000 0.000) (820.000 420.000) (3120.000000 420.000000)  (3120.00 1420.00) (0.0000 1420.0000) (0.0000 0.0000) )
;dbSetCellPRBoundaryPolygon (geGetEditCell) '( (820.000 0.000) (820.000 420.000) (3120.000000 420.000000)  (3120.00 1420.00) (0.0000 1420.0000) (0.0000 0.0000) )
