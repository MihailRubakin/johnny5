use <tooth.scad>;
use <lib/utils.scad>;
include <constant.scad>

$fn = getFragmentCount(debug=false);

SIZE = THREAD_SIZE;
BOLT_RECESS = 5;

CENTER_HINGE = 20;

CLEARANCE_X = 0.15;
CLEARANCE_Y = 0.3;
GRIP_CLEARANCE = 0.3;

function getHingeSizeY() = SIZE.z + 2 * CLEARANCE_Y;

function getCenterSizeY() = 
    let(
        front = 0,
        back = THREAD_BOLT_DISTANCE,
        hinge= getHingeSizeY(),
        sizeY = (back - front) - hinge
    ) sizeY;

module thread() {
  front = 0;
  back = THREAD_BOLT_DISTANCE;
  center = (back - front) / 2;
  
  module frame() {
      hull() {
          // Front cylinder
          rotate([0, 90, 0])
          translate([0, front, 0])
            cylinder(SIZE.x/2, d=SIZE.z);
          
          // Back cylinder
          rotate([0, 90, 0])
          translate([0, back, 0])
            cylinder(SIZE.x/2, d=SIZE.z);
      }
  }
  
  module bolt(posY) {
      rotate([0, 90, 0])
          translate([0, posY, 0])
            cylinder(SIZE.x/2, d=THREAD_BOLT);
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
            sizeX + GRIP_CLEARANCE / 2, 
            CHAIN_GRIP.y + GRIP_CLEARANCE / 2, 
            2 * CHAIN_GRIP.z
        ], center=true);
  }
  
  module toothWithChamfer() {
    CHAMFER_SIZE = sqrt(pow(TOOTH_SIZE.z, 2) + pow(TOOTH_SIZE.z, 2));

    module chamfer() {    
        translate([
            TOOTH_SIZE.y / 2, 
            TOOTH_SIZE.x / 2, 
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
            translate([0, TOOTH_SIZE.x / 4, 0])
                tooth(TOOTH_SIZE.y, TOOTH_SIZE.x / 2, TOOTH_SIZE.z);
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
            0, 
            center + TOOTH_SIZE.y / 2, 
            SIZE.z / 2
        ])
        rotate([0, 0, -90])
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

function getThreadRingDiameter(tooth) =
    let(
        side = THREAD_BOLT_DISTANCE,
        radius = side / (2 * sin(180 / tooth))
    ) 2 * radius;

module threadRing(tooth, start=0, end=-1) {
    radius = getThreadRingDiameter(tooth) / 2;
    
    end = end == -1 ? tooth : end;
    
    for ( i=[start:end]) {
        a0 = i * 360 / tooth;
        x0 = sin(a0) * radius;
        y0 = cos(a0) * radius;
        
        a1 = (i + 1) * 360 / tooth;
        x1 = sin(a1) * radius;
        y1 = cos(a1) * radius;
        
        a = atan2(y1 - y0, x1 - x0);
        
        translate([x0, y0, 0])
        rotate([0, 90, a - 90])
            thread();
    }
}

module threadChain(tooth) {
    for(i = [0:tooth - 1])
        translate([0, (i + 0.5) * THREAD_BOLT_DISTANCE, 0])
            thread();
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