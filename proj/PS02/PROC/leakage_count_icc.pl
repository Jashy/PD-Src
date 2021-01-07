#!  /usr/local/bin/perl -w

use strict;
use File::Basename;
use File::Find;
use File::Copy;
use Term::ANSIColor qw(:constants);
$Term::ANSIColor::AUTORESET = 1;


my $input = shift;
#my $lib1 = "/proj/M4F/LIB/20080201/SC/TSMCHOME/digital/Front_End/timing_power_noise/NLDM/tcbn65lp_121c/tcbn65lp_c070507ml.lib";
#my $lib2 = "/proj/M4F/LIB/20080201/SC/TSMCHOME/digital/Front_End/timing_power_noise/NLDM/tcbn65lphvt_121c/tcbn65lphvt_c070507ml.lib";
#my $lib1 = "/proj/WyvernES2/iTitan/LIB/CURRENT/SC/TSMCHOME/digital/Front_End/timing_power_noise/NLDM/tcbn65lp_121c/tcbn65lp_c070507ml.lib";
#my $lib2 = "/proj/WyvernES2/iTitan/LIB/CURRENT/SC/TSMCHOME/digital/Front_End/timing_power_noise/NLDM/tcbn65lphvt_121c/tcbn65lphvt_c070507ml.lib";
my $lib1 = "/proj/Sapphire4/LIB/CURRENT/SC/HVT/synopsys/scc090ng_hs_hvt_v0p9_ss125.lib";
my $lib2 = "/proj/Sapphire4/LIB/CURRENT/SC/RVT/synopsys/scc090ng_hs_rvt_v0p9_ss125.lib";
my %total;
my %cell_info;

open (IN, "$input") or die;

my $begin = 0;
while (<IN>) {
	chomp;
	s/^\s*//;
	next if (/^#/ or /^\s*$/ or /^=.*$/);
	if (/Master Instantiation:/) {
		$begin = 1;
	} 
	if (/Misc. Utilization:/) {
		$begin = 0;
	}

	if ($begin) {
		next if (/MasterName\s+Type\s+InstCount/);
		my @line = split /\s+/, $_;
		$total{$line[0]}{count}	= $line[2] if ($line[1] eq "STD");
	}
}
close IN;

&get_lib_info ($lib1, \%cell_info);
&get_lib_info ($lib2, \%cell_info);

foreach my $cell (keys %total) {
	if (!exists $cell_info{$cell}) {
		print "Can not find cell: \"$cell\" in lib!\n";
		delete $total{$cell};
		next;
	}
        my $cell_count = $total{$cell}{count};
	$total{$cell}{area} = $cell_info{$cell}{area} * $cell_count;
	$total{$cell}{leakage} = $cell_info{$cell}{leakage} * $cell_count;
}

my $hvt_area_total = 0;
my $hvt_leakage_total = 0;
my $hvt_total = 0;
my $nvt_area_total = 0;
my $nvt_leakage_total = 0;
my $nvt_total = 0;


foreach my $cell (keys %total) {
	if ($cell =~ /HVT_.*V\d+$/ or $cell =~ /HVTD\d+P5$/) {
		$hvt_area_total += $total{$cell}{area};
		$hvt_leakage_total += $total{$cell}{leakage};
		$hvt_total += $total{$cell}{count};
	} else {
		$nvt_area_total += $total{$cell}{area};
		$nvt_leakage_total += $total{$cell}{leakage};
		$nvt_total += $total{$cell}{count};
	}
}

my $total;
my $p;

$total = $hvt_total + $nvt_total;
$p = $hvt_total/$total;
print "HVT CELL: $hvt_total ($p)\n";
$p = $nvt_total/$total;
print  "NVT CELL: $nvt_total ($p)\n";
print  "TOTAL CELL: $total\n\n";

$total = $hvt_area_total + $nvt_area_total;
$p = $hvt_area_total/$total;
print  "HVT AREA: $hvt_area_total ($p)\n";
$p = $nvt_area_total/$total;
print  "NVT AREA: $nvt_area_total ($p)\n";
print  "TOTAL AREA: $total\n\n";

$total = $hvt_leakage_total + $nvt_leakage_total;
$p = $hvt_leakage_total/$total;
print  "HVT LEAKAGE: $hvt_leakage_total ($p)\n";
$p = $nvt_leakage_total/$total;
print  "NVT LEAKAGE: $nvt_leakage_total ($p)\n";
print  "TOTAL LEAKAGE: $total\n\n";




#################
sub get_lib_info {
	my ($lib, $cell_info) = @_;

	open (LIB, "$lib") or die;

	my ($cell);

	while (<LIB>) {
		chomp;
		next if (/^\s*$/);
		
		if (/^\s*cell\s*\((\S+)\)/) {
			$cell = $1;
		} elsif (/^\s*cell_leakage_power\s*:\s*(\S+)\s*;/) {
			$$cell_info{$cell}{leakage} = $1;
		} elsif (/^\s*area\s*:\s*(\S+)\s*;/) {
			$$cell_info{$cell}{area} = $1;
		}
	}

	foreach my $cell (keys %$cell_info) {
		if (!exists $$cell_info{$cell}{area}) {
			print "No cell area for \"$cell\" in lib \"$lib\"\n";
			delete $$cell_info{$cell};
		}
		if (!exists $$cell_info{$cell}{leakage}) {
                        print "No cell leakage for \"$cell\" in lib \"$lib\"\n";
			delete $$cell_info{$cell};
                }
	} 
}

