#!/usr/bin/env perl

use strict;
use warnings;
use v5.10;
use Getopt::Long::Descriptive;

my ( $opt, $pattern, $files ) = get_options();

$pattern = quotemeta($pattern) unless $opt->perl_regexp;
$pattern = qr/$pattern/i       if     $opt->ignore_case;
$pattern = qr/\b$pattern\b/    if     $opt->word_regexp;
$pattern = qr/^$pattern$/      if     $opt->line_regexp;
$pattern = qr/$pattern/;

say $pattern if $opt->verbose;

check_line($_) while (<>);

sub check_line {
    my $line = shift;
    print $line if $line =~ $pattern;
}

sub get_options {
    my ($opt, $usage) = describe_options(
        'filtre.pl %o PATTERN [FILE]',
        ['ignore-case|i' => 'ignore case distinctions'],
        ['perl-regexp|P' => 'PATTERN is a Perl regular expression'],
        ['word-regexp|w' => 'force PATTERN to match only whole words'],
        ['line-regexp|x' => 'force PATTERN to match only whole lines'],
        [],
        ['help'          => 'print usage message and exit'],
        ['verbose|v'     => 'show some debug info'],
    );

    my $pattern = shift @ARGV;

    if ( not defined $pattern || $opt->help ) {
        say $usage;
        exit;
    }

    return ( $opt, $pattern );
}

1;
