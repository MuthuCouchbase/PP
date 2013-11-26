#!/usr/bin/perl
use strict;
use warnings;
my $DIR = $ARGV[0];
opendir(DIR,$DIR) or die "Couldn't open directory\n";
my @files = readdir(DIR);
my @required_files = map { $_ =~ /\.java/ ? $_ : () } @files;
foreach my $file(@required_files) {
    open(FILE, "<", $file) or die "Couldn't open file\n";
    my $regex = $1 if($file =~ /([^\.]+)\.java/);
    my $output_file = "/x/local/mkoteeswaran/Test/".$regex."Test.java";
    open(OUTPUT, ">", $output_file) or die "Couldn't open output file\n";
    print OUTPUT "package com.paypal.fusion.model;\n\nimport java.util.Date;\n\nimport org.junit.Assert;\nimport org.junit.Test;\nimport com.paypal.fusion.model.".$regex.";\n\npublic class $regex"."Test {\n\t\@Test\n\tpublic void test$regex"."Objects() {\n\t\t$regex object = new $regex();\n\t\t";
    my $GETS;
    while(<FILE>) {
        if($_ =~ / set([^\)]+)\(String/) {
            print OUTPUT "object.set$1(\"STRING\");\n\t\t";
        }
        if($_ =~ / set([^\)]+)\(Date/) {
            print OUTPUT "object.set$1(\"new Date()\");\n\t\t";
        }
        if($_ =~ / set([^\)]+)\(int/) {
            print OUTPUT "object.set$1(12345);\n\t\t";
        }
        if($_ =~ / get([^\)]+)\(\)/) {
            $GETS .= "object.get$1();\n\t\t";
        }
   }
   print OUTPUT "\n\t\t";
   print OUTPUT $GETS;
   print OUTPUT "\n\t\tAssert.assertTrue(object.hashCode() < 0);\n\t\t$regex clonedObject = new $regex();\n\t\tclonedObject = object;\n\t\tAssert.assertTrue(object.equals(clonedObject));\n\t}\n}";

   close(OUTPUT) or warn "Couldn't close output file\n";
   close(FILE) or warn "Couldn't close file\n";
}
closedir(DIR) or warn "Couldn't close DIR\n";
