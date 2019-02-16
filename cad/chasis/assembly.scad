use <../lib/utils.scad>

use <../wheelAssembly.scad>

include <common.scad>
use <sidePlate.scad>
use <coverPlate.scad>

use <../arm/arm.scad>

include <../constant.scad>

DEBUG = true;

SHOW_THREAD = true;
SHOW_WHEEL = true;

$fn = getFragmentCount(debug=DEBUG);

module debugBatteryPack() {
    size = [46, 138, 24];
    translate([0, 0, size.z/2])
        cube(size, center=true);
}

module debugMotor() {
    shaftHeight = 12.3;
    shaftDiameter = 3.16;
    
    rotate([0, 90, 0]) {
        translate([0, 0, -shaftHeight])
            cylinder(shaftHeight, d=shaftDiameter);
        cylinder(MOTOR_ROTOR_HEIGHT, d=MOTOR_ROTOR_DIAMETER);
        translate([0, 0, MOTOR_ROTOR_HEIGHT])
            cylinder(MOTOR_BODY_HEIGHT, d=MOTOR_BODY_DIAMETER);
    }
}

module debugTransmission() {
    topFront = TOP_FRONT_WHEEL;
    
    pignonDiam = prop("tipDiameter", MOTOR_GEAR_DEF);
    
    render() {
        mirror([1, 0, 0])
        translate([0, topFront.y, topFront.z])
        rotate([0, 90, 0])
            gear(WHEEL_GEAR_DEF);
        
        translate([0, MOTOR_GEAR_CENTER.y, MOTOR_GEAR_CENTER.x])
        rotate([0, 90, 0])
            cylinder(MOTOR_PIGNON_BASE, d=pignonDiam);
        
        mirror([1, 0, 0])
        translate([0, MOTOR_GEAR_CENTER.y, MOTOR_GEAR_CENTER.x])
        rotate([0, 90, 0])
            gear(MOTOR_GEAR_DEF);
    }
    
    # translate([MOTOR_PIGNON_BASE, MOTOR_GEAR_CENTER.y, MOTOR_GEAR_CENTER.x])
        debugMotor();
}

module sidePlates(twoSided = false) {
    module oneSide() {
        mirror([0, 1, 0])
        mirror([1, 0, 0])
        rotate([0, -90, 0])
            sidePlate();

        mirror([1, 0, 0])
        rotate([0, -90, 0])
            sidePlate(true);
    }
    
    oneSide();
    
    if (twoSided) {
        translate([WIDTH + 2 * THICKNESS, 0, 0])
        mirror([1, 0, 0])
            oneSide();
    }
}

module main() {
    // Frame
    sidePlates(false);
    coverPlateAssembly();

    // Others
    color("green")
    debugTransmission();

    % translate([-THREAD_SIZE.x / 2, 0, 0])
        wheelAssembly(showWheel=SHOW_WHEEL, showThread=SHOW_THREAD);

    CENTER_X = FULL_WIDTH / 2;

    color("cyan")
    translate([CENTER_X, 0, BOTTOM])
        debugBatteryPack();

    translate([WIDTH / 2, -TOP_FRONT_WHEEL.y / 2, TOP + THICKNESS])
    rotate([0, 0, -90])
    // scale([0.75, 0.75, 0.75])
    translate(getArmOffset())
        armAssembly(-80, -60);
}

// Debug bed
// # rotate([0, 90, 0]) square(190, center=true);

translate([0, 0, WHEEL_DIAMETER / 2 + THREAD_SIZE.z]) 
    main();