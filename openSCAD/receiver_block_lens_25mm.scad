 
hcenter  = 14.9;
xcenter  = 15.9;

rotate([0,-90,0]) translate([0, 0, 0]) difference() {
    union() {
        cube([7.8, 31.8, 28.8]);
        translate([7.8, 27.4, 24]) cube([2, 2.4,2.4]);
        translate([7.8, 2, 4.5]) cube([2, 2.4,2.4]);
    }
    translate([1.4,1.5,0]) cube([13,4.8,2]);
    translate([1.4,9.5,0]) cube([13,4.8,2]);
    translate([1.4,17.5,0]) cube([13,4.8,2]);
    translate([1.4,25.5,0]) cube([13,4.8,2]);
    
    translate([5.7, 27.3, 4.4]) cube([2.1, 2.6,2.6]);
    translate([5.7, 1.9, 23.9]) cube([2.1, 2.6,2.6]);
    
    
    translate([7.8,xcenter,hcenter]) rotate([0,90,0]) cylinder(h=2.3, r=12.6, center=true);
    translate([0,xcenter,hcenter]) rotate([0,90,0]) cylinder(h=18, r=11.6, center=false);
}