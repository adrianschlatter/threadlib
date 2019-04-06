/* Test and demonstrate thread library */

use <threadlib.scad>

module bolt(designator, turns, fn=120) {
    union() {
        specs = thread_specs(str(designator, "-ext"));
        P = specs[0]; Dsupport = specs[2];
        H = (turns + 1) * P;
        thread(str(designator, "-ext"), turns=turns, higbee_arc=20, fn=fn);
        translate([0, 0, -P / 2])
            cylinder(h=H, d=Dsupport, $fn=fn);
    };
};

module nut(designator, turns, fn=120) {
    union() {
        specs = thread_specs(str(designator, "-int"));
        P = specs[0]; Dsupport = specs[2];
        H = (turns + 1) * P;        
        rotate(180)
            thread(str(designator, "-int"), turns=turns, higbee_arc=20, fn=fn);

        translate([0, 0, -P / 2])
            difference() {
                cylinder(h=H, d=Dsupport * 1.1, $fn=fn);
                translate([0, 0, -0.1])
                    cylinder(h=H+0.2, d=Dsupport, $fn=fn);
            };
    };
};


type = "G1";
turns = 5;

intersection() {
    color("Green")
        translate([-100, 0, -100])
            cube(200, 200, 200);
    union() {
        bolt(type, turns);
        nut(type, turns);
    };
};
