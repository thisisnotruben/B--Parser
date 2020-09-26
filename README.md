# CSCV-453 Project 1

## Authors

* Ruben Alvarez Reyes
	* rubenreyes@email.arizona.edu

* Samuel Glenn Bryant
	* sbryant1@email.arizona.edu

## Description

* Flex 2.6.4.
* Bison 3.0.4.

## Todo

- [ ] 5 negative test cases

## Test Usage for Flex

Switch `DEBUG_LEX` to `1` in [parse.l](parse.l)

```bash
# to run specific test in 'testcases/'
./scannerTest.sh $TEST_NUMBER

# to run all tests and output to 'scannerResults.txt'
./scannerTest.sh ALL
```

## Test Usage
```bash
make $TEST_FILE
```
