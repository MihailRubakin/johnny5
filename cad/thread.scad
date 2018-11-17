use <tooth.scad>;
include <constant.scad>

DEBUG = false;
$fn = DEBUG ? 0 : 100;

SIZE = THREAD_SIZE;
BOLT = 3.3;
BOLT_RECESS = 5;

CLEARANCE = 0.3;

CENTER_HINGE = 20;

module thread() {
  front = 0;
  back = SIZE.y - SIZE.z / 2;
  center = (back - front) / 2;
  
  module frame() {
      hull() {
          // Front cylinder
          rotate([0, 90, 0])
          translate([0, front, 0])
            cylinder(SIZE.x/2, r=SIZE.z/2);
          
          // Back cylinder
          rotate([0, 90, 0])
          translate([0, back, 0])
            cylinder(SIZE.x/2, r=SIZE.z/2);
      }
  }
  
  module bolt(posY) {
      rotate([0, 90, 0])
          translate([0, posY, 0])
            cylinder(SIZE.x/2, r=BOLT/2);
  }
  
  module hinge(front=false) {
      clearance = front ? 0 : CLEARANCE;
      
      module frontHinge() {
          translate([CENTER_HINGE / 4 - clearance, 0, 0])
            cube([
                CENTER_HINGE / 2 - 2 * clearance,
                SIZE.z + 2 * clearance,
                SIZE.z
            ], center=true);
      }
      
      if (front) {
          frontHinge();
      } else {
          difference() {
              translate([SIZE.x / 4, 0, 0])
                cube([SIZE.x / 2, SIZE.z, SIZE.z], center=true);
              frontHinge();
          }
      }
  }
  
  module boltRecess() {
      translate([SIZE.x / 2 - BOLT_RECESS / 2, 0, 0])
        cube([BOLT_RECESS, SIZE.z, SIZE.z], center=true);
  }
  
  module chainGrip() {
    sizeX = SIZE.x / 2 - CHAIN_GRIP.x;
    translate([sizeX / 2, center, -SIZE.z /2])
        cube([
            sizeX, 
            CHAIN_GRIP.y, 
            2 * CHAIN_GRIP.z
        ], center=true);
  }
  
  module assembly() {      
      union() {
        difference() {
            frame();

            // Front
            bolt(front);
            translate([0, front, 0])
                hinge(front=true);

            // Back
            bolt(back);
            translate([0, back, 0])
                hinge(front=false);
            
            boltRecess();
            chainGrip();
        };

        translate([
            TOOTH_SIZE.x / 4, 
            center - TOOTH_SIZE.y / 2, 
            SIZE.z / 2
        ])
        rotate([0, 0, 90])
            tooth(TOOTH_SIZE.y, TOOTH_SIZE.x / 2, TOOTH_SIZE.z);
      }
  }
  
  render() {
      union() {
          assembly();
          
          mirror()
            assembly();
      }
  }
}

module main() {
    thread();
}

translate([
    0, 
    -(THREAD_SIZE.y  - THREAD_SIZE.z / 2) / 2, 
    THREAD_SIZE.z / 2
])
    main();