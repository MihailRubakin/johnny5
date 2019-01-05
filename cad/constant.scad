use <lib/gear.scad>

THREAD_SIZE = [50, 20, 7.5];
THREAD_BOLT = 3.3;
THREAD_BOLT_DISTANCE = THREAD_SIZE.y - THREAD_SIZE.z / 2;

TOOTH_SIZE = [20, 8.15, 5];
TOOTH_SPACING = (THREAD_SIZE.y - THREAD_SIZE.z) - TOOTH_SIZE.y;

// CHAIN_GRIP.x is a border from thread side
CHAIN_GRIP = [3, 2, 2];

WHEEL_SHAFT_DIAMETER = 6;
FACE_WIDTH = 6;
WHEEL_BEARING_DIAMETER = 13.3; // With clearance
WHEEL_BEARING_HEIGHT = 5.3; // With clearance

GEAR_MOD = diametralPitchToModule(32);
WHEEL_GEAR_TOOTHS = 60;
WHEEL_GEAR_DEF = defGear(WHEEL_GEAR_TOOTHS, GEAR_MOD, 
            faceWidth=FACE_WIDTH,
            shaft=WHEEL_SHAFT_DIAMETER,
            bearings=[
                defBearing(WHEEL_BEARING_DIAMETER, WHEEL_BEARING_HEIGHT, 1)
            ]);

WHEEL_THREAD_COUNT = 12;

CHASIS_THICKNESS = 2;