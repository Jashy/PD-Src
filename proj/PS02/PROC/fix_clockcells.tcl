
  set SDC_LIST {
    BISTR	/proj/Hydra5/RELEASE/20090415_VNET/GAIA_bistr_signoff.sdc
    SCAN1	/proj/Hydra5/RELEASE/20090415_VNET/GAIAIO_20090421_dcscan_capture_signoff.sdc
    SCAN2	/proj/Hydra5/RELEASE/20090415_VNET/GAIAIO_20090421_acscan_capture_signoff.sdc
    SCAN3	/proj/Hydra5/RELEASE/20090415_VNET/GAIAIO_20090421_dcscan_shift_signoff.sdc
    SCAN4	/proj/Hydra5/RELEASE/20090415_VNET/GAIAIO_20090421_acscan_shift_signoff.sdc
    I2CSL	/proj/Hydra5/RELEASE/20090415_VNET/GAIAIO_i2cslave.sdc
  }

#    FUNC	{ /proj/Hydra5/RELEASE/20090415_VNET/GAIAIO_pt_normal-mode_wc_cworst_setup_20090420_layout_mod.sdc
#		  /proj/Hydra5/RELEASE/20090415_VNET/GAIA_mbist1_signoff.sdc
#		  /proj/Hydra5/RELEASE/20090415_VNET/GAIA_mbist2_signoff.sdc }



  source /proj/Hydra5/TEMPLATES/ICC/fix_clock_cell_type.tcl
  source /proj/Hydra5/TEMPLATES/SIGNOFF_CHECK/report_clock_cell_type/report_clock_cell_type.tcl


  fix_clock_cell_type
  report_clock_cell_type	> ${SESSION}.run/report_clock_cell_type_NORMAL.log


  foreach {name sdc} $SDC_LIST {
    remove_sdc -keep_parasitics

    SOURCE $sdc

    source $KEEP_LIST
    source $DONT_TOUCH_LIST
    SOURCE $DFT_DONT_TOUCH_LIST
    SOURCE $DONT_USE_LIST

    fix_clock_cell_type
    report_clock_cell_type	> ${SESSION}.run/report_clock_cell_type_${name}.log
  }


  legalize_placement -eco -incremental


  remove_sdc

  read_sdc   ${FUNC_SDC}
  read_sdc   ${BIST1_SDC}
  read_sdc   ${BIST2_SDC}
  read_sdc   ${FALSCLK_SDC}
  read_sdc   ${FALSPATH_SDC}
  read_sdc   ${UNCERTAINTY}

