function prop(key, table) = 
    table[search([key], table)[0]][1];

function flatten(l) = [ for (a = l) for (b = a) b ] ;

function getFragmentCount(debug=false) = debug ? 0 : 100;

function circleIntersection(c, radius, p0, p1) = let(
    dx = p1.x - p0.x,
    dy = p1.y - p0.y,
    
    a = pow(dx, 2) + pow(dy, 2),
    b = 2 * (dx * (p0.x - c.x) + dy * (p0.y - c.y)),
    c = pow(p0.x - c.x, 2)
        + pow(p0.y - c.y, 2)
        - pow(radius, 2),
    
    det = b * b - 4 * a * c
)
    // If (no point)
    (a <= 0.0000001 || det < 0) 
    ? []
    // Else if (one point)
    : (det == 0)
    ? let(t = -b / 2 * a) [[
        p0.x + t * dx,
        p0.y + t * dy
    ]]
    // Else (two points)
    : let(
        t0 = (-b + sqrt(det)) / (2 * a),
        t1 = (-b - sqrt(det)) / (2 * a)
        ) [
            [p0.x + t0 * dx, p0.y + t0 * dy],
            [p0.x + t1 * dx, p0.y + t1 * dy]
        ];
        
module sector(radius, start, end, fn = 24) {
    r = radius / cos(180 / fn);
    step = -360 / fn;

    points = concat([[0, 0]],
        [for(a = [start : step : end - 360]) 
            [r * cos(a), r * sin(a)]
        ],
        [[r * cos(end), r * sin(end)]]
    );
    
    difference() {
        circle(radius, $fn = fn);
        polygon(points);
    }
}

module arc(radius, start, end, width = 1, fn = 24) {
    difference() {
        difference() {
            sector(radius + width, start, end, fn);
            sector(radius, start, end, fn);
        }
        circle(r=radius, $fn=fn);
    }
}