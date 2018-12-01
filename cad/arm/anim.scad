use <arm.scad>
use <base.scad>

use <../lib/utils.scad>

DEBUG = false;
$fn = getFragmentCount(debug=DEBUG);

/*
$vpt = [-15, 0, 10];
$vpr = [75, 0, 320];
$vpd = 2200;
*/

function getAngleH(s=0, a=45) = $t < 0.25
    ? s - a * $t / 0.25
    : $t > 0.75 
    ? s - a * (1 - ($t - 0.75) / 0.25)
    : s - a;

function getAngleV(s=0, a=45) = $t < 0.25 || $t > 0.75
    ? s 
    : $t < 0.5
    ? s - a * ($t - 0.25) / 0.25
    : s - a * (1 - ($t - 0.5) / 0.25);

translate(getArmOffset())
    armAssembly(    
        getAngleH(30, 80), 
        getAngleV(0, 60));