#!/usr/bin/perl
use strict;

my $ticket_data_file = "/var/www/html/flticketdata/output/*/WEEKLYFLN_*.csv";
my $ldap_data_file = "/x/downloads/ldapdata/ldap_data_latest";
my $file = `ls -ad $ticket_data_file | tail -1`;
my $outputfile = "/x/home03/user/output.txt";
chomp($file);

if(! -f $ldap_data_file) {
    die "LDAP file Missing /x/downloads/ldapdata/ldap_data_latest";
}
else {
    open(FILE, "<", $file) or die "Couldn't open ticket file for reading -$!\n";
    open(OUTPUTFILE, ">", $outputfile) or die "Couldn't open output file for writing -$!\n";
    while(<FILE>) {
        chomp($_);
        if($_ !~ /key\,created/) {
            my @array = split(",",$_);
            my $ticket = $array[0];
            my $assignee = $array[2];
            my $reporter = $array[3];
            my $rca_parent = $array[5];
            my $rca_child = $array[6];
            my $matching_entry = `grep ^$reporter $ldap_data_file`;
            chomp($matching_entry);
            my $cmd = `echo "$matching_entry" | cut -d: -f5,7`;
            my ($manager, $location) = split(":",$cmd);
            ($manager, $location) =~ s/\n//g;
            print OUTPUTFILE "$manager,$reporter,$location\n" if($manager && $reporter && $location);
        }
     }
     close(OUTPUTFILE) or warn "Couldn't close file - $!\n";
     close(FILE) or warn "Couldn't close file - $!\n";
}
!system("cat $outputfile | cut -d, -f1,3 | sort | uniq -c | sed 's/^  *//g'|sort -k1 -nr | head -20 > $outputfile; mail -s \"Manager Ticket Data\" xyz\@XYZ.com < $outputfile") or die "Couldn't manipulate output and send email - $!\n";
