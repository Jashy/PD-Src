#!/bin/csh -f
set path = (/apps/synopsys/starrc_vC-2009.06-SP3-3/amd64_starrc/bin $path)
unsetenv BLOCK 
unsetenv MLKYWYLIB 
unsetenv MLKYWYCEL
unsetenv icc_ready
unsetenv COND
unsetenv MODE
unsetenv DATE
unsetenv SESSION 
unsetenv SPEF
unsetenv SpefReady 
unsetenv process
unset cpu_mul

setenv BLOCK            ptile_top
setenv MLKYWYLIB        /proj/Pezy-1/WORK/carson/ptile_top/ICC/MDB_ptile_top
setenv MLKYWYCEL        ptile_top
setenv icc_ready        /proj/Pezy-1/WORK/carson/ptile_top/ICC/ready
setenv DATE		20111122

setenv process          45nm

set CONDS = "cworst_0C cbest_0C cworst_125C cbest_125C "


foreach COND ( $CONDS )
  setenv MODE             couple ; # couple or decouple
  setenv SESSION          ${BLOCK}_${COND}_${MODE}
  setenv SPEF             ${BLOCK}_${COND}_${MODE}.spef
  setenv SpefReady        ${PWD}/$COND/starrc_ready_${COND}
  
  set cpu_mul = 4
  set MAP = /proj/Pezy-1/LIB/TechFile/synopsys/techfiles/tluplus/star.map_9M
  
  
  if (${COND} == "cbest_m40C") then
        set GRD = /proj/Pezy-1/LIB/TechFile/synopsys/techfiles/cln40g_1p09m+alrdl_6x2z_cbest.nxtgrd
  	set TEMPERATURE = -40
  else if (${COND} == "cbest_0C") then
          set GRD = /proj/Pezy-1/LIB/TechFile/synopsys/techfiles/cln40g_1p09m+alrdl_6x2z_cbest.nxtgrd
  	set TEMPERATURE = 0
  else if (${COND} == "cbest_25C") then
          set GRD = /proj/Pezy-1/LIB/TechFile/synopsys/techfiles/cln40g_1p09m+alrdl_6x2z_cbest.nxtgrd
  	set TEMPERATURE = 25
  else if (${COND} == "cbest_125C") then
          set GRD = /proj/Pezy-1/LIB/TechFile/synopsys/techfiles/cln40g_1p09m+alrdl_6x2z_cbest.nxtgrd
  	set TEMPERATURE = 125
  else if (${COND} == "cworst_m40C") then
          set GRD = /proj/Pezy-1/LIB/TechFile/synopsys/techfiles/cln40g_1p09m+alrdl_6x2z_cworst.nxtgrd
  	set TEMPERATURE = -40
  else if (${COND} == "cworst_0C") then
          set GRD = /proj/Pezy-1/LIB/TechFile/synopsys/techfiles/cln40g_1p09m+alrdl_6x2z_cworst.nxtgrd
  	set TEMPERATURE = 0
  else if (${COND} == "cworst_125C") then
          set GRD = /proj/Pezy-1/LIB/TechFile/synopsys/techfiles/cln40g_1p09m+alrdl_6x2z_cworst.nxtgrd
  	set TEMPERATURE = 125
  endif
  
  if (${MODE} == "couple") then
  	set TOGND = no
  else
  	set TOGND = yes
  endif
  if ($cpu_mul > 0) then
cat << StarXXT > .${SESSION}.cmd
	milkyway_database:            ${MLKYWYLIB}
	block:                        ${MLKYWYCEL}
	tcad_grd_file:                ${GRD}
	mapping_file:                 ${MAP}
	extraction:                   rc
	netlist_file:                 ${SPEF}
	netlist_format:               spef
	couple_to_ground:             ${TOGND}
	*reduction:                   no
	NUM_PARTS: 		      $cpu_mul
        OPERATING_TEMPERATURE:       ${TEMPERATURE}
	netlist_logical_type:         VERILOG
	netlist_input_drivers:        YES
	METAL_FILL_POLYGON_HANDLING:   Automatic
	MILKYWAY_ADDITIONAL_VIEWS:     FILL
