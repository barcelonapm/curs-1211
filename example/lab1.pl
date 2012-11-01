#!/usr/bin/env perl

# lab1.pl - Example implementation for perl curs first practice.

# Prepare help message to be user around
my $usage = "Usage: $0 [OPTION]... PATTERN [FILE]...\n";
my $usage_advice = "Try `$0 --help' for more information.\n";

if (@ARGV == 0) {
	print STDERR $usage, $usage_advice;
	exit -1;
}

