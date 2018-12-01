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
