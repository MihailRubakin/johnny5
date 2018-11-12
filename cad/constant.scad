use <lib/gear.scad>

THREAD_SIZE = [50, 20, 7.5];

TOOTH_SIZE = [15, 5, 5];
TOOTH_SPACING = (THREAD_SIZE.y - THREAD_SIZE.z) - TOOTH_SIZE.y;

// CHAIN_GRIP.x is a border from thread side
CHAIN_GRIP = [3, 3, 3];

GEAR_MOD = diametralPitchToModule(32);

SHAFT_DIAMETER = 5;
FACE_WIDTH = 6;

BEARING_DIAMETER = 10;
BEARING_HEIGHT = 4;