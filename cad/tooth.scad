use <lib/utils.scad>

function getFragmentCount() = $fn > 0 ? $fn / 2 : 6;

module tooth2D(x, y) {
    step = 180 / getFragmentCount();
    
    coords = [
        for (i = [0:step:180])
            [ x * i/180, y* sin(i)]
    ];
        
    polygon(coords);
}

module tooths2D(x, y, count, spacing=1, base=1) {
    width = x + spacing;
    
    step = 180 / getFragmentCount();
    
    coords = flatten(
        [
            for (i = [0:count])
                concat([
                    for (j = [0:step:180])
                        [ i * width + x * j/180, y* sin(j)]
                ], [
                    [i * width + x, 0],
                    [i * width + x + spacing, 0]
                ])
        ]);
        
    polygon(concat([[0, -base]], coords, [[ (count + 1) * width, -base]]));
}

module tooth(x, y, z) {
    translate([0, y / 2, 0])
    rotate([90, 0, 0])
    linear_extrude(y) 
        tooth2D(x, z);
}

module tooths(x, y, z, count, spacing=1, base=1) {
    translate([0, y / 2, 0])
    rotate([90, 0, 0])
    linear_extrude(y) 
        tooths2D(x, z, count, spacing, base);
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
        
        // TODO: generate
        echo("Got ", count, " tooths");
    }
}

function diameterFromToothCount(x, spacing, count) =
    (x + spacing) * count / PI;

// toothsFromDiameter(0.75, 0.75, 1, 1, diameterFromToothCount(0.75, 1, 10));

//tooths2D(0.75, 1, 10);

tooths(0.75, 1, 3, 10);