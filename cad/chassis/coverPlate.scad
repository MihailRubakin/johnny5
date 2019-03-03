use <../../libs/scad-utils/morphology.scad>

include <common.scad>

module topShape(mask=false) {
    size = TOP_PLATE_SIZE - (mask ? 0 : 1.5 * PLATE_CLEARANCE);
    offsetY = mask ? 0 : PLATE_CLEARANCE;
    
    translate([TOP + PLATE_CLEARANCE, -TOP_PLATE_SIZE + offsetY])
        square([COVER_THICKNESS, size]);
}

module bottomShape(mask=false) {
    size = BOTTOM_PLATE_SIZE - (mask ? 0 : PLATE_CLEARANCE);
    offsetY = mask ? 0 : PLATE_CLEARANCE;
    thickness = COVER_THICKNESS + (mask ? PLATE_CLEARANCE  : 0);
    
    translate([BOTTOM - COVER_THICKNESS - PLATE_CLEARANCE, -BOTTOM_PLATE_SIZE + offsetY])
        square([thickness, 2 * size]);
}

module endPlateMask() {
    union() {
        topShape(true);
        bottomShape(true);
        // Edge
        translate([BOTTOM - COVER_THICKNESS, 0])
            square([TOP - BOTTOM + 2 * COVER_THICKNESS + PLATE_CLEARANCE, COVER_THICKNESS + PLATE_CLEARANCE]);
    }
}

module roundedShell() {
    shell(d=COVER_THICKNESS)
    outset(d=PLATE_CLEARANCE)
        roundedShape();
}

module topPlate() {
    render()
    difference() {
        linear_extrude(FULL_WIDTH)
            topShape();
        flatPlateScrewHole(TOP, TOP_PLATE_SIZE, 180);
    }
}

module bottomPlate() {
    render()
    difference() {
        linear_extrude(FULL_WIDTH)
            bottomShape();
        
        flatPlateScrewHole(BOTTOM, BOTTOM_PLATE_SIZE, 0);
        mirror([0, 1, 0])
            flatPlateScrewHole(BOTTOM, BOTTOM_PLATE_SIZE, 0);
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
        topPlate();
        endPlate();

        mirror([0, 1, 0]) {
            topPlate();
            endPlate();
        }
        
        bottomPlate();
    }
    
    # rotate([0, -90, 0])
        wheelShafts();
}

coverPlateAssembly();

// # rotate([0, -90, 0]) square(190, center=true);