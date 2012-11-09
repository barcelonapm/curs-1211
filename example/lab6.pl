#!/usr/bin/env perl

# lab6.pl - Example implementation for perl curs 6th lab.

use strict;
use warnings;

my ( $args, $pattern, @files ) = get_options();

# Ensure there is a 'false' filename when no files given to signal
# the need of reading from STDIN
if ( not @files ) {
    push @files, '-';
}

# Escape metachars from pattern unless perl regex mode is on.
$pattern = quotemeta($pattern) unless $args->{'-P'};

# Turn regex into ignoring case when -i
$pattern = qr/$pattern/i                if $args->{'-i'};

# Turn regex into matching entire words when -w
$pattern = qr/(?:^|\s)$pattern(?:\s|$)/ if $args->{'-w'};

# Turn regex into matching entire lines when -x
$pattern = qr/^$pattern$/               if $args->{'-x'};

# Let's check file by file...
my $found = 0;

while (@files) {
    my $filename = shift @files;

    if (-d $filename) {
       if ( not $args->{-R} ) {
           exit 1;
       }

       push @files, list_dir($filename);
    }
    else { 
        $found += grep_one_file($filename);
    }
}

print "$found\n" if $args->{-c};

exit !$found;

#
# list_dir( $name )
#
# Gets a list of directory contents except . and ..
#
sub list_dir {
    my $filename = shift;

    if ( substr( $filename, length($filename)-1 ) ne '/' ) {
        $filename .= '/';
    }

    if ( opendir my $dir, $filename ) {
        my @list;

        while ( defined( my $entry = readdir $dir ) ) {
            if ( $entry ne '.' && $entry ne '..' ) {
                push @list, "$filename$entry";
            }
        }

        return @list;
    }

    warn "$0: $filename: $!\n";
    return;
}

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
        return 0;
    }

    if ( $filename eq '-' ) {
        $filename = '(standard input)';
    }

    # All ready!, starting to filter input
    my $found = 0;
    while ( my $line = <$fh> ) {
        if ( $line =~ /($pattern)/ || $args->{'-v'} ) {
            next if $1 && $args->{'-v'};
            $found++;

            if ( $args->{-l} ) {
                print "$filename\n";
            }
            elsif ( not $args->{'-c'} ) {
                $line = "$.:$line" if $args->{'-n'};
                print $line;
            }
        }
    }

    return $found;
}

#
# get_options()
#
# Function to parse grep options, pattern and files if any.
# Returns hashref with options, pattern string and arrayref
# with files given if any.
#
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
      '-P' => 'PATTERN is a Perl regular expression',
      '-i' => 'ignore case distinctions',
      '-w' => 'force PATTERN to match only whole words',
      '-x' => 'force PATTERN to match only whole lines',
    );

    for my $opt ( '--help', qw/ -V -c -n -v -R -l -P -i -w -x / ) {
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

