use FindBin qw/$Bin/;
use lib "$Bin/lib";
use CmdExec;
use Test::More;

test_version( '-V' );
test_help   ( '--help' );

test_version( '--help', '-V' );
test_version( '-V', '--help' );


($in, $out, $err, $exit) = run_command('-x');
subtest 'Run command with invalid option' => sub {
    ok   ($err, "There is output in STDERR");
    like ($err, qr/Invalid option/m, "Error says 'Invalid option'");
    like ($err, qr/-x/m, "Error shows which option was given");
    isnt ($exit, 0, "Exit code is not 0");
};

done_testing;

sub test_help {
    my ($in, $out, $err, $exit) = run_command(@_);
    subtest 'Run command with ' . (join ' ', @_) => sub {
        is   ($err, '', "There is no output on STDERR");
        like ($out, qr/\s--help\s/m, "Help says something about '-h'");
        like ($out, qr/\s-V\s/m, "Help says something about '-V'");
        is   ($exit, 0, "Exit code is 0");
    };
}

sub test_version {
    my ($in, $out, $err, $exit) = run_command(@_);
    subtest 'Run command with ' . (join ' ', @_) => sub {
        is   ($err, '',  "There is no output on STDERR");
        ok   ($out, "There is output in STDOUT");
        like ($out, qr/grep.pl/m, "Error contains 'grep.pl' string");
        like ($out, qr/VERSION/m, "Output contains 'VERSION' string");
        like ($out, qr/\d\.\d/m, "Output contains VERSION");
        is   ($exit, 0, "Exit code is 0");
    };
}

