#!/bin/bash 

if [ "$date" = true ]; then
    codepoints="$codepoints_date_latin"
    if [ -n "$small" ]; then
        # small
        fontsize=32
        output_size=
    else
        # normal
        fontsize=44
    fi
fi