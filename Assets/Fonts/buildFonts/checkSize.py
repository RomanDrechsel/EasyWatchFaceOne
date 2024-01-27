import os
import subprocess

def checkSize(fontfile, fontsize, maxheight, codepoints, prefix):
    startheight = 64
    width = maxheight
    step = 8

    tmp = "./tmp"
    
    if os.path.exists(tmp):
        p = subprocess.Popen("rm -rf " + tmp, stdout=subprocess.PIPE, shell=True)
        (output, err) = p.communicate() 

    os.mkdir(tmp)
        
    
    height = startheight
    
    best_size = None
    best_height = None
    
    while height <= maxheight:
        output = os.path.join(tmp, "tmpfile_" + str(height))
        
        params = "--font-file=\"" + fontfile + "\" \
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

        p = subprocess.Popen("~/MyStuff/Coding/Tools/FontBM/fontbm " + params, stdout=subprocess.PIPE, shell=True)
        (output, err) = p.communicate()

        size = 0
        for file in os.scandir(tmp):
            if file.is_file():
                _, ext = os.path.splitext(file.path)
                if ext == ".png":
                    size += os.stat(file.path).st_size
                p = subprocess.Popen("rm " + file.path, stdout=subprocess.PIPE, shell=True)
                (output, err) = p.communicate() 
        
        
        
        print(prefix + "Checked " + fontfile + " (" + str(fontsize) + "): " + str(width) + "x" + str(height) + ": " + str(size) + " bytes")
        
        if size > 0:
            if best_size == None or best_size > size:
                best_height = height
                best_size = size
        
        height += step
        
    if os.path.exists(tmp):
        p = subprocess.Popen("rm -rf " + tmp, stdout=subprocess.PIPE, shell=True)
        (output, err) = p.communicate() 
        
    print(prefix + "Found best Size " + str(width) + "x" + str(best_height) + " with " + str(best_size) + " bytes")
    return width, best_height