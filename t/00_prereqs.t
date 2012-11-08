#
# List of prereqs that must be installed
#

use strict;
use warnings;

use Test::More;

my @prereqs = qw(
    IPC::Run3
    File::Slurp
    IO::String
);

use_ok $_ for @prereqs;

done_testing;
