#! /usr/bin/perl -w

use strict;
use lib '/proj/PS02/RELEASE/UTILITY/perl_lib';
use Verilog;

my $in  = shift @ARGV;
my $out = shift @ARGV;
my $key;

my $always09 = 0 ;

$always09 = 1
	if $in =~ m,\bADU,
	|| $in =~ m,\bFRU_PD,
	|| $in =~ m,\bGAIA,
	|| $in =~ m,\bGEVG,
	|| $in =~ m,\bJPU,
	|| $in =~ m,\bLCU,
	|| $in =~ m,\bVOU_CORE,
	|| $in =~ m,\bVOU_CORE,
	|| $in =~ m,\bYCU_AM,
	|| $in =~ m,\bS_MainNoC_Arc_St_m_PD_B12,
	|| $in =~ m,\bS_MainNoC_Arc_St_m_PD_C17,
	|| $in =~ m,\bS_MainNoC_Arc_St_m_PD_C18,
	|| $in =~ m,\bS_MainNoC_Arc_St_m_PD_C19,
	|| $in =~ m,\bS_MainNoC_Arc_St_m_PD_D14,
	|| $in =~ m,\bS_MainNoC_Arc_St_m_PD_D15,
	|| $in =~ m,\bS_MainNoC_Arc_St_m_PD_D16,
	|| $in =~ m,\bS_MainNoC_Arc_St_m_PD_DEF02_NIUs_GEVG,
	|| $in =~ m,\bS_MainNoC_Arc_St_m_PD_DEF06_NIUs_ADU,
	|| $in =~ m,\bS_MainNoC_Arc_St_m_PD_DEF06_NIUs_JPU,
	|| $in =~ m,\bS_MainNoC_Arc_St_m_PD_DEF08_NIUs_VOU_monm_pro,
	|| $in =~ m,\bS_MainNoC_Arc_St_m_PD_DEF08_NIUs_VOU_monm_pro,
	|| $in =~ m,\bS_MainNoC_Arc_St_m_PD_DEF08_NIUs_VOU_mont,
	|| $in =~ m,\bS_MainNoC_Arc_St_m_PD_DEF08_NIUs_VOU_mont,
	|| $in =~ m,\bS_MainNoC_Arc_St_m_PD_DEF08_NIUs_VOU_other_mas,
	|| $in =~ m,\bS_MainNoC_Arc_St_m_PD_DEF08_NIUs_VOU_other_mas,
	|| $in =~ m,\bS_MainNoC_Arc_St_m_PD_DEF08_NIUs_VOU_other_slv,
	|| $in =~ m,\bS_MainNoC_Arc_St_m_PD_DEF08_NIUs_VOU_other_slv,
	|| $in =~ m,\bS_MainNoC_Arc_St_m_PD_DEF08_NIUs_VOU_sub_mont,
	|| $in =~ m,\bS_MainNoC_Arc_St_m_PD_DEF08_NIUs_VOU_sub_mont,
	|| $in =~ m,\bS_MainNoC_Arc_St_m_PD_F24_f32,
	|| $in =~ m,\bS_MainNoC_Arc_St_m_PD_F24_f4,
	|| $in =~ m,\bS_MainNoC_Arc_St_m_PD_F24_uec,
	|| $in =~ m,\bS_MainNoC_Arc_St_m_PD_F24_ume,
	|| $in =~ m,\bS_MainNoC_Arc_St_m_PD_F24_usc,
	|| $in =~ m,\bS_PeriNoC_Arc_St_m_PD_B12,
	|| $in =~ m,\bS_PeriNoC_Arc_St_m_PD_C14,
	|| $in =~ m,\bS_PeriNoC_Arc_St_m_PD_C15,
	|| $in =~ m,\bS_PeriNoC_Arc_St_m_PD_C16,
	|| $in =~ m,\bS_PeriNoC_Arc_St_m_PD_C17,
	|| $in =~ m,\bS_PeriNoC_Arc_St_m_PD_C19,
	|| $in =~ m,\bS_PeriNoC_Arc_St_m_PD_DEF02_NIUs_GEVG,
	|| $in =~ m,\bS_PeriNoC_Arc_St_m_PD_DEF06_NIUs_ADU,
	|| $in =~ m,\bS_PeriNoC_Arc_St_m_PD_DEF06_NIUs_JPU,
	|| $in =~ m,\bS_PeriNoC_Arc_St_m_PD_DEF06_NIUs_LCU,
;

open (IN, $in) || die "$in : $!";
open (OUT, ">$out") || die "$out : $!";
my %filter_ref;
$filter_ref{"*A8TS"} = 1;
my %filter_pin;
$filter_pin{"VDD"} = 1;
$filter_pin{"VSS"} = 1;

my ($line, $master, $instance, @pin_net, @g_pin_net);
my ($pin, $net);
while (!eof IN)
{
    $line = GetLine (*IN);
    next if (!defined $line || $line =~ /^\s*$/);
    if (GetMIP ($line, \$master, \$instance, \@pin_net)) {
	if ($master =~ /A8T|S8T/ && $master !~ /BIASNW/) {
	    @g_pin_net = ();
	    foreach (@pin_net) {
		($pin, $net) = split ":";
		if ($pin eq "VDD" && $master !~ /LVLUO/ && $instance !~ /DUMMY_BUFFER/ ) {
		    if ($always09 == 1) {
		      push @g_pin_net, "VNW:VDD";
		    } else {
		      push @g_pin_net, "VNW:VDD1V";
		    }
		} else {
                  if ($pin eq "VDD" && $master !~ /LVLUO/ && $instance =~ /DUMMY_BUFFER/ ) {
                      if ($always09 == 1) {
                      push @g_pin_net, "VNW:VDD1V_MEM";
                    } else {

                      push @g_pin_net, "VNW:VDD1V";
                    }

}
   }      
		if ($pin eq "VSS") {
		    push @g_pin_net, "VPW:$net" ;
		}
		push @g_pin_net, "$pin:$net";
	    }
	    $line = PutMIP ($master, $instance, \@g_pin_net);
	}
    }
    PutLine (*OUT, $line);
}

close IN;
close OUT;

