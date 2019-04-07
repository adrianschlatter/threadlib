/*
Test and demonstrate thread library

:Author: Adrian Schlatter
:Date: 2019-04-07
:License: 3-Clause BSD. See LICENSE.
*/

use <threadlib.scad>

type = "G1";
turns = 5;
Douter = thread_specs(str(type, "-int"))[2] * 1.2;

intersection() {
    color("Green")
        translate([-100, 0, -100])
            cube(200, 200, 200);
    union() {
        bolt(type, turns);
        nut(type, turns, Douter);
    };
};
