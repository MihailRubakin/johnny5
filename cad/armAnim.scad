use <arm.scad>

/*
$vpt = [-15, 0, 10];
$vpr = [75, 0, 320];
$vpd = 215;
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

armAssembly(    
    getAngleH(30, 90), 
    getAngleV(0, 60));