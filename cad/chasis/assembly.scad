use <../lib/utils.scad>

use <../wheelAssembly.scad>

include <common.scad>
use <sidePlate.scad>
use <coverPlate.scad>

include <../constant.scad>

DEBUG = true;

$fn = getFragmentCount(debug=DEBUG);

module batteryPack() {
    size = [46, 138, 24];
    translate([0, 0, size.z/2])
        cube(size, center=true);
}

module motor() {
    diameter = 35.8;
    rotate([0, 90, 0]) {
        cylinder(13.5, d=3.175);
        translate([0, 0, 13.5])
            cylinder(4.5, d=13);
        translate([0, 0, 18])
            cylinder(50, d=diameter);
    }
}

module debugTransmission() {
    topFront = TOP_FRONT_WHEEL;
    render() {
        translate([THICKNESS, topFront.y, topFront.z])
        rotate([0, 90, 0])
            gear(WHEEL_GEAR_DEF);
        
        translate([THICKNESS, SMALL_GEAR_CENTER.y, SMALL_GEAR_CENTER.x])
        rotate([0, 90, 0])
            gear(TRANSMISSION_SMALL_GEAR_DEF);
        
        translate([THICKNESS + FACE_WIDTH, SMALL_GEAR_CENTER.y, SMALL_GEAR_CENTER.x])
        rotate([0, 90, 0])
            gear(TRANSMISSION_LARGE_GEAR_DEF);
        
        translate([THICKNESS + FACE_WIDTH, MOTOR_GEAR_CENTER.y, MOTOR_GEAR_CENTER.x])
        rotate([0, 90, 0])
            gear(MOTOR_GEAR_DEF);
    }
    
    translate([THICKNESS + FACE_WIDTH, MOTOR_GEAR_CENTER.y, MOTOR_GEAR_CENTER.x])
        motor();
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

// Frame
sidePlates(false);
// coverPlateAssembly();

// Others
% debugTransmission();

% translate([-THREAD_SIZE.x / 2, 0, 0])
    wheelAssembly(showWheel=SHOW_WHEEL, showThread=SHOW_THREAD);

// Debug bed
//# rotate([0, 90, 0]) square(190, center=true);

CENTER_X = WIDTH / 2 + THICKNESS;

color("cyan")
translate([CENTER_X, 0, BOTTOM])
    batteryPack();