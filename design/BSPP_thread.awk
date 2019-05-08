function tan(x) {
	return(sin(x) / cos(x))
}

function calculateThreadlibSpecs() {
	Designator = $1;
	P = $3;
	H = P / 2 / tan(phi / 2);
	DMax = $5;
	DPitch = $6;
	DMin = $7;
	DPitchInt = DPitch + $9 / 2;
	DPitchExt = DPitch + $10 / 2;
	DMinInt = DMin + $14 / 2;
	DMaxExt = DMax + $15 / 2;
	DSupportExt = DPitchExt - 2 * 5 / 12 * H;
	DSupportInt = DPitchInt + 2 * 5 / 12 * H;
	DValleyExt = DPitchExt - 2 * 5 / 12 * H * qOverlap;
	DValleyInt = DPitchInt + 2 * 5 / 12 * H * qOverlap;
	DCrestExt = DMaxExt - tan((pi + phi) / 4) / 6 * (1 - sin(phi / 2));
	DCrestInt = DMinInt + tan((pi + phi) / 4) / 6 * (1 - sin(phi / 2));
	ZValley = 0.03125 * P;
	ZCrestExt = (DPitchExt + H - DCrestExt) / 2 * tan(phi / 2);
	ZCrestInt = (DCrestInt - DPitchInt + H) / 2 * tan(phi / 2);
}

BEGIN {
	FS = "\t";
	pi = atan2(0, -1);
	deg = pi / 180;
	phi = 55 * deg;
	qOverlap = 1.05;
}

/^[^#]/ {
	calculateThreadlibSpecs();

	# External thread:
	printf "G" Designator "-ext,"			# designator
	printf	P ","					# pitch
	printf	 "%.4f,", DValleyExt / 2		# Rrot
	printf	"%.4f,", DSupportExt			# Dsupport
	printf	0 ","					# r0
	printf	"%.4f,", -P / 2 + ZValley		# z0
	printf	0 ","					# r1
	printf	"%.4f,", +P / 2 - ZValley		# z1
	printf	"%.4f,", (DCrestExt - DValleyExt) / 2	# r2
	printf	"%.4f,", +ZCrestExt			# z2
	printf	"%.4f,", (DCrestExt - DValleyExt) / 2	# r3
	printf	"%.4f\n", -ZCrestExt;			# z3

	# Internal thread:
	printf "G" Designator "-int,"			# designator
	printf	P ","					# pitch
	printf	 "%.4f,", -DValleyInt / 2		# Rrot
	printf	"%.4f,", DSupportInt			# Dsupport
	printf	0 ","					# r0
	printf	"%.4f,", +P / 2 - ZValley		# z0
	printf	0 ","					# r1
	printf	"%.4f,", -P / 2 + ZValley		# z1
	printf	"%.4f,", -(DCrestInt - DValleyInt) / 2	# r2
	printf	"%.4f,", -ZCrestInt			# z2
	printf	"%.4f,", -(DCrestInt - DValleyInt) / 2	# r3
	printf	"%.4f\n", +ZCrestInt;			# z3
}

