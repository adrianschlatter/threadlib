/*
Britisch Standard Pipe Thread
++++++++++++++++++++++++++++++

British Standard Pipe Thread is based on a triangular profile. The angle between flanks
is 55 deg (symmetrical). We use the following nomenclature:

- crest: The "summit" of a thread
- valley: The lowest point in the valley of a thread
- rcrest, rvalley: Radii of crest and groove, respectively
- rpitch = the mean radius of the original triangular profile

The crest and groove are both truncated by t/6. The radii at these flats are called
rmajor and rminor.

Note 1:

The specification requires that the flats are smoothed by circles that tangentially
match the flanks. We use a simpler version here: We create a triangular profile
and truncate the crests but not the grooves.

Note 2:

The specification requires allowances. This module creates threads with the ideal
rpitch for both external and internal threads (i.e., they just touch each other).
This is exactly at the edges of the given allowances and will not reliably work
in practice!
*/

use <thread_profile.scad>
include <THREAD_TABLE.scad>

function thread_specs(designator) =
    /* Returns thread specs of thread-type 'designator' as a vector of
       [pitch, Rrotation, Dsupport, section_profile] */
       
    THREAD_TABLE[search([designator], THREAD_TABLE, num_returns_per_match=1,
                   index_col_num=0)[0]][1];

module thread(designator, turns, higbee_arc=45, fn=120)
{
    specs = thread_specs(designator);
    P = specs[0]; Rrotation = specs[1]; section_profile = specs[3];
    echo(designator, "Rrotation", Rrotation);
    straight_thread(
        section_profile=section_profile,
        higbee_arc=higbee_arc,
        r=Rrotation,
        turns=turns,
        pitch=P);
}


// testing:

type = "G1";
intersection() {
    color("Green")
        translate([-100, 0, -100])
            cube(200, 200, 200);
                union() {
                    echo("Dsupport", thread_specs(str(type, "-ext"))[2]);
                    thread(str(type, "-ext"), turns=3, higbee_arc=20, fn=120);
                    translate([0, 0, -1.2])
                        cylinder(h=9, d=thread_specs(str(type, "-ext"))[2], $fn=120);

                    rotate(180)
                        thread(str(type, "-int"), turns=3, higbee_arc=20, fn=120);
                    translate([0, 0, -0.9])
                        difference() {
                            cylinder(h=9, r=200, $fn=120);
                            translate([0, 0, -0.1])
                                cylinder(h=10, d=thread_specs(str(type, "-int"))[2], $fn=120);
                        };
                };
};
