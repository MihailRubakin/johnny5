/*
A: 35mm
B: 30mm
C: 31mm
D: 13mm
E: 41mm
F: 19mm

40 degree on each side

29x13x30

*/
module baseServo() {
    sizeY = 13;
    baseHeight = 19;
    fixtureHeight = 31 - baseHeight;
    
    rotate([90, 0, 0])
    union() {
        // Tip
        cylinder((35-31), d=10);
        
        
        // Fixture
        translate([41/6, 0, -fixtureHeight / 2])
        cube([41, sizeY, fixtureHeight ], center=true);
        
        // Base
        translate([41/6, 0, -(fixtureHeight + baseHeight/2) ])
        cube([30, sizeY, baseHeight], center=true);
    }
}

/*
23.1x12x25.9

60 degree on each side
*/
module gripServo() {
    
}

baseServo();