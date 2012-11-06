package Grep;

use strict;
use warnings;

use Exporter 'import';

our $VERSION   = "0.02";
our @EXPORT_OK = qw( scan_input match_line );

sub scan_input {
    my ( $filehandle, $callback ) = @_;

    # for each line of $filehandle
    # call match_line with $callback

    # return: array of match_line results
}

sub match_line {
    my ( $line_nr, $line_text, $callback ) = @_;

    # if $callback returns true with $line_text
    # return: hashref with keys match, text, line_nr

    # return undef otherwise
}

# package success
1;
