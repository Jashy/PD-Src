#! /usr/bin/perl -w
use strict;
my ($start_point, $end_point, $end_point_pin, $data_arrival_time, $path_delay);
while ( <> ) {
	chomp;
	if (/ +Startpoint: ([^ ]+)/) {
		$start_point = $1;
		while ( <> ) {
			chomp;
			if (/ +Endpoint: ([^ ]+).*/) {
				$end_point = $1;
				while ( <> ) {
					chomp;
					if (m{($end_point\/[^ ]+) \(.*\)}) {
						$end_point_pin = $1;
						while ( <> ) {
							chomp;
							if (/data arrival time +(\d+\.\d+)/) {
								$data_arrival_time = $1;
								print "$data_arrival_time\t$start_point\t$end_point_pin\n";
								last;
							}
						}
						last;
					}
				}
				last;
			}
		}
	}
}

