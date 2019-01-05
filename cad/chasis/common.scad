use <../wheelAssembly.scad>
use <../thread.scad>

use <../lib/utils.scad>
use <../lib/gear.scad>

include <../constant.scad>

SHOW_THREAD = true;
SHOW_WHEEL = false ;

// TODO: Set width
WIDTH = 30;

BORDER = THREAD_SIZE.z;
THICKNESS = CHASIS_THICKNESS;

SHELL_SIZE = 2 * BORDER;
SHELL_THICKNESS = FACE_WIDTH;

WHEEL_DIAMETER = getThreadRingDiameter(WHEEL_THREAD_COUNT)  - THREAD_SIZE.z;
SHAFT_DIAMETER = WHEEL_SHAFT_DIAMETER;

GEAR_CLEARANCE = 1;
WHEEL_GEAR_DIAMETER = prop("tipDiameter", WHEEL_GEAR_DEF);
CHASIS_WHEEL_SIZE = WHEEL_GEAR_DIAMETER 
    + 2 * GEAR_CLEARANCE
    + BORDER;

// Wheels positions
WHEELS = getWheelsPos();
TOP_FRONT_WHEEL = getTopFront();
BOTTOM_FRONT_WHEEL = getBottomFront();

// Chasis size
TOP = TOP_FRONT_WHEEL.z + BORDER;
BOTTOM = BOTTOM_FRONT_WHEEL.z - BORDER;
FRONT_ANGLE = atan2(
    TOP_FRONT_WHEEL.z - BOTTOM_FRONT_WHEEL.z,
    TOP_FRONT_WHEEL.y - BOTTOM_FRONT_WHEEL.y);
DELTA_FRONT = sin(FRONT_ANGLE) * (TOP - BOTTOM);

// Side panel points
function chasisPoint(y, z) = [0, y, z];

BOTTOM_FRONT = chasisPoint(BOTTOM_FRONT_WHEEL.y - BORDER,  BOTTOM);
BOTTOM_CENTER = chasisPoint(0, BOTTOM);
TOP_CENTER = chasisPoint(0, TOP);
TOP_FRONT = chasisPoint(BOTTOM_FRONT.y - DELTA_FRONT, TOP);

// Utility function
function gearPoint(p0, p1) = let(
    p = circleIntersection(
        [
            TOP_FRONT_WHEEL.y,
            TOP_FRONT_WHEEL.z
        ],
        CHASIS_WHEEL_SIZE / 2,
        [p0.y, p0.z], 
        [p1.y, p1.z])
) [0, p[0].x, p[0].y];

function toSide2D(points) = [
    for(pos = points)
        [pos.z, pos.y]
];

TOP_GEAR = gearPoint(TOP_FRONT, TOP_CENTER);
BOTTOM_GEAR = gearPoint(TOP_FRONT, BOTTOM_FRONT);

CHASIS_POINTS = [
    BOTTOM_FRONT,
    BOTTOM_CENTER,
    TOP_CENTER,
    TOP_GEAR,
    TOP_FRONT,
    BOTTOM_GEAR
];

// Debug parts
module debugTransmission() {
    topFront = getTopFront();
    
    render() {
        translate([0, topFront.y, topFront.z])
        rotate([0, 90, 0])
            gear(WHEEL_GEAR_DEF);
    }
}
