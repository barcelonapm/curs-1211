#!/usr/bin/env perl

# grep.pl - Example implementation for perl curs

# Getting allowed options
my %args;
my %validoptions = (
  '-V' => 'Version 1',
  '--help' => 'Help',
);

while (substr($ARGV[0], 0, 1) eq '-'){
    if (not exists $validoptions{ $ARGV[0] }){
        print STDERR "$0: unrecognized option '$ARGV[0]'\n";
        exit 1;
    } else {
        $args{ $ARGV[0] } = 1;
        shift @ARGV
    }
}

# Reading and using options
if ($args{'-V'}){
    print "grep Version 2.10\n";
    exit 0;
}
if ($args{'--help'}){
    print "Usage: $0 [OPTION]... PATTERN [FILE]...\nSearch for PATTERN\n".
          "--help usage information\n".
          "-V version info\n";
    exit 0;
}

if (not @ARGV) {
    print STDERR <<EOF;
Usage: $0 [OPTION]... PATTERN [FILE]...
Try `$0 --help' for more information.
EOF
    exit 1;
}

# Getting nexta parameter, PATTERN.
my $pattern = shift @ARGV;

# All ready!, starting to filter input
my $found=1;
while (my $line = <STDIN>){
    if (0 <= index($line,$pattern)) {$found = 0; print $line;}
}
exit $found;

