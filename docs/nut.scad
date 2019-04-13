/*
Create nice previews for documentation

:Author: Adrian Schlatter
:Date: 2019-04-10
:License: 3-Clause BSD. See LICENSE.
*/

use <threadlib/threadlib.scad>

type = "M12x0.5";
turns = 10;
Douter = 16;
higbee_arc = 45;

nut(type, turns, Douter, higbee_arc=higbee_arc);
