#!  /usr/bin/perl -w

use strict;
use File::Basename;
use File::Find;
use File::Copy;
use Term::ANSIColor qw(:constants);
$Term::ANSIColor::AUTORESET = 1;

my $in = shift;
my %block;
my $ff_num = 17;

my %pins;

my ($clock, $source);
my $min_level = 999;

print "Step1: Reduce internal ...\n";

open (IN, $in) or die;
open (OUT, "> $in.reduce1.rpt") or die;
while (<IN>) {
        chomp;
        my $line = $_;
        if ($line =~ /^#\s+(\S+)\s+\(\S+\)/) {
                $clock = $1;
                print OUT "$line\n";
        } elsif ($line =~ /^#\s+Source:\s+(\S+)\s+\(\S+\)/) {
                $source = $1;
                $clock = "$clock:$source"; 
                print OUT "$line\n";
        } elsif ($line =~ /\s*L(\S+)\s+(\S+)\s+\((\S+)\)\s+(.*)/) {
                my $pin = $2;
                my $level = $1;
                if (exists $pins{$clock}{$pin} ) {
                        if ($level <= $min_level) {
				$min_level = $level;
                                print OUT "$line ; # Exist internal \n";
                        } else {
                                next;
                        }
                } else {
                        $pins{$clock}{$pin} = $level;
			$min_level = 999;
			 print OUT "$line\n";
                }
        } else {
                print OUT "$line\n";
        }
}

close IN;
close OUT;


print "Step2: Reduce in each clock\n";
my %pin_all;
my $is_warn_Exceeded = 1;
$min_level = 999;
open (IN, "$in.reduce1.rpt" ) or die;
open (OUT, "> $in.reduce2.rpt") or die;
while (<IN>) {
        chomp;
        my $line = $_;
        if ($line =~ /^#\s+(\S+)\s+\(\S+\)/) {
                $clock = $1;
                print OUT "$line\n";
        } elsif ($line =~ /^#\s+Source:\s+(\S+)\s+\(\S+\)/) {
                $source = $1;
                $clock = "$clock:$source";
                print OUT "$line\n";
        } elsif ($line =~ /\s*L(\S+)\s+(\S+)\s+\((\S+)\)\s+(.*)/) {
                my $pin = $2;
                my $level = $1;
                if (exists $pin_all{$pin} ) {
                        if ($level <= $min_level) {
                                $min_level = $level;
				my $ck = "";
                                foreach my $c (keys %{$pin_all{$pin}}) {
					next if ($c eq $clock);
                                        $ck .= "$c ";
                                }
				if ($ck eq "") {
					print OUT "$line\n";
				} else {
                                	print OUT "$line ; # Exist in '$ck'\n";
				}
                        } else {
                                next;
                        }
                } else {
                        $pin_all{$pin}{$clock} = $level;
                        $min_level = 999;
			 print OUT "$line\n";
                }
        } elsif ($line =~ /Warning: Exceeded level count limit\(\S+\)\. Stop to trace\./) {
                print STDERR "INFO: Exists: `$line`\n" if ($is_warn_Exceeded);
                $is_warn_Exceeded = 0;
        } else {
                print OUT "$line\n";
        }
}

close IN;
close OUT;


print "Step3: Reduce for ENB--FF structure ...\n";
my %block_num;
#$block_num{"arm926"} = 0;
#$block_num{"image_proc"} = 0;
$block_num{"TOP"} = 0;

my $level_pre = -1;
my $is_new_section;
my $is_print_ENB;
open (IN, "$in.reduce2.rpt" ) or die;
open (OUT, "> $in.reduce.final.rpt") or die;
while (<IN>) {
        chomp;
        my $line = $_;
	if ($line =~ /^(\s*)L(\S+)\s+(\S+)\s+\((\S+)\)\s+(.*)/) {
		my ($space, $level, $pin, $ref, $others) = ($1, $2, $3, $4, $5);

		if ($level != $level_pre) {
			$is_new_section = 1;
		} else {
		        $is_new_section = 0;
		}
		$others =~ s/\s*;\s*#.*//g;
        	if ($ref =~ /ENB/ and $others =~ /^SEQ=(\d+)\s*/ ) {
			my $num_ff = $1;
			if ($is_new_section) {
				my $sp = $block_num{space};
                        	my $le = $block_num{level};
                        	delete $block_num{space};
                        	delete $block_num{level};
                        	foreach my $b (keys %block_num) {
                                	if ($block_num{$b} != 0) {
                                        	print OUT "$sp# L$le $b: ENB=$block_num{$b} ; # reduced ENB-FF structure\n";
                                	}
                        	}
                        	foreach my $b (keys %block_num) {
                                	$block_num{$b} = 0;
                        	}
			}
			if ($num_ff <= $ff_num) {
				$is_print_ENB = 0;
				$block_num{space} = $space;
				$block_num{level} = $level;
				my $is_top = 0;
				foreach my $b (keys %block_num) {
					next if ($b eq "level" or $b eq "space");
					if ($pin =~ /^\$$b/) {
						$block_num{$b} ++;
						$is_top = 0;
						last;
					} else {
						$is_top = 1;
					}
				}
				$block_num{"TOP"} ++ if ($is_top);
			} else {
				$is_print_ENB = 1;
			}
		} else {
			$is_print_ENB = 1;

		}
		#if ($is_print_ENB) {
		#	my $sp = $block_num{space};
		#	my $le = $block_num{level};
		#	delete $block_num{space};
		#	delete $block_num{level};
		#	foreach my $b (keys %block_num) {
		#		if ($block_num{$b} != 0) {
		#			print OUT "$sp# L$le $b: ENB=$block_num{$b} ; # reduced ENB-FF structure\n";
		#		}
		#	}
		#	foreach my $b (keys %block_num) {
		#		$block_num{$b} = 0;
		#	}
		#	print OUT "$line\n";
		#}
		$level_pre = $level;
        } else {
                $is_print_ENB = 1;
		next if ($line =~ /No sources\./);
	}

                if ($is_print_ENB) {
                        my $sp = $block_num{space};
                        my $le = $block_num{level};
                        delete $block_num{space};
                        delete $block_num{level};
                        foreach my $b (keys %block_num) {
                                if ($block_num{$b} != 0) {
                                        print OUT "$sp# L$le $b: ENB=$block_num{$b} ; # reduced ENB-FF structure\n";
                                }
                        }
                        foreach my $b (keys %block_num) {
                                $block_num{$b} = 0;
                        }
                        $is_print_ENB = 0;
                        print OUT "$line\n";
                }
}

close IN;
close OUT;
