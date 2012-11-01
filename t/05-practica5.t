use FindBin qw/$Bin/;
use lib "$Bin/lib";
use CmdExec;
use Test::More;
use File::Slurp;

chdir $Bin;

my ($in, $out, $err, $exit) = run_with_input(['-R', 'num', 'test_data']);
subtest 'Option -R is accepted' => sub {
    ok((not $err), 'No error with -R option');

    my $exp = <<EOF;
test_data/enron1/ham/0002.1999-12-13.farmer.ham.txt:tomorrow . i told linda harris that we ' d get her a telephone number in gas
test_data/enron1/ham/0002.1999-12-13.farmer.ham.txt:numbers , for the record , are 281 . 584 . 3359 voice and 713 . 312 . 1689 fax .
test_data/enron1/Summary.txt:- Total number: 3672 emails
test_data/enron1/Summary.txt:- Total number: 1500 emails
test_data/enron1/Summary.txt:Total number of emails (legitimate + spam): 5975
test_data/data01:[    1.472401] PCI: max bus depth: 1 pci_try_num: 2
test_data/data01:[    3.436255]   Magic number: 0:904:374
EOF
    $out =~ s/\r//gs;

    is($out, $exp, "Correct output");
};


subtest 'Option -l' => sub {
    my $input = read_file("$Bin/test_data/data01");
    my ($in, $out, $err, $exit) = run_with_input([
        '-R', '-l', 'num', 'test_data'
    ]);
    ok((not $err), 'No error with -l option');

    my $exp = <<EOF;
test_data/enron1/ham/0002.1999-12-13.farmer.ham.txt
test_data/enron1/Summary.txt
test_data/data01
EOF

    is($out, $exp, "Correct output");

};

done_testing;
