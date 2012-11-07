package Grep;

use strict;
use warnings;

use Exporter 'import';

our $VERSION   = "0.02";
our @EXPORT_OK = qw( scan_input match_line );

sub scan_input {
    my ( $filehandle, $callback ) = @_;

    #
    # TODO for students:
    #
    # for each line of $filehandle
    # call match_line with $callback
    #
    # return: array of match_line results
    #
}

sub match_line {
    my ( $line_nr, $line_text, $callback ) = @_;

    #
    # TODO for students:
    #
    # if $callback returns non-empty array with $line_text
    # return: hashref with keys match, text, line_nr
    #
    # return undef otherwise
    #
}

#
# Text matching function (feel free to use)
#
# returns: first match or undef
#
sub match_text {
    my ( $pattern, $content ) = @_;

    my ($match) = $content =~ /($pattern)/;
    return $match;
}

# package success
1;
