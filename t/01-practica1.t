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
Usage: grep [OPTION]... PATTERN [FILE]...
Try `grep --help' for more information.
EOF
    is ($err, $output, "Error message ok");
    isnt ($exit, 0, "Exit code is not 0");
};

subtest 'Run command with --help option' => sub {
    my ($in, $out, $err, $exit) = run_command('-h');
    unlike ($err, qr/VERSION/, "Error not contains 'VERSION' string");
    unlike ($err, qr/\d\.\d/, "Error not contains VERSION");
    unlike ($err, qr/\bone parameter\b/, "Error not contains 'one parameter'");
    unlike ($err, qr/\s-h\s.*\n/, "Error not contains -h advice");
    is   ($exit, 0, "Exit code is 0 now");
};

done_testing;

