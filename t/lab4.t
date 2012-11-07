use FindBin qw/$Bin/;
use lib "$Bin/lib", "$Bin/..", "$Bin/../example/lib4";
use CmdExec;
use Test::More;
use File::Slurp;
use IO::String;
use Grep;

my ($in, $out, $err, $exit) = run_with_input(['-P', 'xxx'], \'asdf');
subtest 'Option -P is accepted' => sub {
    ok((not $err), 'No error with -P option');
};

my $input = read_file("$Bin/test_data/data01");

subtest 'Option -n' => sub {
    my ($in, $out, $err, $exit) = run_with_input(['-n', '570'], $input);

    ok((not $err), 'No error with -n option');

    my $exp = <<'EOF';
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
    can_ok( $module, 'scan_input', 'match_line', 'match_text' );
};

subtest 'Options -c -P works as expected' => sub {
    my ($in, $out, $err, $exit) = run_with_input(['-c', '-P', 'BIOS'], $input);
    is($out, "22\n", "grep -n -P BIOS");

    ($in, $out, $err, $exit) = run_with_input(['-c', '-P', 'ACPI'], $input);
    is($out, "70\n", "grep -n -P BIOS");

    ($in, $out, $err, $exit) = run_with_input(['-c', '-P', 'BIOS|ACPI'], $input);
    is($out, "88\n", "grep -n -P BIOS");
};

subtest 'Options -n -P works as expected' => sub {
    my $exp = <<'EOF';
72:[    0.000000] 0MB HIGHMEM available.
73:[    0.000000] 512MB LOWMEM available.
EOF
    my ($in, $out, $err, $exit) = run_with_input(['-n', '-P', 'HIGHMEM|LOWMEM'], $input);
    is($out, $exp, "option -n shows line number before line");
};

subtest "Grep.pm does what's expected" => sub {
    my $in = join "\n", qw/ uno dos tres cuatro cinco seis /;

    ok (my $matches = Grep::scan_input( IO::String->new($in), sub { 
        my $content = shift;
        return Grep::match_text( 'o', $content );
    }), 'Call Grep::scan_input()' );

    is( ref $matches, 'ARRAY', 'Grep::scan_input() returns an arrayref' );
    is( @$matches, 4, 'Matches count is 4 as expected' );

    is_deeply(
        $matches,
        [
            { 'text' => "uno\n",    'match' => 'o', 'line_nr' => '1' },
            { 'text' => "dos\n",    'match' => 'o', 'line_nr' => '2' },
            { 'text' => "cuatro\n", 'match' => 'o', 'line_nr' => '4' },
            { 'text' => "cinco\n",  'match' => 'o', 'line_nr' => '5' }
        ],
        'Data structure (AoH) looks as expected, yay!'
    );
};

done_testing;
