use <../../lib/gears.scad>
use <../util.scad>
include <../main.scad>
use <MCAD/2Dshapes.scad>
use <MCAD/regular_shapes.scad>



function liquid_piston_coordinates(t, size = rotor_radius) = [
            ((size * 6) / 7) * cos(t) - size / 7 * cos(((size * 6) / 7) / ((size * 2) / 7) * t),
            ((size * 6) / 7) * sin(t) - size / 7 * sin(((size * 6) / 7) / ((size * 2) / 7) * t),
    ];

function liquid_piston_points(n = $rn, size = rotor_radius) = [for (t = [0:360 / n:359.999]) liquid_piston_coordinates(t
, size)];

module rotor_shape() {
    linear_extrude(height = height)
        polygon(liquid_piston_points());
}

module rotor_cutout() {
    linear_extrude(height = height)
        polygon(liquid_piston_points(size = rotor_radius - rotor_outer_wall_thickness));
}


module center_connection(t) {
    point = liquid_piston_coordinates(t, rotor_radius - rotor_outer_wall_thickness / 2);
    length = sqrt(point[0] * point[0] + point[1] * point[1]) * 2;

    rotate([0, 0, t + 90])
        translate([0, 0, height / 2]) cube([rotor_inner_wall_thickness, length, height / 2], center = true);
}


module exhaust_chamber_intersection(off = 0, scaling = 1) {
    rotor_offset = rotor_radius * 4 / 7;

    scale([scaling, scaling, 1]) intersection() {
        rotor_cutout();

        translate([0, off + rotor_offset, - height / 4 + rotor_inner_wall_thickness]) difference() {
            linear_extrude(height * 1.002) pieSlice([rotor_radius, rotor_radius], start_angle = - 35, end_angle = 215);

            translate([0, - rotor_offset, - .001])
                oval_prism(rx = rotor_radius * 4 / 7 + rotor_radius / 18, ry = rotor_radius * 4 / 7,
                height = height * 1.1);
        }
    }
}

module exhaust_chamber() {
    translate([0, 0, 0]) difference() {
        exhaust_chamber_intersection();

        translate([0, 0, - rotor_inner_wall_thickness])
            exhaust_chamber_intersection(scaling = rotor_inner_wall_thickness / rotor_radius + 1);
    }
}

module exhaust_chamber_cutout() {
    start_angle = 120;
    stop_angle = 125;

    translate([0, 0, - .001]) scale([1, 1, 1.002])
        exhaust_chamber_intersection();

    translate([0, 0, height / 4]) linear_extrude(height / 2)
        polygon([
            liquid_piston_coordinates(start_angle, size = rotor_radius * 1.002),
            liquid_piston_coordinates(start_angle, size = rotor_radius - rotor_outer_wall_thickness - 0.002),
            liquid_piston_coordinates(stop_angle, size = rotor_radius - rotor_outer_wall_thickness - 0.002),
            liquid_piston_coordinates(stop_angle, size = rotor_radius * 1.002),
            ]);
}


module inlet_chamber_tunnel(radius = rotor_radius * 3 / 7) {
    start_angle = 205;
    stop_angle = 212.5;

    translate([0, 0, height / 4]) linear_extrude(height / 2)
        polygon([
            liquid_piston_coordinates(start_angle, size = rotor_radius * 1.1),
                [cos(start_angle) * (radius - rotor_inner_wall_thickness), sin(start_angle) * (radius -
                rotor_inner_wall_thickness)],
                [cos(stop_angle) * (radius - rotor_inner_wall_thickness), sin(stop_angle) * (radius -
                rotor_inner_wall_thickness)],
            liquid_piston_coordinates(stop_angle, size = rotor_radius * 1.1),
            ]);
}

module inlet_chamber() {
    radius = inlet_circle_radius;

    difference() {
        union() {
            difference() {
                union() {
                    translate([0, 0, height / 4 - rotor_inner_wall_thickness])
                        cylinder(r = radius, h = height * 3 / 4 + rotor_inner_wall_thickness);

                    translate([0, 0, height - rotor_inner_wall_thickness])
                        cylinder(r = min(inlet_circle_radius, rotor_radius * 4 / 7) + rotor_radius / 7, h =
                        rotor_inner_wall_thickness);
                }

                translate([0, 0, height / 4])
                    cylinder(r = radius - rotor_inner_wall_thickness, h = height);
            }

            intersection() {
                difference() {
                    rotor_cutout();

                    cylinder(r = radius, h = height);
                }

                difference() {
                    minkowski() {
                        inlet_chamber_tunnel();

                        cube(rotor_inner_wall_thickness, center = true);
                    }
                }
            }
        }

        inlet_chamber_tunnel();
    }
}

module inlet_chamber_cutout() {
    radius = inlet_circle_radius;

    intersection() {
        translate([0, 0, height / 2 + rotor_inner_wall_thickness])
            clone([0, 0, 1]) translate([0, 0, height / 8]) scale([1, 1, 1.002])
                hull() difference() {
                    cylinder(r = radius, h = height);

                    translate([0, 0, rotor_inner_wall_thickness])
                        cylinder(r = radius - rotor_inner_wall_thickness, h = height);
                }

        rotor_shape();
    }

    inlet_chamber_tunnel();
}


module rotor_spur_gear() {
    translate([0, 0, - bottom_thickness])
        spur_gear(rotor_radius / 18, 10, bottom_thickness, - 10000, 30, optimized = false);
}


module simple_rotor() {
    difference() {
        union() {
            difference() {
                rotor_shape();
                scale([1, 1, 1.5]) translate([0, 0, - height / 4]) rotor_cutout();
            }
            rotate([0, 0, 18]) rotor_spur_gear();

            // Connections to center piece
            center_connection(0);
            center_connection(120);
            center_connection(- 120);
        }
    }
}

module rotor() {
    difference() {
        union() {
            difference() {
                simple_rotor();

                exhaust_chamber_cutout();
                inlet_chamber_cutout();
            }

            // Add exhaust chamber
            color(undef, 0.35) exhaust_chamber();

            // Add inlet chamber
            inlet_chamber();

            cylinder(h = height, r = center_hole_radius + rotor_center_wall_thickness);
        }

        polyhole(h = height * 2.002, r = center_hole_radius, center = true);
    }
}

rotor();
