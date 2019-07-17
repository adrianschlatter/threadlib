function tan(x) {
	return(sin(x) / cos(x))
}

function min(x, y) {
	if (x < y) return(x)
	else return(y)
}

function calculateThreadlibSpecs() {
	Designator = $3;
	P = $4;
	H = P / 2 / tan(phi / 2);
	DPitchExt = ($8 + $9) / 2;
	DSupportExt = ($10 + $11) / 2;
	DValleyExt = $11;
	DCrestExt = ($6 + $7) / 2;
	ZValleyExt = (DPitchExt + H - DValleyExt) / 2 * tan(phi / 2); 
	ZCrestExt = (DPitchExt + H - DCrestExt) / 2 * tan(phi / 2);

	DPitchInt = ($15 + $16) / 2;
	DSupportInt = ($17 + $18) / 2;
	DValleyInt = $18;
	DCrestInt = ($13 + $14) / 2;
	# for some reason, the data sometimes has dRMax > H. We have to fix this:
	dRMax = min((DValleyInt - DPitchInt + H) / 2, 0.99 * H);
	DValleyInt = DPitchInt - H + 2 * dRMax;
	# now, continue as usual
	ZValleyInt = dRMax * tan(phi / 2);
	ZCrestInt = (DCrestInt - DPitchInt + H) / 2 * tan(phi / 2);
}

BEGIN {
	FS = "\t";
	pi = atan2(0, -1);
	deg = pi / 180;
	phi = 60 * deg;
}

/^[^#]/ {
	calculateThreadlibSpecs();

	# External thread:
	eps = 0.0001;
	z2 = +ZCrestExt;
	r2 = (DCrestExt - DValleyExt) / 2;

	z0ext = P/2 + eps;
	r0ext = z2 + r2 - z0ext;

	DSupportExt = DSupportExt + r0ext;

	printf	Designator "-FDM-ext,"			# designator
	printf	P ","					# pitch
	printf	 "%.4f,", DValleyExt / 2		# Rrot
	printf	"%.4f,", DSupportExt			# Dsupport

	printf	"%.4f,", r0ext				# r0
	printf	"%.4f,", -z0ext 			# z0

	printf	"%.4f,", r0ext				# r3
	printf	"%.4f,", +z0ext				# z3

	printf	"%.4f,", (DCrestExt - DValleyExt) / 2	# r4
	printf	"%.4f,", +ZCrestExt			# z4

	printf	"%.4f,", (DCrestExt - DValleyExt) / 2	# r5
	printf	"%.4f\n", -ZCrestExt;			# z5

	# Internal thread:

	z0int = +ZValleyInt + eps;

	printf	Designator "-FDM-int,"			# designator
	printf	P ","					# pitch
	printf	 "%.4f,", -DValleyInt / 2		# Rrot
	printf	"%.4f,", DSupportInt			# Dsupport

	printf	"%.4f,", 0				# r0
	printf	"%.4f,", +z0int				# z0

	printf	"%.4f,", +z0int				# r1
	printf	"%.4f,", 0				# z1

	printf	"%.4f,", 0				# r2
	printf	"%.4f\n", -z0int			# z2

}

