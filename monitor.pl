#!/usr/bin/perl
# Created by Leonardo Berbert Gomes
# E-mail: leo4berbert@gmail.com
# Date: Mar 13 2012
# Version: 1.00
# Description: Monitor Process

use Time::Local;
use File::Basename;
use Sys::Hostname;
use strict;

#Altere para o processo que será monitorado

my @process = ('apache');
my $hostname = hostname();
my $scriptname = basename($0);

my ($da_sec,$da_min,$da_hour,$da_mday,$da_mon,$da_year,$da_wday,$da_yday,$da_isdst) = localtime();

$da_year += 1900;
$da_mon++;

if ( $da_mday < 10 )
{
        $da_mday = 0 . $da_mday;
}
if ( $da_mon < 10 )
{
        $da_mon = 0 . $da_mon;
}

## Altere para o local onde o log deverá ser redirecionado

my $out_file="/home/user/file_" . $da_year . $da_mon . $da_mday . ".log";

foreach my $service (@process) {

my $status = `/bin/ps cax | /bin/grep $service`;

## Acrescente o hostname que será monitorado ##
if (!$status && $hostname =~/killer/) {

	open(OUT,">>$out_file") or die "Can't open $out_file: $!";
		printf OUT ( "%-12.12s" . ":" . get_date(1) . ":P:Process is not running\n", $scriptname);
		printf OUT ( "%-12.12s" . ":" . get_date(1) . ":1:Starting Process\n", $scriptname);
		#Comando para o start do processo em questão
		`apachectl start`;
		printf OUT ( "%-12.12s" . ":" . get_date(1) . ":I:Process successfully started\n", $scriptname);
	close OUT;
}
}

sub get_date {

        my $opt = shift;
        my ($sec,$min,$hour,$day,$month,$year) = (localtime(time))[0,1,2,3,4,5]; $month +=1;$year +=1900;
        if ($day =~ /^\d$/) { $day = "0" . $day;}
        if ($min =~ /^\d$/) { $min = "0" . $min;}
        if ($sec =~ /^\d$/) { $sec = "0" . $sec;}
        if ($hour =~ /^\d$/) { $hour = "0" . $hour;}
        if ($month =~ /^\d$/) { $month = "0" . $month;}

        if ($opt) {
            my $current_date = "$day$month $hour$min$sec";
            return $current_date;
        } else {
             my $date = "$year$month$day$hour$min$sec";
             return $date;
        }
}
