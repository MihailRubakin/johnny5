use <lib/gear.scad>

THREAD_SIZE = [50, 20, 7.5];
THREAD_BOLT = 3.3;

TOOTH_SIZE = [20, 8.15, 5];
TOOTH_SPACING = (THREAD_SIZE.y - THREAD_SIZE.z) - TOOTH_SIZE.y;

// CHAIN_GRIP.x is a border from thread side
CHAIN_GRIP = [3, 2, 2];

GEAR_MOD = diametralPitchToModule(32);

SHAFT_DIAMETER = 6;
FACE_WIDTH = 6;

BEARING_DIAMETER = 13.3;
BEARING_HEIGHT = 5;