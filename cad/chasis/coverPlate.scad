use <../../libs/scad-utils/morphology.scad>

include <../../libs/nutsnbolts/cyl_head_bolt.scad>

use <../lib/utils.scad>

include <common.scad>

DEBUG = true;

$fn = getFragmentCount(debug=DEBUG);

NUT_DIAMETER = _get_fam(SCREW_NAME)[_NB_F_NUT_KEY];
FULL_WIDTH = WIDTH + 2 * THICKNESS;

/*
module screwHolder() {
    distance = THICKNESS + SHELL_THICKNESS;
    height = SCREW_LENGTH - distance;
    diameter = NUT_DIAMETER + 2 * SCREW_BORDER;
    
    render()
    translate([-diameter / 2, 0, 0])
    difference() {
        translate([0, 0, -SCREW_LENGTH])
        union() {
            cylinder(height, d=diameter);
            translate([0, -diameter / 2, 0])
                cube([(diameter + THICKNESS) / 2, diameter, height]);
        }
        hole_through(SCREW_NAME, SCREW_LENGTH);
        rotate([0, 0, 180])
        translate([0, 0, -(SCREW_LENGTH - NUT_DISTANCE)])
            nutcatch_sidecut(SCREW_NAME, l=NUT_DIAMETER);
    }
}
*/

module endPlateMask(geared=false) {
    union() {
        topShape(geared);
        bottomShape();
        // Edge
        translate([BOTTOM - THICKNESS, 0])
            square([TOP - BOTTOM + 2 * THICKNESS, THICKNESS]);
    }
}

module topShape() {
    size = abs(TOP_GEAR.y) - FILLET - SCREW_SPACING;
    translate([TOP, -size])
        square([THICKNESS, size]);
}

module bottomShape() {
    size = abs(BOTTOM_FRONT_WHEEL.y) - SHAFT_DIAMETER - SCREW_SPACING;
    translate([BOTTOM - THICKNESS, -size])
        square([THICKNESS, size]);
}

module gearedShell() {
    shell(d=THICKNESS)
        gearedShape();
}

module ungearedShell() {
    shell(d=THICKNESS)
        ungearedShape();
}

module flatPlateScrews(posY, size, rotation=0) {
    rotVector = [0, 0, rotation];
    
    translate([posY, -SCREW_SPACING, 0])
    rotate(rotVector) 
    mirror([0, 0, 1])
        screwHolder();
    
    translate([posY, -SCREW_SPACING, FULL_WIDTH])
    rotate(rotVector)
        screwHolder();
    
    translate([posY, size + SCREW_SPACING, 0])
    rotate(rotVector)
    mirror([0, 0, 1])
        screwHolder();
    
    translate([posY, size + SCREW_SPACING, FULL_WIDTH])
    rotate(rotVector)
        screwHolder();
}

module topPlate(geared=false) {
    size = getTopPlateSize(geared);
    union() {
        linear_extrude(FULL_WIDTH)
            topShape(geared);
        flatPlateScrews(TOP, size);
    }
}

module bottomPlate() {
    union() {
        linear_extrude(FULL_WIDTH)
            bottomShape();
        flatPlateScrews(BOTTOM, BOTTOM_FRONT_WHEEL.y, 180);
    }
}

module gearedEndPlate() {
    linear_extrude(FULL_WIDTH)
    difference() {
        gearedShell();
        endPlateMask(true);
    }
}

module ungearedEndPlate() {
    linear_extrude(WIDTH + 2 * THICKNESS)
    difference() {
        ungearedShell();
        endPlateMask();
    }
}

module coverPlateAssembly() {
    mirror([1, 0, 0])
    rotate([0, -90, 0]) {
        color("red") topPlate(true);
        color("blue") bottomPlate();
        gearedEndPlate();

        mirror([0, 1, 0]) {
            color("blue") topPlate();
            color("red") bottomPlate();
            ungearedEndPlate();
        }   
    }
    
    # rotate([0, -90, 0])
        wheelShafts();
}

coverPlateAssembly();

# rotate([0, -90, 0])
    square(190, center=true);