difference() {
    union() {
        cube([24.8,24.8,51.2]);
        translate([10,0.3,51.2]) cube([4.8,1.2,5]);
    }
    translate([1.8,1.5,1]) cube([21.2,21.8,50.2]);
    translate([0.8,5.5,1]) cube([23.2,2,50.2]);
    
    translate([4,0,0]) cube([16.8,0.3,61.2]);
    translate([4,24.5,0]) cube([16.8,0.3,51.2]);
    translate([0,10,0]) cube([0.6,10.8,51.2]);
    translate([24.2,10,0]) cube([0.6,10.8,51.2]);
    
    translate([0,0,0]) cube([0.4,1.4,51.2]);
    translate([24.4,0,0]) cube([0.4,1.4,51.2]);
    translate([0,24.4,0]) cube([0.4,0.4,51.2]);
    translate([24.4,24.4,0]) cube([0.4,0.4,51.2]);
    
    
    //24.8-(8.3+0.8)-2.5,39.5
//    translate([13.2,10,37]) cube([5,50,5]);
            translate([15.7,10,39.5]) rotate([-90,0,0]) cylinder(100,3,3);
}