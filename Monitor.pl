#!/usr/bin/perl
#yodanagioslvs01.qa.xyz.com
use strict;
use warnings;
use Getopt::Long;

my $stagefileInput;
my $hosts_cfg = "/opt/nagios/etc/objects/hosts.cfg";
GetOptions (
            "file=s" => \$stagefileInput, # string
           );
die("Usage : perl yodamonitorAddStage.pl --file=stages.txt :: stages.txt is a file with stagename,ip eg. stage2dev1234\n") if(!$stagefileInput);
open(FILE,"<",$stagefileInput);
#open(HOST_FILE,">>",$hosts_cfg);
open(HOST_FILE,">>","hosts.cfg");
while(<FILE>) {
   chomp($_);
   my $stageName = $_;
   my $ip_address = `nslookup $stageName | grep -A 1 'Name:' | grep 'Address' | cut -f2 -d" "`;
   #!system("curl --request PUT 'https://XYZ.com/addstage/$stageName.qa.xyz.com/$ip_address'")|| die "Couldn't run curl - $!\n";
   #!system("rm /x/opt/pp/var/run/yoda/*.db") || die "Couldn't remove the db files - $!\n";
   my $entry_to_make_in_host_config = "\ndefine host {\nuse         vm-host\nalias       $stageName.qa.xyz.com\nhost_name   $stageName\naddress     $ip_address\n}\n";
   print HOST_FILE $entry_to_make_in_host_config if(`grep $stageName hosts.cfg | wc -l` == 0);
}
close(FILE) || warn "Couldn't close file - $!\n";
close(HOST_FILE) || warn "Couldn't close host file - $!\n";
