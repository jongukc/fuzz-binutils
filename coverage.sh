#!/bin/bash

binary=""
input_file=""
version=2.43
cov_dir="cov-data"

run() {
  for input in ./outputs-$version-cmplog/main/queue/*; do
    LLVM_PROFILE_FILE="$(pwd)/cov-data/objdump-%p.profraw" ./install-$version/bin/objdump.llvmcov --insn-width 64 -d "$input" &> /dev/null
  done

  llvm-profdata merge -sparse $cov_dir/objdump-*.profraw -o $cov_dir/merged.profdata
  llvm-cov show ./install-$version/bin/objdump.llvmcov -instr-profile=$cov_dir/merged.profdata -format=html -output-dir=cov-html
  rm $cov_dir/objdump-*.profraw
}

run
