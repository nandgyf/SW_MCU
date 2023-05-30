#!/bin/bash

find ./ -name "*.v" -type f -print | xargs vlog
# vvp -n wave -vcd
