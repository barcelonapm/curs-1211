use strict;
use warnings;

use FindBin qw/$Bin/;
use lib "$Bin/lib", "$Bin/..", "$Bin/../example/lib4";
use CmdExec;
use Test::More tests => 21;
use File::Slurp;

#subtest 'Help message has new options' => sub {
{
    my ($in, $out, $err, $exit) = run_command('--help');

    like ($out, qr/-P/m, "--help has -R option");
    like ($out, qr/-i/m, "--help has -i option");
    like ($out, qr/-x/m, "--help has -x option");
    like ($out, qr/-w/m, "--help has -w option");
}

#subtest 'Option -P is used as expected' => sub {
{
    my $input = join "\n", qw/ uno dos tres cuatro cinco /;

    my ($in, $out, $err, $exit) = run_with_input(['uno|dos'], $input);
    is( $out, '', 'Passing a regex doesnt work without -P' );

    ($in, $out, $err, $exit) = run_with_input(['-P', 'uno|dos'], $input);
    is( $out, "uno\ndos\n", "PATTERN is used as a perl regex when using -P option" );
}

#subtest 'Option -i is used as expected' => sub {
{
    my $input = join "\n", map { ucfirst } qw/ uno dos tres cuatro cinco /;

    my ($in, $out, $err, $exit) = run_with_input(['uno'], $input);
    is( $out, '', 'Nothing match without -i to ignore case' );

    ($in, $out, $err, $exit) = run_with_input(['-i', 'uno'], $input);
    is( $out, "Uno\n", "PATTERN is used as a perl regex when using -P option" );
}

#subtest 'Option -x is used as expected' => sub {
{
    my $input = join "\n", qw/ uno dos tres cuatro cinco /;

    my ($in, $out, $err, $exit) = run_with_input(['cua'], $input);
    is( $out, "cuatro\n", 'Matching partial line is fine on normal mode' );

    ($in, $out, $err, $exit) = run_with_input(['-x', 'cua'], $input);
    is( $out, "", 'Not matching partial lines with -x enabled' );

    ($in, $out, $err, $exit) = run_with_input(['-x', 'cuatro'], $input);
    is( $out, "cuatro\n", '...but match using full line' );
}

#subtest 'Option -w is used as expected' => sub {
{
    my $input = join "\n", qw/ uno dos tres cuatro cinco /;

    my ($in, $out, $err, $exit) = run_with_input(['cua'], $input);
    is( $out, "cuatro\n", 'Matching partial word is fine on normal mode' );

    ($in, $out, $err, $exit) = run_with_input(['-w', 'cua'], $input);
    is( $out, "", 'Not matching partial words with -w enabled' );

    ($in, $out, $err, $exit) = run_with_input(['-w', 'cuatro'], $input);
    is( $out, "cuatro\n", '...but match using full word' );

    $input = join "\n", map {"$_ y algo mas"} qw/ uno dos tres cuatro cinco /;
    ($in, $out, $err, $exit) = run_with_input(['-w', 'cuatro'], $input);
    is( $out, "cuatro y algo mas\n", '-w match full word at the start of the line' );

    $input = join "\n", map {"algo mas que $_"} qw/ uno dos tres cuatro cinco /;
    ($in, $out, $err, $exit) = run_with_input(['-w', 'cuatro'], $input);
    is( $out, "algo mas que cuatro\n", '-w match full word at the end of the line' );

    $input = join "\n", map {"y $_ tambien"} qw/ uno dos tres cuatro cinco /;
    ($in, $out, $err, $exit) = run_with_input(['-w', 'cuatro'], $input);
    is( $out, "y cuatro tambien\n", '-w match full word at the middle of the line' );
}

# real files tests...
my $input = read_file("$Bin/test_data/data01");

#subtest 'Options -c -P works as expected' => sub {
{
    my $input = read_file("$Bin/test_data/data01");
    my ($in, $out, $err, $exit) = run_with_input(['-c', '-P', 'BIOS'], $input);
    is($out, "22\n", "grep -n -P BIOS");

    ($in, $out, $err, $exit) = run_with_input(['-c', '-P', 'ACPI'], $input);
    is($out, "70\n", "grep -n -P BIOS");

    ($in, $out, $err, $exit) = run_with_input(['-c', '-P', 'BIOS|ACPI'], $input);
    is($out, "88\n", "grep -n -P BIOS");
}

#subtest 'Options -n -P works as expected' => sub {
{
    my $exp = <<'EOF';
72:[    0.000000] 0MB HIGHMEM available.
73:[    0.000000] 512MB LOWMEM available.
EOF
    my ($in, $out, $err, $exit) = run_with_input(['-n', '-P', 'HIGHMEM|LOWMEM'], $input);
    is ($out, $exp, "option -n shows line number before line");
}

