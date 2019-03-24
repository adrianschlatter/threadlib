/*
Gardena Tap Connectors
++++++++++++++++++++++

Units in this file: Millimeter.

*/

use <threads.scad>

// Generic

module gasket (r0=8, r1=12.5, d=3) {
    /*
    Flat ring gasket
    ++++++++++++++++

    r0: Hole diameter
    r1: Outer diameter
    d: Thickness
    */
    
    color("DarkSlateGray")
        difference() {
            cylinder(h=d, r=r1);
            translate([0, 0, -d])
                cylinder(h=3*d, r=r0);
        }
};

module nozzle (radii=[16.8, 7, 10, 4.5, 8.5], zs=[-12, -14, -18, -18, -24, -22, -38],
                dthread=26.441, pthread=25.4/14)
{
    /*
    Gardena nozzle
    +++++++++++++
    
    radii:     List of 5 radii
    zs:        List of 7 z
    dthread:   Thread diameter
    pthread:   Thread pitch
    */
  
    translate([0, 0, -zs[0]])
        difference() {
            color("Gray")
                union() {
                    translate([0, 0, zs[1]])
                        cylinder(h=-zs[1], r=radii[0]);
                    translate([0, 0, zs[3]])
                        cylinder(h=zs[1]-zs[3], r=radii[2]);
                    translate([0, 0, zs[5]])
                        cylinder(h=zs[3]-zs[5], r1=radii[4], r2=radii[2]);
                    translate([0, 0, zs[6]])
                        cylinder(h=zs[5]-zs[6], r=radii[4]);
                };

            color("Gray")
                translate([0, 0, zs[0]])
                    metric_thread(dthread, pthread,
                                   -2*zs[0], angle=27.5, internal=true);
                        
            color("Navy")
                    union() {
                        translate([0, 0, zs[2]])
                            cylinder(h=-zs[2], r=radii[1]);

                        translate([0, 0, zs[2]])
                            cylinder(h=zs[2]-zs[3]+0.001, r=radii[1]);
                        
                        translate([0, 0, zs[4]])
                            cylinder(h=zs[2]-zs[4]+0.002, r1=radii[3], r2=radii[1]);
                        
                        translate([0, 0, zs[6]-0.002])
                            cylinder(h=-zs[6], r=radii[3]);
                    };
            };
};    


// Special

module gasket_gardena_G3o4() {
    gasket();
};

module gasket_gardena_G1() {
    gasket(r0=20/2, r1=31.5/2, d=3);
};

module nozzle_gardena_G3o4 () {
    nozzle();
};

module nozzle_gardena_G1 () {
    nozzle(radii=[19.6, 7, 10, 4.5, 8.5], zs=[-12, -14, -18, -18, -24, -22, -38],
                dthread=33.249, pthread=25.4/11);
};

intersection() {
    translate([-50, 0, -50])
        color("Green")
            cube(100, 100, 100);
    union() {
        gasket_gardena_G1();
        nozzle_gardena_G1();
    };
};
