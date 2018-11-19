const ANCHOR = { x: 0, y: 30 };


const SMALL_LEN = 50;
const LONG_LEN = 150;

const UPPER_ARM_BASE_ANGLE = deg2Rad(30);
const UPPER_BASE_OFFSET = { 
	x: Math.cos(UPPER_ARM_BASE_ANGLE) * SMALL_LEN, 
	y: Math.sin(UPPER_ARM_BASE_ANGLE) * SMALL_LEN
};

const WRIST_ANGLE = deg2Rad(90);

function draw(upperarm, forearm) {
	clear();

	// Anchors
	const anchorMiddle = {
		x: ANCHOR.x + Math.cos(upperarm + deg2Rad(90)) * LONG_LEN,
		y: ANCHOR.y + Math.sin(upperarm + deg2Rad(90)) * LONG_LEN,
	};
	const anchorTip = { 
		x: anchorMiddle.x + Math.cos(forearm + Math.PI) * LONG_LEN, 
		y: anchorMiddle.y + Math.sin(forearm + Math.PI) * LONG_LEN, 
	};
	
	// Upper arm
	const upperarmBottomRight = {
		x: ANCHOR.x + UPPER_BASE_OFFSET.x,
		y: ANCHOR.y + UPPER_BASE_OFFSET.y
	};
	const upperarmTopRight = {
		x: anchorMiddle.x + Math.cos(UPPER_ARM_BASE_ANGLE) * SMALL_LEN,
		y: anchorMiddle.y + Math.sin(UPPER_ARM_BASE_ANGLE) * SMALL_LEN,
	};
	const upperarmTopLeft = {
		x: anchorMiddle.x - Math.cos(WRIST_ANGLE) * SMALL_LEN,
		y: anchorMiddle.y + Math.sin(WRIST_ANGLE) * SMALL_LEN,
	};

	const anchorAngle = Math.atan2(anchorTip.y - anchorMiddle.y, anchorTip.x - anchorMiddle.x);

	const upperarmTip = {
		x: upperarmTopLeft.x + Math.cos(anchorAngle) * LONG_LEN,
		y: upperarmTopLeft.y + Math.sin(anchorAngle) * LONG_LEN,
	}
	drawPoint(upperarmTip.x, upperarmTip.y)
	
	color = "blue";
	drawSegment(upperarmBottomRight.x, upperarmBottomRight.y, upperarmTopRight.x, upperarmTopRight.y);
	drawSegment(ANCHOR.x, ANCHOR.y, anchorMiddle.x, anchorMiddle.y);
	drawSegment(upperarmTopLeft.x, upperarmTopLeft.y, upperarmTip.x, upperarmTip.y);
	drawSegment(anchorTip.x, anchorTip.y, upperarmTip.x, upperarmTip.y);
	drawTriangle(anchorMiddle.x, anchorMiddle.y, upperarmTopRight.x, upperarmTopRight.y, upperarmTopLeft.x, upperarmTopLeft.y);
	drawTriangle(ANCHOR.x, ANCHOR.y, upperarmBottomRight.x, upperarmBottomRight.y, ANCHOR.x + UPPER_BASE_OFFSET.x, ANCHOR.y);

	// Forearm
	const forearmTopRight = {
		x: anchorMiddle.x + Math.cos(forearm) * SMALL_LEN, 
		y: anchorMiddle.y + Math.sin(forearm) * SMALL_LEN, 
	};
	const forearmBottomRight = { 
		x: ANCHOR.x + Math.cos(forearm) * SMALL_LEN, 
		y: ANCHOR.y + Math.sin(forearm) * SMALL_LEN, 
	};

	color = "cyan";
	drawSegment(forearmBottomRight.x, forearmBottomRight.y, forearmTopRight.x, forearmTopRight.y);
	drawSegment(ANCHOR.x, ANCHOR.y, forearmBottomRight.x, forearmBottomRight.y);
	drawSegment(forearmTopRight.x, forearmTopRight.y, anchorTip.x, anchorTip.y);
	drawPoint(anchorMiddle.x, anchorMiddle.y);
}

function main() {
	initScene();

	ANCHOR.x = width / 2;

	const upperarmSlider = document.getElementById("upperarm");
	const forearmSlider = document.getElementById("forearm");

	function handleChange() {
		const upperarm = deg2Rad(parseFloat(upperarmSlider.value));
		const forearm = deg2Rad(parseFloat(forearmSlider.value));

		draw(upperarm, forearm);
	}

	upperarmSlider.addEventListener("input", function() {
		handleChange();
	});

	forearmSlider.addEventListener("input", function() {
		handleChange();
	});

	// Force first run
	handleChange();
	
	/*
	color = "white";
	cx = width / 2;
	cy = height / 2;
	s = 50;
	drawTriangle(cx, cy + s, cx - s, cy, cx + s, cy);
	*/
}