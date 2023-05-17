#!/bin/bash

iverilog -o wave *.v -y ./alu -y ./decoder -y ./regfile 
vvp -n wave -lxt2
