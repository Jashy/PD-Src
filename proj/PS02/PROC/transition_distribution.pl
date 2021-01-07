#!/usr/bin/perl
#usage: perl transition_distribution.pl timing_report_summary
while( <> ) {
 if (/^\s+(-\d+\.\d+)\s+\d+\.\d+\s+.*/) {
	$i += 1;
   $slack = $1;
   if (      ( $slack <=  0.000 ) && ( $slack > -0.005 ) ) { $count_by_slack_range{"0.000-0.005"}++ }
      elsif( ( $slack <= -0.005 ) && ( $slack > -0.010 ) ) { $count_by_slack_range{"0.005-0.010"}++ }
      elsif( ( $slack <= -0.010 ) && ( $slack > -0.015 ) ) { $count_by_slack_range{"0.010-0.015"}++ }
      elsif( ( $slack <= -0.015 ) && ( $slack > -0.020 ) ) { $count_by_slack_range{"0.015-0.020"}++ }
      elsif( ( $slack <= -0.020 ) && ( $slack > -0.025 ) ) { $count_by_slack_range{"0.020-0.025"}++ }
      elsif( ( $slack <= -0.025 ) && ( $slack > -0.030 ) ) { $count_by_slack_range{"0.025-0.030"}++ }
      elsif( ( $slack <= -0.030 ) && ( $slack > -0.035 ) ) { $count_by_slack_range{"0.030-0.035"}++ }
      elsif( ( $slack <= -0.035 ) && ( $slack > -0.040 ) ) { $count_by_slack_range{"0.035-0.040"}++ }
      elsif( ( $slack <= -0.040 ) && ( $slack > -0.045 ) ) { $count_by_slack_range{"0.040-0.045"}++ }
      elsif( ( $slack <= -0.045 ) && ( $slack > -0.050 ) ) { $count_by_slack_range{"0.045-0.050"}++ }
      elsif( ( $slack <= -0.050 ) && ( $slack > -0.055 ) ) { $count_by_slack_range{"0.050-0.055"}++ }
      elsif( ( $slack <= -0.055 ) && ( $slack > -0.060 ) ) { $count_by_slack_range{"0.055-0.060"}++ }
      else                                                 { $count_by_slack_range{"0.060-"}++ }
}
}
printf( "  Slack range       Count\n" ) ;
printf( "  ----------------  -----\n" ) ;
printf( "  %6.3f < %6.3f   %5d\n",  0.000, -0.005, $count_by_slack_range{"0.000-0.005"});
printf( "  %6.3f < %6.3f   %5d\n", -0.005, -0.010, $count_by_slack_range{"0.005-0.010"});
printf( "  %6.3f < %6.3f   %5d\n", -0.010, -0.015, $count_by_slack_range{"0.010-0.015"});
printf( "  %6.3f < %6.3f   %5d\n", -0.015, -0.020, $count_by_slack_range{"0.015-0.020"});
printf( "  %6.3f < %6.3f   %5d\n", -0.020, -0.025, $count_by_slack_range{"0.020-0.025"});
printf( "  %6.3f < %6.3f   %5d\n", -0.025, -0.030, $count_by_slack_range{"0.025-0.030"});
printf( "  %6.3f < %6.3f   %5d\n", -0.030, -0.035, $count_by_slack_range{"0.030-0.035"});
printf( "  %6.3f < %6.3f   %5d\n", -0.035, -0.040, $count_by_slack_range{"0.035-0.040"});
printf( "  %6.3f < %6.3f   %5d\n", -0.040, -0.045, $count_by_slack_range{"0.040-0.045"});
printf( "  %6.3f < %6.3f   %5d\n", -0.045, -0.050, $count_by_slack_range{"0.045-0.050"});
printf( "  %6.3f < %6.3f   %5d\n", -0.050, -0.055, $count_by_slack_range{"0.050-0.055"});
printf( "  %6.3f < %6.3f   %5d\n", -0.055, -0.060, $count_by_slack_range{"0.055-0.060"});
printf( "  %6.3f <    %5d\n", -0.060,              $count_by_slack_range{"0.060-"});

print "$i\n";



