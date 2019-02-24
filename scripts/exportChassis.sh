#!/bin/bash

mkdir -p cad/chassis/stl

# Export segments
stlList=(
	"sidePlateFrontLeft"
	"sidePlateFrontRight"
	"sidePlateBackLeft"
	"sidePlateBackRight"
	"coverPlateTop"
	"coverPlateBottom"
	"coverPlateEnd"
)

for stl in "${stlList[@]}"
do : 
   	openscad -o "cad/chassis/stl/$stl.stl" -D"\$stl=\"$stl\"" cad/chassis/exporter.scad
done
