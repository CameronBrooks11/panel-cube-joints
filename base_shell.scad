// ===============================================================
// Base shell: an open tray that a row of panelled cubes sits in
// ===============================================================

// ---- Module Definition ----
module base_shell(
    plate_size, // width/height of one cube (required)
    cube_count, // number of cubes along X
    connector_thickness, // connector plate thickness, outside the panels
    panel_thickness, // panel (board) thickness
    wall_thickness, // side wall thickness
    floor_thickness, // floor thickness
    height, // overall height, floor included
    fit_allowance // clearance between the box and the walls, per side
) {
    extra_width = connector_thickness + panel_thickness;

    inner = [
        cube_count * plate_size + 2 * (fit_allowance + extra_width),
        plate_size + 2 * (fit_allowance + extra_width),
    ];

    outer = [inner[0] + 2 * wall_thickness, inner[1] + 2 * wall_thickness];

    difference() {
        cube([outer[0], outer[1], height], center=true);
        translate([0, 0, floor_thickness])
            color("lightgrey") cube([inner[0], inner[1], height], center=true);
    }
}
