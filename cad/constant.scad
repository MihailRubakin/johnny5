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
WHEEL_GEAR_CLEARANCE = 1;
WHEEL_GEAR_FACE_WIDTH = FACE_WIDTH + WHEEL_GEAR_CLEARANCE;
WHEEL_GEAR_DEF = defGear(WHEEL_GEAR_TOOTHS, GEAR_MOD, 
            faceWidth=WHEEL_GEAR_FACE_WIDTH,
            shaft=WHEEL_SHAFT_DIAMETER,
            bearings=[
                defBearing(WHEEL_BEARING_DIAMETER, WHEEL_BEARING_HEIGHT, 1)
            ]);

WHEEL_THREAD_COUNT = 12;

CHASSIS_THICKNESS = 2;
CHASSIS_BORDER = 8;

TRANSMISSION_SHAFT_DIAMETER = 4;
TRANSMISSION_BEARING_DIAMETER = 10.3; // With clearance
TRANSMISSION_BEARING_HEIGHT = 4.3; // With clearance

TRANSMISSION_SMALL_GEAR_DEF= defGear(24, GEAR_MOD, 
            faceWidth=FACE_WIDTH,
            shaft=TRANSMISSION_SHAFT_DIAMETER,
            bearings=[
                defBearing(TRANSMISSION_BEARING_DIAMETER, 
                            TRANSMISSION_BEARING_HEIGHT, 1)
            ]);

TRANSMISSION_LARGE_GEAR_DEF= defGear(56, GEAR_MOD, 
            faceWidth=FACE_WIDTH,
            shaft=TRANSMISSION_SHAFT_DIAMETER,
            bearings=[
                defBearing(TRANSMISSION_BEARING_DIAMETER, 
                            TRANSMISSION_BEARING_HEIGHT)
            ]);
            
MOTOR_GEAR_DEF= defGear(14, GEAR_MOD, 
            faceWidth=FACE_WIDTH,
            shaft=3.175);
            
MOTOR_SCREW_SPACING = [24, 5];
MOTOR_SCREW_PLAY = 2;
MOTOR_ROTOR_DIAMETER = 11.5;
MOTOR_ROTOR_HEIGHT = 3.45;

MOTOR_PIGNON_BASE = 6;

MOTOR_BODY_DIAMETER = 36;
MOTOR_BODY_HEIGHT = 52.6;