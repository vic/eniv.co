#!/bin/sh

#ReverseMaker v0.1. Play videos in reverse way
#Copyright (C) 2011 Shreeram Ramamoorthy Swaminathan
#
#This program is free software; you can redistribute it and/or
#modify it under the terms of the GNU General Public License
#as published by the Free Software Foundation; either version 2
#of the License, or (at your option) any later version.

#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.

#You should have received a copy of the GNU General Public License
#along with this program; if not, write to the Free Software
#Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
# MA  02110-1301, USA.

if [ $# -ne 2 ]
then
    echo "Error in $0 - Invalid Command"
    echo "Syntax: $0 [input_filename] [output_filename] "
    exit
fi

directory="backwardPlay"

#Initialize with a directory for output
if [ -d $directory ]; then
    echo "Done Initialization"
else 
    mkdir $directory
    echo "Done Initialization"
fi 

echo "Separating audio"
#ffmpeg -i $1 -vn -acodec copy out.aac
ffmpeg -i $1 -vn -ac 2 out.wav

sox -V out.wav backwards.wav reverse

echo "Converting video to images"
ffmpeg -i $1 -r 25 -qscale 0 -f image2 image-%08d.jpg

list=`ls *.jpg`
inc=`ls *.jpg | wc -l`

echo "Relocating $count images"
for i in $list;
do 
nam=`printf "%08d" $inc`
mv $i './backwardPlay/image-'$nam'.jpg';
inc=$((inc-1));
done

echo "Converting images to video"
ffmpeg -r 25 -qscale 5 -i ./backwardPlay/image-%08d.jpg out.mp4

echo "Merging Video and Audio"
ffmpeg -i out.mp4 -i backwards.wav -qscale 0 $2

echo "Removing temporary files"
rm -f ./backwardPlay/*
rm -f image-*
rm -f out.*
rm -f backwards.*

echo "Finished conversion"
echo "You can start palying now"
