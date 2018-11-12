use <thread.scad>;
use <grip.scad>;
include <constant.scad>;

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

threadAnimation();