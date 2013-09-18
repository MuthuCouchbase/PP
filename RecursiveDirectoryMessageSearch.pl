#!/usr/bin/perl
#Sample Usage: perl file_name.pl "Cannot resolve host name" > /var/tmp/output
use strict;
use warnings;
my $message = $ARGV[0];
chomp($message);
#my $DIR="/x/home/mkoteeswaran/TEST/";
my $DIR="/x/re/fusion/logs/deploy";
opendir(DIR,$DIR) or die "Couldn't close directory\n";
my @files = readdir(DIR);
foreach my $file(@files) {
   if($file !~ /\./) {
      my $SUB_DIR = $DIR."/".$file;
      opendir(SUB,$SUB_DIR) or warn "Could read sub\n";
      my @sub_files = readdir(SUB);
      my @sub_dir_files = map { "$SUB_DIR/".$_ } @sub_files;
      my $counter = `grep '$message' @sub_dir_files | wc -l`;
      print $SUB_DIR."\n" if ($counter > 0);
      closedir(SUB) or warn "Couldn't close SUB\n";
   }
}
closedir(DIR) or warn "Couldn't close DIR\n";
