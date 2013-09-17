#!/usr/bin/perl
use strict;
use warnings;
my $temp;
open(FILE,"<","/x/home/mkoteeswaran/BUILDs1.txt") or die "Couldn't open file\n";
while(<FILE>) {
   chomp($_);
   if($_ !~ /^$/) {
       $temp .= $_."\t";
   }
   else {
       print $temp."\n";
       $temp = "";
   }
}
close(FILE) or  warn "Couldn't close file\n";
