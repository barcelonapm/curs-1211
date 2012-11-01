use Test::More;
use FindBin qw($Bin);
use lib "$Bin/lib";
use CmdExec;

my $cmd = command_path();

ok (-e $cmd, "File '$cmd' exists");
ok (-x $cmd, "File '$cmd' is executable");

subtest 'Run command without options' => sub {
    my ($in, $out, $err, $exit) = run_command();

    ok ($err, "There is output on STDERR");
    my $output = <<EOF;
Usage: $cmd [OPTION]... PATTERN [FILE]...
Try `$cmd --help' for more information.
EOF
    is ($err, $output, "Error message ok");
    isnt ($exit, 0, "Exit code is not 0");
};

subtest 'Run command with --help option' => sub {
    my ($in, $out, $err, $exit) = run_command('--help');
    is ($err, '', "No output in STDERR");
    is ($exit, 0, "Exit code is 0 now");
};

subtest 'Run command with argument' => sub {
    my  ($in, $out, $err, $exit) = run_with_input(['xxxxxx'], '');
    is  ($err, undef, "No output in STDERR");
    is  ($out, undef, "No output in STDOUT");
    isnt($exit, 0, "Exit code is not 0");
};

subtest 'Run command with unknown option --foobar' => sub {
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
};

done_testing;

