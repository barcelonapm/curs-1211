package CmdExec;
use strict;
use v5.10;
use IPC::Run qw/ run timeout /;
use Test::More;

require Exporter;
our @ISA    = qw/ Exporter /;
our @EXPORT = qw/ run_command command_path /;

my $cmd = $ENV{CURSE_PERL_CMD} || './grep.pl';

sub command_path { $cmd }

sub run_command {
    my $this_cmd = join ' ', $cmd, @_;
    diag "Running command $this_cmd";
    my ($in, $out, $err, $exit);
    run [ $cmd, @_ ], \$in, \$out, \$err;
    $exit = $?;

    return ($in, $out, $err, $exit);
}

1;
