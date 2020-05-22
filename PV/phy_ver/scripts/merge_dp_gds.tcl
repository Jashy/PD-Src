## Script to merge DP_Colored.gds with Chip GDS using overlay approach
# read in setup flow variables file
source ../../project_setup.tcl

set GFVAR_EXT [string tolower ${GFVAR_CALIBRE_LAYOUT_SYSTEM}]

set COLORED_FILE "../design_data/gds/DP_colored.${GFVAR_EXT}"
set timesuf [clock seconds]
set DPT_SUFFIX "_${timesuf}"

if {[file exists $COLORED_FILE] } {
 puts "Info: Load Filled Layout"
 eval "\nlayout filemerge -infile { -name $COLORED_FILE -suffix $DPT_SUFFIX } -out temp.${GFVAR_CALIBRE_LAYOUT_EXT}"
 set IN_LAYOUT [layout create ../run_fill/$GFVAR_DESIGN(name).merged.${GFVAR_CALIBRE_LAYOUT_EXT} -dt_expand -preservePaths -preserveTextAttributes -preserveProperties ]
 set top_cell [$IN_LAYOUT topcell]
 puts "Info: Load DP Cell"
 eval "\$IN_LAYOUT import layout temp.${GFVAR_CALIBRE_LAYOUT_EXT} TRUE append -dt_expand -preservePaths -preserveTextAttributes -preserveProperties"
 
 puts "Info: Create reference"
 eval "\$IN_LAYOUT create ref $top_cell ${GFVAR_DESIGN(name)}${DPT_SUFFIX} 0 0 0 0 1.0" 
 #$IN_LAYOUT delete layer 136.103
 #puts "Info: Delete non colored M2/M1"
 #$IN_LAYOUT delete layer 17.0
 #$IN_LAYOUT delete layer 15.0

####delete high metal dummy exclude layer, add bottom dummy exclude layer for top design
if {$GFVAR_DUMMY_EXCLUDE == "YES"} {
 puts "Info: Delete dummy exclude layer"
 foreach layer_number $GFVAR_DUMMY_EXCLUDE_LAYER {
	#eval "\$IN_LAYOUT delete polygon $GFVAR_DESIGN(name) $layer_number $GFVAR_DUMMY_EXCLUDE_LAYER_COORDINATE"
	eval "\$IN_LAYOUT delete layer $layer_number"
 }
}
if {$GFVAR_DUMMY_EXCLUDE_FOR_TOP == "YES"} {
 foreach layer_number $GFVAR_DUMMY_EXCLUDE_BOTTOM_LAYER {
        eval "\$IN_LAYOUT create_layer $layer_number"
	eval "\$IN_LAYOUT delete polygon $GFVAR_DESIGN(name) $layer_number $GFVAR_DUMMY_EXCLUDE_LAYER_COORDINATE"
 }
}


 puts "Info: Write final GDS"
  file delete -force temp.${GFVAR_CALIBRE_LAYOUT_EXT}
 if {$GFVAR_CALIBRE_LAYOUT_SYSTEM == "OASIS"} {
  eval \$IN_LAYOUT oasisout $GFVAR_DESIGN(name).final.${GFVAR_CALIBRE_LAYOUT_EXT} $GFVAR_DESIGN(name)
 } else {
  eval \$IN_LAYOUT gdsout $GFVAR_DESIGN(name).final.${GFVAR_CALIBRE_LAYOUT_EXT} $GFVAR_DESIGN(name)
  }
} else { 
 puts "ERROR: Now $COLORED_FILE file found"
}
