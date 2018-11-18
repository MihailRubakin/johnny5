function getTBody() {
	return document.getElementById("results");
}

function clearResults() {
	const tbody = getTBody();
	while(tbody.firstChild) {
		tbody.removeChild(tbody.firstChild);
	}
}

function addRow(tbody, results) {
	const row = document.createElement("tr");
	tbody.appendChild(row);

	results.forEach(function(col, i) {
		const cell = document.createElement("td");
		cell.innerHTML = col.toString();
		row.appendChild(cell);
	});
}

function getConfig() {
	const config = {};

	[
		"ratio1",
		"ratio2",
		"drive",
		"min",
		"max",
	].forEach(function(key) {
		const input = document.getElementById(key);
		config[key] = parseFloat(input.value);
	});

	return config;
}

function getResults() {
	const config = getConfig();
	const results = [];

	const drive = config.drive;
	const ratio = config.ratio1 / config.ratio2;

	console.log(drive);

	for (var i = config.min; i <= config.max; i++) {
		for (var j = config.min; j <= config.max; j++) {
			for (var k = config.min; k <= config.max; k++) {
				const current = (i / drive) * (k / j);
				if (current === ratio) {
					results.push([i, j, k]);
				}
			}
		}
	}

	return results;
}

function onCalculateClick() {
	clearResults();

	const tbody = getTBody();
	const results = getResults();
	results.forEach(function(row) {
		addRow(tbody, row);
	});
}

function main() {
	const btn = document.getElementById("calculateBtn");
	btn.addEventListener("click", function() {
		onCalculateClick();
	});
}