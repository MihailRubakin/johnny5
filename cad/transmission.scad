use <lib/gear.scad>;
use <lib/utils.scad>;
include <constant.scad>;

$fn = getFragmentCount(debug=false);

SHAFT_DIAMETER = 4;
BEARING_DIAMETER = 10.3; // With clearance
BEARING_HEIGHT = 4.3; // With clearance

SMALL= defGear(24, GEAR_MOD, 
            faceWidth=FACE_WIDTH,
            shaft=SHAFT_DIAMETER,
            bearings=[
                defBearing(BEARING_DIAMETER, BEARING_HEIGHT, 1)
            ]);

LARGE= defGear(56, GEAR_MOD, 
            faceWidth=FACE_WIDTH,
            shaft=SHAFT_DIAMETER,
            bearings=[
                defBearing(BEARING_DIAMETER, BEARING_HEIGHT)
            ]);
            
SPACER = 1;

SMALL_DIAMETER = prop("tipDiameter", SMALL);
            
module transmission() {
    module spacer() {
        difference() {
            cylinder(SPACER, d=SMALL_DIAMETER);
            cylinder(SPACER, d=SHAFT_DIAMETER);
        }
    }
    
    union() {
        translate([0, 0, FACE_WIDTH + SPACER])
            gear(SMALL);
        translate([0, 0, FACE_WIDTH])
            spacer();
        gear(LARGE);
    }
}

transmission();