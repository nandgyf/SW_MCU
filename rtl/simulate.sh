#!/bin/bash

find ./ -name "*.v" -type f -print | xargs iverilog -g2009 -o wave
vvp -n wave -lxt2
# vvp -n wave -vcd
