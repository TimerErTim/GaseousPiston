use <gears.scad>



module seal_cutout() {
    move = R+r+d*1.5;
    cylinder_radius = 12.5;
    cube_length = d*3;
    
    translate([0, -move, 0]) union() {
        translate([0, 0, h/2]) cylinder(h=h,r=cylinder_radius, center=true);
        translate([0, cylinder_radius+cube_length/2-10, h/2]) cube([7.5, cube_length, h], center=true);
    }
}

module chamber_cutout() {
    move = R+r*2;
    radius = d*2 - h/10;
    
    translate([0, move, 0]) union() {
        translate([0, 0, 0]) sphere(r=radius);
    }
}

module housing () {    
    union() {
        difference() {
            hull() scale([1.35, 1.35, 1]) housing_cutout();
            translate([0, 0, h/10]) housing_cutout();
            
            // Add backing ring gear
            hull() translate([0, 0, -1]) ring_gear(7.5, 15, 50, 2, 30);
            
            // Add seals
            translate([0, 0, h/10]) union() { 
                seal_cutout();
                rotate([0, 0, 120]) seal_cutout();
                rotate([0, 0, -120]) seal_cutout();
            }
                
            
            // Add combustion chambers
            translate([0, 0, h/2 + h/20]) union() {
                chamber_cutout();
                rotate([0, 0, 120]) chamber_cutout();
                rotate([0, 0, -120]) chamber_cutout();
            }
        }
        
        rotate([0, 0, -6]) ring_gear(7.5, 15, h/10, 5, 30);
    }
}



rotate([0, 0, $t * 200]) translate([0, 25, h/10])  rotate([0, 0, -$t * 300]) rotor();

housing();


