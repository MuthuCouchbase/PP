#!/usr/bin/perl
use strict;
use warnings;
my @jobArray = ('MS_live-BAT','live_stagevalidation','MS_rqa-BAT','rqa_stagevalidation');
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();
my $formatted_date = sprintf("%04d-%02d-%02d", $year+1900, $mon+1, $mday-1);
print "JobName Total_Runs Total_Failures SUCCESS_PERCENTAGE\n";
foreach my $job(@jobArray) {
   my $DIR = "/x/hudson/jobs/$job/builds";
   my @files = <$DIR/$formatted_date*/log>;
   my ($total,$failures);
   foreach(@files) {
      `strings "$_" > /var/tmp/abcd`;
      my $output = `grep -E 'totalTest|Tests run: ' /var/tmp/abcd| grep -v '^Test'`;
      my $output1 = `grep 'Total failed FrontTier/Mid tier Services: 2' /var/tmp/abcd | wc -l`;
      chomp($output1);
      `rm /var/tmp/abcd`;
      chomp($output);
      if($output =~ /Tests run: (\d+), Failures: (\d+)/ || $output=~ /"totalTest":"(\d+)", "failedTest":"(\d+)"/) {
         $total+=$1;
         $failures+=$2;
      }
   }
   my $percentage = sprintf("%.2f",(($total-$failures)/$total)*100);
   print "$job $total $failures $percentage"."%\n";
}
