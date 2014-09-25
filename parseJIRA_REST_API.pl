#!/usr/bin/perl
use strict;
use warnings;
my $file = $ARGV[0];
open(FILE,"<", $file) or die "Couldn't open file\n";
$/ = "<option>";
while(<FILE>) {
chomp($_);
$_ =~ s/\n/=/g;
if($_ =~ /.*?<value>([^\<]+)<\/value>.*?<disabled>([^\<]+)<\/disabled>(.*)/) {
   my ($parent, $isdisabled, $array) = ($1, $2, $3);
   my @child_array = split("=", $array);
   foreach my $child(@child_array) {
      my ($child,$isChildDisabled) = ($1,$2) if($child =~ /<value>([^\<]+).*?<disabled>([^\<]+)<\/disabled>/);
      print "$parent - $child\n" if($isdisabled ne "true" && defined $child && $isChildDisabled ne "true");
   }
}
}
close(FILE) or warn "Couldn't close file\n";
