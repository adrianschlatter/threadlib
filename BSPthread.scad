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


module BSPP_external_thread(pitch=2.309, turns=3, dpitch=31.68, higbee_arc=45, fn=120)
{
    rpitchp = dpitch / 2;
    P = pitch;

    rcrest = rpitchp + 0.21706 * P;
    rvalley = rpitchp - 0.42021 * P;
    zvalley = 0.03125 * P;
    zcrest = 0.13701 * P;
    
    section_profile = [[rvalley, -P / 2 + zvalley], [rvalley, +P / 2 - zvalley],
                       [rcrest, +zcrest],
                       [rcrest, -zcrest]];

    straight_thread(
        section_profile=section_profile,
        higbee_arc=higbee_arc,
        r=0,
        turns=turns,
        pitch=pitch,
        fn=fn);
}

module BSPP_internal_thread(pitch=2.309, turns=3, dpitch=31.86, higbee_arc=45, fn=120)
{
    rpitchp = dpitch / 2;
    P = pitch;
    
    rcrest = rpitchp - 0.19813 * P;
    rvalley = rpitchp + 0.42021 * P;
    zvalley = 0.03125 * P;
    zcrest = 0.13701 * P;
    
    section_profile = [[rvalley, P / 2 - zvalley], [rvalley, -P / 2 + zvalley],
                       [rcrest, -zcrest], [rcrest, +zcrest]];

    rotate(180) // rotate by half a turn to fit external thread
        straight_thread(
            section_profile=section_profile,
            higbee_arc=higbee_arc,
            r=0,
            turns=turns,
            pitch=pitch,
            fn=fn);
}

// testing:

intersection() {
    color("Green")
        translate([-50, 0, -50])
            cube(100, 100, 100);
                union() {
                    BSPP_external_thread(pitch=2.309, turns=3, dpitch=31.68,
                                          higbee_arc=20, fn=120);
                    translate([0, 0, -1.2])
                        cylinder(h=9, r=31.68/2 - 0.40020 * 2.309);
                    BSPP_internal_thread(pitch=2.309, turns=3, dpitch=31.86,
                                         higbee_arc=20, fn=120);
                    translate([0, 0, -0.9])
                        difference() {
                            cylinder(h=9, r=20, $fn=120);
                            translate([0, 0, -0.1])
                                cylinder(h=10, r=31.86/2 + 0.40020 * 2.309, $fn=120);
                        };
                };
};
