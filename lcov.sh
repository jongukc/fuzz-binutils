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
  run_cmd lcov --base-directory . --ignore-errors version --capture --initial --directory ./ --output-file app.info
  run_cmd ../install/bin/objdump.afl ../outputs-good/main/.cur_input
  run_cmd lcov --no-checksum --directory ./ --capture --output-file app2.info
  run_cmd genhtml --highlight --legend -output-directory ./html-coverage/ ./app2.info

  popd > /dev/null
}

while getopts ":i" opt; do
  case $opt in
    i)
      input_file=$OPTARG
      echo "Input file: $input_file"
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      usage
      ;;
  esac
done

shift $((OPTIND -1))

binary=$1
run_lcov
