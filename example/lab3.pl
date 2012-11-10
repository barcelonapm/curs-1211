#!/usr/bin/env perl

# lab3.pl - Example implementation for perl curs third practice.

use strict;
use warnings;

# Prepare help message to be user around
my $usage = "Usage: $0 [OPTION]... PATTERN [FILE]...\n";
my $usage_advice = "Try `$0 --help' for more information.\n";

# Getting allowed options
my (%args, $usage_options);
my %validoptions = (
  '--help' => 'usage information',
  '-V' => 'version info',
  '-c' => 'only print a count of matching lines per FILE',
);
for my $opt ( '--help', '-V', '-c' ) {
    $usage_options .= "$opt $validoptions{$opt}\n";
}

while (@ARGV && substr($ARGV[0], 0, 1) eq '-'){
    if (not exists $validoptions{ $ARGV[0] }){
        die "$0: unrecognized option '$ARGV[0]'\n"
          . $usage
          . $usage_advice;
    } else {
        $args{ $ARGV[0] } = 1;
        shift @ARGV
    }
}

# Reading and using options
if ($args{'-V'}){
    print "grep Version 2.10\n";
    exit 0;
}
if ($args{'--help'}){
    print $usage, $usage_options;
    exit 0;
}

if (not @ARGV) {
    die $usage . $usage_advice;
}

# Getting nexta parameter, PATTERN.
my $pattern = shift @ARGV;

# All ready!, starting to filter input
my $found=0;
while (my $line = <STDIN>){
    if (0 <= index($line,$pattern)) {
        $found++; 
        if (not $args{'-c'}) {
            print $line;
        }
    }
}

print "$found\n" if $args{'-c'};

exit !$found;
