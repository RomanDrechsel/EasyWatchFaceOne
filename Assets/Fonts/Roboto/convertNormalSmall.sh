#!/bin/bash

#Syntax:
#https://github.com/vladimirgamalyan/fontbm

#Codetable:
#https://www.utf8-chartable.de/unicode-utf8-table.pl?utf8=dec

cd "$(dirname "$0")"

params=(
    "--font-file=../Roboto-Medium.ttf"
    "--output=Normal"
    "--font-size=24"
    "--chars=45,48-57"
    "--texture-size=56x48"
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