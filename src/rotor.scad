use <gears.scad>
include <main.scad>



function liquid_piston_coordinates(t, size=rotor_radius) = [
    ((size * 6) / 7) * cos(t) - size / 7 * cos(((size * 6) / 7)/((size * 2) / 7) * t),
    ((size * 6) / 7) * sin(t) - size / 7 * sin(((size * 6) / 7)/((size * 2) / 7) * t),
];

function liquid_piston_points(n=$rn, size=rotor_radius) = [ for (t=[0:360/n:359.999]) liquid_piston_coordinates(t, size)];

module rotor_shape() {
    linear_extrude(height = height)
        polygon(liquid_piston_points());
}

module rotor_cutout() {
    linear_extrude(height = height)
        polygon(liquid_piston_points(size = rotor_radius - rotor_outer_wall_thickness));
}

module rotor_spur_gear() {
    translate([0, 0, - bottom_thickness])
        spur_gear(rotor_radius / 18, 10, bottom_thickness, - 10000, 30, optimized = false);
}

module rotor() {

    difference() {
        union() {
            difference() {
                rotor_shape();
                scale([1, 1, 1.5]) translate([0, 0, - 0.002]) rotor_cutout();
            }
            rotate([0, 0, 18]) rotor_spur_gear();

            // Connections to center piece

            cylinder(h=height, r=center_hole_radius+rotor_center_wall_thickness);
        }

        cylinder(h=height*2.002, r=center_hole_radius, center=true);
    }
}

rotor();
