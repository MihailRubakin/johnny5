module hingeDuplicator(yCoords) {
    for (y = yCoords)
        translate([0, y, 0])
            children();
}

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