#!/bin/sh

prove
echo -- lab2
CURSPERL_CMD=./example/lab2.pl prove t/lab1.t
echo -- lab3
CURSPERL_CMD=./example/lab3.pl prove t/lab1.t t/lab2.t
echo -- lab4
CURSPERL_CMD=./example/lab4.pl prove t/lab1.t t/lab2.t t/lab3.t
echo -- lab5
CURSPERL_CMD=./example/lab5.pl prove t/lab1.t t/lab2.t t/lab3.t t/lab4.t
echo -- lab6
CURSPERL_CMD=./example/lab6.pl prove t/lab1.t t/lab2.t t/lab3.t t/lab4.t
