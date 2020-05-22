
//mot yet finished

rotate([0,-90,0]) translate([0, 0, 04]) difference() {
    union() {
        //translate([0, 0.3, 8]) cube([2.5, 70, 46]);
        
        translate([0, 0.3, 7]) cube([2.5, 50, 20]);
        translate([0, -12, 22]) cube([2.5, 94.5, 49]);
        translate([2.5, 76.2, 67]) cube([1.2, 2.4,2.4]);
        translate([2.5, 56.2, 67]) cube([1.2, 2.4,2.4]);
        translate([2.5, 76.2, 24]) cube([1.2, 2.4,2.4]);
        translate([2.5, 66.2, 24]) cube([1.2, 2.4,2.4]);
        translate([2.5, 12, 12.5]) cube([1.2, 2.4,2.4]);
        translate([2.5, 36.2, 67]) cube([1.2, 2.4,2.4]);
        translate([2.5, 36.2, 24]) cube([1.2, 2.4,2.4]);
        translate([2.5, 32, 12.5]) cube([1.2, 2.4,2.4]);
    }
    
    //corners
    translate([1.2, 1.9-10, 66.9]) cube([1.3, 2.6,2.6]);
    translate([1.2, 1.9+10, 66.9]) cube([1.3, 2.6,2.6]);
    translate([1.2, 1.9-10, 23.9]) cube([1.3, 2.6,2.6]);
    translate([1.2, 1.9, 23.9]) cube([1.3, 2.6,2.6]);
    translate([1.2, 46.1, 12.4]) cube([1.3, 2.6,2.6]);
    translate([1.2, 31.9, 66.9]) cube([1.3, 2.6,2.6]);
    translate([1.2, 31.9, 23.9]) cube([1.3, 2.6,2.6]);
    translate([1.2, 36.1, 12.4]) cube([1.3, 2.6,2.6]);
    
   
    
    translate([0,34.7,23]) mirror([0,-1,0]) {
        translate([1, 0.5, 7]) cube([1.5, 43, 35]);
        translate([1, 40.5, 17]) cube([1.5, 4, 15]);
        translate([1, 5, 0]) cube([1.5, 24, 10]);
        
        //for wires
        translate([1.2,5,-40]) cube([2, 4, 40]);
        translate([1.2,5,-20]) rotate([-30,0,0]) cube([2, 6, 30]);
        
        translate([0,2,10]) cube([5,40,30.5]);
    }

    
    translate([0,35.9,23]) {
        translate([1, 0.5, 7]) cube([1.5, 43, 35]);
        translate([1, 40.5, 17]) cube([1.5, 4, 15]);
        translate([1, 5, 0]) cube([1.5, 24, 10]);
        
        //for wires
        translate([1.2,4,-20]) cube([2, 5, 40]);
        //translate([1.2,5,-20]) rotate([-30,0,0]) cube([2, 6, 30]);
        
        translate([0,2,10]) cube([5,40,30.5]);
        
    }
}
