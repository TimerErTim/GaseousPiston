include <main.scad>
use <housing.scad>
use <rotor.scad>
use <crank_shaft.scad>
use <spinning_disk.scad>
use <counter_weight.scad>
use <cover.scad>
use <nut.scad>
use <seal.scad>

module rotor_preview() {
    rotate([0, 0, - $t * 720]) translate([0, rotor_radius / 7, 0])  rotate([0, 0, $t * 720 / 2 * 3]) rotor();
}

module housing_preview() {
    housing();
    %rotor_preview();
    %crank_preview();
    %counter_weight_preview();
}

module all_preview() {
    housing();
    rotating_preview();
    color(undef, alpha = 0.5) cover_preview();
    %disk_preview();
}

module crank_preview() {
    rotate([0, 0, 180 - $t * 720]) crank_shaft();
}

module disk_preview() {
    color("green", - 1)
        rotate([0, 0, 180 - $t * 720]) spinning_disk();
}

module cover_preview() {
    cover();
}

module rotating_preview() {
    rotor_preview();
    %disk_preview();
    %crank_preview();
    %counter_weight_preview();
}

module covered_preview() {
    rotor_preview();
    %crank_preview();
    %cover_preview();
}

module counter_weight_preview() {
    rotate([0, 0, 180 - $t * 720]) counter_weight();
}

cover_preview();
