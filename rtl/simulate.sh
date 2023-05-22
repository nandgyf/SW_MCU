#!/bin/bash

find ./ -name "*.v" -type f -print | xargs iverilog -o wave
vvp -n wave -lxt2
# vvp -n wave -vcd
