/*
Create nice previews for documentation

:Author: Adrian Schlatter
:Date: 2019-04-13
:License: 3-Clause BSD. See LICENSE.
*/

use <threadlib/threadlib.scad>

type = "G1/2-ext";
turns = 10;
higbee_arc = 45;

thread(type, turns, higbee_arc=higbee_arc);
