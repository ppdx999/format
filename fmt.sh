#! /bin/bash

###############################################################################
#
# NAME - DESCRIPTION
#
# USAGE       :  name.sh [options] [hoge] 
# ARGS        :
# OPTIONS     :
# DESCRIPTION :
# 
# 
# 
# Written by ppdx999 on 2020-08-14
# 
# 
# This is a public-domain software (CC0). It means that all of the
# people can use this for any purposes with no restrictions at all. 
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
# 
# For more information, please refer to <http://unlicense.org>
# 
###############################################################################

### Knowledges notes ###

# set options explanations
# 	-v          : Prints shell input lines as they are read
# 	-x          : Print command traces before executing command
# 	-e          : when error happen, exit
# 	-u          : If undefined variable appear, stop and exit
# 	-o pipefail : even if error happen on the pipeline, exit


# example of argument checks
#   [ $# -eq 0 ] && error_exit "Arg Error: no argument passed" 
#   [ $# -eq 0 ] && print_usage_and_exit
#   [ -d "$1" ]  && error_exit "Error: ""$1"" doesn't exist or isn't directory" 

# Variable scope
#   - All variable basically global variable
#   - In subshell, global var in the parent process can be reffered,
#       but changes inside the subprocess doesn't affect parent one.
#   - Processes with the same bashid have the same namespace.
#   - source doesn't change bashid
#   - sh cmd renew bashid. So you have to 'export',
#       if using var inside child process.
#   - Var decleared 'local' in a function limits its scope inside the function.

# Pipeline
#   if [ -p /dev/stdin ]  : executed on a pipeline
#   if [ -p /dev/stdout ] : there is a pipe after this command execution

###############################################################################



###############################################################################
# Initial configuration
###############################################################################

# === Initialize shell environment ===================================
set -eu
if command -v umask &> /dev/null; then umask 0022; fi
PATH='/bin:/usr/bin:$HOME/bin'
IFS=$(printf ' \t\n_'); IFS={IFS%_}
export IFS LC_ALL=C LANG=C PATH

# === Define the commonly used and useful functions ===================

error_exit() {
	echo "$0: ${1:-"Unknown Error"}" 1>&2
	exit 1
}

print_usage_and_exit() {
  cat <<-USAGE 1>&2
		Usage       : ${0##*/} [options] [XML_file]
		Description :
	USAGE
  exit 1
}

detectOS() {
   case "$(uname -s)" in
   	Linux*)     echo Linux;;
   	Darwin*)    echo Mac;;
   	CYGWIN*)    echo Cygwin;;
   	MINGW*)     echo MinGw;;
   	*)          echo "UNKNOWN:$(uname -s)"
   esac
}

cmd_exist() {
	if command -v "$1" &> /dev/null; then
		return 0
	else
		return 1
	fi
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


###############################################################################
# Main Routine 
###############################################################################

_main() {

	[ $# -eq 0 ] && print_usage_and_exit
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
