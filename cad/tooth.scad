$fn = 16;

module tooth(x, y, z) {
    
    coords = [
        for (i = [0:1:180])
            [ x * i/180, z* sin(i)]
    ];

    translate([0, y / 2, 0])
    rotate([90, 0, 0])
    linear_extrude(y) 
        polygon(coords);
}

module tooths(x, y, z, count, spacing=1) {
    union() {
        translate([0, -y / 2, -1])
            cube([count * (x + spacing), y, 1], center=false);
        for(i=[0:1:count-1])
            translate([ i * (x + spacing), 0, 0])
                tooth(x, y, z);
    }
}

module toothsFromDiameter(x, y, z, spacing, diameter) {
    circ = PI * diameter;
    
    toothSize = x + spacing;
    
    if (circ % toothSize != 0) {
        current = circ / toothSize;
        lower = floor(current) * toothSize / PI;
        echo("ERROR: Need integral tooth count. ", 
            "Got ", current, " tooths. ", 
            "Lower diameter to ", lower);
    } else {
        count = (circ/ toothSize);
        echo("Got ", count, " tooths");
    }
}

function diameterFromToothCount(x, spacing, count) =
    (x + spacing) * count / PI;

tooths(0.75, 0.75, 1, 10);

toothsFromDiameter(0.75, 0.75, 1, 1, diameterFromToothCount(0.75, 1, 10));