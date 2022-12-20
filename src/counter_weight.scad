include <main.scad>
use <crank_shaft.scad>

module base_connector_shape() {
    minkowski() {
        translate([0, rotor_radius / 7 - crank_shaft_radius / 2])
            cube([crank_shaft_radius * 2, rotor_radius * 2 / 7 + crank_shaft_radius, counter_weight_width], center =
            true);

        cylinder(r = 2, h = 0.001);
    }
}

module basic_connector() {
    circumscribed_r = (crank_shaft_radius) / cos(180 / max(round(4 * crank_shaft_radius), 3));

    difference() {
        base_connector_shape();

        translate([0, rotor_radius / 7, bottom_thickness + (counter_weight_distance + counter_weight_width / 2) * 1.15])
            scale([circumscribed_r / crank_shaft_radius, circumscribed_r / crank_shaft_radius, 1.1]) crank_shaft();
    }
}

module weight() {
    translate([0, rotor_radius * 2 / 7, 0]) minkowski() {
        difference() {
            cylinder(r = rotor_radius * 2 / 7, h = counter_weight_width, center = true);

            translate([0, - rotor_radius / 7, 0])
                cube([rotor_radius * 4 / 7, rotor_radius * 2 / 7, counter_weight_width + 0.002], center = true);
        }

        cylinder(r = 2, h = 0.001);
    }
}

module counter_weight() {
    translate([0, - rotor_radius / 7, - bottom_thickness - counter_weight_distance - counter_weight_width / 2]) union()
        {
            basic_connector();
            weight();
        }
}
