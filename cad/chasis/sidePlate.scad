use <../../libs/scad-utils/morphology.scad>

include <common.scad>

// $vpr = [0, 0, -90];

// TODO: Move to constant.scad
SHELL_SIZE = 2 * BORDER;

module gearBoxWheel() {
    translate(GEARED_WHEEL_CENTER)
        circle(d=GEARBOX_WHEEL_DIAMETER);
}

module gearBoxMotor() {
    translate(MOTOR_GEAR_CENTER)
    rotate([0, 0, MOTOR_GEAR_ANGLE]) 
    hull() {
        translate([0, MOTOR_SCREW_PLAY])
            circle(d=MOTOR_BODY_DIAMETER);
        translate([0, -MOTOR_SCREW_PLAY])
            circle(d=MOTOR_BODY_DIAMETER);
    }
}

module gearBoxMotorMask() {
    left = MOTOR_SCREW_SPACING.x / 2;
    right = -left;
    back = MOTOR_SCREW_SPACING.y / 2 + MOTOR_SCREW_PLAY;
    front = -back;
    
    module screwSlots(screwHeight=THICKNESS + INNER_THICKNESS, screwDiameter=3) {
        translate(MOTOR_GEAR_CENTER)
        rotate([0, 0, MOTOR_GEAR_ANGLE]) {
            hull() {
                translate([left, front])
                    cylinder(screwHeight, d=screwDiameter);
                translate([left, back])
                    cylinder(screwHeight, d=screwDiameter);
            }
            hull() {
                translate([right, front])
                    cylinder(screwHeight, d=screwDiameter);
                translate([right, back])
                    cylinder(screwHeight, d=screwDiameter);
            }
        }
    }
    
    module gearSlot() {
        diameter = GEARBOX_MOTOR_DIAMETER + GEAR_CLEARANCE;
        
        translate(MOTOR_GEAR_CENTER)
        rotate([0, 0, MOTOR_GEAR_ANGLE])
        hull() {
            translate([0, MOTOR_SCREW_PLAY, 0])
                cylinder(MOTOR_ROTOR_HEIGHT, d=diameter);
            translate([0, -MOTOR_SCREW_PLAY, 0])
                cylinder(MOTOR_ROTOR_HEIGHT, d=diameter);
        }
    }
    
    module motorSlot() {
        translate([0, 0, MOTOR_ROTOR_HEIGHT])
        linear_extrude(MOTOR_BODY_HEIGHT)
            gearBoxMotor();
    }
    
    union() {
        // TODO: Screw head size
        screwSlots(3, 4);
        screwSlots();
        gearSlot();
        motorSlot();
    }
}

module gearBoxShell(hasMotor=false) {
    gearBoxWheel();
    
    if (hasMotor) {
         gearBoxMotor();
    }
}

module outsetedShape(hasMotor) {
    intersection() {
        union() {
            outset(d=BORDER)
                gearBoxShell(hasMotor);
        }
        roundedShape();
    }
}

module sidePlate(hasMotor=false) {    
    module shellShape() {
        difference() {
            union() {
                shell(d=-SHELL_SIZE)
                    roundedShape();
                outsetedShape(hasMotor);
            }
            wheelShafts();
        }
    }
    
    module _plate() {
        linear_extrude(THICKNESS)
        difference() {
            roundedShape();
            wheelShafts();
        }
    }
    
    module _shell() {
        translate([0, 0, THICKNESS])
        linear_extrude(INNER_THICKNESS)
            shellShape();
    }
    
    render()
    difference() {
        union() {
            _plate();
            _shell();
        }
        
        if (hasMotor) {
            gearBoxMotorMask();
        }
        
        flatPlateScrewSlot(TOP, TOP_PLATE_SIZE);
        flatPlateScrewSlot(BOTTOM, BOTTOM_PLATE_SIZE, 180);
        endPlateScrewSlot();
    }
}

mirror([0, 1, 0]) sidePlate();
sidePlate(true);