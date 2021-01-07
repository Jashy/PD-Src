#################################################################
#create MW database
create_mw_lib -tech $TECH_FILE $MW_LIB 
set_mw_lib_reference -mw_reference_library $MW_REF_LIB ./$MW_LIB
open_mw_lib $MW_LIB
