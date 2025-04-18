#!/bin/bash

#Syntax:
#https://github.com/vladimirgamalyan/fontbm

#Codetable:
#https://www.utf8-chartable.de/unicode-utf8-table.pl?utf8=dec

cd "$(dirname "$0")"

params=(
    "--font-file=Kanit-Medium.ttf"
    "--output=KanitDateThai"
    "--font-size=32"
    "--chars=32,46,48-57,3585,3588,3592,3605,3608,3614,3617-3618,3620,3624,3626,3629,3634,3648"
    "--texture-size=100x200"
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
)

~/MyStuff/Coding/Tools/FontBM/fontbm "${params[@]}"