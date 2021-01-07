#! /usr/bin/perl -w
my %is_module;
my $start = 0;
my $is_input = 0;
my $is_end_pin = 0;
my $file_out = "./hold_path";
my $report_file = "/proj/ARM926EJS/WORK_ATILE/simonw/pt/0217_vt_0.3/normal-mode/wcz_cworst_0C_max/REPORT/report_timing.rep";
my $module = "/filer/home/simon/module.list";
open REPORT_FILE, "$report_file" or die "$report_file: $!\n";
open MODULE, "$module" or die "$module: $!\n";
open OUT, ">$file_out" or die "$file_out: $!\n";
while (<MODULE>) {
	chomp;
	$is_module{$_} = 1;
}
while (<REPORT_FILE>) {
	chomp;
	if (/Startpoint: ([^ ]+)/) {
		print OUT  "## Startpoint: $1\n";
	}
	if (/Endpoint: ([^ ]+)/) {
		$start = 1;
		$endpoint = $1;
		print OUT  "## Endpoint: $1\n";
		print OUT  "################################################################################\n";
	}
	if (/data arrival time/) {
		$start = 0;
	}
	if (/slack \(VIOLATED.*\) +(-*.*)/) {
		print OUT  "## Slack: $1\n";
		print OUT  "################################################################################\n";
	}
	if ($start) {
		if (/ +([^ ]+\/[^ ]+) \(([^ ]+)\)/) {
			if ($2 eq "net") {
				next;
			} elsif ($is_module{$2}) {
				print " $1\n";
				next;
				
			} elsif ( $_ =~ m#($endpoint/[^ /]+) \(# ) {
				$input_pin = $1;
				print OUT  "$input_pin\n";
			} else {
				$is_input = !$is_input;
				$input_pin = $1;
			}
			if ( $is_input ) {
				print OUT  "$input_pin\n";
			}
		}
	}

}
