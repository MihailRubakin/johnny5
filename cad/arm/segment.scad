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

module longSegment(short, long, thickness=1) {
    render()
    difference() {
        segment(short + long, thickness);
        
        translate([short, 0, 0])
        rotate([90, 0, 0])
            cylinder(thickness, d=BOLT_DIAMETER);
    }
}

module topSegment(pos, angle) {
    clearanceX = (BOLT_DIAMETER + SEGMENT_WIDTH) / 2;
    sizeX = LONG - 2 * clearanceX;
    sizeY = CENTER;
    
    translate([pos.x, 0, pos.y])
    rotate([0, angle, 0])
    union() {
        translate([sizeX / 2 + clearanceX, -sizeY/2, 0])
            cube([sizeX, sizeY, SEGMENT_WIDTH], center=true);

        hingeDuplicator([
            0, 
            -2 * THICKNESS, 
            -CENTER + 2 * THICKNESS, 
            -CENTER
        ]) {
                segment(LONG, thickness=THICKNESS);
        }
    }
}

rotate([-90, 0, 0]) {
    // Need 2
    // segment(SHORT, THICKNESS);
    
    // Need 4
    // segment(LONG, THICKNESS);
    
    // Need 1
    // servoSegment(SHORT, THICKNESS);
    
    // Need 1
    // servoSegment(LONG, THICKNESS);
    
    // Need 1
    // longSegment(SHORT, LONG, THICKNESS);
    
    // Need 1
    //topSegment([0, 0], 0);
}