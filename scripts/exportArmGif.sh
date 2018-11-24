#!/bin/bash

mkdir -p tmp
rm tmp/arm*.png

camera="-15,0,10,75,0,320,215"

IMAGES=60

for i in $(seq 1 $IMAGES)
do
	n=$(printf "%02d" $i)
	out="tmp/arm$n.png"
	t=$i/$IMAGES

	echo "Rendering frame $i/$IMAGES"

	openscad --camera="$camera" -D"\$t=$t" -o "$out" cad/armAnim.scad
done

echo "Converting to gif"
convert 'tmp/arm*.png' -set delay 1x24 arm.gif

rm tmp/arm*.png
