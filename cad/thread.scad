use <tooth.scad>;
include <constant.scad>

DEBUG = false;
$fn = DEBUG ? 0 : 100;

SIZE = THREAD_SIZE;
BOLT = 3.3;
BOLT_RECESS = 5;

CLEARANCE_X = 0.15;
CLEARANCE_Y = 0.3;

CENTER_HINGE = 20;

function getBackY() = SIZE.y - SIZE.z / 2;
function getHingeSizeY() = SIZE.z + 2 * CLEARANCE_Y;

function getCenterSizeY() = 
    let(
        front = 0,
        back = getBackY(),
        hinge= getHingeSizeY(),
        sizeY = (back - front) - hinge
    ) sizeY;

module thread() {
  front = 0;
  back = getBackY();
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
      clearanceX = front ? 0 : CLEARANCE_X;
      
      module frontHinge() {
          translate([CENTER_HINGE / 4 - clearanceX, 0, 0])
            cube([
                CENTER_HINGE / 2 - 2 * clearanceX,
                getHingeSizeY(),
                SIZE.z
            ], center=true);
      }
      
      if (front) {
          frontHinge();
      } else {
          difference() {
              translate([SIZE.x / 4, 0, 0])
                cube([SIZE.x / 2, SIZE.z + 2 * CLEARANCE_Y, SIZE.z], center=true);
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
  
  module toothWithChamfer() {
    CHAMFER_SIZE = sqrt(pow(TOOTH_SIZE.z, 2) + pow(TOOTH_SIZE.z, 2));

    module chamfer() {    
        translate([
            TOOTH_SIZE.y / 2, 
            TOOTH_SIZE.x / 4 + TOOTH_SIZE.z, 
            TOOTH_SIZE.z
        ])
        rotate([45, 0, 0])
        cube([
            TOOTH_SIZE.y, 
            CHAMFER_SIZE, 
            CHAMFER_SIZE
        ], center=true);
    }
    
    difference() {
        tooth(
            TOOTH_SIZE.y, 
            TOOTH_SIZE.x / 2 + 2 * TOOTH_SIZE.z, 
            TOOTH_SIZE.z);
        chamfer();
        mirror([0, 1, 0])
            chamfer();
    }
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
            toothWithChamfer();
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