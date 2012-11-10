use strict;
use warnings;

use FindBin qw/$Bin/;
use lib "$Bin/lib", "$Bin/..", "$Bin/../example/lib4";
use CmdExec;
use Test::More tests => 14;
use File::Slurp;
use IO::String;
use Grep;

#subtest 'Help message has new -n option' => sub {
{
    my ($in, $out, $err, $exit) = run_command('--help');

    like ($out, qr/-n/m, "--help has -n option");
    like ($out, qr/-v/m, "--help has -v option");
}

#subtest 'Option -n exists and work as expected' => sub {
{
    my $input = read_file("$Bin/test_data/data01");

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

    ($in, $out, $err, $exit) = run_with_input(['-n', 'HIGHMEM'], $input);
    is( $out, "72:[    0.000000] 0MB HIGHMEM available.\n", "option -n shows line number before line" );

    ($in, $out, $err, $exit) = run_with_input(['-n', 'LOWMEM'], $input);
    is( $out, "73:[    0.000000] 512MB LOWMEM available.\n", "option -n shows line number before line" );
}

#subtest 'Option -v work as expected' => sub {
{
    my $input = join "\n", qw/ uno dos tres cuatro cinco /;

    my ($in, $out, $err, $exit) = run_with_input(['-v', 'o'], $input);
    is( $out, "tres\n", "-v option negate matches as expected" );

    ($in, $out, $err, $exit) = run_with_input(['-v', 'c'], $input);
    is( $out, "uno\ndos\ntres\n", "-v option negate matches as expected" );
}

#subtest 'Grep.pm is correctly defined' => sub {
{
    my $module = 'Grep';
    use_ok($module);
    can_ok( $module, 'scan_input', 'match_line' );
}

#subtest "Grep.pm does what's expected" => sub {
{
    my $in = join "\n", qw/ uno dos tres cuatro cinco seis /;

    ok (my $matches = Grep::scan_input( IO::String->new($in), sub { return shift =~ /o/ ? 'o' : undef; }), 'Call Grep::scan_input()' );

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
}
