package Grep;

use strict;
use warnings;

use Exporter 'import';

our $VERSION   = "0.03";
our @EXPORT_OK = qw( scan_input match_line );

sub scan_input {
    my ( $filehandle, $callback ) = @_;

    my @results;
    while ( defined( my $line = <$filehandle>) ) {
        if ( my $match = match_line( $., $line, $callback ) ) {
            push @results, $match;
        }
    }

    return \@results;
}

sub match_line {
    my ( $line_nr, $line_text, $callback ) = @_;

    if ( my $match = $callback->($line_text) ) {
        return { match => $match, text => $line_text, line_nr => $line_nr };
    }
}

# package success
1;
