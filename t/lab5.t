use FindBin qw/$Bin/;
use lib "$Bin/lib";
use CmdExec;
use Test::More;

subtest 'Help message has new options' => sub {
    my ($in, $out, $err, $exit) = run_command('--help');

    like ($out, qr/-R/m, "--help has -R option");
    like ($out, qr/-l/m, "--help has -l option");
};

done_testing;
