include <main.scad>
use <crank_shaft.scad>

module base_connector_shape() {
    minkowski() {
        cube([crank_shaft_radius * 3, rotor_radius * 2 / 7, counter_weight_width], center = true);

        cylinder(r = 2, h = 0.001);
    }
}

module basic_connector() {
    difference() {
        translate([0, - rotor_radius / 7]) base_connector_shape();

        translate([0, 0, bottom_thickness + (counter_weight_distance + counter_weight_width / 2) * 1.15])
            scale([1, 1, 1.1]) crank_shaft();
    }
}

module counter_weight() {
    translate([0, 0, - bottom_thickness - counter_weight_distance - counter_weight_width / 2]) {
        basic_connector();
    }
}
