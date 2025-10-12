// ===============================================================
// Two-cube base shell — parameterized, concise version
// ===============================================================

// ---- Module Definition ----
module base_shell(
  plate_size, // width/height of one cube (required)
  cube_count, // number of cubes along X
  connector_thickness, // outer face/connector plate thickness
  panel_thickness, // inner ledge/seating thickness
  wall_thickness, // true wall thickness
  fit_allowance // clearance for fit
) {
  extra_width = connector_thickness + panel_thickness;

  // Derived dimensions
  outer = [
    cube_count * plate_size + 2 * (wall_thickness + extra_width),
    plate_size + 2 * (wall_thickness + extra_width),
    wall_thickness * 2,
  ];

  inner = [
    cube_count * plate_size + 2 * (fit_allowance + extra_width),
    plate_size + 2 * (fit_allowance + extra_width),
    outer[2],
  ];

  difference() {
    cube(outer, center=true);
    translate([0, 0, wall_thickness / 2])
      color("lightgrey") cube(inner, center=true);
  }
}
