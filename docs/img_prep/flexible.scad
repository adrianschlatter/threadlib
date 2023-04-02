/*
Create nice previews for documentation

:Author: Adrian Schlatter
:Date: 2019-04-13
:License: 3-Clause BSD. See LICENSE.
*/

use <threadlib/threadlib.scad>

type = "G1/2-ext";
turns = 5;
higbee_arc = 20;

thread(type, turns, higbee_arc=higbee_arc);

specs = thread_specs(type);
P = specs[0]; Rrot = specs[1]; Dsupport = specs[2];
section_profile = specs[3];
H = (turns + 1) * P;
translate([0, 0, -P / 2])
    cylinder(h=H, d=Dsupport, $fn=120);
