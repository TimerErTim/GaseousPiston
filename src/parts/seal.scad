include <../main.scad>
use <MCAD/regular_shapes.scad>

module seal() {
    union() {
        %translate([0, - seal_length / 3, 0]) cube([stator_seal_width, seal_length, height]);
        cube([stator_seal_width, seal_length * 2 / 3, height]);
        translate([stator_seal_width / 2, 0, 0]) oval_prism(height, seal_length / 3, stator_seal_width / 2);
    }
}