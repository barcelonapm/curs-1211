package CmdExec;
use strict;
use v5.10;
use IPC::Run3;
#use Test::More;

require Exporter;
our @ISA    = qw/ Exporter /;
our @EXPORT = qw/ run_command command_path run_with_input /;

my $cmd = $ENV{CURSPERL_CMD} || './grep.pl';

sub command_path { $cmd }

sub run_command {

    my ($in, $out, $err, $exit);
    run3 [ $cmd, @_ ], \$in, \$out, \$err;
    $exit = $?;

    return ($in, $out, $err, $exit);
}

sub run_with_input {
    my ($args, $input) = @_;

    #$SIG{'PIPE'} = 'IGNORE';

    my ($out, $err, $exit);
    run3 [ $cmd, @$args ], \$input, \$out, \$err;
    $exit = $?;

    return (undef, $out, $err, $exit);
}

1;
