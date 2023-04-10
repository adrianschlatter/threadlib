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
	if (v0[1] != v1[1] || v2[1] != v3[1]) {
		print designator " FAIL: not horizontal";
		PASS = 0;
	}
}

BEGIN	{
	# define useful constants
	FS = ","; 
	pi = atan2(0, -1);
	deg = pi / 180;
	dphi = 0.1;

	PASS = 1;
	NR_OF_TESTS = 0;
	NR_OF_THREADS = 0;
}

{ 	# first match-all rule: set state to untested
	tested = 0;
}

/"[^,]+-ext/ {
	# external threads have positive Rrot 
	parse();
	if (Rrot < 0) {
		print designator " FAIL: negative radius of rotation";
		PASS = 0;
	}
	# test overlapp between thread and support
	if (Rrot > Dsupport / 2) {
		print designator " FAIL: Rsupport < Rrot";
		PASS = 0;
	}
	NR_OF_TESTS += 2;
}

/"[^,]+-int/ {
	# internal threads have negative Rrot 
	parse();
	if (Rrot > 0) {
		print designator " FAIL: positive radius of rotation";
		PASS = 0;
	}
	# test overlapp between thread and support
	if (-Rrot < Dsupport / 2) {
		print designator " FAIL: Rsupport > Rrot";
		PASS = 0;
	}
	NR_OF_TESTS += 2;
}

/((M[0-9.x-]+)|(UN([CF]|EF)[\/\#0-9-]+)|([0-9]+-UN-[\/\#0-9-]+))ext/ {
	# ext M, UN*, and *-UN threads have +/-60 deg slopes, horizontal crest / valley
	parse();
	m1 = slope(v0, v3) / deg;
	m2 = slope(v2, v1) / deg;
	if (m1 > 60 + dphi || m1 < 60 - dphi \
	    || m2 < -60 - dphi || m2 > -60 + dphi) {
		print designator " FAIL: " m1 ", " m2 " deg";
		PASS = 0;
	};
	test_horizontal();
	tested = 1;
	NR_OF_TESTS += 2;
}

/((M[0-9.x-]+)|(UN([CF]|EF)[\/\#0-9-]+)|([0-9]+-UN-[\/\#0-9-]+))int/ {
	# int M, UN*, and *-UN threads have +/-60 deg slopes, horizontal crest / valley
	parse();
	m1 = slope(v3, v0) / deg;
	m2 = slope(v1, v2) / deg;
	if (m1 > -60 + dphi || m1 < -60 - dphi \
	    || m2 < 60 - dphi || m2 > 60 + dphi) {
		print designator " FAIL: " m1 ", " m2 " deg";
		PASS = 0;
	}
	test_horizontal();
	tested = 1;
	NR_OF_TESTS += 2;
}

/(G.+-ext)|(RMS-ext)/ { 
	# ext G- and RMS threads have +/-62.5 deg slopes, horizontal crest / valley
	parse();
	m1 = slope(v0, v3) / deg;
	m2 = slope(v2, v1) / deg;
	if (m1 > 62.5 + dphi || m1 < 62.5 - dphi \
	    || m2 < -62.5 - dphi || m2 > -62.5 + dphi) {
		print designator " FAIL: " m1 ", " m2 " deg";
		PASS = 0;
	}
	test_horizontal();
	tested = 1;
	NR_OF_TESTS += 2;
}
	
/(G.+-int)|(RMS-int)/ { 
	# int G- and RMS threads have +/-62.5 deg slopes, horizontal crest / valley
	parse();
	m1 = slope(v3, v0) / deg;
	m2 = slope(v1, v2) / deg;
	if (m1 > -62.5 + dphi || m1 < -62.5 - dphi \
	    || m2 < 62.5 - dphi || m2 > 62.5 + dphi) {
		print designator " FAIL: " m1 ", " m2 " deg";
		PASS = 0;
	}
	test_horizontal();
	tested = 1;
	NR_OF_TESTS += 2;
}

/PCO-1810-ext/ { 
	# PCO-1810 threads have +/-70 deg slopes, horizontal crest / valley
	parse();
	m1 = slope(v0, v3) / deg;
	m2 = slope(v2, v1) / deg;
	if (m1 > 70 + dphi || m1 < 70 - dphi \
	    || m2 < -70 - dphi || m2 > -70 + dphi) {
		print designator " FAIL: " m1 ", " m2 " deg";
		PASS = 0;
	}
	test_horizontal();
	tested = 1;
	NR_OF_TESTS += 2;
}

/PCO-1810-int/ { 
	# PCO-1810 threads have +/-70 deg slopes, horizontal crest / valley
	parse();
	m1 = slope(v3, v0) / deg;
	m2 = slope(v1, v2) / deg;
	if (m1 > -70 + dphi || m1 < -70 - dphi \
	    || m2 < 70 - dphi || m2 > 70 + dphi) {
		print designator " FAIL: " m1 ", " m2 " deg";
		PASS = 0;
	}
	test_horizontal();
	tested = 1;
	NR_OF_TESTS += 2;
}

/PCO-1881-ext/ { 
	# PCO-1881 threads have slopes of -80 deg (on the load side) and 70 deg
	# (on the other side) + horizontal crest / valley
	parse();
	m1 = slope(v0, v3) / deg;
	m2 = slope(v2, v1) / deg;
	if (m1 > 70 + dphi || m1 < 70 - dphi \
	    || m2 < -80 - dphi || m2 > -80 + dphi) {
		print designator " FAIL: " m1 ", " m2 " deg";
		PASS = 0;
	}
	test_horizontal();
	tested = 1;
	NR_OF_TESTS += 2;
}

/PCO-1881-int/ { 
	# PCO-1881 threads have slopes of 80 deg (on the load side) and -70 deg
	# (on the other side) + horizontal crest / valley
	parse();
	m1 = slope(v3, v0) / deg;
	m2 = slope(v1, v2) / deg;
	if (m1 > -70 + dphi || m1 < -70 - dphi \
	    || m2 < 80 - dphi || m2 > 80 + dphi) {
		print designator " FAIL: " m1 ", " m2 " deg";
		PASS = 0;
	}
	test_horizontal();
	tested = 1;
	NR_OF_TESTS += 2;
}

/[^,]+-(int|ext)/ {
	# final match-all (designators) rule: test wether all lines have been
	# tested
	if (tested == 0) {
		parse();
		print designator " FAIL: not tested";
		PASS = 0;
	};
	NR_OF_THREADS += 1;
}

END {
	print "Ran " NR_OF_TESTS " tests on " NR_OF_THREADS " threads";
	if (PASS == 1) print "TESTS SUCCESSFUL"
	else print "TESTS FAIL";
}

