use <../lib/utils.scad>

DEBUG = false;
$fn = getFragmentCount(debug=DEBUG);

// Used to calculate segment max length
BED_DIMENSION = 190;

SEGMENT_WIDTH = 30;
BOLT_DIAMETER = 3.3; // 3 + 0.3 clearance

SHORT = 60;
LONG = sqrt(2 * BED_DIMENSION * BED_DIMENSION) - (SHORT + 3/2 * SEGMENT_WIDTH);

SIZE_Y = 42;

CLAW_WIDTH = 25;
CLEARANCE = 0.3;
THICKNESS = 5;

// Angles in degree
BOTTOM_SLOPE = 30;
TOP_SLOPE = 10;

CENTER = SIZE_Y - 6 * THICKNESS;

function getTopCoords(size, angle) =
	let(computedAngle = 90 + angle) [
		cos(computedAngle) * size,
		sin(computedAngle) * size
	];

function getBottomCoords(size, angle) = [
    cos(angle) * size,
    sin(angle) * size
];