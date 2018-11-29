include <constant.scad>
use <utils.scad>

module clawBase() {
    sizeY = 3 * THICKNESS + CENTER;
    sizeZ = cos(TOP_SLOPE) * SHORT;
    
    difference() {
        translate([
            0, 
            -sizeY, 
            0
        ]) cube([
                CLAW_WIDTH - SEGMENT_WIDTH / 2, 
                sizeY, 
                sizeZ
            ]);
    
        hingeDuplicator([
            - 3/2 * THICKNESS,
            -(CENTER + 3/2 * THICKNESS)
        ]) {
            translate([0, 0, 1/4 * sizeZ])
            rotate([0, 90, 0])
                cylinder(sizeZ, d=BOLT_DIAMETER);
            translate([0, 0, 3/4 * sizeZ])
            rotate([0, 90, 0])
                cylinder(sizeZ, d=BOLT_DIAMETER);
        }
    }
}

module clawSingleSection(size, angle, width=1, thickness=1) {
    top = getTopCoords(size, angle);
    
    difference() {
        hull() {
            translate([top.x, 0, top.y])
            rotate([90, 0, 0])
                cylinder(THICKNESS, d=SEGMENT_WIDTH);
            
            translate([-CLAW_WIDTH, 0, top.y])
            rotate([90, 0, 0])
                cylinder(THICKNESS, d=SEGMENT_WIDTH);
        }
        
        translate([top.x, 0, top.y])
        rotate([90, 0, 0])
            cylinder(THICKNESS, d=BOLT_DIAMETER);
    }
}

module clawDoubleSection(size, angle, width=1, thickness=1) {
    top = getTopCoords(size, angle);
    coords = [
        [ 0, 0 ],
        top,
        [ -width, top.y ],
        [ -width, 0 ]
    ];
    
    rotate([90, 0, 0])
    linear_extrude(thickness)
    difference() {
        minkowski() {
            polygon(coords);
            circle(d=SEGMENT_WIDTH);
        };
        translate([0, 0, 0])
            circle(d=BOLT_DIAMETER);
        translate([top.x, top.y, 0])
            circle(d=BOLT_DIAMETER);
    }
}

module clawHinge(size, angle, width=1, thickness=1) {    
    hingeDuplicator([
        0,
        -2 * THICKNESS
    ]) {
        clawSingleSection(size, angle, width, thickness);
    }
    
    hingeDuplicator([
        -CENTER,
        -(CENTER + 2 * THICKNESS)
    ]) {
        clawDoubleSection(size, angle, width, thickness);
    }
    
    translate([-(CLAW_WIDTH + SEGMENT_WIDTH / 2), 0, 0])
        clawBase();
}

translate([0, 0, CLAW_WIDTH + THICKNESS])
rotate([0, -90, 0])
  clawHinge(SHORT, TOP_SLOPE, width=CLAW_WIDTH, thickness=THICKNESS);