#!/usr/bin/env perl

# lab4.pl - Example implementation for perl curs 4th lab.

use FindBin qw($Bin);
use lib "$Bin/lib4";
use Grep qw( scan_input match_text );

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
my $matches = scan_input( \*STDIN, sub { 
    my $content = shift;
    return match_text( $pattern, $content );
});

# Ok, time to print output
my $found = scalar @$matches;
if ( $args{'-c'} ) {
    print "$found\n";
}
else {
    for my $match ( @$matches ) {
        my $line = $match->{text};
        $line = $match->{line_nr} . ":$line" if $args{'-n'};
        print $line;
    }
}

exit !$found;
