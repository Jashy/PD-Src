geOpenLib
setFormField "Open Library" "Library Name" lib_name
setFormField "Open Library" "Library Path" "/DELL/proj/Shisha/WORK/ash/gds2fram/template"
formOK "Open Library"



auStreamIn
setFormField "Stream In Data File" "Library Name" lib_name
setFormField "Stream In Data File" "Stream File Name" (string-append "./" cell_name ".gds")
setFormField "Stream In Data File" "Layer File" ""
setFormField "Stream In Data File" "Store Undefined Layers" "1"
setFormField "Stream In Data File" "Extract Only Geometries Defined in Layer File" "0"
setFormField "Stream In Data File" "Use Layer for Boundary" "0"
setFormField "Stream In Data File" "Overwrite Existing Cells" "1"
setFormField "Stream In Data File" "Boundary Layer" "255"
formOK "Stream In Data File"
;
;
cmSmash
setFormField "Smash" "Library Name" lib_name
setFormField "Smash" "Child View" "Original"
setFormField "Smash" "Cell Name" cell_name
setFormField "Smash" "explode text" "1"
formOK "Smash"

geOpenCell
setFormField "Open Cell" "Cell Name" (string-append cell_name ".CEL")
formOK "Open Cell"


dbSetCellPortTypes "asdsrscfs1p1024x32cm8sw8" "asdsrscfs1p1024x32cm8sw8" '(
  ("VDD" "Inout" "Power" )
  ("VSS" "Inout" "Ground" )
  ("VDD:" "Inout"  "Power")
  ("VSS:" "Inout" "Ground")
) #f

(dbSaveCell (geGetEditCell))
;geCloseWindow
;formButton "Close Window" "DiscardAll"
;formOK "Close Window"


;geOpenLib
;setFormField "Open Library" "Library Name" lib_name
;setFormField "Open Library" "Library Path" "/DELL/proj/Shisha/WORK/ash/gds2fram/template"
;formOK "Open Library"

;geOpenCell
;setFormField "Open Cell" "Cell Name" (string-append cell_name ".CEL")
;formOK "Open Cell"

;dbCreateCellBoundary (geGetEditCell) '( (4200.000 0.000) (4200.000 3300.000) (0.000000 3300.000000)  (0 0) )
;dbSetCellPRBoundaryPolygon (geGetEditCell) '( (4200.000 0.000) (4200.000 3300.000) (0.000000 3300.000000)  (0 0) )

;(dbSaveCell (geGetEditCell))
;geCloseWindow
;formButton "Close Window" "DiscardAll"
;formOK "Close Window"


;dbCreateCellBoundary (geGetEditCell) '( (4200.000 0.000) (4200.000 3300.000) (0.000000 3300.000000)  (0 0) )
;dbSetCellPRBoundaryPolygon (geGetEditCell) '( (4200.000 0.000) (4200.000 3300.000) (0.000000 3300.000000)  (0 0) )
;
;
;dbSetCellPortTypes lib_name cell_name ' ( ("VDD" "Inout" "Power") ("VSS" "Inout" "Ground")) #f
