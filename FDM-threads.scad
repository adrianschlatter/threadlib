include <threadlib/threadlib.scad>

// Zoom in on the threads to see the difference

translate([5, 0, 0]) {
    bolt("M10", turns=5);
    %bolt("M10-FDM", turns=5);
}

translate([15, 0, 0]) {
    %nut("M10", turns=0.5);
    nut("M10-FDM", turns=0.5);
}

// not truncated