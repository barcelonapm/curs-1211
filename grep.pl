#!/usr/bin/env perl

my %validoptions = (
  '-V' => 'Version 1',
  '--help' => 'Help',
);

my %args;

my $opt = shift @ARGV;

while (defined $opt && substr($opt, 0, 1) eq '-'){
    if (not exists $validoptions{ $opt }){
        print STDERR "grep: unrecognized option '$opt'\n";
        exit 1;
    } else {
        $args{ $opt } = 1;
    }
    $opt = shift @ARGV;
}

if ($args{'-V'}){
    print "$0 Version 2.10\n";
    exit 0;
}
if ($args{'--help'}){
    print "Usage: $0 [OPTION]... PATTERN [FILE]...\nSearch for PATTERN\n".
          "--help usage information\n".
          "-V version info\n";
    exit 0;
}

if (not @ARGV) {
    print STDERR "Usage: grep [OPTION]... PATTERN ...\nTry `grep --help' for more information. \n";
    exit 1;
}
