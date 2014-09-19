#!/usr/bin/perl
use strict;
use warnings;
my $start = $ARGV[0];
my $end = $ARGV[1];
my $job = $ARGV[2];
if(!$start || !$end || !$job) {
die "Provide start iteration number, end iteration number and jobName space delimited\n";
}
my $DIR = "/x/hudson/jobs/$job/builds";
for(my $i = $start; $i<=$end; $i++) {
my $output = `grep 'Tests run: ' "$DIR/$i/log"| grep -v 'Time elapsed'`;
chomp($output);
if($output =~ /Tests run: (\d+), Failures: (\d+)/) {
print "$i,$1,$2\n";
}
}
