"""
File: imgur_downloader.py
Badly Written By: Brian Bauer
"""
import json, os
from PIL import Image
import argparse

import urllib2

urls = set()

def IsGif(gif):
    isanimated = True
    try:
        gif.seek(1)
    except EOFError:
        isanimated = False
    return isanimated

def ConvertToJpg(filename):
    im = Image.open(filename)
    if IsGif(im):
        im.putpalette(im.getpalette())
        print "What's this a gif, I think you want a jpg"
        bg = Image.new("RGB", im.size, (255,255,255))
        bg.paste(im)
        bg.save(filename, quality=95)
    im.close()

def SearchAndSave(amount, directory):
    print "Lets do some soul searching"
    while amount >= 1:
        lookup = urllib2.urlopen('https://imgur.com/random')
        url = lookup.geturl()
        url = url.replace("/gallery/","/")
        url += ".jpg"
        check = urllib2.urlopen(url)
        if check.geturl() != "http://i.imgur.com/removed.png":
            urls.add(url)
            amount -= 1
            print "I found something, only", amount, "left"
        else:
            print "nothing here..."

    print "Downloading " + str(len(urls)) +" images to your directory"
    for url in urls:
        image_file = urllib2.urlopen(url)
        pos = url.rfind('/')
        filename = os.path.join(directory, url[pos+1:])
        output = open(filename, 'wb')
        output.write(image_file.read())
        output.close()
        ConvertToJpg(filename)
        print "saved " + url + " as " + filename

parser = argparse.ArgumentParser(description="Look up random images on imgur and download them")
parser.add_argument('-a', type=int, help="specifiy the AMOUNT of images you want try and download")
parser.add_argument('-dir', type=str, help="the directory you wish to save the files in")

args = parser.parse_args()

a = 5
directory = ""
if args.a != None:
    a = args.a
if args.dir != None:
    directory = args.dir
SearchAndSave(a, directory)
