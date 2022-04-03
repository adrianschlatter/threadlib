# Creating Thread Specs

In the following, we explain how a thread spec (i.e., an entry in THREAD_TABLE.scad) is created. First, we will explain the basics of threads and how they are specified in the norms. Then, we will elaborate on how to translate those into threadlib thread specs.


## Thread Basics

As an example, we use British Standard Pipe parallel (BSPP) thread (see drawing below). The black curve shows the parting line between internal and external thread. In an ideal world, both threads are created according to the parting line. For BSP thread it is based on a fundamental triangle with a 55-degree angle rounded to a radius r.

![BSPP thread drawing](imgs/BSPthread.jpg)

     BSPP thread drawing. Source: Maryland Metrics.

Reality is a bit more complicated: If one of the threads deviates only a little in the wrong direction, the threads collide. Therefore, the pitch radius r_pitch (radius where distance between falling and rising edges is exactly P/2) of the external thread has to be reduced a little bit (and vice versa for the internal thread). Also, major- and minor radii are adjusted so that the real thread is guaranteed to remain on its own side of the theoretical parting line.

Of course, it is not ok to introduce arbitrarily large allowances: The norm (BS EN ISO 228-1: 2003 in this case) gives the necessary constraints. Quoting Maryland Metrics thread data charts for BSP thread (which used to be [here](http://mdmetric.com/tech/thddat7.htm)):

<table>
 <tr>
 <td colspan="7" align="center" valign="bottom"></td>
 <td colspan="5" align="center" valign="bottom">Tolerances on pitch diametera</td>
 <td colspan="2" align="center" valign="bottom">Tolerance on minor diameter</td>
 <td colspan="2" align="center" valign="bottom">Tolerance on major diameter</td>
 </tr>
 <tr>
 <td colspan="4" align="center" valign="bottom"></td>
 <td colspan="3" align="center" valign="bottom">Diameters</td>
 <td colspan="2" align="center" valign="bottom">Internal thread TD2</td>
 <td colspan="3" align="center" valign="bottom">External thread Td2</td>
 <td colspan="2" align="center" valign="bottom">Internal thread TD1</td>
 <td colspan="2" align="center" valign="bottom">External thread Td</td>
 </tr>
 <tr>
 <td align="center" valign="bottom">Desig-nation of thread</td>
 <td align="center" valign="bottom">Number of threads in 25.4 mm</td>
 <td align="center" valign="bottom">Pitch    P</td>
 <td align="center" valign="bottom">Height of thread    h</td>
 <td align="center" valign="bottom">major d  = D</td>
 <td align="center" valign="bottom">pitch d2  = D2</td>
 <td align="center" valign="bottom">minor d1  = D1</td>
 <td align="center" valign="bottom">Lower deviation</td>
 <td align="center" valign="bottom">Upper deviation</td>
 <td align="center" valign="bottom">Lower deviation Class A</td>
 <td align="center" valign="bottom">Lower deviation Class B</td>
 <td align="center" valign="bottom">Upper deviation</td>
 <td align="center" valign="bottom">Lower deviation</td>
 <td align="center" valign="bottom">Upper deviation</td>
 <td align="center" valign="bottom">Lower deviation</td>
 <td align="center" valign="bottom">Upper deviation</td>
 </tr>
 <tr>
 <td align="center" valign="bottom">1/16</td>
 <td align="center" valign="bottom">28</td>
 <td align="center" valign="bottom">0.907</td>
 <td align="center" valign="bottom">0.581</td>
 <td align="center" valign="bottom">7.723</td>
 <td align="center" valign="bottom">7.142</td>
 <td align="center" valign="bottom">6.561</td>
 <td align="center" valign="bottom">0</td>
 <td align="center" valign="bottom">0.107</td>
 <td align="center" valign="bottom">-0.107</td>
 <td align="center" valign="bottom">-0.214</td>
 <td align="center" valign="bottom">0</td>
 <td align="center" valign="bottom">0</td>
 <td align="center" valign="bottom">0.282</td>
 <td align="center" valign="bottom">-0.214</td>
 <td align="center" valign="bottom">0</td>
 </tr>
 <tr>
 <td align="center" valign="bottom">1/8</td>
 <td align="center" valign="bottom">28</td>
 <td align="center" valign="bottom">0.907</td>
 <td align="center" valign="bottom">0.581</td>
 <td align="center" valign="bottom">9.728</td>
 <td align="center" valign="bottom">9.147</td>
 <td align="center" valign="bottom">8.566</td>
 <td align="center" valign="bottom">0</td>
 <td align="center" valign="bottom">0.107</td>
 <td align="center" valign="bottom">-0.107</td>
 <td align="center" valign="bottom">-0.214</td>
 <td align="center" valign="bottom">0</td>
 <td align="center" valign="bottom">0</td>
 <td align="center" valign="bottom">0.282</td>
 <td align="center" valign="bottom">-0.214</td>
 <td align="center" valign="bottom">0</td>
 </tr>
 <tr>
 <td align="center" valign="bottom">1/4</td>
 <td align="center" valign="bottom">19</td>
 <td align="center" valign="bottom">1.337</td>
 <td align="center" valign="bottom">0.856</td>
 <td align="center" valign="bottom">13.157</td>
 <td align="center" valign="bottom">12.301</td>
 <td align="center" valign="bottom">11.445</td>
 <td align="center" valign="bottom">0</td>
 <td align="center" valign="bottom">0.125</td>
 <td align="center" valign="bottom">-0.125</td>
 <td align="center" valign="bottom">-0.25</td>
 <td align="center" valign="bottom">0</td>
 <td align="center" valign="bottom">0</td>
 <td align="center" valign="bottom">0.445</td>
 <td align="center" valign="bottom">-0.25</td>
 <td align="center" valign="bottom">0</td>
 </tr>
</table>


## Deriving threadlib Specs

We want to approximate the thread profile by straight-line segments as shown in the sketch in red and blue (internal and external thread, respectively).

It is clear that we have to match the pitch exactly.  Therefore, threadlib's P is equal to the pitch in the norm (for G1/16: 0.907 mm).

Then, we choose the pitch diameter to be in the center of the given tolerance range. For G1/16 this is (7.723 + 0.107/2) mm. 

To explain the choice of r_major and r_minor for both external and internal threads simultaneously, we use the terms r_crest and r_valley. r_crest is the major/minor radius (external/internal) and r_valley is the minor/major radius (external/internal). The norm does not give limits for r_valley. But threadlib requires that the thread profile covers *less* than 1 pitch of thread. Therefore, we arbitrarily choose a small but finite width of "valley floor" that leaves ample clearance to the parting line. For r_crest, we to take into account

1) the allowed deviations given in the norm
2) the rounding

