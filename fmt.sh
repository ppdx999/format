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

# mktemp command doesn't comply with POSIX. This is the substitution.
# source https://qiita.com/ko1nksm/items/45574a24ecd5f15a731e#%E3%81%99%E3%81%A7%E3%81%AB%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%E3%81%8C%E3%81%82%E3%82%8B%E5%A0%B4%E5%90%88%E3%81%AE%E3%82%A8%E3%83%A9%E3%83%BC%E5%87%A6%E7%90%86
make_tempfile() {
	#--------------------------------------------------
	#Usage:
	#	make_tempfile [prefix] [suffix] [dir_path]
	#
	#Description:
	#	Function for make a tmp file
	#
	#--------------------------------------------------
  (
    now=$(date +'%Y%m%d%H%M%S') || return $?
    file="${3:-${TMPDIR:-/tmp}}/${1:-}$now-$$${2:-}"
    umask 0077
    set -C
    : > "$file" || return $?
    echo "$file"
  )
}

make_tempdir() {
	#--------------------------------------------------
	#Usage:
	#	make_tempdir [prefix] [suffix] [dir_path]
	#
	#Description:
	#	Function for make a tmp directory
	#
	#--------------------------------------------------
  (
    now=$(date +'%Y%m%d%H%M%S') || return $?
    file="${3:-${TMPDIR:-/tmp}}/${1:-}$now-$$${2:-}"
    umask 0077
    mkdir "$file" || return $?
    echo "$file"
  )
}

# Example of Arg check
# n of args check
#[ $# -eq 0 ] &&  error_exit "argument count" 
# directory check
#[ -d "$1" ] &&  error_exit "argument count" 
