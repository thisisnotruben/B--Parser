#!/bin/bash

#=====INPUT=====
# 01-21 / s / p

TEST_DIR="testcases"
SCANNER_OUTPUT_FILE="resultS.txt"
PARSER_OUTPUT_FILE="resultP.txt"
EXTENSION=".c"
NEW_LINE=$'\n'

function makeScanner {
	make scanner
}

function runScanner {
	./scanner < $TEST_DIR/test$1$EXTENSION
}

function runAllScanner {

	testResults="──── Date made: $(date) ────"$NEW_LINE

	makeScanner
	for filePath in $TEST_DIR/*$EXTENSION; do

		test=$(basename -s $EXTENSION $filePath)
		index=$(grep -o [0-9]* <<< $test)

		testResults+=$"──── $test ────"$NEW_LINE$NEW_LINE
		testResults+=$(runScanner $index)
		testResults+=$NEW_LINE$NEW_LINE

	done
	tee $SCANNER_OUTPUT_FILE <<< $testResults > /dev/null
}

function makeParser {
	make parse
}

function testAllParser {
	
	testResults="──── Date made: $(date) ────"$NEW_LINE
	testResults+="TEST  | EXIT CODE"$NEW_LINE$NEW_LINE

	exitCodeOk=0
	exitCodeErr=0

	makeParser
	for filePath in $TEST_DIR/*$EXTENSION; do

		test=$(basename -s $EXTENSION $filePath)

		make $test
		errorCode=$?

		testResults+="$test: [$errorCode]"$NEW_LINE

		if [ $errorCode -eq 0 ]; then
			exitCodeOk=$((exitCodeOk+1))
		else
			exitCodeErr=$((exitCodeErr+1))
		fi

	done

	testResults+=$NEW_LINE"Exit code Ok: "$exitCodeOk$NEW_LINE
	testResults+="Exit code Er: "$exitCodeErr
	
	tee $PARSER_OUTPUT_FILE <<< $testResults > /dev/null
}

if [ $@ = 's' ]; then
	runAllScanner

elif [ $@ = 'p' ]; then
	testAllParser

else
	makeScanner
	runScanner $@
fi
