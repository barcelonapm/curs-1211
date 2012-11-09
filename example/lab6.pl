#!/usr/bin/env perl
use strict;
use warnings;

# lab6.pl - Example implementation for perl curs 6th lab.

my ( $args, $pattern, $files ) = get_options();

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

# Ensure there is a '-' filename when no files given to signal
# the need of reading from STDIN
@$files = $args->{'-R'} ? ('./') : ('') unless @$files;
for my $filename ( @$files) {
    if (-d $filename) {
       #to do add contents of directories to $files when necesary 
    }
    else { 
        my $fh = get_fh($filename);
        $filename = '(standard input)' if $filename eq '-'; 
        $found += grep_one_file( $filename || '(standard input)' => $fh ) if $fh;
    }
}

print "$found\n" if $args->{-c};

exit !$found;

=head2 grep_one_file
Given a filename and a filehandler this will run all grep login on this filehandle.
=cut
sub grep_one_file {
    my ( $filename, $fh ) = @_;

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

=head2 get_fh
Open and returns a filehandler for the given file or STDIN when no filename given.
=cut
sub get_fh {
    my $filename = shift;

    my $fh;
    if ( $filename and $filename ne '-') {
        if ( -f $filename ) {
            open($fh, '<', $filename) || die "$filename: $!";
        }
        else {
            print STDERR  "grep: $filename: No such file or directory";
        }
    }
    else {
        $fh = \*STDIN;
    }

    $fh;
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
      '-P' => 'PATTERN is a Perl regular expression',
      '-i' => 'ignore case distinctions',
      '-w' => 'force PATTERN to match only whole words',
      '-x' => 'force PATTERN to match only whole lines',
    );

    for my $opt ( '--help', map {"-$_"} qw/ V c n v R l P i w x / ) {
        $usage_options .= "$opt $validoptions{$opt}\n";
    }

    while (substr($ARGV[0]||'', 0, 1) eq '-'){
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

    return \%args, $pattern, [@ARGV];
}

