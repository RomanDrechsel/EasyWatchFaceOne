#!/bin/bash

#Syntax:
#https://github.com/vladimirgamalyan/fontbm

#Codetable:
#https://www.utf8-chartable.de/unicode-utf8-table.pl?utf8=dec


output_normal="../../../EasyOne/resources-rectangle-320x360/fonts"
output_small="../../../EasyOne/resources-rectangle-240x240/fonts"

declare -a fonts

### Date
fonts[0]="date Komikazoom lat -o \"$output_normal/KomikazoomDate\""
fonts[1]="-s date Komikazoom lat -o \"$output_small/KomikazoomDate\""

fonts[2]="date GoD lat -o \"$output_normal/GoDDate\""
fonts[3]="-s date GoD lat -o \"$output_small/GoDDate\""

fonts[4]="date Troika lat -o \"$output_normal/TroikaDate\""
fonts[5]="-s date Troika lat -o \"$output_small/TroikaDate\""
fonts[6]="date Troika cyr -o \"$output_normal/TroikaDateCyrillic\""
fonts[7]="-s date Troika cyr -o \"$output_small/TroikaDateCyrillic\""
fonts[8]="date Troika gre -o \"$output_normal/TroikaDateGreek\""
fonts[9]="-s date Troika gre -o \"$output_small/TroikaDateGreek\""

fonts[10]="date Roboto lat -o \"$output_normal/RobotoDate\""
fonts[11]="-s date Roboto lat -o \"$output_small/RobotoDate\""
fonts[12]="date Roboto cyr -o \"$output_normal/RobotoDateCyrillic\""
fonts[13]="-s date Roboto cyr -o \"$output_small/RobotoDateCyrillic\""
fonts[14]="date Roboto gre -o \"$output_normal/RobotoDateGreek\""
fonts[15]="-s date Roboto gre -o \"$output_small/RobotoDateGreek\""

fonts[16]="date NotoSans log -o \"$output_normal/NotoSansDateLogogram\""
fonts[17]="-s date NotoSans log -o \"$output_small/NotoSansDateLogogram\""

fonts[18]="date Kanit tha -o \"$output_normal/KanitDateThai\""
fonts[19]="-s date Kanit tha -o \"$output_small/KanitDateThai\""

### Time
fonts[20]="hour ConsolaBold hrs -o \"$output_normal/ConsolaHour\""
fonts[21]="-s hour ConsolaBold hrs -o \"$output_small/ConsolaHour\""
fonts[22]="minutes Consola min -o \"$output_normal/ConsolaMinute\""
fonts[24]="seconds Consola sec -o \"$output_normal/ConsolaSecond\""
fonts[25]="-s seconds Consola sec -o \"$output_small/ConsolaSecond\""

fonts[26]="hour Impossible hrs -o \"$output_normal/ImpossibleTime\""
fonts[27]="-s hour Impossible hrs -o \"$output_small/ImpossibleTime\""
fonts[28]="seconds Impossible sec -o \"$output_normal/ImpossibleSecond\""
fonts[29]="-s seconds Impossible sec -o \"$output_small/ImpossibleSecond\""

fonts[30]="hour Komikazoom hrs -o \"$output_normal/KamikazoomTime\""
fonts[31]="-s hour Komikazoom hrs -o \"$output_small/KamikazoomTime\""
fonts[32]="seconds Komikazoom sec -o \"$output_normal/KamikazoomSecond\""
fonts[33]="-s seconds Komikazoom sec -o \"$output_small/KamikazoomSecond\""

fonts[34]="hour RobotoBold hrs -o \"$output_normal/RobotoHour\""
fonts[35]="-s hour RobotoBold hrs -o \"$output_small/RobotoHour\""
fonts[36]="minutes RobotoRegular min -o \"$output_normal/RobotoMinute\""
fonts[38]="seconds Roboto sec -o \"$output_normal/RobotoSecond\""
fonts[39]="-s seconds Roboto sec -o \"$output_small/RobotoSecond\""

fonts[40]="hour Typesauce hrs -o \"$output_normal/TypesauceTime\""
fonts[41]="-s hour Typesauce hrs -o \"$output_small/TypesauceTime\""
fonts[42]="seconds Typesauce sec -o \"$output_normal/TypesauceSecond\""
fonts[43]="-s seconds Typesauce sec -o \"$output_small/TypesauceSecond\""

### Texts
fonts[100]="text Normal nor -o \"$output_normal/Normal\""
fonts[101]="-s text Normal nor -o \"$output_small/Normal\""
fonts[102]="text Small sma -o \"$output_normal/Small\""
fonts[103]="-s text Small sma -o \"$output_small/Small\""
fonts[104]="text Tiny tin -o \"$output_normal/Tiny\""

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