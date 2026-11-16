// ===============================================================
// Modular Right-Triangle Connector System
// Corner, Edge, Sleeve, and Sleeve-Corner connectors
// Each unit is composed of extruded right-triangle plates
// ===============================================================

// ---------------- Global defaults ----------------
z_fight = $preview ? 0.01 : 0;

// Facets on each screw hole. Set here, on the hole itself, because a
// top-level $fn in this file does not reach callers that `use` it: they
// got 5-sided holes from OpenSCAD's defaults.
hole_fn = 64;

// ===============================================================
//  Base components
// ===============================================================

// ---- Unit: right triangle plate with screw hole ----
// hole_dia is the hole's diameter: about 1.7 mm for an M2 screw to tap
// into the plastic, or 2.2-2.4 mm to clear one for a nut.
module tri_right_plate(dim, thickness, hole_dia, hole_loc) {
  difference() {
    linear_extrude(height=thickness)
      polygon(points=[[0, 0], [dim, 0], [0, dim]], paths=[[0, 1, 2]]);
    translate(hole_loc)
      translate([0, 0, -z_fight / 2])
        cylinder(h=thickness + z_fight, r=hole_dia / 2, $fn=hole_fn);
  }
}

// ---- Unit: small corner chamfer filler (triangular prism) ----
module corner_chamfer(plate_thickness) {
  polyhedron(
    points=[
      [0, 0, 0],
      [plate_thickness, 0, 0],
      [0, plate_thickness, 0],
      [plate_thickness, plate_thickness, 0],
      [0, 0, plate_thickness],
    ],
    faces=[
      [0, 1, 4],
      [1, 3, 4],
      [3, 2, 4],
      [2, 0, 4],
      [0, 2, 3, 1],
    ]
  );
}

// ===============================================================
//  Connector modules
// ===============================================================

// ---- Edge connector (2 right triangles sharing an edge) ----
module edge_connector(dim, thickness, hole_dia, hole_loc) {
  for (i = [0:1])
    mirror([i, 0, 0])
      tri_right_plate(dim, thickness, hole_dia, hole_loc);
}

// ---- Sleeve connector (4 right triangles forming a 90° sleeve) ----
module sleeve_connector(dim, thickness, plate_thickness, hole_dia, hole_loc) {
  union() {
    // Two plates along one edge
    translate([0, 0, -thickness])
      edge_connector(dim, thickness, hole_dia, hole_loc);

    // Two more rotated 90° around perpendicular axis
    rotate([90, 0, 0])
      edge_connector(dim, thickness, hole_dia, hole_loc);

    // Structural spine (central filler)
    translate([0, -thickness / 2, -thickness / 2])
      cube([dim * 2, thickness, thickness], center=true);

    // Internal board ledge
    translate([0, plate_thickness / 2, plate_thickness / 2])
      cube([dim * 2 - 2 * plate_thickness, plate_thickness, plate_thickness], center=true);

    // Chamfer caps closing both ends
    for (i = [0:1])
      mirror([i, 0, 0])
        translate([-dim + plate_thickness, 0, 0])
          rotate([0, -90, 0])
            corner_chamfer(plate_thickness);
  }
}

// ---- Sleeve-corner connector (3 faces at 90° around a vertex) ----
module sleeve_corner_connector(dim, thickness, plate_thickness, hole_dia, hole_loc) {
  union() {
    // Base triangle on +Z
    tri_right_plate(dim, thickness, hole_dia, hole_loc);

    // +X face
    translate([0, 0, thickness])
      rotate([0, -90, 0])
        tri_right_plate(dim, thickness, hole_dia, hole_loc);

    // +Y face
    translate([0, 0, thickness])
      rotate([90, 0, 0])
        tri_right_plate(dim, thickness, hole_dia, hole_loc);

    // Edge fillers
    translate([-thickness / 2, dim / 2 - thickness / 2, thickness / 2])
      cube([thickness, dim + thickness, thickness], center=true);

    translate([dim / 2 - thickness / 2, -thickness / 2, thickness / 2])
      cube([dim + thickness, thickness, thickness], center=true);

    translate([-thickness / 2, -thickness / 2, dim / 2 + thickness / 2])
      cube([thickness, thickness, dim + thickness], center=true);

    // Board ledges
    translate([plate_thickness / 2, dim / 2 - plate_thickness / 2, plate_thickness / 2 + thickness])
      cube([plate_thickness, dim - plate_thickness, plate_thickness], center=true);

    translate([dim / 2 - plate_thickness / 2, plate_thickness / 2, plate_thickness / 2 + thickness])
      cube([dim - plate_thickness, plate_thickness, plate_thickness], center=true);

    translate([plate_thickness / 2, plate_thickness / 2, dim / 2 + thickness - plate_thickness / 2])
      cube([plate_thickness, plate_thickness, dim - plate_thickness], center=true);

    // Chamfers: XY, YZ, XZ
    translate([0, 0, dim + thickness - plate_thickness])
      corner_chamfer(plate_thickness);

    translate([dim - plate_thickness, 0, thickness])
      rotate([0, 90, 0])
        rotate([0, 0, 90])
          corner_chamfer(plate_thickness);

    translate([0, dim - plate_thickness, thickness])
      rotate([-90, 0, 0])
        rotate([0, 0, -90])
          corner_chamfer(plate_thickness);
  }
}

// ---- Corner connector (2 faces at 90° around a vertex) ----
module corner_connector(dim, thickness, plate_thickness, hole_dia, hole_loc) {
  union() {
    translate([0, 0, thickness])
      rotate([0, -90, 0])
        tri_right_plate(dim, thickness, hole_dia, hole_loc);

    translate([0, 0, thickness])
      rotate([90, 0, 0])
        tri_right_plate(dim, thickness, hole_dia, hole_loc);

    translate([-thickness / 2, -thickness / 2, dim / 2 + thickness])
      cube([thickness, thickness, dim], center=true);

    // Ledge for panel
    translate([plate_thickness / 2, plate_thickness / 2, dim / 2 + thickness - plate_thickness / 2])
      cube([plate_thickness, plate_thickness, dim - plate_thickness], center=true);

    // Single top chamfer
    translate([0, 0, dim + thickness - plate_thickness])
      corner_chamfer(plate_thickness);
  }
}
