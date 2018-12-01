DEBUG = false;

$fn = DEBUG ? 0 : 100;

SEGMENT_WIDTH = 20;
BOLT_DIAMETER = 3;

SHORT = 75;
LONG = 175;
CLAW_WIDTH = 25;
THICKNESS = 10;

// Angles in degree
BOTTOM_SLOPE = 30;
TOP_SLOPE = 10;

CENTER = 50;

function getTopCoords(size, angle) =
	let(computedAngle = 90 + angle) [
		cos(computedAngle) * size,
		sin(computedAngle) * size
	];

function getBottomCoords(size, angle) = [
    cos(angle) * size,
    sin(angle) * size
];