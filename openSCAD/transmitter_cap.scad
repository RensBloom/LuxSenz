difference() {
    union() {

        cube([70.6, 77.3, 1.5]);

        translate([0,0,0]) cube([70.6, 1.6, 15]);
        translate([0,75.7,0]) cube([70.6, 1.6, 15]);
        //translate([0,0,13.5]) cube([70.4, 77.3, 1.5]);

        translate([0,0,0]) cube([1.6, 77.3, 15]);
        translate([69,0,0]) cube([1.6, 77.3, 15]);

        translate([0,5,15]) cube([1.6, 67.3, 3]);
        translate([69,5,15]) cube([1.6, 67.3, 3]);

        translate([0,0,15]) {
            translate([50,0,0]) cube([8,1.6,8]);
            translate([-1.3,75.7,0]) {
                translate([10.1,0,0]) cube([4.8,1.6,8.1]);
                translate([20.1,0,0]) cube([7.8,1.6,8.1]);
                translate([42.1,0,0]) cube([7.8,1.6,8.1]);
                translate([55.1,0,0]) cube([4.8,1.6,8.1]);
                translate([10.1,0,8.1]) cube([17.8,1.6,1.6]);
                translate([42.1,0,8.1]) cube([17.8,1.6,1.6]);
            }
            
        }
    }

    translate([3.2,20,0]) {
        translate([0,-4,-3]) cube([1.8,8,5]);
        translate([0,10,-3]) cube([1.8,8,5]);
        translate([0,24,-3]) cube([1.8,8,5]);
        translate([0,38,-3]) cube([1.8,8,5]);
    }
    translate([18.8,20,0]) {
        translate([0,-4,-3]) cube([1.8,8,5]);
        translate([0,10,-3]) cube([1.8,8,5]);
        translate([0,24,-3]) cube([1.8,8,5]);
        translate([0,38,-3]) cube([1.8,8,5]);
    }
    translate([34.4,20,0]) {
        translate([0,-4,-3]) cube([1.8,8,5]);
        translate([0,10,-3]) cube([1.8,8,5]);
        translate([0,24,-3]) cube([1.8,8,5]);
        translate([0,38,-3]) cube([1.8,8,5]);
    }
    translate([50.0,20,0]) {
        translate([0,-4,-3]) cube([1.8,8,5]);
        translate([0,10,-3]) cube([1.8,8,5]);
        translate([0,24,-3]) cube([1.8,8,5]);
        translate([0,38,-3]) cube([1.8,8,5]);
    }
    translate([65.6,20,0]) {
        translate([0,-4,-3]) cube([1.8,8,5]);
        translate([0,10,-3]) cube([1.8,8,5]);
        translate([0,24,-3]) cube([1.8,8,5]);
        translate([0,38,-3]) cube([1.8,8,5]);
    }
}