use <../lib/utils.scad>
include <common.scad>

TOP_GEAR = gearPoint(TOP_FRONT, TOP_CENTER);
BOTTOM_GEAR = gearPoint(TOP_FRONT, BOTTOM_FRONT);

module wheelCover() {
    bottomDx = TOP_FRONT_WHEEL.y - BOTTOM_GEAR.y;
    bottomDy = TOP_FRONT_WHEEL.z - BOTTOM_GEAR.z;
    
    topDx = TOP_FRONT_WHEEL.y - TOP_GEAR.y;
    topDy = TOP_FRONT_WHEEL.z - TOP_GEAR.z;        
    
    corner = sqrt(2 * THICKNESS * THICKNESS);
    fullWidth = WIDTH + 2 * THICKNESS;

    module shell() {
        startAngle = atan2(bottomDy, bottomDx);
        endAngle = atan2(topDy, topDx);
        
        linear_extrude(fullWidth)
            arc(CHASIS_WHEEL_SIZE / 2, startAngle, endAngle, THICKNESS);
    }
    
    module bottomChamfer() {
        translate([bottomDx, bottomDy, -1])
        rotate([0, 0, 90])
            cube([corner, corner, fullWidth + 2]);
    }
    
    module topChamfer() {
        translate([topDx, topDy, -1])
        rotate([0, 0, 135])
            cube([corner, corner, fullWidth + 2]);
    }
    
    render()
    difference() {
        shell();
        topChamfer();
        bottomChamfer();
    }
}

wheelCover();