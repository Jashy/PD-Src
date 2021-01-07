#!/usr/bin/perl
# version     : 2015.11.25_v02
# author      : tiwen

$place_timing_rpt =  "./report/060_icc_place_opt/report_timing_normal-wcl_cworst_m25c_max-cts_leakage_dynamic.rep.summary ./report/060_icc_place_opt/report_timing_mbist-wcl_cworst_m25c_max-cts.rep.summary";
$route_timing_rpt =  "./report/100_icc_route_opt/report_timing_normal-wcl_cworst_m25c_max-cts_leakage_dynamic.rep.summary ./report/100_icc_route_opt/report_timing_mbist-wcl_cworst_m25c_max-cts.rep.summary";
@pt_internal_rpt =  glob "./report/176_pt_sta_ss28lpp/*/wcl_cworst_m25c_max/report_timing_max.rep.summary";
@pt_boundary_rpt =  glob "./report/176_pt_sta_ss28lpp/*/wcl_cworst_m25c_max/report_timing_max_boundary.rep.summary";
@place_timing_rpt =  split (/[\s\n]+/, $place_timing_rpt) ;
@route_timing_rpt =  split (/[\s\n]+/, $route_timing_rpt) ;
$route_uti_rpt =  "./report/100_icc_route_opt/placement_utilization.rpt";
$route_short_rpt = "./LOG/100_icc_route_opt/log";
printf "\n";
printf "\n";
printf "\n";
printf "place_opt timing from: @place_timing_rpt[0] \n"; 
printf "place_opt timing from: @place_timing_rpt[1] \n"; 
printf "route_opt timing from: @route_timing_rpt[0] \n"; 
printf "route_opt timing from: @route_timing_rpt[1] \n"; 
printf "pt timing report from: @pt_internal_rpt[0] \n"; 
printf "pt timing report from: @pt_internal_rpt[1] \n"; 
printf "pt timing report from: @pt_internal_rpt[2] \n"; 
printf "pt timing report from: @pt_internal_rpt[3] \n"; 
printf "route_opt utiliz from: $route_uti_rpt \n"; 
printf "route_opt shorts from: $route_short_rpt \n"; 
printf "\n";
printf "\n";
printf "\n";
printf( "                          060_icc_place_opt        100_icc_route_opt       176_pt_sta_ss28lpp     Routing         Utilization \n");
printf "--------------------------------------------------------------------------------------------------------------------------------- \n";
########## For ICC place_opt
foreach $file ( @place_timing_rpt ) {
	if ( $file =~m#.report/\d+_(\S+)/report_timing_(\S+)-wcl_cworst_m25c_max.+#) {
		$step = $1;
		$mode = $2;
		$stage = "${step}_${mode}";
#		print "$sum \n";
	}
	open( FILE, "< $file" ) ;
	$flag = 0;
	$internal_violation_count = 0 ;
	$boundary_violation_count = 0 ;
	$internal_worst_slack = "N" ;
	$boundary_worst_slack = "N" ;

while( <FILE> ) {
	$line = $_;
    if ($line =~ /^\s*startpoint block/) {
    	$flag = 1;
    	next;
    }
    if ($flag == 1) {
    	if ($line =~ /^\s*--------------------/) {
    		$flag = 2;
    		next;
    	}
    } elsif ($flag == 2) {
    	if ($line =~ /^\s*--------------------/) {
    		last;
    	} elsif ($line =~ /^\s*(\S+)\s+(\S+)\s+(\S+)\s+(\S+)/) {
    		$from = $1;
    		$to = $2;
    		$num = $3;
    		$slack = $4;
		if (($from eq "in") || ($to eq "out")) {
			$boundary_violation_count = $boundary_violation_count + $num;
			if ($boundary_worst_slack eq "N") {
    				$boundary_worst_slack = $slack;
    			} elsif ($boundary_worst_slack > $slack) {
    				$boundary_worst_slack = $slack;
    			}
		}
    		#next if ($from eq "in");
    		#next if ($to eq "out");
    		else {
			$internal_violation_count = $internal_violation_count + $num;
    			if ($internal_worst_slack eq "N") {
    				$internal_worst_slack = $slack;
    			} elsif ($internal_worst_slack > $slack) {
    				$internal_worst_slack = $slack;
    		}
    	}
    }
}
}
close( FILE ) ;
if ($mode eq "normal") {
	$icc_place_opt_normal_internal = "$internal_violation_count/$internal_worst_slack";
	$icc_place_opt_normal_boundary = "$boundary_violation_count/$boundary_worst_slack";
} elsif ($mode eq "mbist") {
	$icc_place_opt_mbist_internal = "$internal_violation_count/$internal_worst_slack";
	$icc_place_opt_mbist_boundary = "$boundary_violation_count/$boundary_worst_slack";
} 

}
#printf "060_n_i : $icc_place_opt_normal_internal \n";
#printf "060_n_b : $icc_place_opt_normal_boundary \n";
#printf "060_m_i : $icc_place_opt_mbist_internal \n";
#printf "060_m_b : $icc_place_opt_mbist_boundary \n"; 

