#!/bin/bash

#Syntax:
#https://github.com/vladimirgamalyan/fontbm

#Codetable:
#https://www.utf8-chartable.de/unicode-utf8-table.pl?utf8=dec

cd "$(dirname "$0")"

params=(
    "--font-file=GrimoireOfDeath-2O2jX.ttf"
    "--output=GoDDate"
    "--font-size=32"
    "--chars=32,46,48-57,65-90,193-194,196-197,199,201,205,214,216,218,220,268,282,286,344,346,350,352,377,381"
    #"--texture-size=256x256"
    "--texture-crop-width"
    "--texture-crop-height"
    "--color=255,255,255"
    "--background-color=0,0,0"
    "--data-format=txt"
    "--kerning-pairs=regular"
    "--padding-up=0"
    "--padding-right=0"
    "--padding-down=0"
    "--padding-left=0"
    "--extra-info"
    "--texture-name-suffix=none"
    "--texture-name-suffix=none"
    #"--texture-name-suffix=index_aligned"
)

~/MyStuff/Coding/Tools/FontBM/fontbm "${params[@]}"