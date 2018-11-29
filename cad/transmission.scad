use <lib/gear.scad>;
use <lib/utils.scad>;
include <constant.scad>;

$fn = getFragmentCount(debug=false);

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
            
module transmission() {
    union() {
        translate([0, 0, FACE_WIDTH])
            gear(SMALL);
        gear(LARGE);
    }
}

transmission();