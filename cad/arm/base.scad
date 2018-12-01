include <constant.scad>
use <servo.scad>
use <utils.scad>

SHOW_SERVO = false;

module bottomHinge(size, angle, thickness=1) {
    point = getBottomCoords(size, angle);
    
    coords = [
        [0, 0],
        [point.x, 0],
        point
    ];
    
    rotate([90, 0, 0])
    linear_extrude(thickness)
    difference() {
        minkowski() {
            polygon(coords);
            circle(d=SEGMENT_WIDTH);
        };
        circle(d=BOLT_DIAMETER);
        translate([point.x, point.y, 0])
            circle(d=BOLT_DIAMETER);
    };
}

module base() {
    point = getBottomCoords(SHORT, BOTTOM_SLOPE);
    
    // TODO: Use servo constants
    front = -max(41 * 1/3, SEGMENT_WIDTH / 2);
    back = point.x + SEGMENT_WIDTH;
    
    yPos = getYPositions(thickness=THICKNESS, center=CENTER);

    sizeX = back - front;
    sizeY = getSizeY(thickness=THICKNESS, center=CENTER);
    sizeZ = point.y + SEGMENT_WIDTH + CLEARANCE;
    
    module leftWall() {
        difference() {
            translate([
                (back + front) / 2, 
                -THICKNESS / 2, 
                (point.y - CLEARANCE) / 2
            ]) 
                cube([sizeX, THICKNESS, sizeZ], center=true);
            
            rotate([90, 0, 0])
                cylinder(THICKNESS, d=BOLT_DIAMETER);
            
            translate([point.x, 0, point.y])
            rotate([90, 0, 0])
                cylinder(THICKNESS, d=BOLT_DIAMETER);
        }
    }
    
    module leftJoin() {
        translate([
            back - SEGMENT_WIDTH / 2, 
            -THICKNESS / 2, 
            (point.y - (CLEARANCE + SEGMENT_WIDTH)) / 2
        ])
            cube([
                SEGMENT_WIDTH, 
                THICKNESS + CLEARANCE, 
                sizeZ - SEGMENT_WIDTH
            ], center=true);
    }

    module rightWall() {
        sizeX = -(2 * front);
        
    	translate([
            sizeX / 2 + front, 
            -THICKNESS / 2, 
            -CLEARANCE / 2
        ])
            cube([
                sizeX,
                THICKNESS, 
                SEGMENT_WIDTH + CLEARANCE
            ], center=true);
    }
    
    module rightHinge() {
    	difference() {
            union() {
                rotate([90, 0, 0])
                    cylinder(THICKNESS, d=SEGMENT_WIDTH);
                translate([
                    0, 
                    -THICKNESS / 2, 
                    -(SEGMENT_WIDTH / 2 + CLEARANCE) / 2
                ])
                    cube([
                        SEGMENT_WIDTH, 
                        THICKNESS, 
                        SEGMENT_WIDTH / 2 + CLEARANCE
                    ], center=true);
            }
            
            rotate([90, 0, 0])
                cylinder(THICKNESS, d=BOLT_DIAMETER);
        }
    }
    
    module bottom() {
        translate([
            (back + front) / 2, 
            -sizeY / 2, 
            -THICKNESS / 2
        ])
            cube([sizeX, sizeY, THICKNESS], center=true);
    }
    
    module servos() {
        translate([0, yPos[1], 0])
            baseServo();
        translate([0, yPos[6], 0])
        rotate([180, 0, 0])
            baseServo();
    }
    
    difference() {
        union() {
            leftWall();
            translate([0, yPos[1], 0])
                leftJoin();
            translate([0, yPos[2], 0])
                leftWall();
            
            translate([0, yPos[4], 0])
                rightHinge();
            translate([0, yPos[6], 0])
                rightWall();
            translate([0, 0, -(SEGMENT_WIDTH / 2 + CLEARANCE)])
                bottom();
        }
        servos();
    }
    
    if (SHOW_SERVO) {
        color("red") servos();
    }
}

translate([0, 0, SEGMENT_WIDTH / 2 + THICKNESS + CLEARANCE])
    base();