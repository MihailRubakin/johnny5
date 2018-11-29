include <constant.scad>
use <lib/utils.scad>;

setDebug(false);

WIDTH = THREAD_SIZE.x - 2 * CHAIN_GRIP.x;

HEIGHT = 1.5;
ROUND = 1.5;

module grip() {
    module rounded() {
        translate([0, CHAIN_GRIP.y / 2, 0])
        rotate([90, 0, 0])
            cylinder(CHAIN_GRIP.y, r=ROUND);
    }
    
    hull() {
        translate([0, 0, -CHAIN_GRIP.z / 2])
            cube([WIDTH, CHAIN_GRIP.y, CHAIN_GRIP.z], center=true);
        
        translate([-WIDTH / 2 + ROUND, 0, HEIGHT - ROUND])
            rounded();
        translate([WIDTH / 2 - ROUND, 0, HEIGHT - ROUND])
            rounded();
    }
}

translate([0, 0, CHAIN_GRIP.y / 2])
rotate([90, 0, 0])
    grip();