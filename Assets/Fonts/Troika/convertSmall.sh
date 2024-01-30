#!/bin/bash

#Syntax:
#https://github.com/vladimirgamalyan/fontbm

#Codetable:
#https://www.utf8-chartable.de/unicode-utf8-table.pl?utf8=dec

cd "$(dirname "$0")"

fontsize=32

params=(
    "--font-file=troika.otf"
    "--output=TroikaDate"
    "--font-size=$fontsize"
    "--chars=32,46,48-57,65-90,193-194,196-197,199,201,205,214,216,218,220,268,282,286,344,346,350,352,377,381"
    "--texture-size=256x140"
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

params=(
    "--font-file=troika.otf"
    "--output=TroikaDateCyrillic"
    "--font-size=$fontsize"
    "--chars=32,46,48-57,1030,1040-1046,1048-1060,1063,1066,1070-1071"
    "--texture-size=256x140"
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

params=(
    "--font-file=troika.otf"
    "--output=TroikaDateGreek"
    "--font-size=$fontsize"
    "--chars=32,46,48-57,902,904,910,913-917,919,921-925,927-929,931-934"
    "--texture-size=256x140"
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