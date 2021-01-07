#!/usr/local/bin/perl -w


###########################################################################################
#Function:
#	this script is used to
#	check the distance from standard cell's pg pin to the nearest pg strap connection,
#	if the distance exceeds the limitation,
#	the cell will be defined as violated (contain potential IR drop violation).
###########################################################################################


#######################################################
#get arguments

use strict;

if ( $ARGV[0] )
{
	open(CONFIG,$ARGV[0]) || die "Error: unable to open config file $ARGV[0]";
}
else
{
	print "\nPlease input config file.\n\n";
	exit (1);
}

my ($def,@lef,$limit,@conn,$std_height,$std_lowpin,@pg_net,@skip_cell,@skip_area,@skip_pattern);
while (<CONFIG>)
{
	next if ( $_ =~ /^#/ );
	$_ =~ s/\s+//g;
	if ( $_ =~ /DEF:(\S+)/ )
	{
		$def = $1;
	}
	elsif ( $_ =~ /LEF:(\S+)/ )
	{
		@lef = split(/,/,$1);
	}
	elsif ( $_ =~ /LIMIT:(\S+)/ )
	{
		$limit = $1;
	}
	elsif ( $_ =~ /CONN:(\S+)/ )
	{
		@conn = split(/,/,$1);
	}
	elsif ( $_ =~ /STD_HEIGHT:(\S+)/ )
	{
		$std_height = $1;
	}
	elsif ( $_ =~ /STD_LOWPIN:(\S+)/ )
	{
		$std_lowpin = $1;
	}
	elsif ( $_ =~ /PG_NET:(\S+),(\S+)/ )
	{
		push (@pg_net,$1,$2);
	}
	elsif ( $_ =~ /SKIP_CELL:(\S+)/ )
	{
		@skip_cell = split(/,/,$1);	
	}
	elsif ( $_ =~ /SKIP_AREA:(\S+)/ )
	{
		foreach ( split(/;/,$1) )
		{
			push (@skip_area,split(/,/,$_))
		}
	}
	elsif ( $_ =~ /SKIP_PATTERN:(\S+)/ )
	{
		@skip_pattern = split(/,/,$1);
	}	
}
close CONFIG;

unless ( $def && @lef && $limit && @conn && $std_height && $std_lowpin && @pg_net )
{
	print "Missing definition for below variable: DEF/LEF/LIMIT/CONN/STD_HEIGHT/STD_LOWPIN/PG_NET .\n";
	exit (1);
}

if ( !$ENV{FLASH} )
{
	print "Please define environment variable FLASH,\n";
	print "command: setenv FLASH `tty`\n";
	exit (1);
}
else
{
	open (FLASH,">$ENV{FLASH}") || die "Error: unable to open output $ENV{FLASH}";
}


#######################################################
#open input and output files

open(DEF,$def) || die "Error: unable to open input file $def";

while (<DEF>)
{
	if ( $_ =~ /^\s*DESIGN\s*(\S+)\s*;/ )
	{
		open(RPT_ALL,">$1.all") || die "Error: unable to create $1.all";
		open(RPT_ERR,">$1.err") || die "Error: unable to create $1.err";
		open(RPT_SCM,">$1.scm") || die "Error: unable to create $1.scm";
		last;
	}
}

select (STDOUT);
$| = 1;


#######################################################
#print start time

my $current_time = localtime();

print "*-------------------------------------------------------------------\n*\n";
print "* check std2strap script,\n";
print "* used to check the distance\n";
print "* from standard cell's pg pin to the nearest pg strap connection.\n*\n";
print "* Program start time: $current_time\n*\n";
print "*-------------------------------------------------------------------\n\n";


#######################################################
#read lef file

print "----------------------->>\n";
print "Start to read lef files:\t ";
my ($std_cell,%std_size);
my @show_string = ("-","\\","|","/");
foreach ( @lef )
{	
	open(LEF,$_) || die "Error: unable to open input file $_";
	while (<LEF>)
	{
		if ( !$std_cell )
		{
			$std_cell = $1 if ( $_ =~ /^\s*MACRO\s+(\S+)/ );
			next;
		}
		if ( $_ =~ /^\s*SIZE\s+(\S+)\s+BY/ )
		{
			$std_size{$std_cell} = $1*1000;
			undef $std_cell;
			&on_going;
		}
	}
	close LEF;
}
print "\nFinish.\n\n";


#######################################################
#read def file

print "----------------------->>\n";
print "Start to read def file:\t\t ";

my ($flag,$def_location,$line,$skipped,$tmp1,$tmp2);
my (@std_inst,@std_x,@vdd_pin,@vss_pin);

while (<DEF>)
{
	if ( !$flag )
	{
		$flag = 1 if ( $_ =~ /^\s*COMPONENTS\s*/ ); 
		next;
	}
	if ( $_ =~ /^\s*END\s+COMPONENTS\s*/ )
	{
		undef $flag;
		$def_location = tell (DEF);
		close DEF;
		last;
	}
	
	chomp $_;
	$line = "" if ( $_ =~ /^\s+-\s+/ );
	$line = $line.$_;
	next if ( $_ !~ /;\s*$/ );
	
	if ( $line =~ /\s*-\s+(\S+)\s+(\S+).*\(\s*(\S+)\s+(\S+)\s*\)\s+(\S+)\s*;\s*$/ )
	{
		next if (! grep(/^$2$/,keys(%std_size)) );
		if ( @skip_pattern )
		{
			foreach ( @skip_pattern )
			{
				if ( $1 =~ /$_/ )
				{
					$skipped = 1;
					goto for_skipped;
				}
			}
		}
		if ( @skip_cell )
		{
			if ( grep(/^$1$/,@skip_cell) )
			{
				$skipped = 1;
				goto for_skipped;
			}
		}
		if ( @skip_area )
		{
			for ( $tmp1=0;$tmp1<@skip_area;$tmp1=$tmp1+4 )
			{
				if ( ($3 >= $skip_area[$tmp1]) && ($3 <= ($skip_area[$tmp1+2]-$std_size{$2})) && ($4 >= $skip_area[$tmp1+1]) && ($4 <= ($skip_area[$tmp1+3]-$std_height)) )
				{
					$skipped = 1;
					goto for_skipped;
				}
			}
		}
		
		push (@std_inst,$1);
		push (@std_x,$3+$std_size{$2}/2);
		$tmp1 = $4;
		$tmp2 = $4+$std_height;
		if ( (($5 =~ /N/) && ($std_lowpin eq "vss")) || (($5 =~ /S/) && ($std_lowpin eq "vdd")) )
		{	
			push (@vss_pin,$tmp1);
			push (@vdd_pin,$tmp2);
			 
		}
		else
		{
			push (@vdd_pin,$tmp1);
			push (@vss_pin,$tmp2);
		}
	}				
	for_skipped:
	&on_going;
}


#######################################################
#enable dual processes

my $dual_process = fork();

if ( $dual_process == 0 ) 
{
	&check_length($pg_net[0],\@vdd_pin);
	exit (0);
}
else
{
	open (NULL,">/dev/null") || die "Error: unable to open output /dev/null";
	select (NULL);
	&check_length($pg_net[1],\@vss_pin);
	close NULL;
}	

wait();


#######################################################
#generate report

select (STDOUT);
print "----------------------->>\n";
print "Start to write result into report files:\t ";

print RPT_ALL "*--------------------------------------------------\n";
print RPT_ALL "* Column 1:\tstandard cell name\n";
print RPT_ALL "* Column 2:\tcheck result for pg net $pg_net[0]\n";
print RPT_ALL "* Column 3:\tcheck result for pg net $pg_net[1]\n* Unit:\t\tum\n";
print RPT_ALL "*--------------------------------------------------\n\n";
print RPT_ERR "*--------------------------------------------------\n";
print RPT_ERR "* Column 1:\tviolated standard cell name\n";
print RPT_ERR "* Column 2:\tcheck result for pg net $pg_net[0]\n";
print RPT_ERR "* Column 3:\tcheck result for pg net $pg_net[1]\n* Unit:\t\tum\n";
print RPT_ERR "*--------------------------------------------------\n\n";
print RPT_SCM "geNameSelect\n";
print RPT_SCM "formDefault \"Name Select\"\n";
print RPT_SCM "setFormField \"Name Select\" \"Type\" \"cell instance\"\n\n";

my (@std2strap_0,@std2strap_1);
open(TMP,"$pg_net[0].rpt.tmp") || die "Error: unable to open file $pg_net[0].rpt.tmp";
while (<TMP>)
{
	chomp $_;
	push (@std2strap_0,$_);
}
close TMP;
open(TMP,"$pg_net[1].rpt.tmp") || die "Error: unable to open file $pg_net[1].rpt.tmp";
while (<TMP>)
{
	chomp $_;
	push (@std2strap_1,$_);
}
close TMP;
unlink ("$pg_net[0].rpt.tmp","$pg_net[1].rpt.tmp");

for ( $tmp1=0;$tmp1<@std_inst;$tmp1++ )
{	
	print RPT_ALL $std_inst[$tmp1],"\t";
	if ( $std2strap_0[$tmp1] eq "no_conn" )
	{
		print RPT_ALL "no_conn\t";
	}
	else
	{
		printf RPT_ALL ("%.3f\t",$std2strap_0[$tmp1]/1000);
	}
	if ( $std2strap_1[$tmp1] eq "no_conn" )
	{
		print RPT_ALL "no_conn\n";	
	}
	else
	{
		printf RPT_ALL ("%.3f\n",$std2strap_1[$tmp1]/1000);
	}
	
	if ( ($std2strap_0[$tmp1] eq "no_conn") || ($std2strap_0[$tmp1] > $limit)|| ($std2strap_1[$tmp1] eq "no_conn") || ($std2strap_1[$tmp1] > $limit) )	
	{
		print RPT_ERR $std_inst[$tmp1],"\t";
		if ( $std2strap_0[$tmp1] eq "no_conn" )
		{
			print RPT_ERR "no_conn\t";
		}
		else
		{
			printf RPT_ERR ("%.3f\t",$std2strap_0[$tmp1]/1000);
		}
		if ( $std2strap_1[$tmp1] eq "no_conn" )
		{
			print RPT_ERR "no_conn\n";	
		}
		else
		{
			printf RPT_ERR ("%.3f\n",$std2strap_1[$tmp1]/1000);
		}
		
		print RPT_SCM "setFormField \"Name Select\" \"Name\" \"$std_inst[$tmp1]\"\n";
		print RPT_SCM "formApply \"Name Select\"\n\n";
	}
	&on_going;		
}

print RPT_SCM "formCancel \"Name Select\"\n";

close RPT_ALL;
close RPT_ERR;
close RPT_SCM;

print "\nFinish.\n\n";


#######################################################
#print end time

$current_time = localtime();
print "Program end time: $current_time\n\n";

my $cost_time_minutes = int(times/60);
my $cost_time_seconds = times - $cost_time_minutes*60;
print "Total cost time: $cost_time_minutes minutes $cost_time_seconds seconds.\n\n";
close FLASH;


#######################################################
#sub programs

sub on_going
{
	if ( !$dual_process)
	{
		select (FLASH);
		$| = 1;
		my $show_char = shift (@show_string);
		print FLASH "\b",$show_char;
		push (@show_string,$show_char);
		select (STDOUT);
	}
}


sub merge_overlap_wire
{
	my ($wire_1,$wire_2,$wire_3,$wire_1_array,$wire_2_array,$wire_3_array) = @_;
	my ($tmp1,@wire_1_array_tmp,@wire_2_array_tmp,@wire_3_array_tmp,@wire_2_array_check,@wire_3_array_check);
	for ( $tmp1=0;$tmp1<@$wire_1_array;$tmp1++ )
	{
		if ( abs($wire_1 - $$wire_1_array[$tmp1]) <= 0 )
		{
			push (@wire_2_array_check,$$wire_2_array[$tmp1]);
			push (@wire_3_array_check,$$wire_3_array[$tmp1]);
		}
		else
		{
			push (@wire_1_array_tmp,$$wire_1_array[$tmp1]);
			push (@wire_2_array_tmp,$$wire_2_array[$tmp1]);
			push (@wire_3_array_tmp,$$wire_3_array[$tmp1]);
		}
	}
	@$wire_1_array = @wire_1_array_tmp;
	@$wire_2_array = @wire_2_array_tmp;
	@$wire_3_array = @wire_3_array_tmp;	
	redo_check:
	if ( @wire_2_array_check )
	{
		for ( $tmp1=0;$tmp1<@wire_2_array_check;$tmp1++ )
		{								
			if ( ($wire_2-$wire_3_array_check[$tmp1])*($wire_3-$wire_2_array_check[$tmp1]) <= 0 )
			{
				if ( $wire_2 > $wire_2_array_check[$tmp1] )
				{
					$wire_2 = $wire_2_array_check[$tmp1];
				}
				if ( $wire_3 < $wire_3_array_check[$tmp1] )
				{
					$wire_3 = $wire_3_array_check[$tmp1];
				}
				splice (@wire_2_array_check,$tmp1,1);
				splice (@wire_3_array_check,$tmp1,1);								
				goto redo_check;
			}			
		}
		for ( $tmp1=0;$tmp1<@wire_2_array_check;$tmp1++ )
		{
			push (@$wire_1_array,$wire_1);
		}
		push (@$wire_2_array,@wire_2_array_check);
		push (@$wire_3_array,@wire_3_array_check);
	}	
	push (@$wire_1_array,$wire_1);
	push (@$wire_2_array,$wire_2);
	push (@$wire_3_array,$wire_3);
}


sub check_length
{
	my ($pg_net,$pg_pin) = @_;
	my $via_max = $#conn - 1;
	my (@rail_x1,@rail_x2,@rail_y,@rail_width,@strap_x1,@strap_x2,@strap_y1,@strap_y2);
	my (@via_x,@via_y,%via,$conn_via,$tmp3,$tmp4,@std2strap);
	my (@pg_via_x,@pg_via_y,@check_via_x,@check_via_y);
	
	open(TMP,">$pg_net.rpt.tmp") || die "Error: unable to create $pg_net.rpt.tmp";
	open(DEF,$def) || die "Error: unable to open input file $def";
	seek (DEF,$def_location,0);
	
	while (<DEF>)
	{
		if ( !$flag )
		{
			$flag = 1 if ( $_ =~ /^\s*SPECIALNETS\s*/ );		
			next;
		}
		if ( $flag != 2 )
		{
			$flag = 2 if ( $_ =~ /^\s*-\s+$pg_net\s+/ );	
			next;
		}
		if ( ($flag == 2) && ( $_ =~ /^\s*\+\s+USE\s+/) )
		{
			undef $flag;
			close DEF;
			last;
		}
		
		chomp $_;
		$_ =~ s/^\s*//;
		$_ =~ s/^\+\s+//;
		if ( $_ !~ /^SHAPE\s+/ )
		{
			$line = $_;
			next;
		}
		else
		{
			$line = $line." ".$_;
		}
		
		if ( $line =~ /^\S+\s+(\S+)\s+(\d+)\s+.*\(\s*(\d+)\s+(\d+)\s*\)\s+\(\s*(\S+)\s+(\S+)\s*\)\s*$/ )
		{
			#find horizontall pg rail
			if ( ($1 eq $conn[0]) && ($6 eq "*") )
			{
				push (@rail_width,$2);
				if ( !@rail_x1 )
				{					
					push (@rail_x1,$3);
					push (@rail_x2,$5);
					push (@rail_y,$4);
				}
				else
				{
					&merge_overlap_wire($4,$3,$5,\@rail_y,\@rail_x1,\@rail_x2);					
				}
			}
			#find vertical pg strap
			if ( ($1 eq $conn[$via_max+1]) && ($2 >= 2000) && ($5 eq "*") )
			{
				push (@strap_x1,$3-$2/2);
				push (@strap_x2,$3+$2/2);
				if ( $4 < $6 )
				{
					push (@strap_y1,$4);
					push (@strap_y2,$6);
				}
				else
				{
					push (@strap_y1,$6);
					push (@strap_y2,$4);
				}				
			}			
			next;
		}
		elsif ( $_ =~ /^.*\(\s*(\d+)\s+(\d+)\s*\)\s(FATVIA\d+)-\S+\s*$/i )
		{
			#find pg via
			if ( $3 eq $conn[$via_max] )
			{
				push (@via_x,$1);
				push (@via_y,$2);	
			}
			for ( $tmp1=1;$tmp1<$via_max;$tmp1++ )
			{	
				if ( $3 eq $conn[$tmp1] )
				{
					if ( !$via{$tmp1} )
					{
						$via{$tmp1} = "";
					}
					$via{$tmp1} = $via{$tmp1}."-".$1.",".$2.";";
				}				
			}		
		}
		&on_going;
	}
	print "\nFinish.\n\n";
	
	#filter via not connected with strap
	print "----------------------->>\n";
	print "Start to check via to strap connection:\t ";
	foreach ( $tmp1=0;$tmp1<@via_x;$tmp1++ )
	{
		foreach ( $tmp2=0;$tmp2<@strap_x1;$tmp2++ )
		{
			if ( ($via_x[$tmp1] >= $strap_x1[$tmp2]) && ($via_x[$tmp1] <= $strap_x2[$tmp2]) && ($via_y[$tmp1] >= $strap_y1[$tmp2]) && ($via_y[$tmp1] <= $strap_y2[$tmp2]) )
			{
				push (@pg_via_x,$via_x[$tmp1]);
				push (@pg_via_y,$via_y[$tmp1]);
			}
		}
		&on_going;
	}
	print "\nFinish.\n\n";
		
	#filter uncomplete via
	print "----------------------->>\n";
	print "Start to check via array completeness:\t ";
	foreach ( $tmp1=0;$tmp1<@pg_via_x;$tmp1++ )
	{
		$flag = 1;
		foreach ($tmp2=1;$tmp2<$via_max;$tmp2++)
		{
			if ( $via{$tmp2} !~ /-$pg_via_x[$tmp1]\,$pg_via_y[$tmp1];/ )
			{
				$flag = 0;
			}
		}
		if ( $flag )
		{
			push (@check_via_x,$pg_via_x[$tmp1]);
			push (@check_via_y,$pg_via_y[$tmp1]);
		}
		&on_going;
	}
	print "\nFinish.\n\n";
	
	#check via is located in which pg rail
	print "----------------------->>\n";
	print "Start to check rail to via connection:\t ";
	for ( $tmp1=0;$tmp1<@check_via_x;$tmp1++ )
	{
		for ( $tmp2=0;$tmp2<@rail_y;$tmp2++ )
		{
			if ( (abs($check_via_y[$tmp1] - $rail_y[$tmp2]) <= $rail_width[$tmp2]/2) && ($check_via_x[$tmp1] >= $rail_x1[$tmp2]) && ($check_via_x[$tmp1] <= $rail_x2[$tmp2]) )
			{	
				$tmp3 = $conn_via->[$tmp2];
				$tmp4 = $#$tmp3 + 1;
				$conn_via->[$tmp2][$tmp4] = $check_via_x[$tmp1];
				last;
			}		
		}
		&on_going;
	}
	print "\nFinish.\n\n";
	
	#check distance
	print "----------------------->>\n";
	print "Start to check pg pin to strap distance:\t ";
	for ( $tmp1=0;$tmp1<@std_inst;$tmp1++ )
	{
		for ( $tmp2=0;$tmp2<@rail_y;$tmp2++ )
		{			
			#find std cell pg pin is located in rail
			if ( (abs($$pg_pin[$tmp1] - $rail_y[$tmp2]) <= 0) && ($std_x[$tmp1] >= $rail_x1[$tmp2]) && ($std_x[$tmp1] <= $rail_x2[$tmp2]) )
			{	
				foreach ( @{$conn_via->[$tmp2]} )
				{
					push (@std2strap,abs($_ - $std_x[$tmp1]));
				}
				last;				
			}
		}
		if ( @std2strap )
		{
			@std2strap=(sort{$a<=>$b}@std2strap);
			print TMP "$std2strap[0]\n";
			undef @std2strap;
		}
		else
		{
			print TMP "no_conn\n";
		}
		&on_going;
	}
	print "\nFinish.\n\n";
	close TMP;
}
