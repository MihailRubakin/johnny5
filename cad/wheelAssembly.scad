use <lib/utils.scad>
use <thread.scad>
include <constant.scad>

/*
    TODO: 
    - Need to validate that threads work properly with different wheel thread count
    - Flip front and back
    - Move wheel position calculation to a function (for chasis)
    - Move assembly to a module
*/

SHOW_THREAD = true;

WHEEL_DIAMETER = getThreadRingDiameter(WHEEL_THREAD_COUNT) - THREAD_SIZE.z;

SHAFT_DIAMETER = WHEEL_SHAFT_DIAMETER;

MIDDLE_WHEEL_COUNT = 2;

BOTTOM_THREAD_COUNT = 12;
TOP_THREAD_COUNT = 17;
DIAGONAL_THREAD_COUNT = 4;

THREAD_RADIUS = (WHEEL_DIAMETER + THREAD_SIZE.z) / 2;

module simpleWheel() {
    render() {
        rotate([0, 90, 0])
        rotate([0, 0, 360 / WHEEL_THREAD_COUNT / 2])
        difference() {
            cylinder(THREAD_SIZE.x, 
                d=WHEEL_DIAMETER, center=true, 
                $fn=WHEEL_THREAD_COUNT);
            cylinder(THREAD_SIZE.x, d=SHAFT_DIAMETER, center=true);
        }
    }
}

module threadArc(pos, start=0, end=-1) {
    translate(pos)
    rotate([0, 90, 0])
        threadRing(WHEEL_THREAD_COUNT, 
            start=floor(start) - 0.5, 
            end=ceil(end) - 0.5);
}

function threadIterator(ratio) =
    ratio * WHEEL_THREAD_COUNT;    

function getThreadDelta(i) = 
    let(
        angle = -i * (360 / WHEEL_THREAD_COUNT)
    ) [
        0,
        cos(angle) * THREAD_RADIUS,
        sin(angle) * THREAD_RADIUS
];

/**
 * Calculate thread size
 */

BOTTOM_THREAD_WIDTH = BOTTOM_THREAD_COUNT * THREAD_BOLT_DISTANCE;
TOP_THREAD_WIDTH = TOP_THREAD_COUNT * THREAD_BOLT_DISTANCE;
DIAGONAL_THREAD_WIDTH = DIAGONAL_THREAD_COUNT * THREAD_BOLT_DISTANCE;

/**
 * Calculate thread iterators
 */

TOP_BACK_THREAD_ITERATOR = 
        threadIterator(9/8);
BOTTOM_BACK_THREAD_ITERATOR = 
    threadIterator(1/8);
BOTTOM_FRONT_THREAD_ITERATOR = threadIterator(3/8);
TOP_FRONT_THREAD_ITERATOR =
    threadIterator(3/8);

/**
 *   Thread anchors
 */

BOTTOM_FRONT_THREAD_ANCHOR = 
    getThreadDelta(BOTTOM_FRONT_THREAD_ITERATOR);
TOP_FRONT_THREAD_ANCHOR = 
    getThreadDelta(TOP_FRONT_THREAD_ITERATOR);
TOP_BACK_THREAD_ANCHOR = 
    getThreadDelta(TOP_BACK_THREAD_ITERATOR);
BOTTOM_BACK_THREAD_ANCHOR = 
    getThreadDelta(BOTTOM_BACK_THREAD_ITERATOR);

/**
 * Bottom wheel positions
 */
bottomFrontWheel = [
    0, -BOTTOM_THREAD_WIDTH / 2, 0
];

bottomBackWheel = [
    0, 
    BOTTOM_THREAD_WIDTH / 2,
    0
];

bottomMiddleWheels = [
    let (delta = bottomBackWheel - bottomFrontWheel)
    for (i = [1:MIDDLE_WHEEL_COUNT]) 
        bottomFrontWheel + i * delta / (MIDDLE_WHEEL_COUNT + 1)
];

/**
 * Top wheel positions
 */
    
