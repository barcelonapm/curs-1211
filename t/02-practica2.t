use FindBin qw/$Bin/;
use lib "$Bin/lib";
use CmdExec;
use Test::More;

my ($in, $out, $err, $exit) = run_command('-V');
subtest 'Run command with -V' => sub {
    ok   (not $err, "There is no output on STDERR");
    ok   ($out, "There is output in STDOUT");
    like ($out, qr/grep.pl/, "Error contains 'grep.pl' string");
    like ($out, qr/VERSION/, "Output contains 'VERSION' string");
    like ($out, qr/\d\.\d/, "Output contains VERSION");
    is   ($exit, 0, "Exit code is 0");
};


($in, $out, $err, $exit) = run_command('-h');
subtest 'Run command with -h' => sub {
    ok   (not $err, "There is no output on STDERR");
    ok   ($out, "There is output in STDOUT");
    like ($out, qr/-h/, "Help says something about '-h'");
    like ($out, qr/-V/, "Help says something about '-V'");
    is   ($exit, 0, "Exit code is 0");
};


($in, $out, $err, $exit) = run_command('-x');
subtest 'Run command with invalid option' => sub {
    ok   ($err, "There is output in STDERR");
    like ($err, qr/Invalid option/, "Error says 'Invalid option'");
    like ($err, qr/-x/, "Error shows which option was given");
    isnt ($exit, 0, "Exit code is not 0");
};

done_testing;

