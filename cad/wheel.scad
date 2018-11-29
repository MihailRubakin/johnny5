use <lib/gear.scad>
use <lib/utils.scad>
use <tooth.scad>
include <constant.scad>

$fn = getFragmentCount(debug=false);

GEARED = true;

$fn= DEBUG ? 0 : 100;

TOOTH_COUNT = 14;
DIAMETER = diameterFromToothCount(TOOTH_SIZE.y, TOOTH_SPACING, TOOTH_COUNT);

HEIGHT = THREAD_SIZE.x;
SPACER = 2;

TOOTH_CLEARANCE = 0.3;

GEAR_TOOTHS = 60;
GEAR_DEF = defGear(GEAR_TOOTHS, GEAR_MOD, 
            faceWidth=FACE_WIDTH,
            shaft=SHAFT_DIAMETER,
            bearings=[
                defBearing(BEARING_DIAMETER, BEARING_HEIGHT, 1)
            ]);

ITERATIONS = $fn > 0 ? $fn : TOOTH_COUNT;

echo("Tooth count = ", TOOTH_COUNT);
echo("Diameter = ", DIAMETER);
echo("Height = ", HEIGHT);

module body() {
    step = DEBUG ? (360 / TOOTH_COUNT / 2) : 1;
    
    toothHeight = TOOTH_SIZE.x + 2 * TOOTH_CLEARANCE;
    
    module toothRing() {
        toothX= TOOTH_SIZE.y + 2 * TOOTH_CLEARANCE;
        toothY = TOOTH_SIZE.z + TOOTH_CLEARANCE;
        toothSpacing = TOOTH_SPACING - 2 * TOOTH_CLEARANCE;
        
        intersection() {
            circle(r=DIAMETER/2);
            toothRing2D(toothX, toothY,
                count=TOOTH_COUNT,
                spacing=toothSpacing,
                step=step);
        }
    }
    
    module toothCylinder() {
        linear_extrude(toothHeight)
            toothRing();
    }
    
    module pulleyCylinder() {
        toothY = TOOTH_SIZE.z + TOOTH_CLEARANCE;
        cylinder(toothHeight, r=DIAMETER / 2 - toothY);
    }
    
    module trigCylinder(height, radius) {
        coords = [
            for(i = [0:step:360]) [
                cos(i) * radius,
                sin(i) * radius
            ]
        ];
            
        linear_extrude(height)
            polygon(coords);
    }
    
    sectionHeight = (HEIGHT - toothHeight) / 2;
    
    module middleSection() {
        chamferSize = TOOTH_SIZE.z + TOOTH_CLEARANCE;
        smallRadius = DIAMETER / 2 - chamferSize;
        largeRadius = DIAMETER / 2;
        
        union() {
            cylinder(chamferSize, r1=largeRadius, r2=smallRadius);
            
            if (GEARED) {
                toothCylinder();
            } else {
                pulleyCylinder();
            }
            
            translate([0, 0, TOOTH_SIZE.x + 2 * TOOTH_CLEARANCE - chamferSize])
                cylinder(chamferSize, r1=smallRadius, r2=largeRadius);
        }
    }
    
    module topBottom() {
        cylinder(sectionHeight, r=DIAMETER / 2);
    }
    
    union() {
        topBottom();
        translate([0, 0, sectionHeight])
            middleSection();
        translate([0, 0, sectionHeight + toothHeight])
            topBottom();
    }
}

module shaft() {        
    union() {
        // shaft
        cylinder(HEIGHT, r=SHAFT_DIAMETER/2);
        // bearing
        translate([0, 0, 0])
            cylinder(BEARING_HEIGHT, r=BEARING_DIAMETER/2);
    };
}
    
module wheelAssembly() {
    module wheel() {
        difference() {
            body();
            shaft();
        }
    }
    
    module spacer() {
        tipDiameter = prop("tipDiameter", GEAR_DEF);

        translate([0, 0, HEIGHT])
            difference() {
                cylinder(SPACER, r=tipDiameter/2);
                cylinder(SPACER, r=SHAFT_DIAMETER/2);
            }
    }
    
    if (GEARED) {
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
    toothHeight = TOOTH_SIZE.x + 2 * TOOTH_CLEARANCE;
    sectionHeight = (HEIGHT - toothHeight) / 2 + TOOTH_CLEARANCE;
    intersection() {
        translate([0, 0, -sectionHeight])
            body();
        translate([0, 0, height/2])
            cube([DIAMETER, DIAMETER, height], center=true);
    }
}

wheelAssembly();