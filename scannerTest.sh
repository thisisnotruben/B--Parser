#!/bin/bash

# ───INPUT────
# 01-21 || ALL

TEST_DIR="testcases"
OUTPUT_FILE="scannerResults.txt"
EXTENSION=".c"
NEW_LINE=$'\n'

testResults=""

function makeScanner {
	lex parse.l
	yacc -dv parse.y
	gcc -o scanner lex.yy.c y.tab.h
}
function run {
	./scanner < $TEST_DIR/test$1.c
}

function runAll {

	testResults+="──── Date made: $(date) ────$NEW_LINE"

	makeScanner
	for filePath in $TEST_DIR/*$EXTENSION; do

		test=$(basename -s $EXTENSION $filePath)
		index=$(grep -o [0-9]* <<< $test)

		testResults+=$"──── $test ────$NEW_LINE$NEW_LINE"
		testResults+=$(run $index)
		testResults+=$NEW_LINE$NEW_LINE

	done
	tee $OUTPUT_FILE <<< $testResults > /dev/null
}

if [ $@ = 'ALL' ]; then
	runAll
else
	makeScanner
	run $@
fi
