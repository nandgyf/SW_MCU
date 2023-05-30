@echo off

setlocal enabledelayedexpansion

dir /b /s *.v > filelist.txt

set "files="

for /f "delims=" %%F in (filelist.txt) do (
    set files=!files! "%%F"
)

iverilog -g2009 -o wave %files%
vvp -n wave -lxt2
:: vvp -n wave -vcd

del filelist.txt
