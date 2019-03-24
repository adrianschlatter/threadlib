/*
PCO-1881 Bottle Neck

Based on http://imajeenyus.com/mechanical/20120508_bottle_top_threads/28mm-ISBT-PCO-1881-Finish-3784253-17.pdf

*/

use <thread_profile.scad>  // https://github.com/MisterHW/IoP-satellite

module pco1881 () {
    // The PCO-1881 bottle neck (approximately) as described in the spec
    union() {
        difference() {
            union() {
                cylinder(h=20, r=24.20/2);
                cylinder(h=1.7, r=25.07/2);
                translate([0, 0, 9])
                    cylinder(h=11.2-0.6-9, r1=24.2/2, r2=28.0/2);
                translate([0, 0, 11.2-0.6])
                    cylinder(h=0.6, r=28.0/2);
                translate([0, 0, 11.2])
                    cylinder(h=20-11.2, r=25.71/2);
                translate([0, 0, 14.88])
                    cylinder(h=1, r1=33.0/2-3.732, r2=33.0/2);
                translate([0, 0, 14.88+1])
                    cylinder(h=17-14.88-1, r=33.00/2);
                translate([0, 0, 17])
                    cylinder(h=3, r=26.19/2);
            };
            
            translate([0, 0, 13.94])
                rotate_extrude()
                    translate([12.25+1.08, 0, 0])
                        circle(1.08, $fn=50);
            color("Navy")
                translate([0, 0, -0.004])
                    cylinder(h=20.008, r1=21.74/2, r2=10.870);
        };
        translate([0, 0, (1.70 + 1.92) / 2])
            straight_thread(
                section_profile = bottle_pco1881_neck_thread_profile(),
                higbee_arc = 10,
                r = bottle_pco1881_neck_thread_dia() / 2,
                turns = 650 / 360,
                pitch = bottle_pco1881_neck_thread_pitch(),
                fn = 60
            ); 
    };
};

*intersection() {
    color("Green")
        translate([-50, 0, -50])
            cube(100, 100, 100);
    pco1881();
}

*pco1881();