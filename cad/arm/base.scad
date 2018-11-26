include <constant.scad>
use <servo.scad>

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
    thickness = 31 - 19;
    
    front = -41 * 1/3;
    back = point.x + SEGMENT_WIDTH;

    sizeX = back - front;
    sizeY = CENTER + 2 * THICKNESS + thickness;
    sizeZ = point.y + SEGMENT_WIDTH;
    
    module leftWall() {
        difference() {
            translate([
                (back + front) / 2, 
                thickness / 2, 
                point.y / 2
            ]) 
                cube([sizeX, thickness, sizeZ], center=true);
            
            translate([0, thickness, 0])
                rotate([90, 0, 0])
                    cylinder(thickness, d=BOLT_DIAMETER);
            
            translate([point.x, thickness, point.y])
            rotate([90, 0, 0])
                cylinder(thickness, d=BOLT_DIAMETER);
        }
    }
    
    module leftJoin() {
        translate([
            back - SEGMENT_WIDTH / 2, 
            -THICKNESS / 2, 
            point.y / 2 - THICKNESS
        ])
            cube([
                SEGMENT_WIDTH, 
                THICKNESS, 
                sizeZ - SEGMENT_WIDTH
            ], center=true);
    }

    module rightWall() {
    	// TODO: Use servo constants
    	translate([
    		41 / 2 + front,
    		-THICKNESS / 2,
    		0
    	])
    	cube([
    		41,
    		THICKNESS, 
    		SEGMENT_WIDTH
    	], center=true);
    }
    
    module rightHinge() {
    	difference() {
            union() {
                rotate([90, 0, 0])
                    cylinder(THICKNESS, d=SEGMENT_WIDTH);
                translate([0, -THICKNESS / 2, -SEGMENT_WIDTH / 4])
                    cube([
                        SEGMENT_WIDTH, 
                        THICKNESS, 
                        SEGMENT_WIDTH / 2
                    ], center=true);
            }
            
            rotate([90, 0, 0])
                cylinder(THICKNESS, d=BOLT_DIAMETER);
        }
    }
    
    module bottom() {
        translate([
            (back + front) / 2, 
            thickness - sizeY / 2, 
            -3/2 * THICKNESS
        ])
            cube([sizeX, sizeY, THICKNESS], center=true);
    }
    
    union() {
        leftWall();
        translate([0, -(THICKNESS + thickness), 0])
            leftWall();
        leftJoin();
        
        translate([0, -(CENTER - THICKNESS), 0])
            rightHinge();
        translate([0, -(CENTER + THICKNESS), 0])
            rightWall();
        bottom();
    }
    
    color("red") baseServo();
    
    color("red") 
    translate([0, -(CENTER + THICKNESS), 0])
    rotate([180, 0, 0])
        baseServo();
}

base();