#!/bin/bash


# Export segments
stlList=(
	"segmentShort"
	"segmentLong"
	"segmentServoShort"
	"segmentServoLong"
	"segmentDouble"
)

for stl in "${stlList[@]}"
do : 
   	openscad -o "cad/arm/$stl.stl" -D"\$stl=\"$stl\"" cad/arm/segment.scad
done
