include <constant.scad>
use <utils.scad>

module clawSection(size, angle, width=1, thickness=1) {
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
    translate([0, -THICKNESS, 0])
    mirror([0, 1, 0])
    hingeDuplicator([
        0, 
        2 * THICKNESS,
        CENTER,
        CENTER + 2 * THICKNESS
    ]) {
        clawSection(size, angle, width, thickness);
    }

    scaleY = 2 * THICKNESS + CENTER;
    
    translate([-(CLAW_WIDTH + SEGMENT_WIDTH / 2), -scaleY, 0])
    cube([CLAW_WIDTH - SEGMENT_WIDTH / 2, scaleY, cos(TOP_SLOPE) * SHORT]);
}

rotate([-90, 0, 0])
    clawHinge(SHORT, TOP_SLOPE, width=CLAW_WIDTH, thickness=THICKNESS);