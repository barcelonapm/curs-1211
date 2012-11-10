use strict;
use warnings;

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
};

subtest 'option -R works as expected' => sub {
    my ($in, $out, $err, $exit) = run_command('-R', 'MEM', "$Bin/test_data");
    my @exp = (
        "$Bin/test_data/data01:[    0.000000] ACPI: SRAT 1fef0888 00080 (v02 VMWARE MEMPLUG  06040000 VMW  00000001)",
        "$Bin/test_data/data01:[    0.000000] 0MB HIGHMEM available.",
        "$Bin/test_data/data01:[    0.000000] 512MB LOWMEM available.",
    );

    is( (split /\n/, $out), scalar @exp, "lines of grep -R MEM $Bin/test_data" );
    for my $exp (@exp) {
        like( $out, qr{\Q$exp\E}m, "grep -R MEM $Bin/test_data" );
    }

    ($in, $out, $err, $exit) = run_command('-R', '-n', 'MEM', "$Bin/test_data");
    @exp = (
        "$Bin/test_data/data01:70:[    0.000000] ACPI: SRAT 1fef0888 00080 (v02 VMWARE MEMPLUG  06040000 VMW  00000001)",
        "$Bin/test_data/data01:72:[    0.000000] 0MB HIGHMEM available.",
        "$Bin/test_data/data01:73:[    0.000000] 512MB LOWMEM available.",
    );

    is( (split /\n/, $out), scalar @exp, "grep -R -n MEM $Bin/test_data" );
    for my $exp (@exp) {
        like( $out, qr{\Q$exp\E}m, "grep -R -n MEM $Bin/test_data" );
    }

    ($in, $out, $err, $exit) = run_command('-R', '-c', 'x', "$Bin/test_data");
    @exp = (
        "$Bin/test_data/data01:499",
        "$Bin/test_data/enron1/spam/0008.2003-12-18.GP.spam.txt:2",
        "$Bin/test_data/enron1/spam/0006.2003-12-18.GP.spam.txt:2",
        "$Bin/test_data/enron1/Summary.txt:0",
        "$Bin/test_data/enron1/ham/0009.1999-12-14.farmer.ham.txt:0",
        "$Bin/test_data/enron1/ham/0007.1999-12-14.farmer.ham.txt:0",
        "$Bin/test_data/enron1/ham/0002.1999-12-13.farmer.ham.txt:6",
        "$Bin/test_data/enron1/ham/0001.1999-12-10.farmer.ham.txt:0",
        "$Bin/test_data/enron1/ham/0005.1999-12-14.farmer.ham.txt:0",
        "$Bin/test_data/enron1/ham/0004.1999-12-14.farmer.ham.txt:1",
        "$Bin/test_data/enron1/ham/0003.1999-12-14.farmer.ham.txt:0",
        "$Bin/test_data/lipsum/data01:0",
    );
    is( (split /\n/, $out), scalar @exp, "grep -R -c x $Bin/test_data" );
    for my $exp (@exp) {
        like( $out, qr{\Q$exp\E}m, "grep -R -c x $Bin/test_data" );
    }
};

done_testing;
