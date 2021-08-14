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

### Knowledges notes ###

# set options explanations
# 	-u          : If undefined variable appear, stop and exit
# 	-v          : Prints shell input lines as they are read
# 	-x          : Print command traces before executing command
# 	-e          : when error happen, exit
# 	-o pipefail : even if error happen on the pipeline, exit


# example of argument checks
#    [ $# -eq 0 ]  &&  error_exit "Arg Error: no argument passed" 
#    [ -d "$1" ]   &&  error_exit "Error: ""$1"" doesn't exist or isn't directory" 

# Variable scope
#   - All variable basically global variable
#   - In subshell, global var in the parent process can be reffered,
#       but changes inside the subprocess doesn't affect parent one.
#   - Processes with the same bashid have the same namespace.
#   - source doesn't change bashid
#   - sh ./filename change bashid. so you need 'export' if using var inside child process.
#   - Var decleared 'local' inside a function limit its scope inside the function.

# Pipeline
#   if [ -p /dev/stdin ]  : executed on a pipeline
#   if [ -p /dev/stdout ] : there is a pipe after this command execution


###############################################################################

_main(){
}

arg_checks(){
	[ $# -eq 0 ] && [ ! -p /dev/stdin ] &&  error_exit "Arg Error: no argument passed" 
	#[ -d "$1" ] &&  error_exit "Error: ""$1"" doesn't exist or isn't directory" 
}


cmd_exist(){
	if command -v "$1" &> /dev/null; then
		return 0
	else
		return 1
	fi
}

prevent_malcious_env_var(){
	set -u # If undefined variable appear, stop and exit
	#umaks 0022
	PATH=/bin:/usr/bin:$HOME/bin
	IFS=$(printf ' \t\n_'); IFS={IFS%_}
	export IFS LC_ALL=C LANG=C PATH
}

error_exit(){
	echo "$0: ${1:-"Unknown Error"}" 1>&2
	exit 1
}

make_tempfile() {
	#--------------------------------------------------
	#Usage:
	#	make_tempfile [prefix] [suffix] [dir_path]
	#--------------------------------------------------
	(
	now=$(date +'%Y%m%d%H%M%S') || return $?
	file="${3:-${TMPDIR:-/tmp}}/${1:-}$now-$$${2:-}"
	if [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
		umask 0077
	fi
	set -C
	: > "$file" || return $?
	echo "$file"
	)
}

make_tempdir() {
	#--------------------------------------------------
	#Usage:
	#	make_tempdir [prefix] [suffix] [dir_path]
	#--------------------------------------------------
	(
	now=$(date +'%Y%m%d%H%M%S') || return $?
	file="${3:-${TMPDIR:-/tmp}}/${1:-}$now-$$${2:-}"
	if [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
		umask 0077
	fi
	mkdir "$file" || return $?
	echo "$file"
	)
}

if [ -p /dev/stdin ]; then
		# Take the entire standard output as input
		#_main "$(cat -)"

		# Receive line-by-line input
		while read -r line
		do
				_main $line 
		done
else
		_main "$@"
fi 
