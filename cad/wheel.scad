use <lib/gear.scad>
use <lib/utils.scad>
use <tooth.scad>
use <thread.scad>
include <constant.scad>

DEBUG = false;
GEARED = true;
SHOW_RING = false;
SHOW_TOOTH = false;

$fn = getFragmentCount(debug=DEBUG);

TOOTH_COUNT = 12;
DIAMETER = getThreadRingDiameter(TOOTH_COUNT) - THREAD_SIZE.z;

HEIGHT = THREAD_SIZE.x;
SPACER = 3;

TOOTH_CLEARANCE = 0.3;

GEAR_TOOTHS = 60;
GEAR_DEF = defGear(GEAR_TOOTHS, GEAR_MOD, 
            faceWidth=FACE_WIDTH,
            shaft=SHAFT_DIAMETER,
            bearings=[
                defBearing(BEARING_DIAMETER, BEARING_HEIGHT, 1)
            ]);

TOOTH_HEIGHT = TOOTH_SIZE.x + 2 * TOOTH_CLEARANCE;
SECTION_HEIGHT = (HEIGHT - TOOTH_HEIGHT) / 2;

echo("Tooth count = ", TOOTH_COUNT);
echo("Diameter = ", DIAMETER);
echo("Height = ", HEIGHT);
echo("Tip diameter = ", prop("tipDiameter", GEAR_DEF));

module body(geared=false) {
    step = DEBUG ? (360 / TOOTH_COUNT / 2) : 1;
    
    clearedDiameter = DIAMETER - 2 * TOOTH_CLEARANCE;
    
    module centeredTooth() {
        sizeX = TOOTH_SIZE.y + 2 * TOOTH_CLEARANCE;
        sizeY = TOOTH_SIZE.z + TOOTH_CLEARANCE;
        
        translate([-sizeX / 2, 0, 0])
            tooth2D(sizeX, sizeY);
    }
    
    module toothRing() {
        for (i = [0:TOOTH_COUNT]) {
            radius = DIAMETER / 2;
            apotem = radius * cos(180 / TOOTH_COUNT);
            a = i * 360 / TOOTH_COUNT;
            x = sin(a) * apotem;
            y = cos(a) * apotem;
            
            translate([x, y, 0])
            rotate([0, 0, 180 - i * 360 / TOOTH_COUNT])
                centeredTooth();
        }
    }
    
    module toothCylinder() {
        linear_extrude(TOOTH_HEIGHT)
            difference() {
                circle(d=clearedDiameter, $fn=TOOTH_COUNT);
                rotate([0, 0, 360 / TOOTH_COUNT / 2])
                    toothRing();
            }
    }
    
    module pulleyCylinder() {
        toothY = TOOTH_SIZE.z + TOOTH_CLEARANCE;
        cylinder(TOOTH_HEIGHT, r=clearedDiameter / 2 - toothY, $fn=TOOTH_COUNT);
    }
    
    module middleSection() {
        chamferSize = TOOTH_SIZE.z + TOOTH_CLEARANCE;
        small = clearedDiameter - 2 * chamferSize;
        
        union() {
            cylinder(chamferSize, d1=clearedDiameter, d2=small, $fn=TOOTH_COUNT);
            
            if (geared) {
                toothCylinder();
            } else {
                pulleyCylinder();
            }
            
            translate([0, 0, TOOTH_SIZE.x + 2 * TOOTH_CLEARANCE - chamferSize])
                cylinder(chamferSize, d1=small, d2=clearedDiameter, $fn=TOOTH_COUNT);
        }
    }
    
    module topBottom() {
        cylinder(SECTION_HEIGHT, d=clearedDiameter, $fn=TOOTH_COUNT);
    }
    
    union() {
        topBottom();
        translate([0, 0, SECTION_HEIGHT])
            middleSection();
        translate([0, 0, SECTION_HEIGHT + TOOTH_HEIGHT])
            topBottom();
    }
}

module shaft() {
    union() {
        // shaft
        cylinder(HEIGHT, d=SHAFT_DIAMETER);
        // bearing
        translate([0, 0, 0])
            cylinder(BEARING_HEIGHT, d=BEARING_DIAMETER);
    };
}
    
module wheelAssembly(geared=false) {
    module wheel() {
        difference() {
            body(geared=geared);
            shaft();
        }
    }
    
    module spacer() {
        tipDiameter = prop("tipDiameter", GEAR_DEF);

        translate([0, 0, HEIGHT])
            difference() {
                cylinder(SPACER, d=tipDiameter);
                cylinder(SPACER, d=SHAFT_DIAMETER);
            }
    }
    
    if (geared) {
        render() {
            // Gear
            translate([0, 0, HEIGHT + SPACER]) 
                gear(GEAR_DEF);
            
            spacer();
            
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
    
    % translate([0, 0, SECTION_HEIGHT + TOOTH_HEIGHT / 2])
            threadRing(TOOTH_COUNT, start=start, end=end);
}

wheelAssembly(geared=GEARED);