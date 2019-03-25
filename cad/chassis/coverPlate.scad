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

// coverPlateAssembly();

// TODO: Test [25, 69, 47] x2
BATTERY_SIZE = [25, 69, 47];
// BATTERY_SIZE = [24, 138, 46];

module batteryHolder(mask=false) {
    BOTTOM_THICKNESS = 2;
    BORDER = 5;
    COVER = 2;
    
    BATTERY_SPACING = 2;
    
    module debugBattery() {
        offsetZ = (BATTERY_SIZE.z + BATTERY_SPACING) / 2;
        color("cyan") {
            translate([0, 0, offsetZ])
                cube(BATTERY_SIZE, center=true);
            translate([0, 0, -offsetZ])
                cube(BATTERY_SIZE, center=true);
        }
    }
    
    spacing = mask ? PLATE_CLEARANCE : 0;
    spacingVect = [spacing, spacing, spacing];
    
    base = [
        COVER_THICKNESS - BOTTOM_THICKNESS, 
        BATTERY_SIZE.y + 2 * BORDER, 
        2 * BATTERY_SIZE.z + BATTERY_SPACING + 2 * BORDER
    ];
    
    cover= [
        BOTTOM_THICKNESS,
        base.y + 2 * COVER,
        base.z + 2 * COVER
    ];
    
    translate([
        BOTTOM - COVER_THICKNESS / 2 - PLATE_CLEARANCE, 
        0, 
        FULL_WIDTH / 2
    ]) {
        translate([COVER_THICKNESS / 2 - base.x / 2, 0, 0])
            cube(base + spacingVect, center=true);
        translate([cover.x / 2 - COVER_THICKNESS / 2, 0, 0])
            cube(cover+ spacingVect, center=true);
        translate([BATTERY_SIZE.x / 2 + COVER_THICKNESS / 2, 0, 0]) 
            debugBattery();
    }
}

translate([0, 0, -BOTTOM + COVER_THICKNESS])
rotate([0, -90, 0]) {
    % render()
    difference() {
        bottomPlate();
        batteryHolder(true);
    }
    batteryHolder();
}

// # rotate([0, -90, 0]) square(190, center=true);