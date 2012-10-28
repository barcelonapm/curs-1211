#!/usr/bin/env perl

my %validoptions = (
  '-V' => 'Version 1',
  '--help' => 'Help',
);

my %args;


while (substr($ARGV[0], 0, 1) eq '-'){
    if (not exists $validoptions{ $ARGV[0] }){
        print STDERR "$0: unrecognized option '$ARGV[0]'\n";
        exit 1;
    } else {
        $args{ $ARGV[0] } = 1;
        shift @ARGV
    }
}

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
my $pattern = shift @ARGV;
my $found=1;
while (my $line = <STDIN>){
    if (0 <= index($line,$pattern)) {$found = 0; print $line;}
}
exit $found;
