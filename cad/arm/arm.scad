include <constant.scad>
use <base.scad>
use <claw.scad>
use <segment.scad>
use <spacer.scad>
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
    
    yPos = getYPositions(thickness=THICKNESS, center=CENTER);
    
    segmentThickness = THICKNESS - 2 * CLEARANCE;
    
    // debugSphere(B);
    
    // Hinges
    hingesYCoords = [
        yPos[0],
        yPos[2],
    ];
    
    base();
    
    hingeDuplicator(hingesYCoords) {
        translate([B.x, 0, B.y])
            topHinge(
                SHORT, BOTTOM_SLOPE, 
                SHORT, TOP_SLOPE, 
                thickness=THICKNESS);
    }
    
    translate([0, yPos[4], 0])
    hingeDuplicator(hingesYCoords) {
        translate([B.x, 0, B.y])
        rotate([0, -(90 + TOP_SLOPE), 0])
            segment(SHORT, thickness=THICKNESS);
    }
    
    translate([C.x, 0, C.y])
        clawHinge(SHORT, TOP_SLOPE, 
            width=CLAW_WIDTH, 
            thickness=THICKNESS);
    
    // Segments
    translate([A.x, yPos[1] - CLEARANCE, A.y])
    rotate([0, angleH - 90, 0])
        segment(LONG, thickness=segmentThickness);
        
    translate([D.x, yPos[1] - CLEARANCE, D.y])
    rotate([0, angleH - 90, 0])
        segment(LONG, thickness=segmentThickness);
    
    hingeDuplicator([
        yPos[1] - CLEARANCE, 
        yPos[5] - CLEARANCE
    ]) {
        translate([E.x, 0, E.y])
        rotate([0, angleV + 180, 0])
            segment(LONG, thickness=segmentThickness);
    }
    
    translate([0, yPos[5] - CLEARANCE, 0])
    rotate([0, angleV, 0])
        segment(SHORT, thickness=segmentThickness);
    
    translate([0, yPos[4] - CLEARANCE, 0])
    hingeDuplicator(hingesYCoords) {
        translate([F.x, 0, F.y])
        rotate([0, angleH - 90, 0])
            segment(LONG, thickness=segmentThickness);
    }
    
    // Spacers
    translate([B.x, yPos[3] - CLEARANCE, B.y])
    rotate([90, 0, 0])
        spacer(CENTER - 2 * CLEARANCE);
    
    translate([E.x, yPos[3] - CLEARANCE, E.y])
    rotate([90, 0, 0])
        spacer(CENTER - 2 * CLEARANCE);
    
    angleLong = atan2(B.y - C.y, B.x - C.x);
    
    translate([G.x, yPos[5], G.y])
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

function getArmOffset() = [
    0,
    getSizeY(thickness=THICKNESS, center=CENTER) / 2,
    SEGMENT_WIDTH / 2 + CLEARANCE + THICKNESS
];

translate(getArmOffset())
    armAssembly();