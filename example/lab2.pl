#!/usr/bin/env perl

# lab2.pl - Example implementation for perl curs second practice.

# Prepare help message to be user around
my $usage = "Usage: $0 [OPTION]... PATTERN [FILE]...\n";
my $usage_options = << "USAGE";
--help usage information
-V version info
USAGE
my $usage_advice = "Try `$0 --help' for more information.\n";

# Getting allowed options
my %args;
my %validoptions = (
  '-V' => 'Version 1',
  '--help' => 'Help',
);

while (substr($ARGV[0], 0, 1) eq '-'){
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

# Failing anyway since we do not know how to look for pattern yet
exit 1;
