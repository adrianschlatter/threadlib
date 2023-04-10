/*
Create nice previews for documentation

:Author: Adrian Schlatter
:Date: 2019-04-10
:License: 3-Clause BSD. See LICENSE.
*/

use <threadlib/threadlib.scad>

type = "M6";
turns = 5;
higbee_arc = 45;

bolt(type, turns, higbee_arc=higbee_arc);
