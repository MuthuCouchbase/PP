#!/usr/local/bin/perl
#######################################################################################################################################
## File name : killservices.pl
## Author : Muthukumar Koteeswaran
## Reviewer :
## Creation Date : 02/18/2014
## Description: File is used to kill all services in a stage if no existing restart/clean/deploy is running. Run only if load ## average is > 100
#######################################################################################################################################
use lib "/usr/lib/perl5/site_perl/5.8.8";
use strict;
use warnings;

use Net::OpenSSH;
use MIME::Base64;
use encrypt;

## Global Variable declarions and initializations.
## Convert the argument to lower case since argument is coming like 'Stage2md015,Stage2p1432'.
$ARGV[0]=~ tr/A-Z/a-z/;
my $stage=$ARGV[0];

my $userName="user";
my $password = encrypt::decryptString( decode_base64("password") );
my $ssh;
my @result;

if (defined $stage && $stage =~ /stage2[a-zA-Z0-9]+/) {
        runStage($stage);
}
##########################################################################################################################
## Function Name: runStage
## Arguments: stagename
## Returns: JSON string
## Description: Used for SSH to the given stage and get the required attributes about the stage.
##########################################################################################################################
sub runStage {
#print "started child process for $stage\n";
## Check the Ping status of the stage and Run other commands if ping returns true.
## Otherwise don't execute other commands on the stage.

    my ($stage)=@_;

    push(@result,"\{");
    eval{
        $ssh = Net::OpenSSH->new("$stage\.qa\.paypal\.com",user=>$userName,password=>$password,timeout=>'5',master_opts => [-o => "StrictHostKeyChecking=no"]);
    };
    if($ssh->error) {
        push(@result,"\"SSH\"\:\{\"status\"\:\"Failed\"\}");
    }
    else {
        my $load_average = $1 if ($ssh->capture("uptime") =~ /load average:\s*([^,]+)/);
        if(($ssh->capture("deploy -d") !~ /0\-1/ ||
                $ssh->capture("ps -eaf | grep -E 'deploy\/RestartStage|CleanLogsStage|CleanStage' | wc -l") == 1)
                 && ($load_average > 99.9)) {
            my $cmd =~ "ps -ef|grep -i stage2|awk '{print $2}'|xargs kill -9";
            my $output = $ssh->capture("$cmd");
            unless ($ssh->error) {
                $output =~ s/\n//g;
                push(@result,$output);
            }
        }
        else {
            push(@result, "\"Result\"\: Cannot Proceed with Kill all services as Restart/CleanLogs/CleanStage is running\n";
        }
    }
    push(@result,"\}");
    print "@result\n";

}
