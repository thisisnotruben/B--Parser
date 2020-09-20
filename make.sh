#!/bin/bash

lex lex.l;
gcc -o scanner lex.yy.c;
