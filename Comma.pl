#!/usr/bin/perl
use strict;
use warnings;
my $hash = {};
open(FILE,"<","/x/home/mkoteeswaran/abcd.123") or die "Couldn't open file\n";
#open(FILE,"<","/x/home/mkoteeswaran/a") or die "Couldn't open file\n";
while(<FILE>) {
   chomp($_);
   if($_ =~ /([^\t]+)\t([^\t]+)/) {
      $hash->{$1}->{$2}=1;
   }
}
close(FILE) or warn "Couldn't close file\n";
foreach my $key(keys %{$hash}) {
   my $temp;
   foreach my $inner_key(keys %{$hash->{$key}}) {
      $temp = $temp.",".$inner_key;
   }
   print $key."\t".$temp."\n";
}
