include <common.scad>

SEGMENT_WIDTH = SHAFT_DIAMETER + 2 * BORDER;

module framePoint(pos) {
    translate(pos)
        circle(d=SEGMENT_WIDTH);
}

module wheelShaftBorder() {
    wheels2D = toSide2D(getFrontWheelsPos());
    for (pos = wheels2D)
        framePoint(pos);
}

module topFrontPoint() {
    framePoint([TOP_FRONT_WHEEL.z, TOP_FRONT_WHEEL.y, 0]);
}

module bottomFrontPoint() {
    framePoint([BOTTOM_FRONT_WHEEL.z, BOTTOM_FRONT_WHEEL.y, 0]);
}

module frameSquare(pos) {
    translate(pos)
    translate([-SEGMENT_WIDTH / 2, -BORDER])
    square([SEGMENT_WIDTH, BORDER]);
}

module topCenterPoint() {
    frameSquare([TOP_FRONT_WHEEL.z, 0]);
}

module bottomCenterPoint() {
    frameSquare([BOTTOM_FRONT_WHEEL.z, 0]);
}

module plateShape() {
    render()
    difference() {
        union() {
            hull() {
                topFrontPoint();
                bottomFrontPoint();
            }
            hull() {
                topFrontPoint();
                topCenterPoint();
            }
            hull() {
                bottomFrontPoint();
                bottomCenterPoint();
            }
            hull() {
                topCenterPoint();
                bottomCenterPoint();
            }
            wheelShaftBorder();
        }
        wheelShafts();
    }
}

module wheelPlate(hasNut=false) {
    startX = BOTTOM_FRONT_WHEEL.z;
    sizeX = TOP_FRONT_WHEEL.z - startX;

    render()
    difference() {
        linear_extrude(INNER_THICKNESS)
            plateShape();

        translate([startX + 1/3 * sizeX, 0, 0])
            sidePlateScrews(hasNut);
        translate([startX + 2/3 * sizeX, 0, 0])
            sidePlateScrews(hasNut);
    }
}

mirror([0, 1, 0])
    wheelPlate();
wheelPlate(true);