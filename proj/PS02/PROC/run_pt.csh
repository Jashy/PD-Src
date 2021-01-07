#!/bin/csh

unset PROJ  TOP  VNET_LIST MODE SDC_LIST  UseSPEF UseSDF CORNER RC_VERSION  CLOCK_MODE  MARGIN_MAX  MARGIN_MIN  NWORST_NUM  EXIT max_transition_setting MULTI_CPU

setenv PROJ 		Pezy-1
setenv TOP		ptile_top
setenv VNET_LIST        /proj/Pezy-1/WORK/carson/ptile_top/ICC/ptile_top.run/ECO_1122.v
setenv UseSDF	        1
setenv UseSPEF          0
setenv RC_VERSION       20111122
setenv CLOCK_MODE       propagated
setenv MARGIN_MAX       0.3 ; # 0.3 for idea; propagated:0.025
setenv MARGIN_MIN       0.065
setenv NWORST_NUM       1
setenv RPT_INTERNAL     yes
setenv EXIT             yes
setenv max_transition_setting "/proj/Pezy-1/WORK/jimmyx/PT/${TOP}/clk/all_clock_pin_transition_limit.tcl"
setenv MULTI_CPU        0
setenv SAVE_DB          yes

set PMODES = "max_wcz_cworst_0C min_bc_cbest_0C min_bc_cworst_0C max_wc_cworst_125C min_wc_cworst_125C min_wc_cbest_125C  min_ml_cworst_125C min_ml_cbest_125C"

if ( $TOP == "ddr3_wrapper" ) then
  setenv VNET_LIST  "/user/home/nealj/pz/FP/mosys_ca_bitslice_0722.v /user/home/nealj/pz/FP/mosys_wr_bitslice_0722.v $VNET_LIST"
  setenv MARGIN_MAX       0.3 ; # for idea; propagated:0.025
endif


source /proj/Pezy-1/TEMPLATES/SETUPS/PT

set MODES = "normal scan_shift mbist scan_dc_capture scan_ac_capture"