########## For ICC route_opt
foreach $file ( @route_timing_rpt ) {
	if ( $file =~m#.report/(\d+_\S+)/report_timing_(\S+)-wcl_cworst_m25c_max.+#) {
		$step = $1;
		$mode = $2;
#		print "${step}_${mode} \n";
	}
	open( FILE, "< $file" ) ;
	$flag = 0;
	$internal_violation_count = 0 ;
	$boundary_violation_count = 0 ;
	$internal_worst_slack = "N" ;
	$boundary_worst_slack = "N" ;

while( <FILE> ) {
	$line = $_;
    if ($line =~ /^\s*startpoint block/) {
    	$flag = 1;
    	next;
    }
    if ($flag == 1) {
    	if ($line =~ /^\s*--------------------/) {
    		$flag = 2;
    		next;
    	}
    } elsif ($flag == 2) {
    	if ($line =~ /^\s*--------------------/) {
    		last;
    	} elsif ($line =~ /^\s*(\S+)\s+(\S+)\s+(\S+)\s+(\S+)/) {
    		$from = $1;
    		$to = $2;
    		$num = $3;
    		$slack = $4;
		if (($from eq "in") || ($to eq "out")) {
			$boundary_violation_count = $boundary_violation_count + $num;
			if ($boundary_worst_slack eq "N") {
    				$boundary_worst_slack = $slack;
    			} elsif ($boundary_worst_slack > $slack) {
    				$boundary_worst_slack = $slack;
    			}
		}
    		#next if ($from eq "in");
    		#next if ($to eq "out");
    		else {
			$internal_violation_count = $internal_violation_count + $num;
    			if ($internal_worst_slack eq "N") {
    				$internal_worst_slack = $slack;
    			} elsif ($internal_worst_slack > $slack) {
    				$internal_worst_slack = $slack;
    		}
    	}
    }
}
}
close( FILE ) ;
if ($mode eq "normal") {
	$icc_route_opt_normal_internal = "$internal_violation_count/$internal_worst_slack";
	$icc_route_opt_normal_boundary = "$boundary_violation_count/$boundary_worst_slack";
} elsif ($mode eq "mbist") {
	$icc_route_opt_mbist_internal = "$internal_violation_count/$internal_worst_slack";
	$icc_route_opt_mbist_boundary = "$boundary_violation_count/$boundary_worst_slack";
} 
}
#printf "100_n_i : $icc_route_opt_normal_internal \n";
#printf "100_n_b : $icc_route_opt_normal_boundary \n";
#printf "100_m_i : $icc_route_opt_mbist_internal \n";
#printf "100_m_b : $icc_route_opt_mbist_boundary \n"; 

