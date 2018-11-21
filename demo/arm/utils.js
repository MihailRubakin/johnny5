function deg2Rad(d) {
	return d * Math.PI / 180;
}

function rad2Deg(r) {
	return 180 * r / Math.PI;
}

function getAngle(dx, dy) {
	return rad2Deg(Math.atan2(dy, dx));
}

function inRange(v, min, max) {
	return v >= min && v <= max;
}