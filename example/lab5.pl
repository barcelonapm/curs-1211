#!/usr/bin/env perl

# lab5.pl - Example implementation for perl curs 5th lab.

use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/lib4";
use Grep qw( scan_input );

my ( $args, $pattern, @files ) = get_options();

# Ensure there is a 'false' filename when no files given to signal
# the need of reading from STDIN
if ( not @files ) {
    push @files, '-';
}

# Let's check file by file...
my $found = 0;

for my $filename (@files) {
    if (-d $filename) {
       #to do add contents of directories to $files when necesary 
    }
    else { 
        $found += grep_one_file($filename);
    }
}

exit !$found;




#
# get_fh( $filename )
#
# Open and returns a filehandler for the given file
# or STDIN when no filename given.
#
sub get_fh {
    my $filename = shift;

    if ( $filename eq '-' ) {
        return \*STDIN;
    }

    if ( open my $fh, '<', $filename ) {
        return $fh;
    }

    warn "$0: $filename: $!\n";
    return;
}

#
# grep_one_file( $filename )
#
# Given a filename this will run all grep login on this filehandle.
#
sub grep_one_file {
    my ($filename) = @_;

    my $fh = get_fh($filename);
    if ( not defined $fh ) {
        return;
    }

    if ( $filename eq '-' ) {
        $filename = '(standard input)';
    }

    # All ready!, starting to filter input
    my $matches = scan_input( $fh, sub { 
        my $line = shift;
        my $ret = undef;                                 # Init return value as no match
        $ret = $pattern if (0 <= index($line,$pattern)); # Set pattern if it match
        $ret = ''    if $args->{-v} && !$ret;              # Set empty string when no match and -v is active
        $ret = undef if $args->{-v} && $ret;               # Set undef when match but -v is active
        return $ret;
    });

    # Ok, time to print output
    my $found = scalar @$matches;
    if ( $args->{-c} ) {
        print "$found\n";
    }
    elsif ( $args->{-l} ) {
        print "$filename\n" if $found;
    }
    else {
        for my $match ( @$matches ) {
            my $line = $match->{text};
            $line = $match->{line_nr} . ":$line" if $args->{'-n'};
            print $line;
        }
    }

    return $found;
}

=head2 get_options
Function to parse grep options, pattern and files if any.
Returns hashref with options, pattern string and arrayref with files given if any.
=cut
sub get_options {
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
      '-v' => 'select non-matching lines',
      '-R' => 'equivalent to --directories=recurse',
      '-l' => 'only print FILE names containing matches',
    );

    for my $opt ( '--help', '-V', '-c', '-n', '-v', '-R', '-l' ) {
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

    return \%args, $pattern, @ARGV;
}

