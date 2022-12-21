include <main.scad>
use <housing.scad>
use <util.scad>

module cover() {
    cutout_radius = rotor_radius / 7 + crank_shaft_radius + 0.5;

    translate([0, 0, height])
        difference() {
            union() {
                difference() {
                    housing_base(cover_thickness);

                    // Cutout screws
                    translate([0, 0, - height / 2]) clone([1, 0, 0]) {
                        cover_screw_cutout(cover_screw_radius + cover_screw_clearance);
                        rotate([0, 0, 120]) cover_screw_cutout(cover_screw_radius + cover_screw_clearance);
                        rotate([0, 0, - 120]) cover_screw_cutout(cover_screw_radius + cover_screw_clearance);
                    }
                }

                translate([0, 0, cover_thickness])
                    cylinder(r = max(cutout_radius + cover_thickness, center_hole_radius + cover_thickness), h =
                        cover_thickness + 0.25);
            }

            // Cutout crank shaft
            polyhole(r = cutout_radius, h = cover_thickness + 0.25);

            // Cutout center hole
            translate([0, 0, cover_thickness + 0.25]) polyhole(r = center_hole_radius, h = cover_thickness + 0.002);
        }
}