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
`strings "$DIR/$i/log" > /var/tmp/abcd`;
my $output = `grep 'Tests run: ' /var/tmp/abcd| grep -v '^Test'`;
`rm /var/tmp/abcd`;
chomp($output);
if($output =~ /Tests run: (\d+), Failures: (\d+)/) {
print "$i,$1,$2\n";
}
}
