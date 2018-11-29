use <thread.scad>;
use <grip.scad>;
use <wheel.scad>;
use <transmission.scad>;
use <lib/utils.scad>;
use <lib/gear.scad>;
include <constant.scad>;

setDebug(false);

module threadWithGrip() {
    thread();
    
    front = 0;
    back = THREAD_SIZE.y - THREAD_SIZE.z;
    center = (back - front) / 2;
    
    color("gray")
    translate([0, center + CHAIN_GRIP.y / 2, -THREAD_SIZE.z / 2])
    rotate([180, 0, 0])
        grip();
}

module threadAnimation() {
    translate([0, -THREAD_SIZE.y + THREAD_SIZE.z / 2, 0])
        threadWithGrip();

    rotate([$t * 45, 0, 0])
        threadWithGrip();
}

module gears() {
    SPACING = 2;
    
    dist = gearSpacing(60, 24, GEAR_MOD);
    
    translate([0, 0, 0])
    rotate([0, 90, 0])
        wheelAssembly();
    
    angle = 45;
    
    translate([
        THREAD_SIZE.x + 2 * FACE_WIDTH + SPACING, 
        cos(angle) * dist, 
        sin(angle) * dist
    ])
    rotate([0, -90, 0])
        transmission();
}

// threadAnimation();
gears();