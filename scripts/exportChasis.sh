#!/bin/bash

mkdir -p cad/chasis/stl

# Export segments
stlList=(
	"sidePlateFrontLeft"
	"sidePlateFrontRight"
	"sidePlateBackLeft"
	"sidePlateBackRight"
	"coverPlateTop"
	"coverPlateBottom"
	"coverPlateFront"
	"coverPlateBack"
)

for stl in "${stlList[@]}"
do : 
   	openscad -o "cad/chasis/stl/$stl.stl" -D"\$stl=\"$stl\"" cad/chasis/exporter.scad
done
