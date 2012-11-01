#!/usr/bin/env perl

# grep.pl - Example implementation for perl curs

# Getting allowed options
my %args;
my %validoptions = (
  '-V' => 'Version 1',
  '--help' => 'Help',
);

# Prepare help message to be user around
my $usage = "Usage: $0 [OPTION]... PATTERN [FILE]...\n";
my $usage_options = << "USAGE";
--help usage information
-V version info
USAGE
my $usage_advice = "Try `$0 --help' for more information.\n";

while (substr($ARGV[0], 0, 1) eq '-'){
    if (not exists $validoptions{ $ARGV[0] }){
        print STDERR "$0: unrecognized option '$ARGV[0]'\n",
                     $usage, $usage_advice;
        exit 1;
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
    print STDERR $usage, $usage_advice;
    exit 1;
}

# Getting nexta parameter, PATTERN.
my $pattern = shift @ARGV;

# All ready!, starting to filter input
my $found=1;
while (my $line = <STDIN>){
    if (0 <= index($line,$pattern)) {$found = 0; print $line;}
}
exit $found;

