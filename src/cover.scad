include <main.scad>
use <housing.scad>
use <util.scad>
use <MCAD/regular_shapes.scad>

cutout_radius = rotor_radius / 7 + crank_shaft_radius + 0.5;

inlet_radius = min(inlet_circle_radius + rotor_radius / 7, rotor_radius * 4 / 7);
inlet_width = inlet_radius - max(center_hole_radius + rotor_center_wall_thickness + rotor_radius / 7,
max(cutout_radius + cover_thickness, center_hole_radius + cover_thickness));

inlet_length = rotor_radius * 8 / 7 + stator_outer_wall_thickness - inlet_radius;

module pneumatic_inlet() {
    intersection() {
        translate([- pneumatic_inlet_radius - cover_thickness, 0, cover_height])
            cube([pneumatic_inlet_radius * 2 + cover_thickness * 2, inlet_length * 2, pneumatic_inlet_radius * 2 +
                cover_thickness]);

        difference() {
            housing_base(height * 2);

            cylinder(r = inlet_radius - inlet_width - cover_thickness, h = height * 2);
        }
    }
}

module pneumatic_inlet_cutout() {
    translate([0, 0, cover_height - 0.002]) union() {
        intersection() {
            translate([- pneumatic_inlet_radius, 0, 0]) cube([pneumatic_inlet_radius * 2, inlet_length,
                    pneumatic_inlet_radius * 2]);

            cylinder_tube(height = pneumatic_inlet_radius * 2, radius = inlet_radius - cover_thickness, wall =
                inlet_width - cover_thickness);
        }

        translate([0, .002, 0]) intersection() {
            translate([0, 0, (pneumatic_inlet_radius)])
                rotate([- 90, 0, 0]) cylinder(r = pneumatic_inlet_radius, h = inlet_length * 2);

            difference() {
                housing_base(height * 2);

                cylinder(r = inlet_radius - inlet_width, h = height * 2);
            }
        }
    }
}

module cover() {
    translate([0, 0, height])
        difference() {
            union() {
                difference() {
                    housing_base(cover_height);

                    // Cutout screws
                    translate([0, 0, - height / 2 - 0.002]) clone([1, 0, 0]) {
                        cover_screw_cutout(cover_screw_radius + cover_screw_clearance);
                        rotate([0, 0, 120]) cover_screw_cutout(cover_screw_radius + cover_screw_clearance);
                        rotate([0, 0, - 120]) cover_screw_cutout(cover_screw_radius + cover_screw_clearance);
                    }
                }

                translate([0, 0, cover_height])
                    cylinder(r = max(cutout_radius + cover_thickness, center_hole_radius + cover_thickness), h =
                                cover_thickness * 2 + 1.5 - cover_height);

                // Add inlet ring
                translate([0, 0, cover_height - 0.001])
                    cylinder_tube(height = cover_thickness * 2 - cover_height, radius = inlet_radius, wall = inlet_width
                    );

                // Add pneumatic inlet
                pneumatic_inlet();
            }

            // Cutout inlet ring
            translate([0, 0, - .001])
                cylinder_tube(height = cover_thickness, radius = inlet_radius - cover_thickness, wall = inlet_width -
                    cover_thickness);

            // Cutout pneumatic inlet
            pneumatic_inlet_cutout();

            // Cutout crank shaft
            translate([0, 0, - .001]) polyhole(r = cutout_radius, h = cover_thickness + 1.5 + 0.002);

            // Cutout center hole
            translate([0, 0, cover_thickness + 1.5]) polyhole(r = center_hole_radius, h = cover_thickness + 0.002);
        }
}