########## For PT
$step = "pt_sta";
$pt_internal_violation_count = 0 ;
$pt_boundary_violation_count = 0 ;
$pt_internal_worst_slack = "N" ;
$pt_boundary_worst_slack = "N" ;

foreach $file ( @pt_internal_rpt ) {
	if ( $file =~m#.report/176_pt_sta_ss28lpp/(\S+)/wcl_cworst_m25c_max/report_timing_max.rep.summary#) {
		$mode = $1;
#		printf "$mode \n";
		open( FILE, "< $file" ) ;
		$flag = 0;
	while( <FILE> ) {
		$line = $_;
   	 if ($line =~ /^\s*startpoint block/) {
   	 	$flag = 1;
   	 	next;
  	  }
  	 if ($flag == 1) {
    		if ($line =~ /^\s*--------------------/) {
    			$flag = 2;
    			next;
    		}
   	 } elsif ($flag == 2) {
    		if ($line =~ /^\s*--------------------/) {
    			last;
    		} elsif ($line =~ /^\s*(\S+)\s+(\S+)\s+(\S+)\s+(\S+)/) {
    			$from = $1;
    			$to = $2;
    			$num = $3;
    			$slack = $4;
			if (($from eq "in") || ($to eq "out")) {
				$pt_boundary_violation_count = $pt_boundary_violation_count + $num;
				if ($pt_boundary_worst_slack eq "N") {
    					$pt_boundary_worst_slack = $slack;
    				} elsif ($pt_boundary_worst_slack > $slack) {
    					$pt_boundary_worst_slack = $slack;
    				}
			}
    			else {
				$pt_internal_violation_count = $pt_internal_violation_count + $num;
    				if ($pt_internal_worst_slack eq "N") {
    					$pt_internal_worst_slack = $slack;
    				} elsif ($pt_internal_worst_slack > $slack) {
    					$pt_internal_worst_slack = $slack;
    				}
    			}	
    }
}
}
close( FILE ) ;

#printf "$mode \n";
if ($mode eq "mbist-mode") {
	$pt_mbist_internal = "$pt_internal_violation_count/$pt_internal_worst_slack";
} elsif ($mode eq "normal-mode") {
	$pt_normal_internal = "$pt_internal_violation_count/$pt_internal_worst_slack";
} elsif ($mode eq "scan_capture-mode") {
	$pt_scan_capture_internal = "$pt_internal_violation_count/$pt_internal_worst_slack";
} elsif ($mode eq "scan_shift-mode") {
	$pt_scan_shift_internal = "$pt_internal_violation_count/$pt_internal_worst_slack";
}
}
}
#printf "pt_n_i : $pt_normal_internal \n";
#printf "pt_m_i : $pt_mbist_internal \n";
#printf "pt_c_i : $pt_scan_capture_internal \n";
#printf "pt_s_i : $pt_scan_shift_internal \n";

