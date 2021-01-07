compile_clock_tree -clock_trees { \
            mbist-wcl_cworst_m25c_max-cts@BISTCLK_BIST_396Mhz \
            mbist-wcl_cworst_m25c_max-cts@BISTCLK_BIRA_216Mhz \
            mbist-wcl_cworst_m25c_max-cts@BISTCLK_BIRA_396Mhz}
optimize_clock_tree -clock_trees { \
	mbist-wcl_cworst_m25c_max-cts@BISTCLK_BIST_396Mhz \
	mbist-wcl_cworst_m25c_max-cts@BISTCLK_BIRA_216Mhz \
	mbist-wcl_cworst_m25c_max-cts@BISTCLK_BIRA_396Mhz}
