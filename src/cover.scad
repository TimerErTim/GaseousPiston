include <main.scad>
use <housing.scad>
use <util.scad>

module cover() {
    translate([0, 0, height]) difference() {
        housing_base(cover_thickness);

        // Cutout screws
        translate([0, 0, - height / 2]) clone([1, 0, 0]) {
            cover_screw_cutout(cover_screw_radius + cover_screw_clearance);
            rotate([0, 0, 120]) cover_screw_cutout(cover_screw_radius + cover_screw_clearance);
            rotate([0, 0, - 120]) cover_screw_cutout(cover_screw_radius + cover_screw_clearance);
        }
    }
}