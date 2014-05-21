#!/usr/bin/perl
#Input File is A:B,C A:D,E O/P would be A:B,C,D,E
use strict;
use warnings;
my $hash ={};
open(FILE,"<","/var/tmp/cal_log_dependent_file.txt");
my @lines = <FILE>;
my $temp;
close(FILE);
foreach(@lines) {
        chomp($_);
    my($key, $value) = split(":",$_);
        $hash->{$key}->{$value}=1 if(defined $key && defined $value);
}
foreach my $key1(keys %{$hash}) {
        foreach my $key2 (keys %{$hash->{$key1}}) {
            $temp .= ",".$key2;
        }
        $temp =~ s/^,//g;
        print "$key1:$temp\n";
        $temp="";
}
