#!/bin/sh

prove
echo --
CURSPERL_CMD=./example/lab2.pl prove t/lab1.t
echo --
CURSPERL_CMD=./example/lab3.pl prove t/lab1.t t/lab2.t
echo --
CURSPERL_CMD=./example/lab4.pl prove t/lab1.t t/lab2.t t/lab3.t
