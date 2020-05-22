
difference() {
    
    triFaces = [[0,1,3,2], [4,5,1,0],
        [2,3,5,4], [5,3,1], [4,0,2]];
    
    union() {
        translate([3.4,0,0]) cube([113.2,64,1.5]);
        translate([3.4,0,0]) cube([113.2,2,66]);
        translate([3.4,0,0]) cube([1.6,64,66]);
        translate([3.4,62,0]) cube([113.2,2,66]);
        translate([115,0,0]) cube([1.6,64,66]);
        
        //shutter fit 1
        translate([108,48,8.3]) cube([7.8,16,53.6]);
        translate([108,48,0]) difference() {
               cube([7.8,16,8.3]);
            translate([1,1,0]) cube([2.3,13.5,8.3]);
            translate([4.3,1,0]) cube([2.5,13.5,8.3]);
        }
        //shutter fit 2
        translate([3.4,55,0]) union() {
            translate([0,0,8.3]) cube([20,7.8,53.6]);
            translate([0,0,0]) difference() {
                   cube([20,7.8,8.3]);
                translate([1,1,0]) cube([13.5,2.3,8.3]);
                translate([1,4.3,0]) cube([13.5,2.5,8.3]);
            }
        }
        //reflective shield fit 1
        translate([20,64,0]) {
            translate([20,0,18.5]) {
                translate([-5,-3,-1]) cube([10,3,3.8]);
                translate([9, -3,-1]) cube([10,3,3.8]);
                translate([23,-3,-1]) cube([10,3,3.8]);
                translate([37,-3,-1]) cube([10,3,3.8]);
            }
            translate([20,0,49.7]) {
                translate([-5,-3,-1]) cube([10,3,3.8]);
                translate([9, -3,-1]) cube([10,3,3.8]);
                translate([23,-3,-1]) cube([10,3,3.8]);
                translate([37,-3,-1]) cube([10,3,3.8]);
            }
        }    
        //reflective shield fit 2
        translate([3.4,10,0]) {
            translate([0,0,18.5]) {
                translate([-0,-5,-1]) cube([3,10,3.8]);
                translate([-0,9, -1]) cube([3,10,3.8]);
                translate([-0,23,-1]) cube([3,10,3.8]);
            }
            translate([0,0,49.7]) {
                translate([-0,-5,-1]) cube([3,10,3.8]);
                translate([-0,9, -1]) cube([3,10,3.8]);
                translate([-0,23,-1]) cube([3,10,3.8]);
            }
        }   
        
        translate([3.4,0,58]) intersection() {
            cube([113.2,5,5]);
            rotate([45,0,0]) cube([120,20,20]);
        }
        translate([3.4,59,58]) intersection() {
            cube([113.2,5,5]);
            translate([0,0,5]) rotate([-45,0,0]) cube([114,20,20]);
        }
        
        translate([3.4,0,58]) intersection() {
            cube([5,29,5]);
            rotate([0,-45,0]) cube([20,70,20]);
        }
        translate([3.4,29,57]) intersection() {
            cube([5,6,5]);
            rotate([0,-45,0]) cube([20,70,20]);
        }
        translate([3.4,35,58]) intersection() {
            cube([5,29,5]);
            rotate([0,-45,0]) cube([20,70,20]);
        }
        
        translate([111.6,0,58]) intersection() {
            cube([5,29,5]);
            translate([0,0,5]) rotate([0,45,0]) cube([20,64,20]);
        }
        translate([111.6,29,57]) intersection() {
            cube([5,6,5]);
            translate([0,0,5]) rotate([0,45,0]) cube([20,64,20]);
        }
        translate([111.6,35,58]) intersection() {
            cube([5,29,5]);
            translate([0,0,5]) rotate([0,45,0]) cube([20,64,20]);
        }
        
        
        //thicker wall for e-ink display
        translate([18,2,0]) cube([94,2,57]);
        translate([38,4,0]) cube([74,2.8,47.5]);
        translate([72,4,0]) cube([18,3.8,37.5]);
        
        //PCB case holder
        translate([33.4,18.4,1.5]) cube([29.3,29.3,54.5]);
        
        //TP4056 lock
        translate([15,46,0]) cube([25,1.2,45]);
        
        //Battery holder
        translate([38,46.0,1]) cube([71.5,10.4,45]);
        
        //Lensblokje holder
        translate([88,11.4,1]) cube([20,35.2,55]);
        
        translate([33.4,18.4,1]) cube([82,1.6,52]);
        translate([93.4,40,1]) cube([22,1.2,52]);
    }
    
    //exclude shutter fit 1
    translate([108,49,8.3]) translate([1.2,0,1.5]) cube([5.4,15,50.5]);
    translate([108,48,8.3]) translate([1.2,0,1.5]) cube([5.4,16,44.5]);
    //exclude shutter fit 2
    translate([3.4,55,8.3]) translate([0,1.2,1.5]) cube([19.1,5.4,50.5]);
    translate([3.4,55,8.3]) translate([0,1.2,1.5]) cube([20.1,5.4,36.5]);
    
    //reflective shield fit 1
    translate([20,64,0]) {
        translate([20,0,18.5]) {
            translate([-4,-2,0]) cube([8,4,1.8]);
            translate([10,-2,0]) cube([8,4,1.8]);
            translate([24,-2,0]) cube([8,4,1.8]);
            translate([38,-2,0]) cube([8,4,1.8]);
        }
        translate([20,0,49.7]) {
            translate([-4,-2,0]) cube([8,4,1.8]);
            translate([10,-2,0]) cube([8,4,1.8]);
            translate([24,-2,0]) cube([8,4,1.8]);
            translate([38,-2,0]) cube([8,4,1.8]);
        }
    }    
        //reflective shield fit 2
    translate([4,10,0]) {
        translate([0,0,18.5]) {
            translate([-2,-4,0]) cube([4,8,1.8]);
            translate([-2,10,0]) cube([4,8,1.8]);
            translate([-2,24,0]) cube([4,8,1.8]);
        }
        translate([0,0,49.7]) {
            translate([-2,-4,0]) cube([4,8,1.8]);
            translate([-2,10,0]) cube([4,8,1.8]);
            translate([-2,24,0]) cube([4,8,1.8]);
        }
    }    
    
    //Solar panel
    translate([5,2,63]) cube([110,60,2]);
    
    //PCB case exclude
    translate([35,20,1.5]) cube([25.5,25.5,58]);
    translate([50,20,54]) cube([25.5,25.5,5]);
    
    tri1Points = [
        [ 0, 0, 0], [140, 0, 0], 
        [ 0, 8, 0], [140, 8, 0],
        [ 0, 4, 4], [140, 4, 4]];
    //PT sight
    translate([47,26,38.5]) {
        cube([140,8,5]); //PT sight
        cube([25,8,50]); //space for shield soldering
        translate([0,0,5]) polyhedron( tri1Points, triFaces );
    }
    
    
    //Battery exclude
    translate([40,47.6,1.5]) cube([67.5,8,58]);
    translate([38,47.6,38.5]) cube([69.5,8,21]);
    translate([53,47.6,1]) cube([41.5,10.8,58]);
    
    //Lensblokje exclude
    translate([90,13.9,26.5]) cube([16.1,32.2,30]);
    translate([88,20,32.5]) cube([60,20,13]);
    translate([88,20,32.5]) cube([20,20,24]);
    translate([90,14,1.5]) cube([4.2,32,31]);
    translate([96,14,1.5]) cube([4.2,32,31]);
    translate([102,14,1.5]) cube([4,32,31]);
    tri2Points = [
        [ 0, 0, 0], [60, 0, 0], 
        [ 0, 20, 0], [60, 20, 0],
        [ 0, 10, 10], [60, 10, 10]];
    translate([88,20,44.5]) polyhedron( tri2Points, triFaces );
    
    
    translate([20,2,1]) cube([89.5,1,12]);
    //E-ink exclude
    translate([20,0,14]) {
        difference() {
            cube([89.5,3,41.5]);
            translate([0,0,41.5]) rotate([-45,0,0]) cube([89.3,5,5]);
        }
        //cube([89,3,38]);
        translate([0,0,6]) cube([12,9,20.5]);
        translate([0,0,28-13.5]) intersection() {
            cube([17,9,23.5]);
            rotate([0,-45,0]) cube([17,9,17]);
        }
        translate([-12,3,6]) cube([12,8,20]);
        
        translate([-12,3,26]) intersection() {
            cube([12,8,30]);
            rotate([0,45,0]) cube([17,8,17]);
        }
        difference() {
            translate([19,0,9]) cube([70.5,5.5,22.5]);
            translate([19,3,31.5]) rotate([-45,0,0]) cube([70.5,5,5]);
        }
        
        difference() {
            translate([56,1,9]) cube([10,5.5,12.5]);
            translate([56,4,21.5]) rotate([-45,0,0]) cube([10,5,5]);
        }
        
        //screws
        translate([2.6, 0, 2.6]) rotate([-90,0,0]) cylinder(10,1.6,1.6,false);
        translate([86.7, 0, 2.6]) rotate([-90,0,0]) cylinder(10,1.6,1.6,false);
        translate([86.7, 0, 35.6]) rotate([-90,0,0]) cylinder(10,1.6,1.6,false);
        

        
    }
}


        

