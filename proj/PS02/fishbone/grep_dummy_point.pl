#! /user/bin/perl -w

if (@ARGV !=1 ) {
	die "Usage: perl hand_clock_structure.pl <hand_clk.rpt>";
}

## get max level
open (INPUT,"<$ARGV[0]") || die ("Cant't open the input file\n");
$max_lvl = 0;
$min_lvl = 999;
while (<INPUT>) {
if ($_ =~m/^\s+L(\d+)\s(\S+ECK)\s\(ENB\).+SEQ=(\d+)/) {
	if ($1 > $max_lvl) {
		$max_lvl = $1;
} 
	if ($1 < $min_lvl) {
		$min_lvl = $1;
}
	#$current_lvl = $1;
	#$icg_name = $2;
	#$seq_count = $3;
	#printf "$current_lvl $icg_name $seq_count \n";
}
}
printf "source /filer/home/tiwent/PS02/FB/insert_dummy_gating_for_FF.tcl \n";
printf "\n";
printf "## max level of icg: $max_lvl \n"; 
printf "## min level of icg: $min_lvl \n"; 
close INPUT;

## get icgs for insert dummy gating between max_lvl-1 to min_lvl
printf "\n";
printf "## insert dummy gating between max_lvl-1 to min_lvl \n";
$max_lvl_tmp = $max_lvl;
$min_lvl_tmp = $min_lvl;
$max_lvl_tmp = $max_lvl_tmp - 1;
while ($max_lvl_tmp >= $min_lvl_tmp) {
open (INPUT,"<$ARGV[0]") || die ("Cant't open the input file\n");
while (<INPUT>) {
if ($_ =~m/^\s+(L$max_lvl_tmp)\s(\S+ECK)\s\(ENB\).+ENB=(\d+).+SEQ=(\d+)/) {
#	$level = $1;
	$icg_name = $2;
#	$seq_count = $3;
#	if ($seq_count > 50) {
		printf "## $_ ";
		#printf "## LEVEL: $level DUMMY_CEL: $icg_name SEQ: $seq_count \n";
		printf "insert_dummy_gating_for_FF $icg_name \n \n";
#}
}
}
close INPUT;
$max_lvl_tmp = $max_lvl_tmp - 1;
}

## insert dummy for ISO_BUF
#printf "\n";
#printf "## insert dummy gating for ISO_BUF \n";
#open (INPUT,"<$ARGV[0]") || die ("Cant't open the input file\n");
#while (<INPUT>) {
#if ($_ =~m/^\s+(L\d+)\s(.+ISO.+)\s\(BUF\).+SEQ=(\d+)/) {
#		$level = $1;
#		$iso_name = $2;
#		$seq_count = $3;
#		printf "## LEVEL: $level DUMMY_PIN: $iso_name SEQ: $seq_count \n";
#		printf "insert_dummy_gating $iso_name \n";
#} 
#}
#close INPUT;

