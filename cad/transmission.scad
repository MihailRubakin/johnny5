use <lib/gear.scad>;
include <constant.scad>;

DEBUG = false;
$fn= DEBUG ? 0 : 100;

SMALL= defGear(18, GEAR_MOD, 
            faceWidth=FACE_WIDTH,
            shaft=SHAFT_DIAMETER,
            bearings=[
                defBearing(BEARING_DIAMETER, BEARING_HEIGHT, 1)
            ]);

LARGE= defGear(30, GEAR_MOD, 
            faceWidth=FACE_WIDTH,
            shaft=SHAFT_DIAMETER,
            bearings=[
                defBearing(BEARING_DIAMETER, BEARING_HEIGHT)
            ]);
            
module transmission() {
    union() {
        translate([0, 0, FACE_WIDTH])
            gear(SMALL);
        gear(LARGE);
    }
}

transmission();