foreach MODE ( $MODES )
  foreach PMODE ( $PMODES )
    setenv STA_MODE    `echo $PMODE | awk -F "_" '{print $1}'`
    setenv LIB_COND    `echo $PMODE | awk -F "_" '{print $2}'`
    setenv RC_COND     `echo $PMODE | awk -F "_" '{print $3}'`
    setenv TMP_COND    `echo $PMODE | awk -F "_" '{print $4}'`
    setenv RC_COND     "${RC_COND}_${TMP_COND}"
    setenv CORNER      "${LIB_COND}_${RC_COND}"

    setenv SDC_LIST /proj/Pezy-1/WORK/marshals/fir_top/Release/sdc/fir_top.${MODE}.tcl
    switch ($MODE)
      case normal :
        setenv SDC_LIST /proj/Pezy-1/LIB/BLOCK/CURRENT/sdc/${TOP}.sdc
      breaksw
      case scan_ac_capture
        setenv SDC_LIST /proj/Pezy-1/WORK/albertz/DFT/RELEASE/0831/ptile/sdc/ptile_top.scan_ac_capture.tcl
      breaksw
      case scan_shift
        setenv SDC_LIST /proj/Pezy-1/WORK/albertz/DFT/RELEASE/0831/ptile/sdc/ptile_top.scan_shift.tcl
      breaksw
       case scan_dc_capture
        setenv SDC_LIST /proj/Pezy-1/WORK/albertz/DFT/RELEASE/0831/ptile/sdc/ptile_top.scan_dc_capture.tcl
      breaksw
       case mbist
        setenv SDC_LIST /proj/Pezy-1/WORK/albertz/DFT/RELEASE/0831/ptile/sdc/ptile_top.mbist.tcl
      breaksw
    endsw

    setenv SPEF_LIST ""
    setenv SDF ""
    if ( $UseSPEF == 1 ) then
      setenv SPEF_LIST  /proj/Pezy-1/WORK/carson/ptile_top/STAR/20111122a/${RC_COND}/${TOP}_${RC_COND}_couple.spef.gz
      if ( $TOP == "ddr3_wrapper" ) then
        setenv SPEF_LIST "$SPEF_LIST /user/home/nealj/pz/ICC/DDR3/STAR/${RC_COND}/mosys_ca_bitslice_${RC_COND}_couple.spef.gz /proj/Pezy-1/WORK/Nealj/ICC/DDR3_rw_bitslice/STAR/${RC_COND}/mosys_wr_bitslice_${RC_COND}_couple.spef.gz"
      endif
      setenv WAIT_FILE  /proj/Pezy-1/WORK/carson/ptile_top/STAR/20111122a/${RC_COND}/starrc_ready_${RC_COND}
    endif
    if ( $UseSDF == 1 ) then
      setenv SDF       "/proj/Pezy-1/WORK/carson/ptile_top/PT/20111122a/SDF-mode/${CORNER}_sdf/OUTPUT/${TOP}.${CORNER}.sdf.gz"
      setenv WAIT_FILE "/proj/Pezy-1/WORK/carson/ptile_top/PT/20111122a/SDF-mode/${CORNER}_sdf/OUTPUT/${TOP}.${CORNER}.sdf.gz.ready"
    endif

    ##############################################
    # cat setup file
    source /tools/generic/eda.cshrc.back
    
    mkdir -p ./${MODE}-mode
    if ( -e ./${MODE}-mode/${CORNER}_${STA_MODE} ) then
      echo "********** ./${MODE}-mode/${CORNER}_${STA_MODE} already exists. Skipping ... **********"
    else
      echo "********** Starting ./${MODE}-mode/${CORNER}_${STA_MODE} ..."
      mkdir -p ./${MODE}-mode/${CORNER}_${STA_MODE}
      cd ./${MODE}-mode/${CORNER}_${STA_MODE}
      mkdir -p LOG REPORT OUTPUT
      
      while ( ! ( -e ${WAIT_FILE} ) )
        echo "Waiting ${WAIT_FILE} get ready."
        sleep 100
      end

      echo "set PROJ                  ${PROJ}"                                 > ./common_setup.tcl
      echo "set TOP                   ${TOP}"                                 >> ./common_setup.tcl
      echo "set VNET_LIST             [list ${VNET_LIST}]"                    >> ./common_setup.tcl
      echo "set SDC_LIST              [list ${SDC_LIST}]"                     >> ./common_setup.tcl
      echo "set CORNER                ${CORNER}"                              >> ./common_setup.tcl
      echo "set LIB_COND              ${LIB_COND}"                            >> ./common_setup.tcl
      echo "set RC_COND               ${RC_COND}"                             >> ./common_setup.tcl
      echo "set STA_MODE              ${STA_MODE}"                            >> ./common_setup.tcl
      echo "set CLOCK_MODE            ${CLOCK_MODE}"                          >> ./common_setup.tcl
      echo "set SPEF_LIST             [list ${SPEF_LIST}]"                    >> ./common_setup.tcl
      echo "set SDF                   [ list $SDF ]"                          >> ./common_setup.tcl
      echo "set MARGIN_MAX            ${MARGIN_MAX}"                          >> ./common_setup.tcl
      echo "set MARGIN_MIN            ${MARGIN_MIN}"                          >> ./common_setup.tcl
      echo "set NWORST_NUM            ${NWORST_NUM} "                         >> ./common_setup.tcl
      echo "set INTERNAL_ONLY         ${RPT_INTERNAL}"                        >> ./common_setup.tcl
      echo "set EXIT                  ${EXIT}"                                >> ./common_setup.tcl
      echo "set max_transition_setting [ list $max_transition_setting ]"      >> ./common_setup.tcl
      echo "set MULTI_CPU             $MULTI_CPU"                             >> ./common_setup.tcl
      echo "set SAVE_DB               $SAVE_DB"                             >> ./common_setup.tcl
      echo ""                                                                 >> ./common_setup.tcl
      echo "source -echo /proj/Pezy-1/TEMPLATES/PT/PT_common.tcl_0.03"    >> ./common_setup.tcl
      #echo "source -echo ../../PT_common.tcl"                                 >> ./common_setup.tcl

      pt_shell -f common_setup.tcl | tee ./LOG/pt.log
      cd ../../
    endif
  end
end
