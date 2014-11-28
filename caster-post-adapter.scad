outer_radius = (12.46 + 0.2)/2;
inner_radius = (8.4 + 0.5)/2;

difference() {
cylinder(h = 22.9, r1 = outer_radius, r2 = outer_radius);
translate([0, 0, 2])
	cylinder(h = 22.9, r1 = inner_radius, r2 = inner_radius);
}
