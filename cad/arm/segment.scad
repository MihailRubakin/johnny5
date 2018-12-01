include <constant.scad>
use <servo.scad>
use <utils.scad>

CLEARED_THICKNESS = THICKNESS - 2 * CLEARANCE;

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

module servoSegment(length, thickness=1) {
    difference() {
        segment(length, thickness);
        
        translate([0, -thickness, 0])
        rotate([180, 0, 0])
            baseServo();
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

DEBUG_STL = "segmentShort";

function isDebug() = $stl == undef;

module main(stl, pos=0, rotationZ=0) {
    
    // Debug bed
    if (isDebug()) {
        % square(BED_DIMENSION, center=true);
    }
    
    translate([pos, pos, 0])
    rotate([-90, 0, rotationZ]) {
        if (stl == "segmentShort") {
            // x2
            segment(SHORT, CLEARED_THICKNESS);
        } else if (stl == "segmentLong") {
            // x5
            segment(LONG, CLEARED_THICKNESS);
        } else if (stl == "segmentServoShort") {
            // x1
            servoSegment(SHORT, CLEARED_THICKNESS);
        } else if (stl == "segmentServoLong") {
            // x1
            servoSegment(LONG, CLEARED_THICKNESS);
        } else if (stl == "segmentDouble") {
            // x1
            doubleSegment(SHORT, LONG, CLEARED_THICKNESS);
        }
    }
}

if (isDebug()) {
    main(
        stl=DEBUG_STL, 
        pos=-(BED_DIMENSION - SEGMENT_WIDTH) / 2,
        rotationZ=45);
} else {
    echo(str("Exporting ", $stl, ".stl"));
    main(stl=$stl);
}