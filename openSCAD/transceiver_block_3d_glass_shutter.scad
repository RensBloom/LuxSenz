

rotate([0,-90,0]) translate([0, 0, 04]) difference() {
    union() {
        translate([0, 0.3, 23]) cube([2.5, 70, 65]);
        translate([0, 10.3, 8]) cube([2.5, 50, 20]);
        translate([2.5, 66.2, 83]) cube([1.2, 2.4,2.4]);
        translate([2.5, 66.2, 24]) cube([1.2, 2.4,2.4]);
        translate([2.5, 12, 14.5]) cube([1.2, 2.4,2.4]);
        translate([2.5, 36.2, 83]) cube([1.2, 2.4,2.4]);
        translate([2.5, 36.2, 24]) cube([1.2, 2.4,2.4]);
        translate([2.5, 32, 14.5]) cube([1.2, 2.4,2.4]);
    }
    
    translate([1.2, 1.9, 82.9]) cube([1.3, 2.6,2.6]);
    translate([1.2, 1.9, 23.9]) cube([1.3, 2.6,2.6]);
    translate([1.2, 56.1, 14.4]) cube([1.3, 2.6,2.6]);
    translate([1.2, 31.9, 82.9]) cube([1.3, 2.6,2.6]);
    translate([1.2, 31.9, 23.9]) cube([1.3, 2.6,2.6]);
    translate([1.2, 36.1, 14.4]) cube([1.3, 2.6,2.6]);
    
   
    
    translate([0,34.7,23]) mirror([0,-1,0]) {
        translate([1.85, 5, 0]) cube([1, 15, 5]);
        translate([1.85, 5, 5]) cube([1, 20, 10]);
        translate([1.85, 0,15]) cube([1, 30, 35]);
        translate([1.85,30,15]) cube([1, 3, 25]);
        translate([1.85,30,40]) cube([1, 1.5, 5]);
        translate([1.85, 0,50]) cube([1, 25, 5]);
        translate([1.85, 5,55]) cube([1, 15, 5]);
        translate([1.85,25,10]) cube([1, 5, 5]);
        translate([1.2,5,-40]) cube([2, 12, 40]);
        
        
        translate([2.5,5,55]) rotate([0,90,0]) cylinder(h=1.3, r=5, center=true);
        intersection() {
            translate([2.5,20,15]) rotate([0,90,0]) cylinder(h=1.3, r=19.5, center=true);
            translate([0,0,0]) cube([3,10,15]);
        } intersection() {
            translate([2.5,12.5,42.5]) rotate([0,90,0]) cylinder(h=1.3, r=20, center=true);
            translate([0,5 ,50]) cube([3,16.5,15]);
        } intersection() {
            translate([2.5,10,42.5]) rotate([0,90,0]) cylinder(h=1.3, r=21, center=true);
            translate([0,15 ,45]) cube([3,20,16]);
        } intersection() {
            translate([2.5,20,20]) rotate([0,90,0]) cylinder(h=1.3, r=12.5, center=true);
            translate([0,20 ,10]) cube([3,20,20]);
        } intersection() {
            translate([2.5,0,35]) rotate([0,90,0]) cylinder(h=1.3, r=38, center=true);
            translate([0,15 ,0]) cube([3,15,15]);
        } intersection() {
            translate([0,15,15]) rotate([0,90,0]) cylinder(h=5, r=13, center=true);
            translate([0,0,5]) cube([5,15,30]);
        } intersection() {
            translate([0,15,45]) rotate([0,90,0]) cylinder(h=5, r=13, center=true);
            translate([0,0,45]) cube([5,30,15]);
        } intersection() {
            translate([0,15,20]) rotate([0,90,0]) cylinder(h=5, r=15, center=true);
            translate([0,5,5]) cube([5,30,15]);
        } intersection() {
            translate([0,15,40]) rotate([0,90,0]) cylinder(h=5, r=15, center=true);
            translate([0,15,40]) cube([5,15,10]);
        }
        translate([0,2,15]) cube([5,13,30]);
        translate([0,15,20]) cube([5,15,20]);
    }

    
    translate([0,35.9,23]) {
        translate([1.85, 5, 0]) cube([1, 15, 5]);
        translate([1.85, 5, 5]) cube([1, 20, 10]);
        translate([1.85, 0,15]) cube([1, 30, 35]);
        translate([1.85,30,15]) cube([1, 3, 25]);
        translate([1.85,30,40]) cube([1, 1.5, 5]);
        translate([1.85, 0,50]) cube([1, 25, 5]);
        translate([1.85, 5,55]) cube([1, 15, 5]);
        translate([1.85,25,10]) cube([1, 5, 5]);
        translate([1.2,5,-40]) cube([2, 12, 40]);
        
        
        translate([2.5,5,55]) rotate([0,90,0]) cylinder(h=1.3, r=5, center=true);
        intersection() {
            translate([2.5,20,15]) rotate([0,90,0]) cylinder(h=1.3, r=19.5, center=true);
            translate([0,0,0]) cube([3,10,15]);
        } intersection() {
            translate([2.5,12.5,42.5]) rotate([0,90,0]) cylinder(h=1.3, r=20, center=true);
            translate([0,5 ,50]) cube([3,16.5,15]);
        } intersection() {
            translate([2.5,10,42.5]) rotate([0,90,0]) cylinder(h=1.3, r=21, center=true);
            translate([0,15 ,45]) cube([3,20,16]);
        } intersection() {
            translate([2.5,20,20]) rotate([0,90,0]) cylinder(h=1.3, r=12.5, center=true);
            translate([0,20 ,10]) cube([3,20,20]);
        } intersection() {
            translate([2.5,0,35]) rotate([0,90,0]) cylinder(h=1.3, r=38, center=true);
            translate([0,15 ,0]) cube([3,15,15]);
        } intersection() {
            translate([0,15,15]) rotate([0,90,0]) cylinder(h=5, r=13, center=true);
            translate([0,0,5]) cube([5,15,30]);
        } intersection() {
            translate([0,15,45]) rotate([0,90,0]) cylinder(h=5, r=13, center=true);
            translate([0,0,45]) cube([5,30,15]);
        } intersection() {
            translate([0,15,20]) rotate([0,90,0]) cylinder(h=5, r=15, center=true);
            translate([0,5,5]) cube([5,30,15]);
        } intersection() {
            translate([0,15,40]) rotate([0,90,0]) cylinder(h=5, r=15, center=true);
            translate([0,15,40]) cube([5,15,10]);
        }
        translate([0,2,15]) cube([5,13,30]);
        translate([0,15,20]) cube([5,15,20]);
    }
}
