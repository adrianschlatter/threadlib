# Unit Tests

We use unit tests as a means of quality assurance for threadlib.


## THREAD_TABLE.scad

The thread table is tested using an awk script. See [The GNU Awk User's Guide](https://www.gnu.org/software/gawk/manual/gawk.html) for (more than) an introduction to awk. Note that development of threadlib is based not on GNU awk but on MacOS's version of awk, which is mostly - but not completely - compatible.

Every line of THREAD_TABLE.scad is fed to [tests/test_table.awk](../tests/test_table.awk). test_table.awk then runs appropriate tests for every line. Which tests are appropriate is determined by looking at the thread designator. 

Example:

	/"[^,]+-ext/ {
		# external threads have positive Rrot 
		parse();
		if (Rrot < 0) {
			print designator " FAIL: negative radius of rotation";
			PASS = 0;
		}
		# test overlap between thread and support
		if (Rrot > Dsupport / 2) {
			print designator " FAIL: Rsupport < Rrot";
			PASS = 0;
		}
	}

The pattern `/"[^,]+-ext/` means: Run this code for every line that contains double quotes followed by a non-zero (`+`) number of non-comma characters (`[^,]`) followed by the string "-ext". I.e, the code is run for every external thread.  The code (everything between `{}`) tests the following assumptions: 1. every external thread must have positive Rrot 2. there must be some overlap between thread and support (i.e. Rrot > Dsupport / 2).

More specific tests verify, e.g., that the thread angles are correct. Not all threads have the same thread angles, therefore we have to distinguish, e.g., between metric threads (designator "M...") and BSPP threads (designator "G..."). Example:

	/M[0-9.x-]+-ext/ {
		# ext M threads have +/-60 deg slopes, horizontal crest / valley
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
	}

Note that:

- This test uses functions. These are defined at the top of the awk script.
- This test will run *in addition* to the more general test discussed above. It does not *replace* the previous test.

Furthermore, we track whether tests fail. This is done in 2 ways:

- If a test fails, it prints an error to the screen
- If a test fails, the variable PASS is set to zero

At the very end (`END {...}`), the awk script tests the value of PASS. If all tests were successful, it still has its initial value of 1 (set in the `BEGIN {...}` block). Otherwise, it is 0.

Finally, we have assured that every thread is tested. A thread that is not tested at all is considered a FAIL. This is done via two match-all rules: The first initialized the variable 'tested' to 0. The last verifies that it has been set to 1 by one of the test. If it is still zero, this particular thread has not been tested at all.

## threadlib.scad

We intend to add tests for threadlib.scad itself. E.g. by actually rendering a pair of external and internal threads and verifying the number of volumes created. Currently, we do not have these tests yet.

