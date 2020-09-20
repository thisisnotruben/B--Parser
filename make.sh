#!/bin/bash

lex scanner.l;
gcc -o scanner lex.yy.c;
