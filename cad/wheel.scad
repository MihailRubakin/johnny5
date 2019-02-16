use <lib/gear.scad>
use <lib/utils.scad>
use <tooth.scad>
use <thread.scad>
include <constant.scad>

DEBUG = false;
GEARED = true;
SHOW_RING = false;
SHOW_TOOTH = false;

SHAFT_DIAMETER = WHEEL_SHAFT_DIAMETER;
BEARING_DIAMETER = WHEEL_BEARING_DIAMETER;
BEARING_HEIGHT = WHEEL_BEARING_HEIGHT;

$fn = getFragmentCount(debug=DEBUG);

TOOTH_COUNT = WHEEL_THREAD_COUNT;
DIAMETER = getThreadRingDiameter(TOOTH_COUNT) - THREAD_SIZE.z;

HEIGHT = THREAD_SIZE.x;

TOOTH_CLEARANCE = 0.3;

GEAR_DEF = WHEEL_GEAR_DEF;

TOOTH_HEIGHT = TOOTH_SIZE.x + TOOTH_CLEARANCE / 2;
SECTION_HEIGHT = (HEIGHT - TOOTH_HEIGHT) / 2;

echo("Tooth count = ", TOOTH_COUNT);
echo("Diameter = ", DIAMETER);
echo("Height = ", HEIGHT);
echo("Tip diameter = ", prop("tipDiameter", GEAR_DEF));

module body(geared=false) {
    step = DEBUG ? (360 / TOOTH_COUNT / 2) : 1;
    
    apothem = (DIAMETER / 2) * cos(180 / TOOTH_COUNT);
    clearedDiameter = 2 * apothem - 2 * TOOTH_CLEARANCE;
    
    chamferSize = TOOTH_SIZE.z;
    small = clearedDiameter - 2 * chamferSize;
    
    module centeredTooth() {
        sizeX = TOOTH_SIZE.y + 2 * TOOTH_CLEARANCE;
        sizeY = TOOTH_SIZE.z;
        
        translate([-sizeX / 2, 0, 0])
            tooth2D(sizeX, sizeY);
    }
    
    module toothRing() {
        clearedApothem = apothem - TOOTH_CLEARANCE;
        
        for (i = [0:TOOTH_COUNT]) {
            a = i * 360 / TOOTH_COUNT;
            x = sin(a) * clearedApothem;
            y = cos(a) * clearedApothem;
            
            translate([x, y, 0])
            rotate([0, 0, 180 - i * 360 / TOOTH_COUNT])
                centeredTooth();
        }
    }
    
    module toothCylinder() {
        linear_extrude(TOOTH_HEIGHT)
            difference() {
                circle(d=clearedDiameter);
                toothRing();
            }
    }
    
    module pulleyCylinder() {
        cylinder(TOOTH_HEIGHT, d=small);
    }
    
    module middleSection() {
        union() {            
            cylinder(chamferSize, d1=clearedDiameter, d2=small);
            
            if (geared) {
                toothCylinder();
            } else {
                pulleyCylinder();
            }
            
            translate([0, 0, TOOTH_HEIGHT - chamferSize])
                cylinder(chamferSize, d1=small, d2=clearedDiameter);
        }
    }
    
    module top() {
        heightDifference = geared ? WHEEL_GEAR_FACE_WIDTH : 0;
        height = SECTION_HEIGHT - heightDifference;
        cylinder(height, d=clearedDiameter);
    }
    
    module bottom() {
        cylinder(SECTION_HEIGHT, d=clearedDiameter);
    }

    union() {
        bottom();
        translate([0, 0, SECTION_HEIGHT])
            middleSection();
        translate([0, 0, SECTION_HEIGHT + TOOTH_HEIGHT])
            top();
    }
}

module shaft(geared=false) {
    union() {
        // Top bearing (only on pulley)
        if (!geared) {
            translate([0, 0, HEIGHT - BEARING_HEIGHT])
                cylinder(BEARING_HEIGHT, d=BEARING_DIAMETER);
        }
        
        // shaft
        cylinder(HEIGHT, d=SHAFT_DIAMETER);
        // bearing
        cylinder(BEARING_HEIGHT, d=BEARING_DIAMETER);
    };
}
    
module wheelAssembly(geared=false) {
    module wheel() {
        difference() {
            body(geared=geared);
            shaft(geared=geared);
        }
    }
    
    if (geared) {
        render() {
            // Gear
            translate([0, 0, HEIGHT - WHEEL_GEAR_FACE_WIDTH]) 
                gear(GEAR_DEF);
            
            wheel();
        }
    } else {
        render() {
            wheel();
        }
    }
}

module test() {
    height = 1;
    
    intersection() {
        translate([0, 0, -SECTION_HEIGHT])
            body();
        translate([0, 0, height/2])
            cube([DIAMETER, DIAMETER, height], center=true);
    }
}

if (SHOW_RING || SHOW_TOOTH) {
    start = 0;
    end = SHOW_RING ? TOOTH_COUNT : 0;
    
    rotate([0, 0, 360 / TOOTH_COUNT / 2])
    translate([0, 0, SECTION_HEIGHT + TOOTH_HEIGHT / 2])
            threadRing(TOOTH_COUNT, start=start, end=end);
}

wheelAssembly(geared=GEARED);