use <../lib/utils.scad>

use <../wheelAssembly.scad>

include <common.scad>
use <sidePlate.scad>
use <wheelCover.scad>

include <../constant.scad>

DEBUG = true;

$fn = getFragmentCount(debug=DEBUG);

mirror([0, 1, 0])
mirror([1, 0, 0])
rotate([0, -90, 0])
    sidePlate();

mirror([1, 0, 0])
rotate([0, -90, 0])
    sidePlate(true);

% translate([-THREAD_SIZE.x / 2, 0, 0])
    wheelAssembly(showWheel=SHOW_WHEEL, showThread=SHOW_THREAD);
    
debugTransmission();

translate(TOP_FRONT_WHEEL)
rotate([-90, 0, 0])
rotate([0, 90, 0])
wheelCover();