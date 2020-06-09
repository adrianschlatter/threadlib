/*
threadlib
+++++++++

Create threads easily.

:Author: Adrian Schlatter
:Date: 2019-11-11
:License: 3-Clause BSD. See LICENSE.
*/

function __THREADLIB_VERSION() = 0.3;

//use <thread_profile.scad>
use <IoP-satellite/OpenSCAD_bottle_threads/thread_profile.scad>
use <BOSL2/strings.scad> 

include <THREAD_TABLE.scad>


bolt("M4", turns = 5, higbee_arc = 30);
translate([15,0,0]) bolt("G1/2-ext",turns = 5, higbee_arc = 30);
translate([40,0,0]) color("red")bolt("G1/2",turns = 5, higbee_arc = 30);
translate([-15,0,0])nut("M12x0.5", turns=10, Douter=16);
translate([-50,0,0])color("red")nut("G1/2-int", turns=10, Douter=40);
translate([-50,50,0])nut("G1/2", turns=10, Douter=40);



function thread_specs_search(designator,table) =
    /* Returns thread specs of thread-type 'designator' as a vector of
       [pitch, Rrotation, Dsupport, section_profile] */
    table[search([designator], table, num_returns_per_match=1,
                   index_col_num=0)[0]][1];

function thread_specs(designator, table=THREAD_TABLE) =
    let (specs = thread_specs_search(designator,table))
        assert(!is_undef(specs), str("Designator: '",designator,"' not found")) specs;


module thread(designator, turns, higbee_arc=20, fn=120, table=THREAD_TABLE)
{
    specs = thread_specs(designator, table=table);
    P = specs[0]; Rrotation = specs[1]; section_profile = specs[3];
    straight_thread(
        section_profile=section_profile,
        higbee_arc=higbee_arc,
        r=Rrotation,
        turns=turns,
        pitch=P);
}

function sanitize(designator) = let (match =(len(search("-ext",designator)) > 0 ) ? search("-ext",designator) :  (len(search("-int",designator)) > 0)?  search("-int",designator) : [])  (len(match) > 0) ?  substr(designator, 0, match[0]) : designator;


module bolt(designator, turns = 5, higbee_arc=20, fn=120, table=THREAD_TABLE, h = -1) 
{
    name = str(sanitize(designator), "-ext");
    union() {
        specs = thread_specs(name, table=table);
        P = specs[0]; Dsupport = specs[2];
        H = (h >0)? h: (turns + 1) * P;
        thread(name, turns=(h >0)?H/P-1:turns, higbee_arc=higbee_arc, fn=fn, table=table);
        translate([0, 0, -P / 2])
            cylinder(h=H, d=Dsupport, $fn=fn);
    };
};

module nut(designator, turns, Douter, higbee_arc=20, fn=120, table=THREAD_TABLE) 
{
    name = str(sanitize(designator), "-int");
    union() 
    {
        specs = thread_specs(name, table=table);
       
        P = specs[0]; Dsupport = specs[2];
        H = (turns + 1) * P;        
        thread(name, turns=turns, higbee_arc=higbee_arc, fn=fn, table=table);

        translate([0, 0, -P / 2])
            difference() {
                cylinder(h=H, d=Douter, $fn=fn);
                translate([0, 0, -0.1])
                    cylinder(h=H+0.2, d=Dsupport, $fn=fn);
            };
    };
}
