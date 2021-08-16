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
#  -v          : Prints shell input lines as they are read
#  -x          : Print command traces before executing command
#  -e          : when error happen, exit
#  -u          : If undefined variable appear, stop and exit
#  -o pipefail : even if error happen on the pipeline, exit


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
export LC_ALL=C
export PATH="$(command -p getconf PATH 2>/dev/null)${PATH+:}${PATH-}"
case $PATH in :*) PATH=${PATH#?};; esac
#export UNIX_STD=2003 # to make HP-UX conform to POSIX
IFS=$(printf ' \t\n_'); IFS={IFS%_}
export IFS

# === Define the functions for printing usage and error message ======

error_exit() {
  echo "$0: ${1:-"Unknown Error"}" 1>&2
  exit 1
}

print_usage_and_exit() {
  cat <<-USAGE 1>&2
  Usage       : ${0##*/} [options] [XML_file]
  Description :
  Requirement :
USAGE
exit 1
}

# === Check requirement  =============================================

which which >/dev/null 2>&1 || {
  which() {
    command -v "$1" 2>/dev/null |
      awk '{if($0 !~ /^$/) print; ok=1;}
         END{if(ok==0){print "which: not found" > "/dev/stderr"; exit 1}}'
  }
}

(
  fillRequirement(){
    which "$1" >/dev/null  ||
    error_exit \
    "Error: ${0##*/} require ${1} ${2+You can download it at} ${2:-}" &&
    filled=false
  }
  filled=true
  misc_tools="https://github.com/ShellShoccar-jpn/misc-tools"
  open_tukubai="https://github.com/ShellShoccar-jpn/Open-usp-Tukubai"
  Parsrs="https://github.com/ShellShoccar-jpn/Parsrs"
  fillRequirement curl
  fillRequirement utconv $misc_tools
  if ! $filled; then exit 1; fi
) || print_usage_and_exit

# === Define the commonly used and useful functions ===================

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
  # make_tempfile [prefix] [suffix] [dir_path]
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
  # make_tempdir [prefix] [suffix] [dir_path]
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

######################################################################
# Parse Arguments
######################################################################

# === Print the usage when "--help" is put ===========================
case "$# ${1:-}" in
  '1 -h'|'1 --help'|'1 --version') print_usage_and_exit;;
esac

# === Get the options, arguments and pipeline-input ===============================
# --- initialize option parameters -----------------------------------
#
# some parameters here
#
# --- get them -------------------------------------------------------
optmode=''
while [ $# -gt 0 ]; do
  case "$optmode" in
    '') case "$1" in
          --)       shift
                    break
                    ;;
          -[hv]|--help|--version)
                    print_usage_and_exit
                    ;;
          -[ndwl]*) ret=$(printf '%s\n' "${1#-}"                              |
                          awk '{opt     = substr($0,1,1);                     #
                                opt_str = (length($0)>1) ? substr($0,2) : ""; #
                                printf("%s %s", opt, opt_str);              }')
                    ret1=${ret%% *}
                    ret2=${ret#* }
                    case "$ret1$ret2" in
                      n)  optmode='n'             ;;
                      n*) n_param=$ret2;;
                      d)  optmode='d'             ;;
                      d*) d_param=$ret2              ;;
                      w)  optmode='w'             ;;
                      w*) w_param=$ret2  ;;
                      l)  optmode='l'             ;;
                      l*) l_param=$ret2 ;;
                    esac
                    ;;
          -*)       print_usage_and_exit
                    ;;
          *)        case "$arg1" in '') arg1=$1; shift; continue ;; esac
                    case "$arg2" in '') arg2=$1; shift; continue ;; esac
                    case "$arg3" in '') arg3=$1; shift; continue ;; esac
                    break
                    ;;
        esac
        ;;
    n)  n_param=$1
        optmode=''
        ;;
    d)  d_param=$1
        optmode=''
        ;;
    w)  w_param=$1
        optmode=''
        ;;
    l)  l_param=$1
        optmode=''
        ;;
  esac
  shift
done

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