The former is simple: We aim for the center. The latter requires a little math: We want our piecewise linear profile to remain on one side of the (true) BSP profile. Therefore, our crest radius has to be equal to the radius where the straight rising edge of the BSP profile touches the circle of the rounding (see sketch at the top of this page).


## Adding Specs to threadlib

To get the threads into threadlib, we do the following: 

- Tabulate specs as given in norm => design/newthreads.csv
- Write design/newthreads.awk => translates design/newthreads.csv to tabular threadlib specs (see next step).
- Add instructions to Makefile:
  `cat design/newthreads.csv | awk -f design/newthreads.awk >> design/THREAD_TABLE.csv` Now, `make` will automatically run the script.
- design/autogenerate.awk will translate the resulting THREAD_TABLE.csv into the final THREAD_TABLE.scad (same as the .csv but with added quoting and bracketing). This script is already there, you should not need to modify it.

The format of THREAD_TABLE.csv is:

`DESIGNATOR, P, Rrot, Dsup, dr_0, z0, dr_1, z_1, dr_2, z_2, dr_3, z_3`

The meaning of these values is explained in [Design of Threadlib](DesignOfThreadlib.md).


## Adding Tests

Furthermore, we should extend tests/test_table.awk to test our newly created threads. The very minimum is to add a test for the thread angles. Perform the tests by running `make test` in the top-level directory or `make` inside the tests subdirectory. If it prints "TESTS SUCCESSFUL" you are probably fine. Note: If you have a thread spec that is not tested at all, the tests will fail, too.

For more information on testing, see [Unit Tests](UnitTests.md).
