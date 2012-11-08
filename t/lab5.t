use FindBin qw/$Bin/;
use lib "$Bin/lib";
use CmdExec;
use Test::More;

subtest 'Help message has new options' => sub {
    my ($in, $out, $err, $exit) = run_command('--help');

    like ($out, qr/-R/m, "--help has -R option");
    like ($out, qr/-l/m, "--help has -l option");
};

subtest 'option -l works as expected' => sub {
    my $input = join "\n", qw/ uno dos tres cuatro cinco /;

    my ($in, $out, $err, $exit) = run_with_input(['-l', 'tres'], $input);
    is( $out, "(standard input)\n", "Output is ok when matching on standard input" );
    
    ($in, $out, $err, $exit) = run_with_input(['-l', 'none'], $input);
    is( $out, '', "Output is empty when not matching on standard input" );

    #TODO: test with multifile ...
};

done_testing;
