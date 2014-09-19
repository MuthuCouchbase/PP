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
`rm /var/tmp/abcd`;
chomp($output);
if($output =~ /Tests run: (\d+), Failures: (\d+)/ || $output=~ /"totalTest":"(\d+)", "failedTest":"(\d+)"/) {
$total+=$1;
$failures+=$2;
}
}
}
my $percentage = (($total-$failures)/$total)*100;
print "$job $total $failures $percentage"."%\n";

