#!/bin/csh -f
source /proj/BTC/WORK/lukez/star/try/mycshrc_n
source ~/star_lic.csh

set MLKYWYLIB	= _MILKYWAYLIB_
set MLKYWYCEL	= _MILKYWAYCELL_
set astro_ready = _READY_
set BLOCK	= _BLOCK_
#
set MODE	= couple ; # couple or decouple
set DATE	= `date +%Y%m%d`
set MAP		= /proj/BTC/LIB_NEW/TechFile/PR_techfile/r2p0-00eac0/synopsys_tluplus/8M_3Mx_4Cx_1Gx_LB/tluplus.map
set CONDS	= "Cworst Cbest"
set UDC_File 	= /proj/BTC/WORK/arckeonw/ICC/btc_unit/floorplan_20150625/flow_btc_20150723a/STAR/udc_file

#-#-  set name	= 125c
#-#-  set name2	= 0c
foreach COND ($CONDS)
	if (-d $COND) then
		echo "$COND exists"
		continue 
	else 
		mkdir $COND
		cd $COND
	
		set SESSION	= ${BLOCK}_${COND}_${MODE}
		set SPEF	= ${BLOCK}_${COND}_${MODE}.spef
		set SpefReady   = ${PWD}/${COND}_ready
		if (${COND} == "Cworst") then
			set GRD = /proj/BTC/LIB_NEW/TechFile/EDA_Techfile/synopsys/StarRC/8M_3Mx_4Cx_1Gx_LB/14lpp_8M_3Mx_4Cx_1Gx_LB_SigCmaxDP_ErPlus_detailed.nxtgrd
			set names = "125c -25c"
		else if (${COND} == "Cbest") then
			set GRD = /proj/BTC/LIB_NEW/TechFile/EDA_Techfile/synopsys/StarRC/8M_3Mx_4Cx_1Gx_LB/14lpp_8M_3Mx_4Cx_1Gx_LB_SigCminDP_ErMinus_detailed.nxtgrd
			set names = "125c -25c"
		else if (${COND} == "RCworst") then
			set GRD = /proj/BTC/LIB_NEW/TechFile/EDA_Techfile/synopsys/StarRC/8M_3Mx_4Cx_1Gx_LB/14lpp_8M_3Mx_4Cx_1Gx_LB_SigRCmaxDP_ErPlus_detailed.nxtgrd
			set names = "125c"
		else if (${COND} == "RCbest") then
			set GRD = /proj/BTC/LIB_NEW/TechFile/EDA_Techfile/synopsys/StarRC/8M_3Mx_4Cx_1Gx_LB/14lpp_8M_3Mx_4Cx_1Gx_LB_SigRCminDP_ErMinus_detailed.nxtgrd
			set names = "-25c"
		endif
	
		if (${MODE} == "couple") then
			set TOGND = no
		else
			set TOGND = yes
		endif
	
cat << FP > ${SESSION}.cmd

MILKYWAY_DATABASE:            ${MLKYWYLIB}
BLOCK:                        ${MLKYWYCEL}
TCAD_GRD_FILE:                ${GRD}
MAPPING_FILE:                 ${MAP}
EXTRACTION:                   RC
NETLIST_FILE:                 ${SPEF}
NETLIST_FORMAT:               spef
COUPLE_TO_GROUND:             ${TOGND}
*REDUCTION:                   NO 

TEMPERATURE_SENSITIVITY:	YES
NETLIST_CORNER_FILE             ${UDC_File}
NETLIST_CORNER_NAMES:           ${names}
NUM_CORES: 4
DPT: YES

REFERENCE_DIRECTION : VERTICAL
MILKYWAY_ADDITIONAL_VIEWS:    FILL
METAL_FILL_POLYGON_HANDLING:  Automatic
NETLIST_LOGICAL_TYPE:         VERILOG
NETLIST_INPUT_DRIVERS:        YES

COUPLING_ABS_THRESHOLD: 1e-16
COUPLING_REL_THRESHOLD: 0.02
FP
# IGNORE_CAPACITANCE:		ALL RETAIN_GATE_DIFFUSION_COUPLING
# TRANSLATE_FLOATING_AS_FILL:	YES
		
		############Print all the variables########
		echo "****************************************************"
		echo "Milkyway lib:"
		echo "  ${MLKYWYLIB}"
		echo "Spef file"
		echo "  ${SPEF}"
		echo "Spef ready file"
		echo "  ${SpefReady}"
		echo "****************************************************"
		############################################
		
		###waiting for astro ready
		while (! (-e ${astro_ready}))
		echo "waiting ${astro_ready}..."
		sleep 100
		end
		
		### ###
		set current_dir = `pwd`
		set number_cpu  = 4
		@ cnt = 0
		while ( $cnt < $number_cpu )
		  echo "INFO: Start $cnt / $number_cpu"
		   ( StarXtract ${SESSION}.cmd && touch ./part${cnt}.ready ) &
		  @ cnt ++
		end
		
		@ cnt = 0
		while ( $cnt < $number_cpu )
		  while ( ! -e ./part${cnt}.ready )
		    sleep 2
		  end
		  @ cnt ++
		end
		touch extraction.ready
		### ###
		
		if (-e extraction.ready) then
			foreach name ($names)
				if (-e ${SPEF} ) then
					if ($name == "-25c") then
						set name = m25c
					endif
					mv ${SPEF} ${BLOCK}_${COND}_${name}_${MODE}.spef
					gzip ${BLOCK}_${COND}_${name}_${MODE}.spef
				endif 
				if (-e ${SPEF}.${name} ) then
					if ($name == "-25c") then
						mv ${SPEF}.${name} ${BLOCK}_${COND}_m25c_${MODE}.spef
						gzip ${BLOCK}_${COND}_m25c_${MODE}.spef

					else
						mv ${SPEF}.${name} ${BLOCK}_${COND}_${name}_${MODE}.spef
						gzip ${BLOCK}_${COND}_${name}_${MODE}.spef
					endif
				 
				endif 
			end
			touch ${COND}_ready
		else
			touch error_spef
		endif
		cd ..
	endif

end
