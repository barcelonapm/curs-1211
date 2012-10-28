#!/usr/bin/env perl

my %validoptions = (
  '-V' => 'Version 1',
  '-h' => 'Help',
);

my %args;

my $opt = shift @ARGV;

while (defined $opt && substr($opt, 0, 1) eq '-'){
    if (not exists $validoptions{ $opt }){
        print "Invalid option\n";
        exit 1;
    } else {
        $args{ $opt } = 1;
    }
    $opt = shift @ARGV;
}

if ($args{'-V'}){
    print "Version\n";
    exit 1;
}
if ($args{'-h'}){
    print "Usage: $0 [-h] [-V]\n";
    exit 1;
}

if (not @ARGV) {
    print "Pattern not specified\n";
    exit 1;
}
