# Step 1: Edit setup file that is coming from the PDK, correct layer stack etc. 
# Test.cfill.setup
# File is renamed here in this case to or1200.cfill..

# Step 2: Source calibre file
source ../calibre_sourceme

set FILE_EXT=`echo "${LAYOUT_SYSTEM}" | tr '[A-Z]' '[a-z]'`

# Step 3: Run Fill (and merge)
echo "\nStarting  fill run \n"
${PDK_HOME}/FILLGEN/Calibre/run_calibre -l ../run_merge/${MODULE_NAME}_stdcell_merged.${LAYOUT_FILE_TYPE_EXT}  -ln ${MODULE_NAME} -output_filename ${MODULE_NAME}.fill.${FILE_EXT} -setup ${MODULE_NAME}.cfill.setup -tech ${PDK_HOME}/FILLGEN/Calibre/fill_fdsoi22.enc.svrf -keep_merge_script -merge_input -merged_output_file ${MODULE_NAME}.merged.${LAYOUT_FILE_TYPE_EXT} -suffix_gen_tiles_output _gt -output_type ${FILE_EXT}
