#!/usr/bin/perl
use strict;
use warnings;
my $file = $ARGV[0];
my @occ_array = ();
my $dir = "/x/web/RE/htdocs/pub/stage/LIVE/LIVE-GOLD/";
my $protected_dir = "/x/web/RE/htdocs/pub/stage-protecteds";

opendir(DIR1, $protected_dir);
my @protected_rpms = readdir(DIR1);
closedir(DIR1);
my @occ_protected_array = map {$_ =~ /^occ.*?rpm/ ? $_ : ()} @protected_rpms;

opendir(DIR, $dir);
my @all_rpms = readdir(DIR);
closedir(DIR);
my @occ_product_array = map {$_ =~ /^occ.*?rpm/ ? $_ : ()} @all_rpms;

open(FILE,"<", $file) or die "Couldn't open file\n";
while(<FILE>) {
   chomp($_);
   foreach my $product_rpm(@occ_product_array) {
      if($product_rpm =~ /$_\-[0-9]+\.\d+\-/) {
         push(@occ_array, $_);
         last;
      }
   }
}
close(FILE) or warn "Couldn't close file\n";
foreach my $product(@occ_array) {
   foreach my $protected_rpm(@occ_protected_array) {
      if($protected_rpm =~ /$product\-protected-stage\-[0-9]+\.\d+\-/) {
         print $product."\n";
         last;
      }
   }
}
