DEBUG = false;
DEBUG_BOLT = false;

$fn = DEBUG ? 0 : 100;

SEGMENT_WIDTH = 2;
BOLT_DIAMETER= 0.75;

HINGE_ROUND = 1;

SHORT = 10;
LONG = 30;
CLAW_WIDTH = 3;
THICKNESS = 1;

BOTTOM_SLOPE = 30;
TOP_SLOPE = 10;

CENTER = 8;

module segment(length, thickness=1) {
    rotate([90, 0, 0])
    linear_extrude(thickness)
    difference() {
        hull() {
            circle(r=SEGMENT_WIDTH / 2);
            translate([length, 0, 0])
                circle(r=SEGMENT_WIDTH / 2);
        };
        circle(r=BOLT_DIAMETER / 2);
        translate([length, 0, 0])
            circle(r=BOLT_DIAMETER / 2);
    }
}

module longSegment(short, long, thickness=1) {
    render()
    difference() {
        segment(short + long, thickness);
        
        translate([short, 0, 0])
        rotate([90, 0, 0])
            cylinder(thickness, r=BOLT_DIAMETER / 2);
    }
}

function getHingeTopCoords(size, angle) = 
    let(computedAngle = 90 + angle) [
        cos(computedAngle) * size,
        sin(computedAngle) * size
    ];

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
        getHingeTopCoords(sizeV, angleV)
    ];
    
    rotate([90, 0, 0])
    linear_extrude(thickness)
    difference() {
        minkowski() {
            polygon(coords);
            circle(r=HINGE_ROUND);
        };
        for (i=[0:2])
            translate([coords[i].x, coords[i].y, 0])
                circle(r=BOLT_DIAMETER / 2);
    }
}

module clawHinge(size, angle, width=1, thickness=1) {
    top = getHingeTopCoords(size, angle);
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
            circle(r=HINGE_ROUND);
        };
        translate([0, 0, 0])
            circle(r=BOLT_DIAMETER / 2);
        translate([top.x, top.y, 0])
            circle(r=BOLT_DIAMETER / 2);
    }
}

function bottomHingeCoords(size, angle) = [
    cos(angle) * size,
    sin(angle) * size
];

module bottomHinge(size, angle, thickness=1) {
    point = bottomHingeCoords(size, angle);
    
    coords = [
        [0, 0],
        [point.x, 0],
        point
    ];
    
    rotate([90, 0, 0])
    linear_extrude(thickness)
    difference() {
        minkowski() {
            polygon(coords);
            circle(r=HINGE_ROUND);
        };
        circle(r=BOLT_DIAMETER / 2);
        translate([point.x, point.y, 0])
            circle(r=BOLT_DIAMETER / 2);
    };
}

module hingeDuplicator(yCoords) {
    for (y = yCoords)
        translate([0, y, 0])
            children();
}

module debugSphere(pos) {
    color("red")
    translate([pos.x, 0, pos.y])
        sphere(r=2);
}

module debugBolt(length, pos, y = 0) {
    color("blue")
    translate([pos.x, y, pos.y])
    rotate([90, 0, 0])
        cylinder(length, r=0.25);
}

module armAssembly(angleH=0, angleV=0) {
    // Base anchor
    A = [ 0, 0 ];
    
    // Top hinge base pivot
    B = [
        A.x + cos(90 - angleH) * LONG,
        A.y + sin(90 - angleH) * LONG
    ];
    
    // Tip base pivot
    C = [
        B.x + cos(180 - angleV) * LONG,
        B.y + sin(180 - angleV) * LONG
    ];    
    
    // Base back anchor
    D = [
        A.x + cos(BOTTOM_SLOPE) * SHORT,
        A.y + sin(BOTTOM_SLOPE) * SHORT,
    ];
    
    // Top hinge top pivot
    topHingeTopCoords = getHingeTopCoords(SHORT, TOP_SLOPE);
    E = [
        B.x + topHingeTopCoords.x,
        B.y + topHingeTopCoords.y
    ];
    
    // Base back pivot
    F = [
        A.x + cos(-angleV) * SHORT,
        A.y + sin(-angleV) * SHORT
    ];
    
    // Forearm top pivot
    G = [
        F.x + cos(90 - angleH) * LONG,
        F.y + sin(90 - angleH) * LONG
    ];
    
    // debugSphere(F);
    
    // Hinges
    hingesYCoords = [
        -THICKNESS,
        THICKNESS,
    ];
    
    hingeDuplicator(hingesYCoords) {
        bottomHinge(SHORT, BOTTOM_SLOPE, thickness=THICKNESS);
    }
    
    hingeDuplicator(hingesYCoords) {
        translate([B.x, 0, B.y])
            topHinge(
                SHORT, BOTTOM_SLOPE, 
                SHORT, TOP_SLOPE, 
                thickness=THICKNESS);
    }
    
    // TODO: Remove and add to top hinge
    translate([0, -CENTER, 0])
    hingeDuplicator(hingesYCoords) {
        translate([B.x, 0, B.y])
        rotate([0, -(90 + TOP_SLOPE), 0])
            segment(SHORT, thickness=THICKNESS);
    }
    
    hingeDuplicator(concat(hingesYCoords, [
        hingesYCoords[0] - CENTER, 
        hingesYCoords[1] - CENTER
    ])) {
        translate([C.x, 0, C.y])
            clawHinge(SHORT, TOP_SLOPE, width=CLAW_WIDTH, thickness=THICKNESS);
    }
    
    // TODO: Remove and create a claw piece
    scaleY = 2 * THICKNESS + CENTER;
    translate([C.x - CLAW_WIDTH - HINGE_ROUND, -scaleY, C.y])
        cube([1, scaleY, cos(TOP_SLOPE) * SHORT]);
    
    // Segments
    rotate([0, angleH - 90, 0])
        segment(LONG, thickness=THICKNESS);
        
    translate([D.x, 0, D.y])
    rotate([0, angleH - 90, 0])
        segment(LONG, thickness=THICKNESS);
    
    hingeDuplicator([0, -CENTER]) {
        translate([E.x, 0, E.y])
        rotate([0, angleV + 180, 0])
            segment(LONG, thickness=THICKNESS);
    }
    
    translate([0, -CENTER, 0])
    rotate([0, angleV, 0])
        segment(SHORT, thickness=THICKNESS);
    
    translate([0, -CENTER, 0])
    hingeDuplicator(hingesYCoords) {
        translate([F.x, 0, F.y])
        rotate([0, angleH - 90, 0])
            segment(LONG, thickness=THICKNESS);
    }
    
    angleLong = atan2(B.y - C.y, B.x - C.x);
    
    translate([G.x, -CENTER, G.y])
    rotate([0, 180 - angleLong, 0])
        longSegment(SHORT, LONG, thickness=THICKNESS);
    
    if (DEBUG_BOLT) {
        shortLength = 3 * THICKNESS;
        fullLength = 3 * THICKNESS + CENTER;
        
        debugBolt(3 * THICKNESS, A, THICKNESS);
        debugBolt(fullLength, B, THICKNESS);
        debugBolt(fullLength, C, THICKNESS);
        debugBolt(shortLength, D, THICKNESS);
        debugBolt(fullLength, E, THICKNESS);
        debugBolt(shortLength, F, THICKNESS - CENTER);
        debugBolt(shortLength, G, THICKNESS - CENTER);
    }
}

armAssembly();

// segment(10);
// longSegment(10, 30);
// topHinge(10, 30, 10, 0);
// clawHinge(10, 10);