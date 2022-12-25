include <main.scad>
use <util.scad>

module cover_nut() {
    nut_height = cover_screw_length - height - cover_thickness + 1.2;

    difference() {
        cylinder(r = cover_screw_radius + cover_screw_clearance + 1.6, h = nut_height);

        polyhole(r = cover_screw_radius + cover_screw_clearance, h = nut_height + 0.002);
    }
}