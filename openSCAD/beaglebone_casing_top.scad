
rotate([0,180,0]) translate([0,0,-8]) {
    translate([0,0,2]) {
        difference() {
            translate([0,0,4]) cube([55,90,2]);
            translate([5, 75, 0]) cube([10,15,10]);
            translate([21, 66, 0]) cube([17,24,10]);
            translate([0,8,0]) cube([6,61,10]);
            translate([48,8,0]) cube([7,61,10]);
            translate([10,0,0]) cube([15,15,10]);
            translate([0,30,0]) cube([10,16,10]);
            translate([0,0,0]) cube([15,27,10]);
        };

        translate([45,0,0]) cube([10,8,4]);
        translate([48,69,0]) cube([7,7,4]);
        translate([0,69,0]) cube([14,6,4]);
        translate([25,0,0]) cube([5,7,4]);
        translate([15,15,0]) cube([2,2,4]);
        translate([6,27,0]) cube([2,2,4]);

    };

    translate([48,5,0]) cube([1.6,1.6,2]);
    translate([50,72,0]) cube([1.6,1.6,2]);
};