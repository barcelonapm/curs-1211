#!/usr/bin/env perl

# lab4.pl - Example implementation for perl curs 4th lab.

use lib 'example/lib4';

# Prepare help message to be user around
my $usage = "Usage: $0 [OPTION]... PATTERN [FILE]...\n";
my $usage_advice = "Try `$0 --help' for more information.\n";

# Getting allowed options
my (%args, $usage_options);
my %validoptions = (
  '--help' => 'usage information',
  '-V' => 'version info',
  '-c' => 'only print a count of matching lines per FILE',
  '-n' => 'print line number with output lines',
  '-P' => 'PATTERN is a Perl regular expression',
);
for my $opt ( '--help', '-V', '-c', '-n', '-P' ) {
    $usage_options .= "$opt $validoptions{$opt}\n";
}

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

# TODO: describe matching callback
my $cb = sub { do_somethin_with($pattern) };

# All ready!, starting to filter input
my @matches = scan_input( \*STDIN, $cb );

# TODO: use @matches to count
my $found = count_line_matches(@matches);

print "$found\n" if $args{'-c'};

exit !$found;
