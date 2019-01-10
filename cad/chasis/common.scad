use <../../libs/scad-utils/morphology.scad>

use <../wheelAssembly.scad>
use <../thread.scad>

use <../lib/utils.scad>

include <../constant.scad>

SHOW_THREAD = true;
SHOW_WHEEL = false ;

// TODO: Set width
WIDTH = 75;

// TODO: Move to constant file
BORDER = THREAD_SIZE.z + 2;
THICKNESS = CHASIS_THICKNESS;

WHEEL_DIAMETER = getThreadRingDiameter(WHEEL_THREAD_COUNT)  - THREAD_SIZE.z;
SHAFT_DIAMETER = WHEEL_SHAFT_DIAMETER;

GEAR_CLEARANCE = 1;
WHEEL_GEAR_DIAMETER = prop("tipDiameter", WHEEL_GEAR_DEF);
CHASIS_WHEEL_SIZE = WHEEL_GEAR_DIAMETER 
    + 2 * GEAR_CLEARANCE
    + BORDER;
    
ROUNDING = 5;
FILLET = 10;

SCREW_SPACING = 10;
SCREW_NAME = "M3";
SCREW_LENGTH = 20;
SCREW_BORDER = 1;
NUT_DISTANCE = 5;

// Wheels positions
WHEELS = getWheelsPos();
TOP_FRONT_WHEEL = getTopFront();
BOTTOM_FRONT_WHEEL = getBottomFront();

// Chasis size
MIDDLE = TOP_FRONT_WHEEL.z;
TOP = MIDDLE + CHASIS_WHEEL_SIZE / 2;
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
MIDDLE_FRONT = chasisPoint(BOTTOM_FRONT.y - DELTA_FRONT, MIDDLE);
TOP_FRONT = chasisPoint(BOTTOM_FRONT.y - DELTA_FRONT, TOP);

// Gearbox
SMALL_GEAR_DIAMETER = prop("tipDiameter", TRANSMISSION_SMALL_GEAR_DEF);
LARGE_GEAR_DIAMETER = prop("tipDiameter", TRANSMISSION_LARGE_GEAR_DEF);
MOTOR_GEAR_DIAMETER = prop("tipDiameter", MOTOR_GEAR_DEF);

WHEEL_TO_SMALL_DISTANCE = getGearCenterDistance(WHEEL_GEAR_DEF, TRANSMISSION_SMALL_GEAR_DEF);
LARGE_TO_MOTOR_DISTANCE = getGearCenterDistance(TRANSMISSION_LARGE_GEAR_DEF, MOTOR_GEAR_DEF);

GEARBOX_WHEEL_DIAMETER = WHEEL_GEAR_DIAMETER + 2 * GEAR_CLEARANCE;
GEARBOX_SMALL_DIAMETER = SMALL_GEAR_DIAMETER + 2 * GEAR_CLEARANCE;
GEARBOX_LARGE_DIAMETER = LARGE_GEAR_DIAMETER + 2 * GEAR_CLEARANCE;
GEARBOX_MOTOR_DIAMETER = MOTOR_GEAR_DIAMETER + 2 * GEAR_CLEARANCE;

GEARED_WHEEL_CENTER = [TOP_FRONT_WHEEL.z, TOP_FRONT_WHEEL.y];
SMALL_GEAR_CENTER = GEARED_WHEEL_CENTER + [0, WHEEL_TO_SMALL_DISTANCE];

MOTOR_GEAR_ANGLE = 45;
MOTOR_GEAR_CENTER = SMALL_GEAR_CENTER + [
    cos(MOTOR_GEAR_ANGLE + 90) * LARGE_TO_MOTOR_DISTANCE, 
    sin(MOTOR_GEAR_ANGLE + 90) * LARGE_TO_MOTOR_DISTANCE
];

// Utility function

function toSide2D(points) = [
    for(pos = points)
        [pos.z, pos.y]
];

CHASIS_POINTS = [
    BOTTOM_FRONT,
    BOTTOM_CENTER,
    TOP_CENTER,
    TOP_FRONT,
    MIDDLE_FRONT
];
    
module wheelShafts() {
    wheels2D = toSide2D(WHEELS);
    for (pos = wheels2D)
            translate(pos)
            circle(d=SHAFT_DIAMETER);
}
    
// Frame
module baseShape() {
    points2D = toSide2D(CHASIS_POINTS);
    polygon(points2D);
}

module squareEdge() {
    size = max(ROUNDING, FILLET);
    polygon([
        [BOTTOM, 0],
        [TOP, 0],
        [TOP, -size],
        [BOTTOM, -size]
    ]);
}

module ungearedShape() {
    union() {
        squareEdge();
        rounding(r=ROUNDING)
            baseShape();
    }
}

module gearedShape() {
    center = [TOP_FRONT_WHEEL.z, TOP_FRONT_WHEEL.y];
    
    maskWidth = TOP_FRONT_WHEEL.y - TOP_FRONT.y;
    maskHeight = CHASIS_WHEEL_SIZE;
    
    fillet(r=FILLET)
    union() {
        difference() {
            ungearedShape();
            
            translate([0, -maskWidth/2])
            translate(center)
                square([maskHeight, maskWidth], center=true);
        }
        translate(center)
            circle(d=CHASIS_WHEEL_SIZE);
    }
    squareEdge();
}