#!/bin/bash

TARGET="./install/bin/objdump.afl"
INPUT_DIR="outputs-good"
OUTPUT_DIR="outputs-afl-cmin"

if [ ! -d "$INPUT_DIR" ]; then
  echo "Invalid input directory: $INPUT_DIR"
  exit 1
fi

if [ -d "$OUTPUT_DIR" ]; then
  rm -rf "$OUTPUT_DIR"
fi
mkdir -p "$OUTPUT_DIR"

echo "Running afl-cmin..."
afl-cmin -T all -i "$INPUT_DIR" -o "$OUTPUT_DIR" -- "$TARGET" -d "@@"
echo "afl-cmin completed."

file_count=$(find "$OUTPUT_DIR" -type f | wc -l)
echo -e "\nResulting corpus in '$OUTPUT_DIR' contains ${file_count} file(s)."
#find "$OUTPUT_DIR" -type f | sort