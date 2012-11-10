use strict;
use warnings;

use FindBin qw/$Bin/;
use lib "$Bin/lib";
use CmdExec;
use Test::More tests => 12;

test_version( '-V' );
test_help   ( '--help' );

test_version( '--help', '-V' );
test_version( '-V', '--help' );

#subtest 'Run command with invalid option' => sub {
{
    my ($in, $out, $err, $exit) = run_command('--no-valid-option');

    ok   ($err, "There is output in STDERR");
    like ($err, qr/unrecognized option/m, "Error says 'unrecognized option'");
    like ($err, qr/--no-valid-option/m, "Error shows which option was given");
    isnt ($exit, 0, "Exit code is not 0");
}

#subtest 'Full output of and invalid option' => sub {
{
    my $cmd = command_path();
    my  ($in, $out, $err, $exit) = run_command('--foobar');

    ok ($err, "There is output on STDERR");
    my $output = <<EOF;
$cmd: unrecognized option '--foobar'
Usage: $cmd [OPTION]... PATTERN [FILE]...
Try `$cmd --help' for more information.
EOF
    is  ($err, $output, "Error message ok");
    is  ($out, '', "No output in STDOUT");
    isnt($exit, 0, "Exit code is not 0");
}

sub test_help {
    my ($in, $out, $err, $exit) = run_command(@_);
    subtest 'Run command with ' . (join ' ', @_) => sub {
        is   ($err, '', "There is no output on STDERR");
        like ($out, qr/\s--help/m, "Help says something about '--help'");
        like ($out, qr/\s-V/m, "Help says something about '-V'");
        is   ($exit, 0, "Exit code is 0");
    };
}

sub test_version {
    my ($in, $out, $err, $exit) = run_command(@_);
    subtest 'Run command with ' . (join ' ', @_) => sub {
        is   ($err, '',  "There is no output on STDERR");
        ok   ($out, "There is output in STDOUT");
        like ($out, qr/grep/m, "Error contains 'grep' string");
        like ($out, qr/\d\.\d/m, "Output contains VERSION");
        is   ($exit, 0, "Exit code is 0");
    };
}

