#!/bin/bash
BIN_NORMAL=./install/bin/objdump.afl
BIN_CMPLOG=./install/bin/objdump.cmplog
OPT="-d"

CMD1="afl-fuzz -m none -i ./inputs -o ./outputs -c $BIN_CMPLOG -s 123 -M main -- $BIN_NORMAL $OPT @@"
CMD2="afl-fuzz -m none -i ./inputs -o ./outputs -c $BIN_CMPLOG -s 234 -S sub1 -- $BIN_NORMAL $OPT @@"
CMD3="afl-fuzz -m none -i ./inputs -o ./outputs -c $BIN_CMPLOG -s 345 -S sub2 -- $BIN_NORMAL $OPT @@"
CMD4="afl-fuzz -m none -i ./inputs -o ./outputs -c $BIN_CMPLOG -s 456 -S sub3 -- $BIN_NORMAL $OPT @@"

tmux new-session -d -s foo 'exec $CMD1'
