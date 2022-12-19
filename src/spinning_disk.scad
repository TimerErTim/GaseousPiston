include <main.scad>
use <crank_shaft.scad>

module disk_cutout() {
    translate([0, disk_radius, cover_thickness / 2])
        cube([disk_radius / 4, disk_radius / 2, cover_thickness + 0.002], center = true);

    translate([0, disk_radius / 1.5, cover_thickness / 2])
        cube([disk_radius / 2, disk_radius / 4, cover_thickness + 0.002], center = true);
}

module spinning_disk() {
    translate([0, 0, height + cover_thickness + crank_shaft_length - cover_thickness])
        difference() {
            cylinder(r = disk_radius, h = cover_thickness);

            translate([0, 0, - (height + cover_thickness + crank_shaft_length - cover_thickness) + 0.002])
                scale([1.002, 1.002, 1]) crank_shaft();

            // Cutout some forms
            disk_cutout();
            rotate([0, 0, 120]) disk_cutout();
            rotate([0, 0, - 120]) disk_cutout();
        }
}