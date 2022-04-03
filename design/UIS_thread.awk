function tan(x) {
	return(sin(x) / cos(x))
}

function min(x, y) {
	if (x < y) return(x)
	else return(y)
}

function calculateThreadlibSpecs() {
	# Calculates threadlib specs for UIS threads assuming class 2
	# threads (class 1 and class 3 threads are not supported)

	Designator = $1;
	TPI = $2;
	D = $3;
	P = 1 / TPI;
	H = P / 2 / tan(phi / 2);
	basicPitchD = D - 3 / 4 * H;

	nfields = split(Designator, fields, "_");
	tp = fields[1];
	if (nfields > 2)
		tp = tp "-" fields[2]

	if (tp=="UNC" || tp=="UNF" || tp=="4-UN" || tp=="6-UN" || tp=="8-UN")
		LE = D;
	else
		LE = 9 * P;

	# external thread:
	tolPitchD = 0.0015 * D**(1/3) + 0.0015 * sqrt(LE) + 0.015 * P**(2/3);
	maxPitchD = basicPitchD - 0.300 * tolPitchD;
	minPitchD = maxPitchD - tolPitchD;
	centerPitchD = 0.5 * (minPitchD + maxPitchD);
	RrotExt = centerPitchD / 2 - H / 4;
	DSupportExt = 2 * RrotExt + 0.01 * H ;
	RrotExt = RrotExt * inch;
	DSupportExt = DSupportExt * inch;

	dzCrestExt = P / 16 * inch;
	dzRootExt = 3 / 8 * P * inch;
	drRootExt = 0.;
	drCrestExt = 5 / 8 * H * inch;

	# internal thread:
	tolPitchD = 1.300 * tolPitchD;
	minPitchD = basicPitchD;
	maxPitchD = minPitchD + tolPitchD;
	centerPitchD = 0.5 * (minPitchD + maxPitchD);
	RrotInt = -((centerPitchD + H) / 2 - H / 8);
	DSupportInt = -2 * RrotInt - 0.01 * H;
	RrotInt = RrotInt * inch;
	DSupportInt = DSupportInt * inch;

	dzCrestInt = P / 8 * inch;
	dzRootInt = 7 / 16 * P * inch;
	drRootInt = 0.;
	drCrestInt = 5 / 8 * H * inch;

	P = P * inch;
}

BEGIN {
	FS = "\t";
	pi = atan2(0, -1);
	deg = pi / 180;
	phi = 60 * deg;
	inch = 25.4;
}

/^[^#]/ {
	calculateThreadlibSpecs();

	# External thread:
	printf	Designator "-ext,"			# designator
	printf	P ","					# pitch
	printf	 "%.4f,", RrotExt			# Rrot
	printf	"%.4f,", DSupportExt			# Dsupport
	printf	drRootExt ","				# r0
	printf	"%.4f,", -dzRootExt			# z0
	printf	drRootExt ","				# r1
	printf	"%.4f,", +dzRootExt			# z1
	printf	"%.4f,", drCrestExt			# r2
	printf	"%.4f,", +dzCrestExt			# z2
	printf	"%.4f,", drCrestExt			# r3
	printf	"%.4f\n", -dzCrestExt;			# z3

	# Internal thread:
	printf	Designator "-int,"			# designator
	printf	P ","					# pitch
	printf	 "%.4f,", RrotInt			# Rrot
	printf	"%.4f,", DSupportInt			# Dsupport
	printf	drRootInt ","				# r0
	printf	"%.4f,", +dzRootInt			# z0
	printf	drRootInt ","				# r1
	printf	"%.4f,", -dzRootInt			# z1
	printf	"%.4f,", drCrestInt			# r2
	printf	"%.4f,", -dzCrestInt			# z2
	printf	"%.4f,", drCrestInt			# r3
	printf	"%.4f\n", +dzCrestInt;			# z3
}

