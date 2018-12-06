use <thread.scad>
use <arm/arm.scad>
include <constant.scad>

WHEEL_DIAMETER = getThreadRingDiameter(WHEEL_THREAD_COUNT) - THREAD_SIZE.z;

SHOW_THREAD = true;
SHOW_WHEEL = true;

THREAD_COUNT = 15;

WHEEL_BASE = THREAD_BOLT_DISTANCE * THREAD_COUNT;

echo("Wheel diameter =", WHEEL_DIAMETER);

echo("Thread per side =", 2 * THREAD_COUNT + WHEEL_THREAD_COUNT);

module wheels() {

    module threadFull() {
        
        dy = WHEEL_BASE + THREAD_BOLT_DISTANCE;
        dz = WHEEL_DIAMETER + THREAD_SIZE.z;
        
        translate([0, -THREAD_BOLT_DISTANCE / 2, dz / 2])
        mirror([0, 0, 1])
            threadChain(THREAD_COUNT);
        
        translate([0, dy - THREAD_BOLT_DISTANCE / 2, -dz/ 2])
        mirror([0, 1, 0])
            threadChain(THREAD_COUNT);
        
        translate([0, THREAD_BOLT_DISTANCE * THREAD_COUNT, 0])
        rotate([0, 0, 90])
        rotate([90, 0, 0])
            threadRing(WHEEL_THREAD_COUNT, end=WHEEL_THREAD_COUNT / 2 - 1);
        
        rotate([0, 0, 90])
        rotate([90, 0, 0]) {
            threadRing(WHEEL_THREAD_COUNT, start=WHEEL_THREAD_COUNT / 2, end=WHEEL_THREAD_COUNT - 1);
        }   
    }

    if (SHOW_THREAD) {
        % threadFull();
    }

    if (SHOW_WHEEL) {
        % rotate([0, 90, 0])
            cylinder(THREAD_SIZE.x, d=WHEEL_DIAMETER, center=true);
        
        % translate([0, WHEEL_BASE, 0])
        rotate([0, 90, 0])
            cylinder(THREAD_SIZE.x, d=WHEEL_DIAMETER, center=true);
    }
}

module test() {
    front = 30;
    back = 30;
    bottom = 10;
    
    center = THREAD_COUNT * THREAD_BOLT_DISTANCE;
    
    sizeX = 100;
    sizeY = front + center + back;
    sizeZ = WHEEL_DIAMETER;
    
    offsetX = THREAD_SIZE.x / 2;
    
    echo("Length = ", sizeY);
    
    translate([offsetX, -back, bottom - sizeZ / 2])
        cube([sizeX, sizeY, sizeZ - bottom]);
    
    % translate([offsetX + sizeX / 2, 1/3 * sizeY, sizeZ / 2])
    rotate([0, 0, -90])
    translate(getArmOffset())
        armAssembly(-80, -60);
}

wheels();
test();