DEBUG = false;

use <tooth.scad>;

$fn = DEBUG ? 12 : 40;

// $vpt = [0, 0, 0];
// $vpr = [70, 0, $t * 360];

module thread(x, y, z, bolt=0.5, boltRecess=0.5, clearance = 0, pin=[1,1,1]) {
  front = 0;
  back = y - z / 2;
  center = (back - front) / 2;
  
  module frame() {
      hull() {
          // Front cylinder
          rotate([0, 90, 0])
          translate([0, front, 0])
            cylinder(x/2, r=z/2);
          
          // Back cylinder
          rotate([0, 90, 0])
          translate([0, back, 0])
            cylinder(x/2, r=z/2);
      }
  }
  
  module bolt(posY) {
      rotate([0, 90, 0])
          translate([0, posY, 0])
            cylinder(x/2, r=bolt/2);
  }
  
  module hinge(posX, posY, clearance) {
      translate([posX, posY, 0])
                cube([x / 4 + clearance, z + clearance, z], center=true);
  }
  
  module assembly() {
      union() {
          difference() {
              frame();
              
              union() {
                  // Front bolt
                  bolt(front);
                  
                  // Front hinge
                  hinge(1/8 * x, front, clearance);
                  
                  // Back bolt
                  bolt(back);
                  
                  // Back hinge
                  hinge(3/8 * x, back, clearance);
                  
                  // Bolt recess
                  translate([x/2 - boltRecess/2, 0, 0])
                    cube([boltRecess, 10, 10], center=true);

                // Chain grip
                // TODO: Size params
                color("red")
                translate([x/4, center, - z /2])
                    cube([x/2, 1, 1], center=true);
              };
          };
          
          translate([0, center - pin.y / 2, z / 2])
          rotate([0, 0, 90])
            tooth(pin.y, pin.x / 2, pin.z);
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

module test() {
    thread(50, 25, 10, 
        bolt=3.1, 
        boltRecess=5,
        clearance=0.25,
        pin=[10, 5, 5]);
}

translate([0, -25 + 10 / 2, 0])
    test();

rotate([$t * 45, 0, 0])
    test();