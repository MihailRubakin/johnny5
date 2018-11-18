use <lib/utils.scad>
use <lib/gear.scad>
use <tooth.scad>
include <constant.scad>

DEBUG = false;
GEARED = true;

$fn= DEBUG ? 0 : 100;

TOOTH_COUNT = 14;
DIAMETER = diameterFromToothCount(TOOTH_SIZE.y, TOOTH_SPACING, TOOTH_COUNT);

HEIGHT = THREAD_SIZE.x;
SPACER = 2;

// CHAMFER_HEIGHT = 2.5;

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
    toothHeight = TOOTH_SIZE.x + 2 * TOOTH_CLEARANCE;
    
    module toothChain() {
        toothX= TOOTH_SIZE.y + 2 * TOOTH_CLEARANCE;
        toothY = TOOTH_SIZE.z + TOOTH_CLEARANCE;
        toothSpacing = TOOTH_SPACING - 2 * TOOTH_CLEARANCE;
        render() {
            tooths2D(toothX, toothY, 
                count=TOOTH_COUNT, 
                spacing=toothSpacing);
        }
    }
    
    module toothRing() {
        step = 360 / ITERATIONS;
        circ = PI * DIAMETER;
        
        for(i=[0:step:360])
            rotate([0, 0, -i])
            translate([-circ * i / 360, DIAMETER / 2, 0])
            mirror([0,1,0])
              toothChain();
    }
    
    module toothCylinder() {
        linear_extrude(toothHeight)
            difference() {
                circle(r=DIAMETER / 2);
                toothRing();
            }
    }
    
    module pulleyCylinder() {
        toothY = TOOTH_SIZE.z + TOOTH_CLEARANCE;
        cylinder(toothHeight, r=DIAMETER / 2 - toothY);
    }
    
    module middleSection() {
        if (GEARED) {
            toothCylinder();
        } else {
            pulleyCylinder();
        }
    }
    
    sectionHeight = (HEIGHT - toothHeight) / 2;
    
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
        // chamfer
        /*
        translate([0, 0, BEARING_HEIGHT]) 
            cylinder(CHAMFER_HEIGHT, 
                r1=BEARING_DIAMETER/2, 
                r2=SHAFT_DIAMETER/2);
        */
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