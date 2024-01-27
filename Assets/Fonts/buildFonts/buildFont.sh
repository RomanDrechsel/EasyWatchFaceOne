#!/bin/bash

#Syntax:
#https://github.com/vladimirgamalyan/fontbm

#Codetable:
#https://www.utf8-chartable.de/unicode-utf8-table.pl?utf8=dec


output_normal="../../../EasyOne/resources-rectangle-320x360/fonts"
output_small="../../../EasyOne/resources-rectangle-240x240/fonts"

declare -a fonts
fonts[0]="-d Komikazoom lat -o \"$output_normal/KomikazoomDate\""
fonts[1]="-ds Komikazoom lat -o \"$output_small/KomikazoomDate\""

fonts[2]="-d GoD lat -o \"$output_normal/GoDDate\""
fonts[3]="-ds GoD lat -o \"$output_small/GoDDate\""

fonts[4]="-d Troika lat -o \"$output_normal/TroikaDate\""
fonts[5]="-ds Troika lat -o \"$output_small/TroikaDate\""
fonts[6]="-d Troika cyr -o \"$output_normal/TroikaDateCyrillic\""
fonts[7]="-ds Troika cyr -o \"$output_small/TroikaDateCyrillic\""
fonts[8]="-d Troika gre -o \"$output_normal/TroikaDateGreek\""
fonts[9]="-ds Troika gre -o \"$output_small/TroikaDateGreek\""

fonts[10]="-d Roboto lat -o \"$output_normal/RobotoDate\""
fonts[11]="-ds Roboto lat -o \"$output_small/RobotoDate\""
fonts[12]="-d Roboto cyr -o \"$output_normal/RobotoDateCyrillic\""
fonts[13]="-ds Roboto cyr -o \"$output_small/RobotoDateCyrillic\""
fonts[14]="-d Roboto gre -o \"$output_normal/RobotoDateGreek\""
fonts[15]="-ds Roboto gre -o \"$output_small/RobotoDateGreek\""

fonts[16]="-d NotoSans log -o \"$output_normal/NotoSansDateLogogram\""
fonts[17]="-ds NotoSans log -o \"$output_small/NotoSansDateLogogram\""

fonts[18]="-d Kanit tha -o \"$output_normal/KanitDateThai\""
fonts[19]="-ds Kanit tha -o \"$output_small/KanitDateThai\""

fonts[20]="-t ConsolaBold hrs -o \"$output_normal/ConsolaHour\""
fonts[20]="-ts ConsolaBold hrs -o \"$output_small/ConsolaHour\""

i=1
len=${#fonts[@]}

if [ -z "$1" ]; then
    echo
    read -p "Create all fonts? This will take a while... (y/n) " confirm
    echo 
    if [ "${confirm:0:1}" == "y" ] || [ "${confirm:0:1}" == "j" ] || [ "${confirm:0:1}" == "Y" ] || [ "${confirm:0:1}" == "J" ]; then 
        for (( i=0; i<${len}; i++ ));
        do
            done=$(expr $i + 1)
            eval "python3 buildFont.py ${fonts[$i]} -i \"($done/$len) \""
        done
    fi
else
    for var in "$@"
    do
        eval "python3 buildFont.py ${fonts[$var]}"
    done
fi