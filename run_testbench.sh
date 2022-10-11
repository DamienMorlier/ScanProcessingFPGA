#!/usr/bin/env bash

IFS=' 	
'

function setup_colors() {
  if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
	NOFORMAT='\033[0m' RED='\033[0;31m' GREEN='\033[0;32m' ORANGE='\033[0;33m' BLUE='\033[0;34m' PURPLE='\033[0;35m' CYAN='\033[0;36m' YELLOW='\033[1;33m'
  else
	NOFORMAT='' RED='' GREEN='' ORANGE='' BLUE='' PURPLE='' CYAN='' YELLOW=''
  fi
}

# Make sure that we're not on NixOS; if so, avoid tampering with PATH
if [[ -f /etc/os-release ]]
then
  . /etc/os-release
fi

if [[ "NixOS" != "$NAME" ]]
then
  # If found, use getconf to constructing a reasonable PATH, otherwise
  # we set it manually.
  if [[ -x /usr/bin/getconf ]]
  then
	PATH=$(/usr/bin/getconf PATH)
  else
	PATH=/bin:/usr/bin:/usr/local/bin
  fi
fi

function usage()
{
  cat <<Usage_Heredoc
Usage: $(basename $0) [OPTIONS] [COMMANDS]

Run tests on GHD

Available options:

	-h, --help  		Display usage


Available commands:

	run				tests

Usage_Heredoc
}

function setup()
{
	# Install packages
	mkdir ./wave_out >> /dev/null
}

function run()
{
	setup
	test_bench=$1
	ghdl -a $(find ./designs/ -name "*.vhd") $(find ./tests/ -name "*.vhd")
	ghdl -e ${test_bench}
	ghdl -r ${test_bench} --wave=./wave_out/${test_bench}.ghw
	gtkwave ./wave_out/${test_bench}.ghw
}

function error()
{
	echo -e "${RED}Error: ${NOFORMAT}$@" >&2
	exit 1
}

function parse_options()
{
	if [[ $# == 0 ]]; then error "No command provided. Try $(basename $0) -h for options."; fi

  	while (($#))
  	do
		case $1 in
			-h|--help)
				usage
				exit 0
				;;
			run)
				shift
				run $@
				;;
	  		*)
				error "Unknown option: $1. Try $(basename $0) -h for options."
				;;
		esac

		shift
  	done
}

setup_colors
parse_options "$@"