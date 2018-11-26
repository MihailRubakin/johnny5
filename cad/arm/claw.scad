include <constant.scad>

module clawHinge(size, angle, width=1, thickness=1) {
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