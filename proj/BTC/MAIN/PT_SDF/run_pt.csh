#!/bin/csh -f
unsetenv PROJ  TOP  VNET_LIST mode SDC_LIST  FLOW CORNER RC_VERSION SDF_CORNER CLOCK_MODE  NWORST_NUM  EXIT MULTI_CPU BLOCK_ONLY INCLUDE_TRAN BLOCK_RC_VERSION BLOCKS WAIT_FILE TMP_COND RC_COND START_DIR

setenv PROJ			BTC
setenv TOP			"_TOP_"
setenv FLOW			spef
setenv BLOCK_ONLY		1
setenv BLOCKS			""
setenv VNET_LIST		"_NETLIST_"
setenv RC_VERSION		"_RC_VERSION_"
setenv STAR_DIR			"_STAR_DIR_"
setenv BLOCK_RC_VERSION		final
setenv CLOCK_MODE		propagated	; # propagated or ideal
setenv NWORST_NUM		1
setenv RPT_INTERNAL		yes
setenv INCLUDE_TRAN		no		; # yes or no
setenv FULL_CLKREP		no		; # yes or no
setenv RPT_CLK_SKEW		yes		; # yes or no
setenv EXIT			yes
setenv MULTI_CPU		2

set PMODES = "max_wc_Cworst_125c_1 min_bc_Cbest_m25c_0"

source  /proj/HJ/WORK/data/setup/mycshrc_n
source  /proj/BTC/WORK/carsonl/templete/SETUPS/PT

set MODES = "normal" ;####edit####

