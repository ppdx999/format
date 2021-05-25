#!/bin/bash

assert() {
	prog="$1"
	expected="$2"
	input="$3"

	actual=$(./"$prog" "$input" )

	if [ "$actual" = "$expected" ]; then
		echo "$input => $actual"
	else
		echo "$input => $expected expected, but got $actual"
		exit 1
	fi
}


# assert "$1" ex in
