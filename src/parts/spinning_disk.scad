include <../main.scad>
use <crank_shaft.scad>
use <MCAD/regular_shapes.scad>

module disk_cutout() {
    translate([0, disk_radius, disk_thickness / 2])
        cube([disk_radius / 4, disk_radius / 2, disk_thickness + 0.002], center = true);

    translate([0, disk_radius / 1.5, disk_thickness / 2])
        cube([disk_radius / 2, disk_radius / 4, disk_thickness + 0.002], center = true);
}

module spinning_disk() {
    translate([0, 0, height + cover_thickness + crank_shaft_length - disk_thickness])
        difference() {
            cylinder(r = disk_radius, h = disk_thickness);

            circumscribed_r = (crank_shaft_radius) / cos(180 / max(round(4 * crank_shaft_radius), 3));
            translate([0, 0, - (height + cover_thickness + crank_shaft_length - disk_thickness) + 0.002])
                scale([circumscribed_r / crank_shaft_radius, circumscribed_r / crank_shaft_radius, 1]) crank_shaft();

            // Cutout some forms
            disk_cutout();
            rotate([0, 0, 120]) disk_cutout();
            rotate([0, 0, - 120]) disk_cutout();
        }
}

module guided_disk() {
    translate([0, 0, height + cover_thickness + crank_shaft_length - disk_thickness])
        difference() {
            cylinder(r = disk_radius, h = disk_thickness);

            circumscribed_r = (crank_shaft_radius) / cos(180 / max(round(4 * crank_shaft_radius), 3));
            translate([0, 0, - (height + cover_thickness + crank_shaft_length - disk_thickness) + 0.002])
                scale([circumscribed_r / crank_shaft_radius, circumscribed_r / crank_shaft_radius, 1]) crank_shaft();

            // Cutout guidelines
            translate([0, 0, disk_thickness / 2])
                oval_torus(disk_radius - 2.5, thickness = [2.5 * 5, disk_thickness]);

            // Cutout entering hook
            translate([0, - disk_radius, 0]) scale([1, 2, 1]) triangle_prism(disk_thickness / 2, 2.5 / 2);
        }
}