setenv RC_COND ""
setenv RC_COND1 ""
setenv TMP_COND ""
foreach mode ( $MODES )
  foreach PMODE ( $PMODES )
    setenv STA_MODE     `echo $PMODE | awk -F "_" '{print $1}'`
    setenv LIB_COND     `echo $PMODE | awk -F "_" '{print $2}'`
    setenv RC_COND      `echo $PMODE | awk -F "_" '{print $3}'`
    setenv TMP_COND     `echo $PMODE | awk -F "_" '{print $4}'`
    setenv WRITE_SDF    `echo $PMODE | awk -F "_" '{print $5}'`
    setenv SDF_CORNER   "${LIB_COND}_${RC_COND}_${TMP_COND}"
    setenv STA_COND     "${LIB_COND}_${RC_COND}"
    setenv RC_COND1     "${RC_COND}_${TMP_COND}"
    setenv CORNER       "${LIB_COND}_${RC_COND1}"
    switch ($mode)
      case normal :
		setenv SDC_LIST	"_SDC_LIST_"
      		breaksw
      default:
	 echo "ERROR: MODE '$mode' is not defined !"
	 exit
    endsw
    setenv WAIT_FILE  ""
    setenv SPEF_LIST ""  
    setenv SDF ""
    if ( $FLOW == sdf ) then
	    setenv SDF       "" ; ###edit###
	    setenv WAIT_FILE "" ; ###edit###
    else 
	    if ( $BLOCK_ONLY == 1 ) then
	    	setenv SPEF_LIST  ${STAR_DIR}/${RC_VERSION}/${RC_COND}/${TOP}_${RC_COND1}_couple.spef.gz
	    	setenv WAIT_FILE  ${STAR_DIR}/${RC_VERSION}/${RC_COND}/${RC_COND}_ready
            else 
		setenv SPEF_LIST "" ;#####edit####
        	setenv WAIT_FILE "" ;####edit#####
		if ( "${BLOCKS}" != "" ) then
          		setenv VNET_LIST    ""
			foreach BLOCK ($BLOCKS)
				setenv VNET_LIST    ""
				setenv SPEF_LIST "${SPEF_LIST} xxx "
				setenv WAIT_FILE "${WAIT_FILE} xxx "
			end
		endif
    	    endif
    endif

    ##############################################
    # cat setup file
    mkdir -p ./${mode}-mode
    if ( -e ./${mode}-mode/${CORNER}_${STA_MODE} ) then
     echo "********** ./${mode}-mode/${CORNER}_${STA_MODE} already exists. Skipping ... **********"
    else
     echo "********** Starting ./${mode}-mode/${CORNER}_${STA_MODE} ..."
     mkdir -p ./${mode}-mode/${CORNER}_${STA_MODE}
     cd ./${mode}-mode/${CORNER}_${STA_MODE}
     mkdir -p LOG REPORT OUTPUT
     echo "foreach WAIT (${WAIT_FILE})" > ./run.csh
     echo ' while ( ! ( -e ${WAIT} ) )' >> ./run.csh
     echo '   echo "Waiting ${WAIT} get ready."' >> ./run.csh
     echo "   sleep 100" >> ./run.csh
     echo " end" >> ./run.csh
     echo "end" >> ./run.csh

      echo "set PROJ                  ${PROJ}"                                            > ./common_setup.tcl
      echo "set mode                  ${mode}"                                           >> ./common_setup.tcl
      echo "set TOP                   ${TOP}"                                            >> ./common_setup.tcl
      echo "set FLOW                  ${FLOW}"                                           >> ./common_setup.tcl
      echo "set BLOCK_ONLY            ${BLOCK_ONLY}"                                     >> ./common_setup.tcl
      echo "set WRITE_SDF             ${WRITE_SDF}"                                      >> ./common_setup.tcl
      echo "set VNET_LIST             [list ${VNET_LIST}]"                               >> ./common_setup.tcl
      echo "set SDC_LIST              [list ${SDC_LIST}]"                                >> ./common_setup.tcl
      echo "set CORNER                ${CORNER}"                                         >> ./common_setup.tcl
      echo "set LIB_COND              ${LIB_COND}"                                       >> ./common_setup.tcl
      echo "set RC_COND               ${RC_COND}"                                        >> ./common_setup.tcl
      echo "set STA_MODE              ${STA_MODE}"                                       >> ./common_setup.tcl
      echo "set STA_COND              ${STA_COND}"                                       >> ./common_setup.tcl
      echo "set TMP_COND              ${TMP_COND}"                                       >> ./common_setup.tcl
      echo "set CLOCK_MODE            ${CLOCK_MODE}"                                     >> ./common_setup.tcl
      echo "set SPEF_LIST             [list ${SPEF_LIST}]"                               >> ./common_setup.tcl
      echo "set SDF                   [ list $SDF ]"                                     >> ./common_setup.tcl
      echo "set NWORST_NUM            ${NWORST_NUM} "                                    >> ./common_setup.tcl
      echo "set INTERNAL_ONLY         ${RPT_INTERNAL}"                                   >> ./common_setup.tcl
      echo "set INCLUDE_TRAN          ${INCLUDE_TRAN}"                                   >> ./common_setup.tcl
      echo "set FULL_CLKREP           ${FULL_CLKREP}"                                    >> ./common_setup.tcl
      echo "set RPT_CLK_SKEW          ${RPT_CLK_SKEW}"                                   >> ./common_setup.tcl
      echo "set EXIT                  ${EXIT}"                                           >> ./common_setup.tcl
      echo "set MULTI_CPU             $MULTI_CPU"                                        >> ./common_setup.tcl
      echo ""                                                                            >> ./common_setup.tcl
      echo "set SDF_CORNER            ${SDF_CORNER}"                                     >> ./common_setup.tcl
      echo "source -e		      _SPEF2SDF_"					 >> ./common_setup.tcl
      echo 'pt_shell -f common_setup.tcl | tee ./LOG/pt.log' >> ./run.csh
      source ./run.csh &

      cd ../../
    endif
  end
  foreach PMODE ( $PMODES )
	setenv STA_MODE    `echo $PMODE | awk -F "_" '{print $1}'`
	setenv LIB_COND    `echo $PMODE | awk -F "_" '{print $2}'`
	setenv RC_COND     `echo $PMODE | awk -F "_" '{print $3}'`
	setenv TMP_COND    `echo $PMODE | awk -F "_" '{print $4}'`
	setenv CORNER1     "${LIB_COND}_${RC_COND}_${TMP_COND}"
	while ( ! ( -e ./${mode}-mode/${CORNER1}_${STA_MODE}/pt_ready ) )
		echo "waiting ${mode}-mode/${CORNER1}_${STA_MODE}/pt_ready get ready !"
		sleep 30
	end
  end
end
