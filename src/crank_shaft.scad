include <main.scad>

module crank_shaft() {
    difference() {
        union() {
            translate([0, - rotor_radius / 7, 0.001 - bottom_thickness - counter_weight_distance - counter_weight_width]
            )
                cylinder(r = crank_shaft_radius, h = height + bottom_thickness + counter_weight_distance +
                    counter_weight_width);

            hull() {
                translate([0, - rotor_radius / 7, height])
                    cylinder(r = crank_shaft_radius, h = cover_thickness);

                translate([0, 0, height])
                    cylinder(r = crank_shaft_radius, h = cover_thickness);
            }

            translate([0, 0, height - 0.001])
                cylinder(r = crank_shaft_radius, h = crank_shaft_length + cover_thickness);
        }

        translate([0, crank_shaft_radius - rotor_radius / 7, - bottom_thickness - counter_weight_width / 2 -
            counter_weight_distance])
            cube([crank_shaft_radius * 2, crank_shaft_radius, counter_weight_width], center = true);

        translate([0, crank_shaft_radius, height + crank_shaft_length + cover_thickness - d_shaft_length / 2])
            cube([crank_shaft_radius * 2, crank_shaft_radius, d_shaft_length], center = true);
    }
}


