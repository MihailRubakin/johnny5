use <../../libs/scad-utils/morphology.scad>

include <../../libs/nutsnbolts/cyl_head_bolt.scad>

use <../wheelAssembly.scad>
use <../thread.scad>

use <../lib/utils.scad>

include <../constant.scad>

// TODO: Move to constant file
WIDTH = 136;
GEAR_CLEARANCE = 1;
THICKNESS = CHASIS_THICKNESS;

FULL_WIDTH = WIDTH + 2 * THICKNESS;
BORDER = THREAD_SIZE.z + 2;

ROUNDING = 5;
FILLET = 10;

SCREW_SPACING = 10;
SCREW_NAME = "M3";
SCREW_LENGTH = 12;
SCREW_NUT_DISTANCE = 2 * THICKNESS;

PLATE_CLEARANCE = 0.3;

WHEEL_DIAMETER = getThreadRingDiameter(WHEEL_THREAD_COUNT)  - THREAD_SIZE.z;
SHAFT_DIAMETER = WHEEL_SHAFT_DIAMETER;

WHEEL_GEAR_DIAMETER = prop("tipDiameter", WHEEL_GEAR_DEF);
CHASIS_WHEEL_SIZE = WHEEL_GEAR_DIAMETER 
    + 2 * GEAR_CLEARANCE
    + BORDER;
    
INNER_THICKNESS = 10;

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
MOTOR_GEAR_DIAMETER = prop("tipDiameter", MOTOR_GEAR_DEF);

WHEEL_TO_MOTOR_DISTANCE = getGearCenterDistance(WHEEL_GEAR_DEF, MOTOR_GEAR_DEF);

GEARBOX_WHEEL_DIAMETER = WHEEL_GEAR_DIAMETER + 2 * GEAR_CLEARANCE;
GEARBOX_MOTOR_DIAMETER = MOTOR_GEAR_DIAMETER + 2 * GEAR_CLEARANCE;

GEARED_WHEEL_CENTER = [TOP_FRONT_WHEEL.z, TOP_FRONT_WHEEL.y];
MOTOR_GEAR_ANGLE = 0;
MOTOR_GEAR_CENTER = GEARED_WHEEL_CENTER+ [
    cos(MOTOR_GEAR_ANGLE + 90) * WHEEL_TO_MOTOR_DISTANCE, 
    sin(MOTOR_GEAR_ANGLE + 90) * WHEEL_TO_MOTOR_DISTANCE
];

// Screws
TOP_PLATE_SIZE = abs(TOP_FRONT_WHEEL.y) - SHAFT_DIAMETER - SCREW_SPACING;
BOTTOM_PLATE_SIZE = abs(BOTTOM_FRONT_WHEEL.y) - SHAFT_DIAMETER - 2 * SCREW_SPACING;

SCREW_OFFSET_X = THICKNESS + INNER_THICKNESS / 2;

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
module roundedShape() {   
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
    
    center = [TOP_FRONT_WHEEL.z, TOP_FRONT_WHEEL.y];
    
    maskWidth = TOP_FRONT_WHEEL.y - TOP_FRONT.y;
    maskHeight = CHASIS_WHEEL_SIZE;
    
    fillet(r=FILLET)
    union() {
        difference() {
            union() {
                rounding(r=ROUNDING)
                    baseShape();
                squareEdge();
            }
            
            translate([0, -maskWidth/2])
            translate(center)
                square([maskHeight, maskWidth], center=true);
        }
        translate(center)
            circle(d=CHASIS_WHEEL_SIZE);
    }
    squareEdge();
}

// Screws
module screwHoleThrought() {
    rotate([0, -90, 0])
    translate([0, 0, 1.5 * THICKNESS])
        hole_through(SCREW_NAME, 3 * THICKNESS);
}

module dualScrewHole(posX, posY, rotation) {
    rotVector = [0, 0, rotation];
    
    translate([posX, posY, SCREW_OFFSET_X])
    rotate(rotVector) 
    mirror([0, 0, 1])
        screwHoleThrought();
    
    translate([posX, posY, FULL_WIDTH - SCREW_OFFSET_X])
    rotate(rotVector)
        screwHoleThrought();
}

module screwSlot(rotation=0) {
    topClearance = 10;
    
    translate([0, 0, SCREW_OFFSET_X])
    rotate([0, 90, 0])
    rotate([rotation, 0, 0]) {
        translate([0, 0, topClearance])
            hole_through(SCREW_NAME, SCREW_LENGTH + topClearance);
        rotate([0, 0, 180])
        translate([0, 0, -SCREW_NUT_DISTANCE])
            nutcatch_sidecut(SCREW_NAME);
    }
}

module flatPlateScrewHole(posX, size, rotation=0) {
    rotVector = [0, 0, rotation];
    
    dualScrewHole(posX, -SCREW_SPACING, rotation);
    dualScrewHole(posX, -size + SCREW_SPACING, rotation);
}

module flatPlateScrewSlot(posX, size, rotation=0) {
    translate([posX, -SCREW_SPACING, 0])
            screwSlot(rotation);
    translate([posX, -size + SCREW_SPACING, 0])
            screwSlot(rotation);
}

function getEndPlateDiagScrew() = let(
        angle = atan2(BOTTOM_FRONT.y - MIDDLE_FRONT.y, BOTTOM_FRONT.z - MIDDLE_FRONT.z),
        reverseAngle = atan2(BOTTOM_FRONT.z - MIDDLE_FRONT.z,   BOTTOM_FRONT.y - MIDDLE_FRONT.y),
        height = TOP - BOTTOM,
        deltaX = (height - CHASIS_WHEEL_SIZE) / 2
    ) [
        BOTTOM + deltaX,
        BOTTOM_FRONT.y + tan(angle) * deltaX,
        reverseAngle
    ];

module endPlateScrewHole() {
    dualScrewHole(TOP, -TOP_PLATE_SIZE - SCREW_SPACING, 0);
    dualScrewHole(BOTTOM, -BOTTOM_PLATE_SIZE - SCREW_SPACING, 180);
    dualScrewHole(TOP_FRONT_WHEEL.z, TOP_FRONT_WHEEL.y - CHASIS_WHEEL_SIZE / 2, 90);
    
    diag = getEndPlateDiagScrew();
    dualScrewHole(diag.x, diag.y, diag[2] + 90);
}

module endPlateScrewSlot() {
    translate([TOP, -TOP_PLATE_SIZE - SCREW_SPACING, 0])
            screwSlot();
    translate([BOTTOM, -BOTTOM_PLATE_SIZE - SCREW_SPACING, 0])
            screwSlot(180);
    translate([TOP_FRONT_WHEEL.z, TOP_FRONT_WHEEL.y - CHASIS_WHEEL_SIZE / 2, 0])
            screwSlot(90);
    
    diag = getEndPlateDiagScrew();

    translate([diag.x, diag.y, 0])
        screwSlot(diag[2] + 180);
}