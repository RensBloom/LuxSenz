translate([0,0,1.6]) rotate([130,0,0]) {
    rotate([50,0,0]) translate([-34.2,0,0]) cube([101.2,90,1.6]);



    translate([62.4-15.6,0,0]) {
        translate([0,10,-2]) cube([1.6,7.9,5]);
        translate([0,24,-2]) cube([1.6,7.9,5]);
        intersection() {
            cube([1.6, 32, 80]);
            rotate([-40,0,0]) cube([1.6, 32, 80]);
        }
    }

    translate([15.6,0,0]) {
        translate([0,10,-2]) cube([1.6,7.9,5]);
        translate([0,24,-2]) cube([1.6,7.9,5]);
        intersection() {
            cube([1.6, 32, 80]);
            rotate([-40,0,0]) cube([1.6, 32, 80]);
        }
    }
}