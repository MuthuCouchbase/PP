#!/usr/bin/perl
use strict;
use warnings;
my ($total,$failures);
my $start = $ARGV[0];
my $end = $ARGV[1];
my $job = $ARGV[2];
print "JobName Total_Runs Total_Failures SUCCESS_PERCENTAGE\n";
if(!$start || !$end || !$job) {
die "Provide start iteration number, end iteration number and jobName space delimited\n";
}
my $DIR = "/x/hudson/jobs/$job/builds";
for(my $i = $start; $i<=$end; $i++) {
if( -d $DIR) {
`strings "$DIR/$i/log" > /var/tmp/abcd`;
my $output = `grep -E 'totalTest|Tests run: ' /var/tmp/abcd| grep -v '^Test'`;
my $line = `grep -E 'Service Health check is called on the host|services not running on the stage|The health check failed for the service|\*' /var/tmp/abcd`;
chomp($line);
$line =~ s/\n/!!/g;
chomp($output);
if($output =~ /Tests run: (\d+), Failures: (\d+)/ || $output=~ /"totalTest":"(\d+)", "failedTest":"(\d+)"/) {
$total+=$1;
$failures+=$2;
}

if($line =~ /Service Health check is called on the host\s*([^\s\!]+).*?services not running on the stage.*?=([^=]+).*?Checking the health of the  OCC/) {
   print "$1::$2\n";
}
if($line =~ /The health check failed for the service ([^\s]+) on node ([^\s]+) for port \d+$/){
   print "$2::$1\n";
}
`rm /var/tmp/abcd`;
}
}
my $percentage = (($total-$failures)/$total)*100;
print "$job $total $failures $percentage"."%\n";
