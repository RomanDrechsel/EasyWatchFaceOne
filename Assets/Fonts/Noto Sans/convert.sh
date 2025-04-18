#!/bin/bash

#Syntax:
#https://github.com/vladimirgamalyan/fontbm

#Codetable:
#https://www.utf8-chartable.de/unicode-utf8-table.pl?utf8=dec

cd "$(dirname "$0")"

params=(
    "--font-file=NotoSansKR-SemiBold.ttf"
    "--output=NotoSansDateLogogram"
    "--font-size=40"
    "--chars=32,46,48-57,19968,19977,20108,20116,20845,21608,22235,22303,26085,26376,26408,27700,28779,36913,37329,44552,47785,49688,50900,51068,53664,54868"
    "--texture-size=250x256"
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