#!/bin/bash

# ──input──
# int: 01-21

# make
lex parse.l
yacc -dv parse.y
gcc -o scanner lex.yy.c y.tab.h

# run
./scanner < testcases/test$@.c
