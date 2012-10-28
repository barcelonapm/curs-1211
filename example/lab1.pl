#!/usr/bin/env perl

my $USAGE = "Usage: grep [OPTION]... PATTERN [FILE]...\nTry `grep --help' for more information.\n";

if (@ARGV == 0) {
	print STDERR "$USAGE";
	exit -1;
}

