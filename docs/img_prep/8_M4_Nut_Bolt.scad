
use <threadlib/threadlib.scad>

//rotate([15,0,0])

difference () {
  step_8();
  translate([-5,-3,-5]) cube( [10,3,10], center=false);
}


// Thread for interior surfaces
module step_1() {
    thread("M4-int", turns=2);
}

// Overlap with diameter
module step_2() {
    #translate([0,0,-0.5]) color([1,0,0]) cylinder(h=2,d1=4.1095,d2=4.1095,$fn=100);
    thread("M4-int", turns=2);
}

// Create TAP to porper diameter
module step_3() {
    difference() {
        translate([0,0,-0.5]) color([1,0,0]) cylinder(h=2,d1=4.1095,d2=4.1095,$fn=100);
        thread("M4-int", turns=2);
    }
}

// Show full tap
module step_4() {
    difference() {
        translate([0,0,-1.0]) color([1,0,0]) cylinder(h=4,d1=4.1095,d2=4.1095,$fn=100);
        thread("M4-int", turns=2);
    }
}

// Show nut and tap
module step_5() {
        translate([0,0,-0.5]) color([1,0,0]) cylinder(h=2,d1=6,d2=6,$fn=100);
        #difference() {
            translate([0,0,-1.0]) color([1,0,0]) cylinder(h=4,d1=4.1095,d2=4.1095,$fn=100);
            thread("M4-int", turns=2);
    }
}

// Create NUT from douter - TAP
module step_6() {
    difference() {
        translate([0,0,-0.5]) color([1,0,0]) cylinder(h=2,d1=6,d2=6,$fn=100);
        difference() {
            translate([0,0,-1.0]) color([1,0,0]) cylinder(h=4,d1=4.1095,d2=4.1095,$fn=100);
            thread("M4-int", turns=2);
        }
    }
}

// Thread for exterior surfaces
module step_7() {
    step_6();
    thread("M4-ext", turns=2);
}

// Add support material to create BOLT
module step_8() {
    step_6();
    thread("M4-ext", turns=2);
    translate([0,0,-0.5]) color([1,0,0]) cylinder(h=2,d1=3.1110,d2=3.1110,$fn=100);
}



