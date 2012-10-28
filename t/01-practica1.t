use Test::More;
use IPC::Run qw/ run timeout /;

my $cmd = $ENV{CURSE_PERL_CMD} || './grep.pl';


ok (-e $cmd, "File '$cmd' exists");
ok (-x $cmd, "File '$cmd' is executable");

my ($in, $out, $err, $exit) = run_command();

ok($err, "There is output on STDERR");

like ($err, qr/$cmd/, "Error contains '$cmd' string");
like ($err, qr/VERSION/, "Error contains 'VERSION' string");
like ($err, qr/\d\.\d/, "Error contains VERSION");
like ($err, qr/\bone parameter\b/, "Error contains 'one parameter'");
like ($err, qr/\s-h\s.*\n/, "Error contains -h advice");
isnt ($exit, 0, "Exit code is not 0");

done_testing;

sub run_command {
    my $this_cmd = join ' ', $cmd, @_;
    diag("Running command $this_cmd");
    my ($in, $out, $err, $exit);
    run [ $cmd, @_ ], \$in, \$out, \$err;
    $exit = $?;

    return ($in, $out, $err, $exit);
}
