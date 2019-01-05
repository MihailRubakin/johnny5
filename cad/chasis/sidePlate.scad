use <../../libs/scad-utils/morphology.scad>
include <common.scad>

module sidePlate(hasGear=false) {
    module baseShape() {
        points2D = toSide2D(CHASIS_POINTS);
        polygon(points2D);
    }
    
    module gearedShape() {
        center = [TOP_FRONT_WHEEL.z, TOP_FRONT_WHEEL.y];
        difference() {
            union() {
                baseShape();
                translate(center)
                    circle(d=CHASIS_WHEEL_SIZE);
            }
            translate(center)
                circle(d=WHEEL_GEAR_DIAMETER + 2 * GEAR_CLEARANCE);
        }
    }
    
    module wheelShafts() {
        wheels2D = toSide2D(WHEELS);
        for (pos = wheels2D)
                translate(pos)
                circle(d=SHAFT_DIAMETER);
    }
    
    module condShape() {
        if (hasGear) {
            gearedShape();
        } else {
            baseShape();
        }
    }
    
    linear_extrude(THICKNESS)
    difference() {
        condShape();
        wheelShafts();
    }
    
    
    color("red")
    translate([0, 0, THICKNESS])
    linear_extrude(SHELL_THICKNESS)
    difference() {
        shell(d=-SHELL_SIZE)
            condShape();
        wheelShafts();
    }
}

mirror([0, 1, 0])
    sidePlate();
sidePlate(true);