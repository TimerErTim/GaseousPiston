use <../util.scad>
use <../../lib/gears.scad>
use <rotor.scad>
include <../main.scad>

module housing_cutout() {
    move = rotor_radius / 7;

    union() {
        translate([0, move, 0.0]) rotor_shape();
        rotate([0, 0, 120]) translate([0, move, 0.0]) rotor_shape();
        rotate([0, 0, - 120]) translate([0, move, 0.0]) rotor_shape();
    }
}

module housing_base(thickness) {
    xy_scaling = 1 + (stator_outer_wall_thickness) / rotor_radius;

    scale([xy_scaling, xy_scaling, (thickness) / height])
        hull() housing_cutout();
}

module housing_basic() {
    difference() {
        translate([0, 0, - bottom_thickness]) housing_base(height + bottom_thickness);

        scale([1, 1, 1.001]) housing_cutout();
    }
}


module apex_seal_cutout() {
    base_offset = - (rotor_radius * 6) / 7 - stator_seal_depth / 2;

    translate([0, base_offset, height / 2])
        cube([stator_seal_width, stator_seal_depth, height * 1.001], center = true);

    translate([0, base_offset - stator_seal_depth / 2 - stator_seal_push_radius + 1 / stator_seal_push_radius, 0])
        polyhole(r = stator_seal_push_radius, h = height * 1.001);
}

module combustion_chamber_cutout() {
    translate([0, rotor_radius + combustion_chamber_radius / 2, height / 2])
        polysphere(combustion_chamber_radius);
}

module cover_screw_cutout(r) {
    translate([rotor_radius / 1.5, - (rotor_radius * 6 / 7) - stator_outer_wall_thickness / 1.5, height + 0.001])
        polyhole(r = r, h = height, center = true);
}

module outlet_cutout() {
    translate([0, - (rotor_radius * 4) / 7 - rotor_radius * 1 / 18 - outlet_hole_radius / 2, - bottom_thickness / 2])
        polyhole(r = outlet_hole_radius, h = bottom_thickness * 1.002, center = true);
}


module housing_ring_gear() {
    translate([0, 0, - bottom_thickness])
        ring_gear(rotor_radius / 18, 15, bottom_thickness, 1, 30);
}


module housing() {
    union() {
        difference() {
            housing_basic();

            // Cutout apex seals
            apex_seal_cutout();
            rotate([0, 0, 120]) apex_seal_cutout();
            rotate([0, 0, - 120]) apex_seal_cutout();

            // Cutout cumbustion chambers
            combustion_chamber_cutout();
            rotate([0, 0, 120]) combustion_chamber_cutout();
            rotate([0, 0, - 120]) combustion_chamber_cutout();

            // Cutout screws
            clone([1, 0, 0]) {
                cover_screw_cutout(cover_screw_radius);
                rotate([0, 0, 120]) cover_screw_cutout(cover_screw_radius);
                rotate([0, 0, - 120]) cover_screw_cutout(cover_screw_radius);
            }

            // Cutout outlet holes
            outlet_cutout();
            rotate([0, 0, 120]) outlet_cutout();
            rotate([0, 0, - 120]) outlet_cutout();

            // Add backing ring gear
            hull() translate([0, 0, 0.001]) scale([0.99, 0.99, 1.002]) housing_ring_gear();
        }

        rotate([0, 0, - 6]) housing_ring_gear();
    }
}

housing();
