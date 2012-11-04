use FindBin qw/$Bin/;
use lib "$Bin/lib";
use CmdExec;
use Test::More;
use File::Slurp;

my ($in, $out, $err, $exit) = run_with_input(['-P', 'xxx'], \'asdf');
subtest 'Option -P is accepted' => sub {
    ok((not $err), 'No error with -P option');
};


subtest 'Option -n' => sub {
    my $input = read_file("$Bin/test_data/data01");
    my ($in, $out, $err, $exit) = run_with_input(['-n', '570'], $input);

    ok((not $err), 'No error with -n option');

    my $exp = <<EOF;
174:[    0.570249] NMI watchdog disabled (cpu0): hardware events not enabled
175:[    0.570535] Brought up 1 CPUs
176:[    0.570619] Total of 1 processors activated (3666.00 BogoMIPS).
673:[    1.475703] pci 0000:00:17.2: PCI bridge to [bus 15-15]
933:[    1.604570] pcieport 0000:00:18.6: setting latency timer to 64
EOF

    is($out, $exp, "option -n shows line number before line");
};

subtest 'Grep.pm is correctly defined' => sub {
    my $module = 'Grep';
    use_ok($module);
    can_ok( $module, 'scan_input' );
};

done_testing;
