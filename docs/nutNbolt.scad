/*
Create nice previews for documentation

:Author: Adrian Schlatter
:Date: 2019-04-10
:License: 3-Clause BSD. See LICENSE.
*/

use <threadlib/threadlib.scad>

type = "M6";
turns = 6;
higbee_arc = 45;

P = thread_specs(str(type, "-ext"))[0];
dz = (turns / 2 - 1/4) * P;
Douter = thread_specs(str(type, "-int"))[2] * 1.5;

translate([0, 0, dz])
    rotate([0, 0, -90])
        bolt(type, turns, higbee_arc=higbee_arc);
intersection() {
    nut(type, turns, Douter, higbee_arc=higbee_arc);
    translate([-100, 0, 0])
        cube([200, 200, 200]);
};