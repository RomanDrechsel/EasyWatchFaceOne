import sys
import os
import re
import subprocess
from checkSize import checkSize
from buildFontConfig import *

def getFont(input):
    for key, value in avail_fonts.items():
        if key == input:
            return value
    return None

def getCharset(input):
    for key, value in avail_charsets.items():
        if key == input or value == input:
            return value
    return None

font = None
charset = None
type = None
output = "."
small = False
codepoints = None
info = ""

i = 0
argv = sys.argv[1:]
while i < len(argv):
    param = argv[i]
    
    if param[0] == "-":
        for opt in param:
            if opt == "d":
                type = "date"
            elif opt == "t":
                type = "time"
            elif opt == "s":
                small = True
            elif opt == "o":
                output = argv[i + 1]
                i += 1
            elif opt == "f":
                font = getFont(argv[i + 1])
                i += 1
            elif opt == "c":
                charset = getCharset(argv[i + 1])
                i += 1
            elif opt == "i":
                info = argv[i + 1]
                i += 1
                
    else:
        found = False
        if font == None:
            font = getFont(param)
            if font != None:
                found = True
        if found == False and charset == None:
            charset = getCharset(param)
            if charset != None:
                found = True
    i += 1
        
    
if font == None:
    print(info + "Invalid font specified!")
    print(info + "     possible fonts are: \"" + '\", \"'.join(x for x, y in avail_fonts.items()) + "\"")
    exit(1)
elif charset == None:
    print(info + "No Charset specified!")
    print(info + "     possible charsets are: \"" + '\", \"'.join(x for x, y in avail_charsets.items()) + "\"")
    exit(1)
elif type == None:
    print(info + "Only dates (-d) and times (-t) are supported")
    exit(1)

if font != None:
    codepoints = avail_codepoints[type][charset]

if codepoints == None:
    print(info + "No Codepoints found for " + charset + " " + type)
    exit(1)

fontsize = font["Fontsize"]
maxheight = font["MaxHeight"]
if small == True:
    fontsize = font["FontsizeSmall"]
    maxheight = font["MaxHeightSmall"]

width, height = checkSize(font["Fontfile"], fontsize, maxheight, codepoints, info)

if width > 0 and height > 0:
    params = "--font-file=\"" + font["Fontfile"] + "\" \
--output=\"" + output + "\" \
--font-size=" + str(fontsize) + " \
--chars=\"" + codepoints + "\" \
--texture-size=" + str(width) + "x" + str(height) + " \
--texture-crop-width \
--texture-crop-height \
--color=255,255,255 \
--background-color=0,0,0 \
--data-format=txt \
--kerning-pairs=regular \
--padding-up=0 \
--padding-right=0 \
--padding-down=0 \
--padding-left=0 \
--extra-info \
--texture-name-suffix=index \
--max-texture-count 1"

    output_dir = os.path.dirname(output)
    output_file = os.path.basename(output)
    old_size = 0
    if os.path.exists(output_dir) == False:
        os.mkdir(output_dir)
    else:
        for file in os.scandir(output_dir):
            if file.is_file() and re.search(output_file + "_.*.png", file.name) != None:
                old_size += os.stat(file.path).st_size
        
    p = subprocess.Popen("rm -f " + output_file + "*", stdout=subprocess.PIPE, shell=True)
    (o, err) = p.communicate()
    
    p = subprocess.Popen("~/MyStuff/Coding/Tools/FontBM/fontbm " + params, stdout=subprocess.PIPE, shell=True)
    (o, err) = p.communicate()
    
    new_size = 0
    for file in os.scandir(output_dir):
        if file.is_file() and re.search(output_file + "_.*.png", file.name) != None:
            new_size += os.stat(file.path).st_size
    
    if new_size > 0:
        if old_size > 0:
            print(info + "Build " + output + " (diff: " + str(new_size - old_size) + " bytes " + str(round((1 - (new_size / old_size)) * -100, 2)) + "%) done ... ")
        else:
            print(info + "Build " + output + " (new: " + str(new_size) + " bytes) done ... ")
    else:
        print(info + "Build " + output + " done ...")
else:
    print(info + "No suitable size found...")
