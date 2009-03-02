#!/bin/bash
#
# Simple script to rip the audio stream of a FLV to MP3
#
# usage:    mp3dump INPUT.flv ARTIST TITLE
# example:    mp3dump FlashhxSjv3 "Foo Bar" "All your Base are Belong to Us"
# Author:    Milian Wolff
# depends on:  mplayer, lame
#   optional:  ecasound for stereo sound emulation
#   optional:  mp3info to write title and artist mp3 tags

if [[ "$(which mplayer)" == "" ]]; then
  echo -e "\033[41mThis script requires mplayer!\033[0m"
  exit
fi

if [[ "$(which lame)" == "" ]]; then
  echo -e "\033[41mThis script requires lame!\033[0m"
  exit
fi

if [[ "$1" == "" || "$2" == "" || "$3" == "" || "$6" != "" ]]; then
  echo "Usage:\t$(basename $0) INPUT.flv ARTIST TITLE [GENRE] [ALBUM]"
  echo "the last two arguments are optional"
  exit
fi

if [ ! -f "$1" ]; then
  echo "Input file \"$1\" could not be found!"
  exit
fi

if [[ "$(file -b "$1")" != "Macromedia Flash Video" ]]; then
  echo "Input file \"$1\" is not a valid flash video!"
  exit
fi

dest="$2 - $3.mp3"
tmpfile="/tmp/$$-$dest"

echo
echo "Your mp3 output file will be: $dest"
echo
echo

echo -n "dumping audio to mp3 file..."
mplayer -nolirc -dumpaudio "$1" -dumpfile "$dest" 1>/dev/null
echo -e " \033[32mdone\033[0m"
echo

echo -n "reencoding with lame - this might take some time..."
lame --silent --preset standard --mp3input "$dest" "$tmpfile" && mv "$tmpfile" "$dest"
echo -e " \033[32mdone\033[0m"
echo

if [[ "$(which ecasound)" == "" ]]; then
  echo "You can optionally install ecasound to simulate stereo sound"
  echo
else
  echo -n "simulating stereo sound..."

  ecasound -d:1 -X -i "$dest" -etf:8 -o "$tmpfile" 1>/dev/null && mv "$tmpfile" "$dest"

  echo -e " \033[32mdone\033[0m"
  echo
fi


if [[ "$(which mp3info)" == "" ]]; then
  echo "You can optionally install mp3info to write basic mp3 tags automatically"
  echo
else
  echo -n "writing basic mp3 tags..."

  mp3info -a "$2" -t "$3" -g "$5" -l "$6" "$dest"

  echo -e " \033[32mdone\033[0m"
  echo
fi

echo "Have fun with »$dest«"
