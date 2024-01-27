/*
Demo nut_sides argument of nut() module.
*/

use <threadlib/threadlib.scad>
include <../../THREAD_TABLE.scad>

type = "M12x0.5";
turns = 7;
Douter = 16;
higbee_arc = 45;
fn = 16;
nut_sides = 6;

nut(type, turns, Douter, higbee_arc, fn, THREAD_TABLE, nut_sides);
