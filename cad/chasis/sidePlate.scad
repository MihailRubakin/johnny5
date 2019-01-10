use <../../libs/scad-utils/morphology.scad>

include <common.scad>

// $vpr = [0, 0, -90];

// TODO: Move to constant.scad
SHELL_SIZE = 2 * BORDER;

module gearBoxWheel() {
    translate(GEARED_WHEEL_CENTER)
        circle(THICKNESS + FACE_WIDTH, d=GEARBOX_WHEEL_DIAMETER);
}

module gearBoxSmallGear() {
    translate(SMALL_GEAR_CENTER) 
        circle(2 * FACE_WIDTH, d=GEARBOX_SMALL_DIAMETER);
}

module gearBoxLargeGear() {
    translate(SMALL_GEAR_CENTER) 
        circle(FACE_WIDTH, d=GEARBOX_LARGE_DIAMETER);
}

module gearBoxMotorGear() {
    translate(MOTOR_GEAR_CENTER) 
    rotate([0, 0, MOTOR_GEAR_ANGLE])
        hull() {
            translate([0, MOTOR_SCREW_PLAY])
                circle(FACE_WIDTH, d=GEARBOX_MOTOR_DIAMETER);
            translate([0, -MOTOR_SCREW_PLAY])
                circle(FACE_WIDTH, d=GEARBOX_MOTOR_DIAMETER);
        }
}

module gearBoxMotorScrews(isMotorPlate) {
    left = MOTOR_SCREW_SPACING.x / 2;
    right = -left;
    back = MOTOR_SCREW_SPACING.y / 2 + MOTOR_SCREW_PLAY;
    front = -back;
    
    screwZ = isMotorPlate ? 0 : THICKNESS;
    screwHeight =  FACE_WIDTH + (isMotorPlate ? MOTOR_ROTOR_THICKNESS : 0);
    
    translate([0, 0, screwZ])
    translate(MOTOR_GEAR_CENTER)
    rotate([0, 0, MOTOR_GEAR_ANGLE]) {
        hull() {
            translate([left, front])
                cylinder(screwHeight, d=3);
            translate([left, back])
                cylinder(screwHeight, d=3);
        }
        hull() {
            translate([right, front])
                cylinder(screwHeight, d=3);
            translate([right, back])
                cylinder(screwHeight, d=3);
        }
    }
    
    if (isMotorPlate) {
        translate(MOTOR_GEAR_CENTER)
        rotate([0, 0, MOTOR_GEAR_ANGLE])
        hull() {
            translate([0, MOTOR_SCREW_PLAY, 0])
                cylinder(MOTOR_ROTOR_THICKNESS, d=MOTOR_ROTOR_DIAMETER);
            translate([0, -MOTOR_SCREW_PLAY, 0])
                cylinder(MOTOR_ROTOR_THICKNESS, d=MOTOR_ROTOR_DIAMETER);
        }
    } else {
        
    }
}

module gearBoxShell() {
    union() {
        gearBoxWheel();
        gearBoxLargeGear();
        gearBoxMotorGear();
    }
}

module outsetedShape() {
    deltaWheels = SMALL_GEAR_CENTER.y - GEARED_WHEEL_CENTER.y;
    intersection() {
        union() {
            outset(d=BORDER)
                gearBoxShell();
            
            // Patch hole on top of wheels
            translate([TOP, SMALL_GEAR_CENTER.y - deltaWheels / 2])
                square(deltaWheels, center=true);
        }
        gearedShape();
    }
}

module sidePlate(hasGear=false) {
    module condShape() {
        if (hasGear) {
            gearedShape();
        } else {
            ungearedShape();
        }
    }
    
    module baseShellShape() {
        shell(d=-SHELL_SIZE)
            condShape();
    }
    
    module condShellShape() {
        difference() {
            if (hasGear) {
                difference() {                    
                    union() {
                        baseShellShape();
                        outsetedShape();
                    }
                    
                    gearBoxWheel();
                    gearBoxSmallGear();
                }
            }else {
                baseShellShape();
            }
            
            wheelShafts();
        }
    }
    
    module _plate() {
        linear_extrude(THICKNESS)
        difference() {
            condShape();
            
            wheelShafts();
            if (hasGear) {
                gearBoxWheel();
            }
        }
    }
    
    module _shell() {
        translate([0, 0, THICKNESS])
        linear_extrude(FACE_WIDTH)
            condShellShape();
    }
    
    render()
    difference() {
        union() {
            _plate();
            _shell();
        }
        
        // TODO: SPECIFY SCREW SIZE (head)
        gearBoxMotorScrews(false);
    }
}

module transmissionPlate() {
    module _plate() {
        linear_extrude(MOTOR_ROTOR_THICKNESS)
        difference() {
            outsetedShape();
            wheelShafts();
        }
    }
    
    module _shell() {
        translate([0, 0, MOTOR_ROTOR_THICKNESS])
        linear_extrude(FACE_WIDTH)
        difference() {
            outsetedShape();
            
            wheelShafts();
            gearBoxLargeGear();
            gearBoxMotorGear();
        }
    }
         
    render()
    difference() {
        union() {
            _plate();
            _shell();
        }   
        gearBoxMotorScrews(true);
    }
}

// mirror([0, 1, 0]) sidePlate();
sidePlate(true);

translate([0, 0, 2 * THICKNESS + 2 * FACE_WIDTH + 50])
mirror([0, 0, 1])
    transmissionPlate();