topFrontDeltaY = TOP_THREAD_WIDTH / 2;
frontAnchorDeltaY = (bottomFrontWheel.y + BOTTOM_FRONT_THREAD_ANCHOR.y) - (-topFrontDeltaY + TOP_FRONT_THREAD_ANCHOR.y);
anchorDeltaZ = sqrt(abs(pow(DIAGONAL_THREAD_WIDTH, 2) - pow(frontAnchorDeltaY, 2)));
wheelDeltaZ = anchorDeltaZ - TOP_FRONT_THREAD_ANCHOR.z + BOTTOM_FRONT_THREAD_ANCHOR.z;

topFrontWheel = [
    0,
    -topFrontDeltaY,
    bottomFrontWheel.z + anchorDeltaZ
];
topBackWheel = [
    0,
    topFrontDeltaY,
    topFrontWheel.z
];

wheels = concat(bottomMiddleWheels, [
    bottomFrontWheel,
    bottomBackWheel,
    topFrontWheel,
    topBackWheel
]);

module wheelAssembly(showWheel=true, showThread=true) {
    
    if (showWheel) {
        % for (pos = wheels) 
            translate(pos) simpleWheel();
    }

    if (showThread) {
        flatThreadDeltaZ = THREAD_RADIUS * cos(360 / WHEEL_THREAD_COUNT / 2);
        
        topBackThreadPos = topBackWheel + TOP_BACK_THREAD_ANCHOR;
        bottomBackThreadPos = bottomBackWheel + BOTTOM_BACK_THREAD_ANCHOR;
        bottomFrontThreadPos = bottomFrontWheel + BOTTOM_FRONT_THREAD_ANCHOR;
        topFrontThreadPos = topFrontWheel + TOP_FRONT_THREAD_ANCHOR;
        
        /**
         * NOTE: Parts are drawn clockwise from right view
         */
        
        // Top flat chain
        translate([
            topFrontWheel.x,
            topFrontWheel.y,
            topFrontWheel.z + flatThreadDeltaZ
        ])
        mirror([0, 0, 1])
            threadChain(TOP_THREAD_COUNT - 1);
            
        // Top back wheel
        threadArc(topBackWheel, 
            start=threadIterator(3/4), 
            end=TOP_BACK_THREAD_ITERATOR - 1);
            
        // Back diagonal chain
        angleBack = atan2(
            bottomBackThreadPos.z - topBackThreadPos.z,
            bottomBackThreadPos.y - topBackThreadPos.y);

        translate(topBackThreadPos)
        rotate([angleBack, 0, 0])
        mirror([0, 0, 1])
        translate([0, -THREAD_BOLT_DISTANCE / 2, 0])
        threadChain(DIAGONAL_THREAD_COUNT);
        
        // Bottom back wheel
        threadArc(bottomBackWheel, 
            start=BOTTOM_BACK_THREAD_ITERATOR + 1, 
            end=threadIterator(1/4));
        
        // Bottom flat chain
        translate([
            bottomBackWheel.x,
            bottomBackWheel.y,
            bottomBackWheel.z - flatThreadDeltaZ
        ])
        mirror([0, 1, 0])
            threadChain(BOTTOM_THREAD_COUNT - 1);
        
        // Bottom front wheel
        threadArc(bottomFrontWheel, 
            start=threadIterator(1/4), 
            end=BOTTOM_FRONT_THREAD_ITERATOR - 1);
        
        // Front diagonal chain
        angleFront = atan2(
            topFrontThreadPos.z - bottomFrontThreadPos.z,
            topFrontThreadPos.y - bottomFrontThreadPos.y);
        
        translate(bottomFrontThreadPos)
        rotate([angleFront, 0, 0])
        mirror([0, 0, 1])
        translate([0, -THREAD_BOLT_DISTANCE / 2, 0])
        threadChain(DIAGONAL_THREAD_COUNT);
        
        // Top front wheel
        threadArc(topFrontWheel, 
            start=TOP_FRONT_THREAD_ITERATOR + 1, 
            end=threadIterator(3/4));
    }
}

function getWheelsPos() = wheels;
function getTopFront() = topFrontWheel;
function getTopBack() = topBackWheel;
function getBottomFront() = bottomFrontWheel;
function getBottomBack() = bottomBackWheel;

wheelAssembly();