StarXXT
  switch ($process) 
  case "45nm":
  	echo "        mode:                         400" >> .${SESSION}.cmd
  	echo "        COUPLING_ABS_THRESHOLD: 1e-16" >> .${SESSION}.cmd
  	echo "        COUPLING_REL_THRESHOLD: 0.02" >> .${SESSION}.cmd
  	breaksw
  case "65nm":
  	echo "        mode:                         400" >> .${SESSION}.cmd
  	echo "        COUPLING_ABS_THRESHOLD: 1e-16" >> .${SESSION}.cmd
  	echo "        COUPLING_REL_THRESHOLD: 0.02" >> .${SESSION}.cmd
  	breaksw
  case "90nm":
  	echo "        mode:                         200" >> .${SESSION}.cmd
  	breaksw
  case "130nm":
  	echo "        mode:                         200" >> .${SESSION}.cmd
  	breaksw
  endsw
  
  endif
  
  if ( ( -d $COND ) ) then
    echo "********** $COND already exists. Skipping ... **********"
  else
    ############Print all the variables########
    echo "****************************************************"
    echo "Milkyway lib:"
    echo "  ${MLKYWYLIB}"
    echo "Spef file"
    echo "  ${SPEF}.gz"
    echo "Spef ready file"
    echo "  ${SpefReady}"
    echo "****************************************************"
    ############################################
    rm ./starrc_ready_${COND}
    
    mkdir -p $COND
    cd $COND
    cp ../.${SESSION}.cmd ${SESSION}.cmd
    echo "Begin $COND ..."

    ###waiting for icc ready
    while( !( -e ${icc_ready} ) )
     echo "Wating  get ready..."
        sleep 10
     end
    
source /tools/generic/eda.cshrc.back

    @ cnt = 0
    while ( $cnt < ${cpu_mul} )
      ( StarXtract ${SESSION}.cmd && touch ./part${cnt}.ready ) &
      @ cnt ++
    end

    wait

    @ cnt = 0
    while ( $cnt < ${cpu_mul} )
      [ -f ./part${cnt}.ready ] || exit
      @ cnt ++
    end



    #rm -r star
    
#    sleep 200
    gzip ${SPEF}
    
    #perl /proj/NSP/CURRENT/ELE/brucel/STAR/scripts/change_design_name.pl ${BLOCK} ${SPEF} | gzip -c > ${SPEF}.gz
    #sed 's/^*DESIGN ".*"$/*DESIGN '"${BLOCK}"'/' ${SPEF} | gzip -c > ${SPEF}.gz
    #sed 's/^*DESIGN ".*"$/*DESIGN '"${BLOCK}"'/' ${SPEF} > ${SPEF}.gz
    #\rm -f ${SPEF}
    
    ########## followed is for fujitsu 
    #
    #
    #set path = (/proj/LEO2/LIB/SC/CURRENT/RDF/tools/bin  $path)
    #setenv RF_DIR  "/proj/LEO2/LIB/SC/CURRENT/RDF"
    #coeff_rc.pl -rmin 0.66528 -cmin 0.84 -rmax 1.5312 -cmax 1.26 -nf ${CELL_NAME}_${PROCESS_CON}.spef
    #coeff_rc.pl -r 1.1088 -c 0.84 -o ${CELL_NAME}_fastHT.spef ${CELL_NAME}_${PROCESS_CON}.spef
    #coeff_rc.pl -r 0.91872 -c 1.26 -o ${CELL_NAME}_slowLT.spef ${CELL_NAME}_${PROCESS_CON}.spef
    
    touch ./starrc_ready_${COND}
    source /user/home/nealj/Template/LOG_CHECKER/log_check.csh starx ./
    #sleep 2000
    #rm -r star
    cd ..
  endif
end
