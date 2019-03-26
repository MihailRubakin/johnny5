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
    
    module body() {
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
    
    module bottomGuide() {
        DEPTH = 0.4;
        translate([BOLT_DIAMETER, BOLT_DIAMETER, thickness - DEPTH])
            linear_extrude(DEPTH)
            circle(d=2);
    }
    
    rotate([90, 0, 0])
    difference() {
        body();
        bottomGuide();
    }
}

rotate([-90, 0, 0])
topHinge(
    SHORT, BOTTOM_SLOPE, 
    SHORT, TOP_SLOPE, 
    thickness=THICKNESS);