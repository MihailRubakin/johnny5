include <constant.scad>
use <servo.scad>
use <utils.scad>

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
        
        translate([0, -THICKNESS, 0])
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

// stl = "segmentServoLong";

rotate([-90, 0, 0]) {
    if (stl == "segmentShort") {
        // x2
        segment(SHORT, THICKNESS);
    } else if (stl == "segmentLong") {
        // x5
        segment(LONG, THICKNESS);
    } else if (stl == "segmentServoShort") {
        // x1
        servoSegment(SHORT, THICKNESS);
    } else if (stl == "segmentServoLong") {
        // x1
        servoSegment(LONG, THICKNESS);
    } else if (stl == "segmentDouble") {
        // x1
        doubleSegment(SHORT, LONG, THICKNESS);
    }
}