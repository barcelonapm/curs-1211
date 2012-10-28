use FindBin qw/$Bin/;
use lib "$Bin/lib";
use CmdExec;
use Test::More;

use File::Slurp;
my $input = read_file("$Bin/test_data/data01");

my ($in, $out, $err, $exit) = run_with_input(['00:0c:29:9d:fb:d8'], \$input);
is ($err, '', "No errors");

my $exp = "[    3.908124] pcnet32: PCnet/PCI II 79C970A at 0x2000, 00:0c:29:9d:fb:d8 assigned IRQ 18\n";
is ($out, $exp, "Line found");



done_testing;

