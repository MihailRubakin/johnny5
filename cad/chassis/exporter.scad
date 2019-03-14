use <../lib/utils.scad>

use <sidePlate.scad>
use <coverPlate.scad>
use <wheelPlate.scad>

include <common.scad>

$fn = getFragmentCount(debug=false);

FILENAME_SIDE_FRONT_LEFT = "sidePlateFrontLeft";
FILENAME_SIDE_FRONT_RIGHT = "sidePlateFrontRight";
FILENAME_SIDE_BACK_LEFT = "sidePlateBackLeft";
FILENAME_SIDE_BACK_RIGHT = "sidePlateBackRight";
FILENAME_COVER_TOP = "coverPlateTop";
FILENAME_COVER_BOTTOM = "coverPlateBottom";
FILENAME_COVER_END = "coverPlateEnd";
FILENAME_WHEEL_FRONT = "wheelPlateFront";
FILENAME_WHEEL_BACK = "wheelPlateBack";

DEBUG_STL = FILENAME_WHEEL_BACK;

function isDebug() = $stl == undef;

module main(stl) {
    if (stl == FILENAME_SIDE_FRONT_LEFT) {
        sidePlate();
    } else if (stl == FILENAME_SIDE_FRONT_RIGHT) {
        mirror([1, 0, 0])
            sidePlate();
    } else if (stl == FILENAME_SIDE_BACK_LEFT) {
        mirror([1, 0, 0])
            sidePlate(true);
    } else if (stl == FILENAME_SIDE_BACK_RIGHT) {
        sidePlate(true);
    } else if (stl == FILENAME_COVER_TOP) {
        translate([0, 0, -TOP])
        rotate([0, -90, 0])
            topPlate();
    } else if (stl == FILENAME_COVER_BOTTOM) {
        translate([0, 0, BOTTOM])
        rotate([0, 90, 0])
            bottomPlate();
    } else if (stl == FILENAME_COVER_END) {
        endPlate();
    } else if (stl == FILENAME_WHEEL_FRONT) {
        wheelPlate();
    } else if (stl == FILENAME_WHEEL_BACK) {
        mirror([0, 1, 0])
            wheelPlate(true);
    }
}

if (isDebug()) {
    main(stl=DEBUG_STL);
} else {
    echo(str("Exporting ", $stl, ".stl"));
    main(stl=$stl);
}