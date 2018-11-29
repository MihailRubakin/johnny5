function prop(key, table) = 
    table[search([key], table)[0]][1];

function flatten(l) = [ for (a = l) for (b = a) b ] ;

module setDebug(debug) {
	$fn = debug ? 0 : 100;
}