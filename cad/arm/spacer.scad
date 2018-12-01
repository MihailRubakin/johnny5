include <constant.scad>

module spacer(thickness=1) {
    difference() {
        cylinder(thickness, d=SEGMENT_WIDTH);
        cylinder(thickness, d=BOLT_DIAMETER);
    }
}

spacer(CENTER - 2 * CLEARANCE);