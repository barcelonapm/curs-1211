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

    ($in, $out, $err, $exit) = run_with_input(['-l', 'inco', 
                                               '-','nonexisten_file_one',"$Bin/test_data/data01",
                                               'nonexisting_file_two','nonexisting_file_tree',
                                               "$Bin/test_data/data01"],$input);
    is( $out,"(standard input)\n$Bin/test_data/data01\n$Bin/test_data/data01\n",
             "Output ok for standard input with a filelist with valid and nonexisting files" );
    like( $err,qr/nonexisten_file_one.*nonexisting_file_two.*nonexisting_file_tree/sm,'Catches nonexistent file errors');
         

    #TODO: test with multifile ...
};

done_testing;
