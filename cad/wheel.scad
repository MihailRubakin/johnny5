use <lib/utils.scad>
use <lib/gear.scad>
use <tooth.scad>

DEBUG = false;
RENDER_TOOTH = true;

$fn= DEBUG ? 0 : 44;

ITERATIONS = DEBUG ? 15 : 360;

TOOTH_SIZE = [10, 5, 5];
TOOTH_SPACING = 10;

TOOTH_COUNT = 9;
DIAMETER = diameterFromToothCount(TOOTH_SIZE.x, TOOTH_SPACING, TOOTH_COUNT);

HEIGHT = 45;

SHAFT_DIAMETER = 5;
BEARING_DIAMETER = 10;
BEARING_HEIGHT = 4;
CHAMFER_HEIGHT = 2.5;

// Outter rim thickness
OUTTER_RIM = TOOTH_SIZE.z + 5;

// Inner rim diameter
INNER_RIM = BEARING_DIAMETER + 5;

SPOKE_COUNT = 8;
SPOKE_TICKNESS = 3;

echo("Tooth count = ", TOOTH_COUNT);
echo("Diameter = ", DIAMETER);
echo("Height = ", HEIGHT);


// TODO: Test with 2D for performance
// TODO: Add clearance for slots
module outterRim() {    
    
    module toothChain() {
        render() {
            rotate([90, 0, 0])
                tooths(TOOTH_SIZE.x, TOOTH_SIZE.y, TOOTH_SIZE.z, TOOTH_COUNT, TOOTH_SPACING);
        }
    }

    module toothRing() {
        step = 360 / ITERATIONS;
        circ = PI * DIAMETER;
        
        for(i=[0:step:360])
            rotate([0, 0, -i])
            translate([-circ * i / 360, DIAMETER / 2, HEIGHT / 2])
              toothChain();
    }
    
    module rim() {
        difference() {
            cylinder(HEIGHT, r=DIAMETER/2);
            cylinder(HEIGHT, r=DIAMETER/ 2 - OUTTER_RIM);
        }
    }
    
    if (RENDER_TOOTH) {
        difference() {
            rim();
            toothRing();
        }
    } else {
        rim();
    }
}

module innerRim() {
    module shaft() {        
        union() {
            // shaft
            cylinder(HEIGHT, r=SHAFT_DIAMETER/2);
            // bearing
            translate([0, 0, 0])
                cylinder(BEARING_HEIGHT, r=BEARING_DIAMETER/2);
            // chamfer
            translate([0, 0, BEARING_HEIGHT]) 
                cylinder(CHAMFER_HEIGHT, 
                    r1=BEARING_DIAMETER/2, 
                    r2=SHAFT_DIAMETER/2);
        };
    }
    
    difference() {
        cylinder(HEIGHT, r=INNER_RIM / 2);
        shaft();
    }
}

module spokes() {
    // TODO: This is a hack
    mergeLength = 2;
    
    radius = (DIAMETER - INNER_RIM) / 2 - OUTTER_RIM + mergeLength ;
    
    module spoke() {
        translate([(radius + INNER_RIM - mergeLength  / 2) / 2, 0, HEIGHT / 2])
            cube([radius, SPOKE_TICKNESS, HEIGHT], center=true);
    }
    
    for (i = [0:360/SPOKE_COUNT:360])
        rotate([0,0,i])
            spoke();
}


mod = diametralPitchToModule(32);

gearDef = defGear(60, mod, faceWidth=6,
        shaft=5,
        bearings=[
            defBearing(10, 4, 1)
        ]);

translate([0, 0, HEIGHT + 2]) 
    gear(gearDef);

tipDiameter = prop("tipDiameter", gearDef);

// Spacer
translate([0, 0, HEIGHT])
    difference() {
        cylinder(2, r=tipDiameter/2);
        cylinder(2, r=SHAFT_DIAMETER/2);
    }

// Wheel
union() {
    outterRim();
    innerRim();
    spokes();
}