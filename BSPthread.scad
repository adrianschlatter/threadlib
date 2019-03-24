/*
Britisch Standard Pipe Thread
++++++++++++++++++++++++++++++

British Standard Pipe Thread is based on a triangular profile. The angle between flanks
is 55 deg (symmetrical). We use the following nomenclature:

- crest: The "summit" of a thread
- groove: The lowest point in the valley of a thread
- rcrest, rgroove: Radii of crest and groove, respectively
- t = abs(rcrest - rgroove)
- rpitch = mean of rmajor and rminor

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

phi = 55;

module BSPP_external_thread(pitch=2.309, turns=3, dminor=30.291, higbee_arc=45, fn=120)
{
    t = pitch / (2 * tan(phi/2));
    rgroove = dminor / 2 - t / 6;
    rcrest = rgroove + t;
    section_profile = [[0, -pitch / 2], [0, pitch / 2], [+t, 0]];
    rmajor = rcrest - t / 6;
    intersection() {
        straight_thread(
            section_profile=section_profile,
            higbee_arc=higbee_arc,
            r=rgroove,
            turns=turns,
            pitch=pitch,
            fn=fn);
        cylinder(h=turns * pitch, r=rmajor, $fn=fn);
    };
}

module BSPP_internal_thread(pitch=2.309, turns=3, dmajor=33.249, higbee_arc=45, fn=120)
{
    t = pitch / (2 * tan(phi/2));
    rgroove = dmajor / 2 + t / 6;
    rcrest = rgroove - t;
    section_profile = [[0, +pitch / 2], [0, -pitch / 2], [-t, 0]];
    rminor = rcrest + t / 6;
    difference() {
        rotate(180) // rotate by half a turn to fit external thread
            straight_thread(
                section_profile=section_profile,
                higbee_arc=higbee_arc,
                r=rgroove,
                turns=turns,
                pitch=pitch,
                fn=fn);
        cylinder(h=turns * pitch, r=rminor, $fn=fn);
    };
}

// testing:

intersection() {
    color("Green")
        translate([-50, 0, -50])
            cube(100, 100, 100);
                union() {
                    BSPP_external_thread(pitch=2.309, turns=3, dminor=30.291,
                                          higbee_arc=45, fn=120);
                    BSPP_internal_thread(pitch=2.309, turns=3, dmajor=33.249,
                                         higbee_arc=45, fn=120);
                };
};
