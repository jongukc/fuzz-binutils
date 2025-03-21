#!/bin/bash

binary=""
input_file=""
version=2.44

run_cmd() {
  echo "$*"

  eval "$*" || {
    echo "ERROR: $*"
    exit 1
  }
}

run_lcov() {
  pushd binutils-$version > /dev/null

  run_cmd lcov --zerocounters --directory ./
  ../install/bin/objdump.afl -d ../outputs-good/main/.cur_input > /dev/null
  run_cmd lcov --directory ./ --gcov-tool ../llvm-gcov.sh --capture -o cov.info
  run_cmd genhtml --legend -output-directory ./html-coverage/ ./cov.info

  popd > /dev/null
}

#while getopts ":i" opt; do
#  case $opt in
#    i)
#      input_file=$OPTARG
#      echo "Input file: $input_file"
#      ;;
#    :)
#      echo "Option -$OPTARG requires an argument." >&2
#      usage
#      ;;
#  esac
#done
#
#shift $((OPTIND -1))
#
#binary=$1
run_lcov
