function parse() {
	gsub(/[]\[" ]/, "");

	designator = $1;
	pitch = $2;
	Rrot = $3;
	Dsupport = $4;
	v0[1] = $5;
	v0[0] = $6;

	v1[1] = $7;
	v1[0] = $8;

	v2[1] = $9;
	v2[0] = $10;

	v3[1] = $11;
	v3[0] = $12;
}

function slope(x, y) {
	# return the slope from vector x to vector y
	return atan2(y[1] - x[1], y[0] - x[0])
}

function test_horizontal() {
	# test whether v0 and v1 as well as v2 and v3 have the same radius
	if (v0[1] != v1[1] || v2[1] != v3[1])
		print designator " FAIL: not horizontal";
}

BEGIN	{
	# define useful constants
	FS = ","; 
	pi = atan2(0, -1);
	deg = pi / 180;
	dphi = 0.001;
	}

{ 	# first match-all rule: set state to untested
	tested = 0;
}

/M[0-9.x-]+-ext/ {
	# ext M threads have +/-60 deg slopes, horizontal crest / valley
	parse();
	m1 = slope(v0, v3) / deg;
	m2 = slope(v2, v1) / deg;
	if (m1 > 60 + dphi || m1 < 60 - dphi \
	    || m2 < -60 - dphi || m2 > -60 + dphi)
		print designator " FAIL: " m1 ", " m2 " deg";
	test_horizontal();
	tested = 1;
}
	
/M[0-9.x-]+-int/ { 
	# int M threads have +/-60 deg slopes, horizontal crest / valley
	parse();
	m1 = slope(v3, v0) / deg;
	m2 = slope(v1, v2) / deg;
	if (m1 > -60 + dphi || m1 < -60 - dphi \
	    || m2 < 60 - dphi || m2 > 60 + dphi)
		print designator " FAIL: " m1 ", " m2 " deg";
	test_horizontal();
	tested = 1;
}

/G.+-ext/ { 
	# ext M threads have +/-62.5 deg slopes, horizontal crest / valley
	parse();
	m1 = slope(v0, v3) / deg;
	m2 = slope(v2, v1) / deg;
	if (m1 > 62.5 + dphi || m1 < 62.5 - dphi \
	    || m2 < -62.5 - dphi || m2 > -62.5 + dphi)
		print designator " FAIL: " m1 ", " m2 " deg";
	test_horizontal();
	tested = 1;
}
	
/G.+-int/ { 
	# int G threads have +/-62.5 deg slopes, horizontal crest / valley
	parse();
	m1 = slope(v3, v0) / deg;
	m2 = slope(v1, v2) / deg;
	if (m1 > -62.5 + dphi || m1 < -62.5 - dphi \
	    || m2 < 62.5 - dphi || m2 > 62.5 + dphi)
		print designator " FAIL: " m1 ", " m2 " deg";
	test_horizontal();
	tested = 1;
}

/PCO.+-ext/ { 
	# PCO-1881 threads have slopes of -80 deg (on the load side) and 70 deg
	# (on the other side) + horizontal crest / valley
	parse();
	m1 = slope(v0, v3) / deg;
	m2 = slope(v2, v1) / deg;
	if (m1 > 70 + dphi || m1 < 70 - dphi \
	    || m2 < -80 - dphi || m2 > -80 + dphi)
		print designator " FAIL: " m1 ", " m2 " deg";
	test_horizontal();
	tested = 1;
}

/PCO.+-int/ { 
	# PCO-1881 threads have slopes of 80 deg (on the load side) and -70 deg
	# (on the other side) + horizontal crest / valley
	parse();
	m1 = slope(v3, v0) / deg;
	m2 = slope(v1, v2) / deg;
	if (m1 > -70 + dphi || m1 < -70 - dphi \
	    || m2 < 80 - dphi || m2 > 80 + dphi)
		print designator " FAIL: " m1 ", " m2 " deg";
	test_horizontal();
	tested = 1;
}

/"[^,]+-(int|ext)"/ {
	# final match-all (designators) rule: test wether all lines have been
	# tested
	if (tested == 0) {
		parse();
		print designator " FAIL: not tested";
	};
}

