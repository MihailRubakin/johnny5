include <constant.scad>

module topHinge(sizeH, angleH, sizeV, angleV, thickness=1) {
    coords = [
        // Bottom
        [ 0, 0 ],    
        // Center
        [
            cos(angleH) * sizeH,
            sin(angleH) * sizeH,
        ],
        // Top
        getTopCoords(sizeV, angleV)
    ];
    
    rotate([90, 0, 0])
    linear_extrude(thickness)
    difference() {
        minkowski() {
            polygon(coords);
            circle(d=SEGMENT_WIDTH);
        };
        for (i=[0:2])
            translate([coords[i].x, coords[i].y, 0])
                circle(d=BOLT_DIAMETER);
    }
}