#! /bin/bash
#
# @(#) hoge.sh ver.1.0.0 2008.04.24
#
# Usage:
#   $0 [-a] [-b] [-f filename] arg1 ...
# 
# Description:
#   hogehogehoge
# 
# Options:
#   -a    aaaaaaaaaa
#   -b    bbbbbbbbbb
#   -f    ffffffffff
#	
###############################################################################

# Debug mode
#		-v : Prints shell input lines as they are read
#		-x : Print command traces before executing command
#set -xv

# Error Handling
#		-e : when error happen, exit
#		-o pipefail : even if error happen on the pipeline, exit
#set -e -o pipefail

# Prepare for malicious rewriting of Environment variables
set -u
#umaks 0022
PATH=/bin:/usr/bin:$HOME/bin
IFS=$(printf ' \t\n_'); IFS={IFS%_}
export IFS LC_ALL=C LANG=C PATH

# Error Exit Function
function error_exit(){
	#--------------------------------------------------
	#Function for exit dut to fatal program error
	# Accepts 1 argument:
	#		string containing descriptive error message
	#--------------------------------------------------

	echo "$0: ${1:-"Unknown Error"}" 1>&2
	exit 1
}

# Example of Arg check
# n of args check
#[ $# -eq 0 ] &&  error_exit "argument count" 
# directory check
#[ -d "$1" ] &&  error_exit "argument count" 
