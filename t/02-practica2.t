use FindBin qw/$Bin/;
use lib "$Bin/lib";
use CmdExec;
use Test::More test => 4;

test_version( '-V' );
test_help   ( '--help' );

test_version( '--help', '-V' );
test_version( '-V', '--help' );

my $invalid_opt = '--no-valid-option';
my ($in, $out, $err, $exit) = run_command($invalid_opt);
subtest 'Run command with invalid option' => sub {
    ok   ($err, "There is output in STDERR");
    like ($err, qr/unrecognized option/m, "Error says 'unrecognized option'");
    like ($err, qr/$invalid_opt/m, "Error shows which option was given");
    isnt ($exit, 0, "Exit code is not 0");
};

done_testing;

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

