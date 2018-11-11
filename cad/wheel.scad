use <lib/utils.scad>
use <lib/gear.scad>
use <tooth.scad>
include <constant.scad>

DEBUG = false;
RENDER_TOOTH = true;

$fn= DEBUG ? 0 : 100;

TOOTH_COUNT = 14;
DIAMETER = diameterFromToothCount(TOOTH_SIZE.y, TOOTH_SPACING, TOOTH_COUNT);

HEIGHT = THREAD_SIZE.x;

SHAFT_DIAMETER = 5;
BEARING_DIAMETER = 10;
BEARING_HEIGHT = 4;
CHAMFER_HEIGHT = 2.5;

GEAR_MOD = diametralPitchToModule(32);
GEAR_HEIGHT = 6;
GEAR_TOOTHS = 60;
GEAR_DEF = defGear(GEAR_TOOTHS, GEAR_MOD, 
            faceWidth=GEAR_HEIGHT,
            shaft=SHAFT_DIAMETER,
            bearings=[
                defBearing(BEARING_DIAMETER, BEARING_HEIGHT, 1)
            ]);

ITERATIONS = $fn > 0 ? $fn : TOOTH_COUNT;

echo("Tooth count = ", TOOTH_COUNT);
echo("Diameter = ", DIAMETER);
echo("Height = ", HEIGHT);


// TODO: Add clearance for slots
module body() {
    module toothChain() {
        render() {
            tooths2D(TOOTH_SIZE.y, TOOTH_SIZE.z, 
                count=TOOTH_COUNT, 
                spacing=TOOTH_SPACING);
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
        linear_extrude(TOOTH_SIZE.x)
            difference() {
                circle(r=DIAMETER / 2);
                toothRing();
            }
    }
    
    module pulleyCylinder() {
        cylinder(TOOTH_SIZE.x, r=DIAMETER / 2 - TOOTH_SIZE.z);
    }
    
    module middleSection() {
        if (RENDER_TOOTH) {
            toothCylinder();
        } else {
            pulleyCylinder();
        }
    }
    
    sectionHeight = (HEIGHT - TOOTH_SIZE.x) / 2;
    
    module topBottom() {
        cylinder(sectionHeight, r=DIAMETER / 2);
    }
    
    union() {
        topBottom();
        translate([0, 0, sectionHeight])
            middleSection();
        translate([0, 0, sectionHeight + TOOTH_SIZE.x])
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
    
module main() {
    // Gear
    translate([0, 0, HEIGHT + 2]) 
        gear(GEAR_DEF);

    tipDiameter = prop("tipDiameter", GEAR_DEF);

    // Spacer
    translate([0, 0, HEIGHT])
        difference() {
            cylinder(2, r=tipDiameter/2);
            cylinder(2, r=SHAFT_DIAMETER/2);
        }
    
    // Wheel
    difference() {
        body();
        shaft();
    }
}

main();