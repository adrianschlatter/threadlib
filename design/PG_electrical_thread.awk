function calculateThreadlibSpecs() {
	# Calculates threadlib specs for PG electrical threads.

	Designator = $1;
	TPI = $2;
	Pitch = $3;
	MinorDiam = $4;
	MajorDiam = $5;
	PitchDiam = $6;

	Pi = 3.141592;

	P = 25.4 / TPI;
	H = 0.595875 * P;
	R = 0.107 * P;

	Epsilon = 0.001;

	DSupportExt = PitchDiam - H - R/2;
	RrotExt = DSupportExt / 2;
	drRootExt = -Epsilon;
	dzRootExt = cos(40*Pi/180) * H*1.09;
	drCrestExt = H*.9;
	dzCrestExt = cos(40*Pi/180) * H*.1;

	DSupportInt = MinorDiam + H*.9*2 + R/2;
	RrotInt = -DSupportInt / 2;
	drRootInt = -Epsilon;
	dzRootInt = cos(40*Pi/180)*H*1.09;
	drCrestInt = H*.9;
	dzCrestInt = H*.1;
}

BEGIN {
	FS = "\t";
}

/^[^#]/ {
	calculateThreadlibSpecs();

	# External thread:
	printf	Designator "-ext,"			# designator
	printf	Pitch ","					# pitch
	printf	"%f,", RrotExt			# Rrot
	printf	"%f,", DSupportExt			# Dsupport
	printf	drRootExt ","				# r0
	printf	"%.4f,", -dzRootExt			# z0
	printf	drRootExt ","				# r1
	printf	"%.4f,", dzRootExt			# z1
	printf	"%.4f,", drCrestExt			# r2
	printf	"%.4f,", dzCrestExt			# z2
	printf	"%.4f,", drCrestExt			# r3
	printf	"%.4f\n", -dzCrestExt			# z3

	# Internal thread:
	printf	Designator "-int,"			# designator
	printf	Pitch ","					# pitch
	printf	"%f,", RrotInt			# Rrot
	printf	"%f,", DSupportInt			# Dsupport
	printf	drRootInt ","				# r0
	printf	"%.4f,", dzRootInt			# z0
	printf	drRootInt ","				# r1
	printf	"%.4f,", -dzRootInt			# z1
	printf	"%.4f,", drCrestInt			# r2
	printf	"%.4f,", -dzCrestInt			# z2
	printf	"%.4f,", drCrestInt			# r3
	printf	"%.4f\n", dzCrestInt			# z3
}
