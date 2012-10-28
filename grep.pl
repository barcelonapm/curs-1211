#!/usr/bin/env perl
#
# TODO: Cabezera bonita.
#

my $VERSION = "0.1";
my $HEADER = "$0 "."VERSION ".$VERSION;
my $WARNING = "Invalid option";

if (@ARGV == 0) {
	print STDERR "$HEADER\n";
	print STDERR "It's needed at least one parameter!\n";
	print STDERR "Try -h to see available options.\n";
	exit -1;
}
#fas un for i vas iterant o
#fas un while fent pops
for my $opt (@ARGV) {
	if ("-V" eq $opt) {
		print "$HEADER\n";
		exit 0;
	}
	elsif ("-h" eq $opt) {
		# Print help message.
		print <<'EOF';
usage:    grep.pl options pattern
options:
          -V   Prints version.
          -h   Prints this help.
patter:   Text to search.
EOF
		exit 0;
	}
	elsif ("-" eq substr($opt,0,1)) {
		print STDERR "$WARNING $opt!\n";
#		exit 1;
	}
	else {
		#TODO
	}
}
