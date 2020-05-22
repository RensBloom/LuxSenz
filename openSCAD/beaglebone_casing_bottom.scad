
rotate([0,0,0]) translate([0,0,-8]) {
    translate([0,0,2]) {

       difference() {
            translate([-2,-2,-2]) cube([59,94,15]); 
            translate([21, 66, 0]) cube([29,26,15]);
            translate([20,-2, 0]) cube([10,10,15]);
            translate([0,0,0]) cube([55,90,15]);
           translate([30,88,-2]) cube([20,4,15]);
        };
        translate([51,70,0]) cube([4,20,5]);
        translate([47,0,0]) cube([8,7,5]);
        translate([0,0,0]) cube([10,7,5]);
        translate([0,85,0]) cube([15,5,5]);
        translate([0,70,0]) cube([6,5,5]);

    };
};