package Grep;

use strict;
use warnings;

use Exporter 'import';

our $VERSION   = "0.02";
our @EXPORT_OK = qw( scan_input match_line );

sub scan_input {
    my ( $filehandle, $callback ) = @_;

    my @results;
    while ( defined( my $line = <$filehandle>) ) {
        my $match = match_line( $., $line, $callback );
	push @results, $match if defined $match;
    }

    return \@results;
}

sub match_line {
    my ( $line_nr, $line_text, $callback ) = @_;

    my @matches = $callback->($line_text);

    return { match => \@matches, text => $line_text, line_nr => $line_nr }
        if @matches;
}

# package success
1;
