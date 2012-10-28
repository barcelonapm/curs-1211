
use IPC::Run qw/ run timeout /;
use Test::More;

my $cmd = 'grep.pl';

my ($in, $out, $err);

ok (-e $cmd, "Fitxer '$cmd' existeix");
ok (-x $cmd, "Fitxer '$cmd' es cmdutable");

run [ "./$cmd" ], \$in, \$out, \$err;

ok($err, "S'ha fet output per STDERR");

like ($err, qr/$cmd/, "L'error conte '$cmd'");
like ($err, qr/VERSION/, "L'error conte 'VERSION'");
like ($err, qr/\d\.\d/, "L'error conte el numero de versio");

done_testing;
