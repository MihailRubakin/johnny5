const SEGMENT_WIDTH = 25;

var canvas, ctx, width, height, color;

function clear() {
	ctx.clearRect(0, 0, width, height);
}

function drawPath(points, fill) {
	ctx.beginPath();
	ctx.moveTo(points[0][0], points[0][1]);
	
	for (var i = 1; i < points.length; i++) {
		ctx.lineTo(points[i][0], points[i][1]);
	}

	
	if (points.length > 2) {
		ctx.lineTo(points[0][0], points[0][1]);
	}

	ctx.stroke();

	if (fill) {
		ctx.fillStyle = ctx.strokeStyle;
		ctx.fill();
	}

	ctx.closePath();
}

function drawPoint(x, y, width) {
	if (width === undefined) {
		width = 1;
	}
	ctx.beginPath();
	ctx.arc(x, y, width, 0, deg2Rad(360));
	ctx.fill();
	ctx.closePath();
}

function drawSegment(x0, y0, x1, y1) {

	ctx.strokeStyle = "black";
	ctx.lineWidth = SEGMENT_WIDTH;
	ctx.lineCap = "round";		
	drawPath([[x0, y0], [x1, y1]]);
	
	ctx.strokeStyle = color;
	ctx.lineWidth = SEGMENT_WIDTH / 2;
	ctx.lineCap = "round";
	drawPath([[x0, y0], [x1, y1]]);

	ctx.fillStyle = "black";
	drawPoint(x0, y0);
	drawPoint(x1, y1);
}

function drawTriangle(x0, y0, x1, y1, x2, y2) {

	ctx.lineJoin = "round";
	ctx.lineCap = "round";

	ctx.strokeStyle = "black";
	ctx.lineWidth = SEGMENT_WIDTH;
	drawPath([[x0, y0], [x1, y1], [x2, y2]]);
	
	ctx.strokeStyle = color;
	ctx.lineWidth = SEGMENT_WIDTH / 2;
	drawPath([[x0, y0], [x1, y1], [x2, y2]], true);

	ctx.fillStyle = "black";
	drawPoint(x0, y0);
	drawPoint(x1, y1);
	drawPoint(x2, y2);
}


function initScene() {
	canvas = document.getElementById("canvas");
	ctx = canvas.getContext("2d");

	width = canvas.width;
	height = canvas.height;

	// Flip canvas
	ctx.transform(1, 0, 0, -1, 0, height);
}
