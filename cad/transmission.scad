use <lib/gear.scad>;
use <lib/utils.scad>;
include <constant.scad>;

$fn = getFragmentCount(debug=false);
            
SPACER = 1;

SMALL = TRANSMISSION_SMALL_GEAR_DEF;
LARGE = TRANSMISSION_LARGE_GEAR_DEF;

SMALL_DIAMETER = prop("tipDiameter", SMALL);
            
module transmission() {
    module spacer() {
        difference() {
            cylinder(SPACER, d=SMALL_DIAMETER);
            cylinder(SPACER, d=TRANSMISSION_SHAFT_DIAMETER);
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