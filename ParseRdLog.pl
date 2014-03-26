#!/usr/bin/perl
use strict;
use warnings;
my $DIR = "/x/www/html/EnvironmentLogs";
opendir(DIR, $DIR) or die "Couldn't open dir\n";
#/x/www/html/EnvironmentLogs/stage2ms209/16804_RapidDeployExistingStage2/RapidDeployExistingServer.txt
my @stage2dirs = map { $_ =~ /stage2/ ? $_ : () } readdir(DIR);
closedir(DIR) or warn "Couldn't close DIR\n";
foreach my $subdir(@stage2dirs) {
    opendir(SUBDIR, $DIR."/".$subdir) or die "Couldn't open subdir\n";
    my $content = `grep -ih '[Error]' $DIR/$subdir/*_RapidDeployExistingStage2/RapidDeployExistingServer.txt`;
    if($content && $content =~ /Error:/i) {
        print $content."\n";
    }
    closedir(SUBDIR) or warn "Couldn't close Sub DIR\n";
}
