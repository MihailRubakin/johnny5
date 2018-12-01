use <wheel.scad>
use <lib/utils.scad>

DEBUG = false;

$fn = getFragmentCount(debug=DEBUG);

wheelAssembly(geared=true);