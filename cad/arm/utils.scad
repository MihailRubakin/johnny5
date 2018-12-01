module hingeDuplicator(yCoords) {
    for (y = yCoords)
        translate([0, y, 0])
            children();
}

function getYPositions(thickness=1, center=1) = 
    let (
        segment = thickness,
        hinge = thickness
    ) [
        // 0
        0,
        // 1
        -(hinge),
        // 2
        -(hinge + segment),
        // 3
        -(2 * hinge + segment),
        // 4
        -(2 * hinge + segment + center),
        // 5
        -(3 * hinge + segment + center),
        // 6
        -(3 * hinge + 2 * segment + center),
        // 7
        -(4 * hinge + 2 * segment + center)
    ];

function getSizeY(thickness=1, center=1) = 
    let (
        segment = thickness,
        hinge = thickness
    ) 4 * hinge + 2 * segment + center;

module debugSphere(pos) {
    color("red")
    translate([pos.x, 0, pos.y])
        sphere(r=2);
}

module debugBolt(length, pos, y = 0) {
    color("blue")
    translate([pos.x, y, pos.y])
    rotate([90, 0, 0])
        cylinder(length, r=0.25);
}