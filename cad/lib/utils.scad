function prop(key, table) = 
    table[search([key], table)[0]][1];

function flatten(l) = [ for (a = l) for (b = a) b ] ;

function getFragmentCount(debug=false) = debug ? 0 : 100;