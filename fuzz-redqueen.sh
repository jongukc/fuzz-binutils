#!/bin/bash
BIN_NORMAL=./install/bin/objdump.afl
BIN_CMPLOG=./install/bin/objdump.cmplog
BIN_LAFINTEL=./install/bin/objdump.lafintel
OPT="-d"

afl-fuzz -m none -i ./inputs -o ./outputs -c $BIN_CMPLOG -s 123 -M main -- $BIN_NORMAL $OPT @@
#afl-fuzz -m none -i ./inputs -o ./outputs -c $BIN_CMPLOG -s 234 -S sub1 -- $BIN_NORMAL $OPT @@
#afl-fuzz -m none -i ./inputs -o ./outputs -c $BIN_CMPLOG -s 345 -S sub2 -- $BIN_NORMAL $OPT @@
#afl-fuzz -m none -i ./inputs -o ./outputs -s 456 -S sub3-laf -- $BIN_LAFINTEL $OPT @@
