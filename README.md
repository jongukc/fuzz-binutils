# Fuzz-binutils

Shell scripts to fuzz and analyze GNU `binutils`.

# Files

- `build.sh` : Build bintuils with AFL++ vanilla / cmplog / laf-intel instrumentation.
- `lcov.sh` : Generate a coverage information using `lcov`.
- `minimize-corpus.sh` : Extract unique test cases from the fuzz corpus using `afl-cmin`.
