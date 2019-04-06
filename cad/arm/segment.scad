include <constant.scad>
use <servo.scad>
use <utils.scad>

FILENAME_SHORT = "segmentShort";
FILENAME_LONG = "segmentLong";
FILENAME_SERVO_SHORT = "segmentServoShort";
FILENAME_SERVO_LONG = "segmentServoLong";
FILENAME_DOUBLE = "segmentDouble";

DEBUG_STL = FILENAME_SERVO_SHORT;

module segment(length, thickness=1) {
    rotate([90, 0, 0])
    linear_extrude(thickness)
    difference() {
        hull() {
            circle(d=SEGMENT_WIDTH);
            translate([length, 0, 0])
                circle(d=SEGMENT_WIDTH);
        };
        circle(d=BOLT_DIAMETER);
        translate([length, 0, 0])
            circle(d=BOLT_DIAMETER);
    }
}

module servoHorn(thickness=1) {
    translate([0, 0, thickness - 1])
        cylinder(1, d=7.5);
    
    translate([0, 15/2, 0])
        cylinder(thickness, d=1);
    translate([0, -15/2, 0])
        cylinder(thickness, d=1);
    translate([13/2, 0, 0])
        cylinder(thickness, d=1);
    translate([-13/2, 0, 0])
        cylinder(thickness, d=1);
}

module servoSegment(length, thickness=1) {
    difference() {
        segment(length, thickness);
        
        rotate([90, 0, 0])
            servoHorn(thickness);
    }
}

module doubleSegment(short, long, thickness=1) {
    render()
    difference() {
        segment(short + long, thickness);
        
        translate([short, 0, 0])
        rotate([90, 0, 0])
            cylinder(thickness, d=BOLT_DIAMETER);
    }
}

function isDebug() = $stl == undef;

module main(stl, pos=0) {    
    translate([pos, pos, 0])
    rotate([-90, 0, 45]) {
        if (stl == FILENAME_SHORT) {
            // x2
            segment(SHORT, THICKNESS);
        } else if (stl == FILENAME_LONG) {
            // x5
            segment(LONG, THICKNESS);
        } else if (stl == FILENAME_SERVO_SHORT) {
            // x1
            servoSegment(SHORT, THICKNESS);
        } else if (stl == FILENAME_SERVO_LONG) {
            // x1
            servoSegment(LONG, THICKNESS);
        } else if (stl == FILENAME_DOUBLE) {
            // x1
            doubleSegment(SHORT, LONG, THICKNESS);
        }
    }
}

if (isDebug()) {
    // Debug bed
    % square(BED_DIMENSION, center=true);
    
    main(stl=DEBUG_STL, pos=-(BED_DIMENSION - SEGMENT_WIDTH) / 2);
} else {
    echo(str("Exporting ", $stl, ".stl"));
    main(stl=$stl);
}