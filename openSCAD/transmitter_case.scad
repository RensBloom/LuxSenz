translate([0,0,0]) union() {
    difference() {
        cube([73.2, 86.9, 34.5]);
        translate([1.2,1.2,1.2]) cube([70.8,84.5, 33.3]);
        translate([62,70,26.2]) cube([6, 50, 8.3]);
    }
    translate([0,4,1.2]) {
        translate([30, 0, 0]) cube([20.5,1.2,5]);
        translate([30, 68.7, 0]) cube([15.5,1.2,5]);
    }
    difference() {
        union() {
            intersection() {
                union() {
                    translate([0,0,0]) cube([10,10,32]);
                    translate([15,0,0]) cube([5,10,32]);
                    translate([28,0,0]) cube([14,10,32]);
                    translate([60,0,0]) cube([10,10,32]);
                    translate([50,0,0]) cube([5,10,32]);
                }
                translate([0,-14,30]) {
                    rotate([-45,0,0]) cube([73.2,19.8,19.8]);
                }
            }
            translate([0,0,24]) {
                cube([73.2,8,25.2]);
                translate([65.2,0,0]) cube([8,8,1.6]);
                
            }
        }
        translate([1.2,1.1,24]) cube([70.6,5.4,25.2]);
    }
    translate([0,83.8,29]) cube([50,2,4]);
    translate([68,83.8,29]) cube([5,2,4]);
}



translate([0,0,0]) intersection() {
    cube([0, 0, 0]);
    difference() {
        union() {
            cube([74, 56.6, 85]);
        }
        
        translate([1.6,1.6,2]) cube([70.8, 28.2, 83]);
        translate([1.6,31.8,2]) cube([70.8, 2, 83]);
        translate([3,1.6,2]) cube([68, 33.8, 83]);
        translate([1.6,35.4,2]) cube([10, 15, 83]);
        translate([62.4,35.4,2]) cube([10, 15, 83]);
        translate([13.2, 37, 2]) cube([47.6, 15, 83]);
        translate([1.6, 47, 2]) cube([67.5,8,85]);
        translate([70.7, 47, 2]) cube([1.7,8,85]);
        
        translate([5,1.6, 44]) cube([64,53.4,43]);
        translate([1.6, 47, 37]) cube([70.8,8,50]);
    }
}