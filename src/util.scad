// Using this holes should come out approximately right when printed
module polyhole(h, r, center = false) {
    n = max(round(4 * r), 3);
    rotate([0, 0, 180])
        cylinder(h = h, r = (r) / cos(180 / n), center = center);
}

// Using this holes should come out approximately right when printed
module polysphere(r) {
    n = max(round(4 * r), 3);
    sphere(r = (r) / cos(180 / n));
}


module clone(vec = [0, 1, 0]) {
    children();
    mirror(vec) children();
}
