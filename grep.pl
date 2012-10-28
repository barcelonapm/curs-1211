#!/usr/bin/env perl
#
# 
#

my $VERSION = "0.1";
my $HEADER = "$0 "."VERSION ".$VERSION;

if (@ARGV == 0) {
	print STDERR "$HEADER\n";
	print STDERR "$0 needs at least one parameter!\n";
	print STDERR "Try -h to see available options.\n";
	exit -1;
}

