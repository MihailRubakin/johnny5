include <constant.scad>
use <utils.scad>

module clawBase(boltY, sizeY) {
    sizeX = CLAW_WIDTH - SEGMENT_WIDTH / 2;
    sizeZ = cos(TOP_SLOPE) * SHORT;
    
    difference() {
        translate([
            0, 
            -sizeY, 
            0
        ]) cube([
                sizeX, 
                sizeY, 
                sizeZ
            ]);
    
        hingeDuplicator([
            -boltY,
            -(sizeY - boltY)
        ]) {
            translate([0, 0, 1/4 * sizeZ])
            rotate([0, 90, 0])
                cylinder(sizeX, d=BOLT_DIAMETER);
            translate([0, 0, 3/4 * sizeZ])
            rotate([0, 90, 0])
                cylinder(sizeX, d=BOLT_DIAMETER);
        }
    }
}

module clawSingleSection(top, width=1, thickness=1) {
    difference() {
        hull() {
            translate([top.x, 0, top.y])
            rotate([90, 0, 0])
                cylinder(thickness, d=SEGMENT_WIDTH);
            
            translate([-CLAW_WIDTH, 0, top.y])
            rotate([90, 0, 0])
                cylinder(thickness, d=SEGMENT_WIDTH);
        }
        
        translate([top.x, 0, top.y])
        rotate([90, 0, 0])
            cylinder(thickness, d=BOLT_DIAMETER);
    }
}

module clawDoubleSection(top, width=1, thickness=1) {
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
    yPos = getYPositions(thickness=thickness, center=CENTER);
    sizeY = getSizeY(thickness=thickness, center=CENTER);
    top = getTopCoords(size, angle);
    
    translate([0, yPos[0], 0])
        clawSingleSection(top, width, thickness);    
    
    translate([0, yPos[2], 0])
        clawSingleSection(top, width, CENTER + thickness);
    
    hingeDuplicator([
        yPos[4],
        yPos[6]
    ]) {
        clawDoubleSection(top, width, thickness);
    }
    
    boltY = 3 / 2 * thickness;
    translate([-(CLAW_WIDTH + SEGMENT_WIDTH / 2), 0, 0])
        clawBase(boltY, sizeY);
}

translate([0, 0, CLAW_WIDTH + SEGMENT_WIDTH / 2])
rotate([0, -90, 0])
  clawHinge(SHORT, TOP_SLOPE, width=CLAW_WIDTH, thickness=THICKNESS);