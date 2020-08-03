use <threadlib/threadlib.scad>;

intersection() {
    union() {
        difference() {
            cylinder(r = 15, h = 20);
            tap("G1/2", 8);
        }
        bolt("G1/2", 8);
    }
    cube([20, 20, 20]);
}