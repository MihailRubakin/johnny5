use <utils.scad>

ITERATIONS = $fn;

function getStepSize(tooth) = 360 / ($fn > 0 && tooth < $fn ? $fn : tooth);

function circularPitchToModule(pitch) = pitch / PI;
function diametralPitchToModule(pitch) = 25.4 / pitch;

function defBearing(diameter, tickness=1, pos=0) = [
    [ "diameter", diameter ],
    [ "tickness", tickness],
    [ "pos", pos ]
];

module bearing(bearingDef, faceWidth) {
    diameter = prop("diameter", bearingDef);
    tickness = prop("tickness", bearingDef);
    
    module _bearing() {
        cylinder(tickness, r=diameter/2);
    }
    
    posFlag = prop("pos", bearingDef);
    
    if (posFlag == 1)  {
        translate([0, 0, faceWidth - tickness])
            _bearing();
    } else {
        _bearing();
    }
}

module shaft(gearDef) {
    faceWidth = prop("faceWidth", gearDef);
    shaft = prop("shaft", gearDef);
    
    if(shaft > 0)
        cylinder(faceWidth, r=shaft/2);
    
    bearings = prop("bearings", gearDef);
    
    for (bearingDef = bearings)  
        bearing(bearingDef, faceWidth);
}

function defGear(tooth, mod=1, pressureAngle=20, faceWidth=1, shaft=0, bearings=undef) =
    let (
        referenceDiameter = mod * tooth,
        pitch = PI * mod,
        addendum = mod,
        dedendum = 1.25 * mod
    )
    [
        [ "tooth", tooth],
        [ "module", mod],
        [ "pressureAngle", pressureAngle ],
        [ "faceWidth", faceWidth ],
        [ "referenceDiameter", referenceDiameter ],
        [ "tipDiameter", referenceDiameter  + 2 * mod ],
        [ "rootDiameter", referenceDiameter - 2.5 * mod ],
        [ "addendum", mod ],
        [ "dedendum", addendum ],
        [ "toothDepth", addendum + dedendum ],
        [ "pitch", pitch ],
        [ "toothTickness", pitch / 2 ],
        [ "shaft", shaft ],
        [ "bearings", bearings ]
    ];

module linear2D(gearDef) {
    polygon(getPoints(gearDef));
    
    function getPoints(gearDef) = 
        let(
            a = prop("pressureAngle", gearDef),
            z = prop("tooth", gearDef),
            p = prop("pitch", gearDef),
            ha = prop("addendum", gearDef),
            hf= prop("dedendum", gearDef),
            
            slope = tan(a) * (ha + hf),
            flat = (p - 2 * slope) / 2,
    
            p1 = flat / 2,
            p2 = flat / 2 + slope  / 2,
            p3 = flat / 2 + slope ,
            p4 = 1.5 * flat + slope ,
            p5 = 1.5 * flat + 1.5 * slope,
            p6 = 1.5 * flat + 2 * slope,
    
            points = [
                for(i=[0:z-1]) [
                    [ i * p, -hf],
                    [ i * p + p1, -hf],
                    [ i * p + p2, 0 ],
                    [ i * p + p3, ha],
                    [ i * p + p4, ha],
                    [ i * p + p5, 0 ],
                    [ i * p + p6, -hf ],
                    [ (i + 1) * p, -hf ]
                ]
            ]
        ) flatten(concat(
                [[[0,-hf-2]]],
                points,
                [[[p * z, -hf-2]]]));
}

module gear2D(gearDef) {
    r = prop("tipDiameter", gearDef) / 2;
    ref = prop("referenceDiameter", gearDef) / 2;
    
    pitch = prop("pitch", gearDef);
    tooth = prop("tooth", gearDef);
    length = pitch * tooth;
    
    step = getStepSize(tooth);
    
    difference() {
        circle(r);
        
        for(i=[0:step:360])
            rotate([0, 0, i])
            translate([-length * i/360, -ref, 0])
              linear2D(gearDef);
    }
}

module gear(gearDef) {
    faceWidth = prop("faceWidth", gearDef);
    
    difference() {
        linear_extrude(faceWidth) 
            gear2D(gearDef);
        shaft(gearDef);
    }
}

mod = diametralPitchToModule(32);

gear(
    defGear(60, mod, faceWidth=6,
        shaft=5,
        bearings=[
            defBearing(10, 4)
        ])
);