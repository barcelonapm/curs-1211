#!/usr/bin/env perl
#
# 
#

my $VERSION = "0.1";
my $HEADER = "$0 "."VERSION ".$VERSION."\n";

if (@ARGV == 0) {
	print STDERR "$HEADER\n";
	print STDERR "$0 needs at least one parameter!\n";
	print STDERR "Try -h to see available options.";
	exit -1;
}

