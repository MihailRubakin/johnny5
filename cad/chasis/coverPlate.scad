use <../../libs/scad-utils/morphology.scad>

use <../lib/utils.scad>

include <common.scad>

DEBUG = true;

$fn = getFragmentCount(debug=DEBUG);

module topShape(mask=false) {
    size = TOP_PLATE_SIZE - (mask ? 0 : 1.5 * PLATE_CLEARANCE);
    offsetY = mask ? 0 : PLATE_CLEARANCE;
    
    translate([TOP, -TOP_PLATE_SIZE + offsetY])
        square([THICKNESS, size]);
}

module bottomShape(mask=false) {
    size = BOTTOM_PLATE_SIZE - (mask ? 0 : 1.5 * PLATE_CLEARANCE);
    offsetY = mask ? 0 : PLATE_CLEARANCE;
    
    translate([BOTTOM - THICKNESS, -BOTTOM_PLATE_SIZE + offsetY])
        square([THICKNESS, size]);
}

module endPlateMask() {
    union() {
        topShape(true);
        bottomShape(true);
        // Edge
        translate([BOTTOM - THICKNESS, 0])
            square([TOP - BOTTOM + 2 * THICKNESS, THICKNESS]);
    }
}

module roundedShell() {
    shell(d=THICKNESS)
        roundedShape();
}

module topPlate() {
    render()
    difference() {
        linear_extrude(FULL_WIDTH)
            topShape();
        flatPlateScrewHole(TOP, TOP_PLATE_SIZE);
    }
}

module bottomPlate() {
    render()
    difference() {
        linear_extrude(FULL_WIDTH)
            bottomShape();
        flatPlateScrewHole(BOTTOM, BOTTOM_PLATE_SIZE, 180);
    }
}

module endPlate() {    
    render()
    difference() {
        linear_extrude(FULL_WIDTH)
        difference() {
            roundedShell();
            endPlateMask();
        }
        
        endPlateScrewHole();
    }
}

module coverPlateAssembly() {
    mirror([1, 0, 0])
    rotate([0, -90, 0]) 
    {
        color("red") topPlate(true);
        color("blue") bottomPlate();
        color("purple") endPlate();

        mirror([0, 1, 0]) {
            color("blue") topPlate();
            color("red") bottomPlate();
            color("purple") endPlate();
        }   
    }
    
    # rotate([0, -90, 0])
        wheelShafts();
}

coverPlateAssembly();

// # rotate([0, -90, 0]) square(190, center=true);