/*
threadlib
+++++++++

Create threads easily.

:Author: Adrian Schlatter and contributors
:Date: 2019-11-11
:License: 3-Clause BSD. See LICENSE.
*/

function __THREADLIB_VERSION() = 0.3;

use <thread_profile.scad>
include <THREAD_TABLE.scad>

bolt("M6", height=2.8, tol=0);

function thread_specs(designator, table=THREAD_TABLE) =
    /* Returns thread specs of thread-type 'designator' as a vector of
       [pitch, Rrotation, Dsupport, section_profile] */
      
    // first lookup designator in table inside a let() statement:
    let (specs = table[search([designator], table, num_returns_per_match=1,
                              index_col_num=0)[0]][1])
        // verify that we found something and return it:
        assert(!is_undef(specs), str("Designator: '", designator, "' not found")) specs;

module thread(designator, turns, higbee_arc=20, fn=120, table=THREAD_TABLE, tol=0)
{
    specs = thread_specs(designator, table=table);
    P = specs[0]; Rrotation = specs[1]-tol; section_profile = specs[3];
    straight_thread(
        section_profile=section_profile,
        higbee_arc=higbee_arc,
        r=Rrotation,
        turns=turns,
        pitch=P, fn=fn); // added fn for this function : smoother thread
}

module bolt(designator, turns, height=0, higbee_arc=20, fn=120, table=THREAD_TABLE, tol=0) {
    union() {
        specs = thread_specs(str(designator, "-ext"), table=table);
        P = specs[0]; Dsupport = specs[2];
		turns=turns?turns:height/P;
        H = (turns + 1) * P;
        thread(str(designator, "-ext"), turns=turns, higbee_arc=higbee_arc, fn=fn, table=table, tol=tol);
        translate([0, 0, -P / 2])
            cylinder(h=H, d=Dsupport-2*tol, $fn=fn);
    };
};

module nut(designator, turns, height=0, Douter, higbee_arc=20, fn=120, table=THREAD_TABLE, tol=0.0) {
    union() {
        specs = thread_specs(str(designator, "-int"), table=table);
        P = specs[0]; Dsupport = specs[2] + tol;
		turns=turns?turns:height/P;
        H = (turns + 1) * P;        
        thread(str(designator, "-int"), turns=turns, higbee_arc=higbee_arc, fn=fn, table=table, tol=tol);

        translate([0, 0, -P / 2])
            difference() {
                cylinder(h=H, d=Douter, $fn=fn);
                translate([0, 0, -0.1])
                    cylinder(h=H+0.2, d=Dsupport+tol, $fn=fn);
            };
    };
};

module tap(designator, turns, height=0, higbee_arc=20, fn=120, table=THREAD_TABLE, tol=0.0) {
    difference() {
        specs = thread_specs(str(designator, "-int"), table=table);
        P = specs[0]; Dsupport = specs[2];
		turns=turns?turns:height/P;
        H = (turns + 1) * P;
        translate([0, 0, -P / 2]) {
            cylinder(h=H, d=Dsupport+2*tol, $fn=fn);
        };
        
        thread(str(designator, "-int"), turns=turns, higbee_arc=higbee_arc, fn=fn, table=table, tol=tol);
    };
}
