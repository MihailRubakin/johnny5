include <constant.scad>
use <base.scad>
use <claw.scad>
use <segment.scad>
use <top.scad>
use <utils.scad>

DEBUG_BOLT = false;

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
    topCoords = getTopCoords(SHORT, TOP_SLOPE);
    E = [
        B.x + topCoords.x,
        B.y + topCoords.y
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
    
    base();
    
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
    
    translate([C.x, THICKNESS, C.y])
        clawHinge(SHORT, TOP_SLOPE, 
            width=CLAW_WIDTH, 
            thickness=THICKNESS);
    
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
        doubleSegment(SHORT, LONG, thickness=THICKNESS);
    
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