foreach $file ( @pt_boundary_rpt ) {
	if ( $file =~m#.report/176_pt_sta_ss28lpp/(\S+)/wcl_cworst_m25c_max/report_timing_max_boundary.rep.summary#) {
		$mode = $1;
		$pt_boundary_violation_count = 0 ;
		$pt_boundary_worst_slack = "N" ;
		open( FILE, "< $file" ) ;
		$flag = 0;
	while( <FILE> ) {
		$line = $_;
   	 if ($line =~ /^\s*startpoint block/) {
   	 	$flag = 1;
   	 	next;
  	  }
  	 if ($flag == 1) {
    		if ($line =~ /^\s*--------------------/) {
    			$flag = 2;
    			next;
    		}
   	 } elsif ($flag == 2) {
    		if ($line =~ /^\s*--------------------/) {
    			last;
    		} elsif ($line =~ /^\s*(\S+)\s+(\S+)\s+(\S+)\s+(\S+)/) {
    			$from = $1;
    			$to = $2;
    			$num = $3;
    			$slack = $4;
			if (($from eq "in") || ($to eq "out")) {
				$pt_boundary_violation_count = $pt_boundary_violation_count + $num;
				if ($pt_boundary_worst_slack eq "N") {
    					$pt_boundary_worst_slack = $slack;
    				} elsif ($pt_boundary_worst_slack > $slack) {
    					$pt_boundary_worst_slack = $slack;
    				}
			}
			}
}
}
close( FILE ) ;
if ($mode eq "mbist-mode") {
	$pt_mbist_boundary = "$pt_boundary_violation_count/$pt_boundary_worst_slack";
} elsif ($mode eq "normal-mode") {
	$pt_normal_boundary = "$pt_boundary_violation_count/$pt_boundary_worst_slack";
} elsif ($mode eq "scan_capture-mode") {
	$pt_scan_capture_boundary = "$pt_boundary_violation_count/$pt_boundary_worst_slack";
} elsif ($mode eq "scan_shift-mode") {
	$pt_scan_shift_boundary = "$pt_boundary_violation_count/$pt_boundary_worst_slack";
}
}
}
#printf "pt_n_b : $pt_normal_boundary \n";
#printf "pt_m_b : $pt_mbist_boundary \n";
#printf "pt_c_b : $pt_scan_capture_boundary \n";
#printf "pt_s_b : $pt_scan_shift_boundary \n";

######### ICC route_opt short count
open( INPUT,"< $route_short_rpt") ;
	while( <INPUT> ) {
		if (/^\s+Short\s\S\s(\d+)/) {
			$short = $1;
}
}
close( INPUT ) ;
#printf "100_short : $short \n";

######### ICC route_opt utilization
open( INPUT,"< $route_uti_rpt") ;
	while( <INPUT> ) {
		if (/^\S+\s+\S+\s+\S+\s+(\d+.\d+%)/) {
			$utilization = $1;
}
}
close( INPUT ) ;
#printf "100_uti : $utilization \n";

printf( " %-25s    %-20s    %-20s    %-15s    %-5s %-11s  %-15s \n", normal_internal, $icc_place_opt_normal_internal, $icc_route_opt_normal_internal, $pt_normal_internal, short, $short, $utilization  );
printf( " %-25s    %-20s    %-20s    %-15s     \n", normal_boundary, $icc_place_opt_normal_boundary, $icc_route_opt_normal_boundary, $pt_normal_boundary );
printf( " %-25s    %-20s    %-20s    %-15s     \n", mbist_internal, $icc_place_opt_mbist_internal, $icc_route_opt_mbist_internal, $pt_mbist_internal );
printf( " %-25s    %-20s    %-20s    %-15s     \n", mbist_boundary, $icc_place_opt_mbist_boundary, $icc_route_opt_mbist_boundary, $pt_mbist_boundary );
printf( " %-25s    %-20s    %-20s    %-15s     \n", scan_capture_internal, $icc_place_opt_scan_capture_internal, $icc_route_opt_scan_capture_internal, $pt_scan_capture_internal );
printf( " %-25s    %-20s    %-20s    %-15s     \n", scan_capture_boundary, $icc_place_opt_scan_capture_boundary, $icc_route_opt_scan_capture_boundary, $pt_scan_capture_boundary );
printf( " %-25s    %-20s    %-20s    %-15s     \n", scan_shift_internal, $icc_place_opt_scan_shift_internal, $icc_route_opt_scan_shift_internal, $pt_scan_shift_internal );
printf( " %-25s    %-20s    %-20s    %-15s     \n", scan_shift_boundary, $icc_place_opt_scan_shift_boundary, $icc_route_opt_scan_shift_boundary, $pt_scan_shift_boundary );
printf "--------------------------------------------------------------------------------------------------------------------------------- \n";
printf "\n";
printf "\n";
printf "\n";
