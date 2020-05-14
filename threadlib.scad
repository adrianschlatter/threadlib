/*
threadlib
+++++++++

Create threads easily.

:Author: Adrian Schlatter
:Date: 2019-11-11
:License: 3-Clause BSD. See LICENSE.
*/

function __THREADLIB_VERSION() = 0.3;

use <thread_profile.scad>
include <THREAD_TABLE.scad>

function thread_specs(designator, table=THREAD_TABLE) =
    /* Returns thread specs of thread-type 'designator' as a vector of
       [pitch, Rrotation, Dsupport, section_profile] */
       
    table[search([designator], table, num_returns_per_match=1,
                   index_col_num=0)[0]][1];

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

function addIntExt(designator, ext) = (len(search("-ext",designator)) > 0 || len(search("-int",designator)) > 0)? str(designator) : str(designator, ext);

module bolt(designator, turns, higbee_arc=20, fn=120, table=THREAD_TABLE) 
{
    name = addIntExt(designator, "-ext");
    union() {
        specs = thread_specs(name, table=table);
      echo("specs for ",addIntExt(designator, "-int")," ",specs); 
        //specs = thread_specs(str(designator, "-ext"), table=table);
        P = specs[0]; Dsupport = specs[2];
        H = (turns + 1) * P;
        thread(name, turns=turns, higbee_arc=higbee_arc, fn=fn, table=table);
        translate([0, 0, -P / 2])
            cylinder(h=H, d=Dsupport, $fn=fn);
    };
};

module nut(designator, turns, Douter, higbee_arc=20, fn=120, table=THREAD_TABLE) {
    name = addIntExt(designator, "-ext");
    union() {
        //specs = thread_specs(str(designator, "-int"), table=table);
        specs = thread_specs(name, table=table);
       
      echo("specs for ",addIntExt(designator, "-int")," ",specs); 
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
