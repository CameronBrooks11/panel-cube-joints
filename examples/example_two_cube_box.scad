// A two-cube box
// Every part of a 160 x 80 x 80 mm box of 80 mm panels, laid out to print: 12 connectors and the tray.

use <../connectors.scad>;
use <../base_shell.scad>;

// ===============================================================
//  Every part of a two-cube box of 80 mm panels, laid out to print
//
//  The box is two 80 mm cubes end to end, 160 x 80 x 80 mm: two
//  panels on each long side, one on each end, two on top as a lid
//  that lifts off, standing in a tray. It takes 12 connectors and
//  32 M2 screws, one per triangular plate:
//
//    sleeve-corner  4  top corners                    3 screws each
//    corner         4  bottom corners, into the tray  2 screws each
//    sleeve         2  top edge, where the panels meet 4 screws each
//    edge           2  bottom of each long side, where the panels meet
//                                                     2 screws each
// ===============================================================

part = "all"; // "all", "connectors", "tray"

// Connectors
dim = 20; // right triangle leg length
thickness = 2; // plate thickness
plate_thickness = 1.4; // ledge the panel edge seats against
hole_dia = 1.7; // M2 self-tapping pilot; untested, see README
hole_offset = 5; // panel's holes, in from its edges

corner_hole_loc = [hole_offset + plate_thickness, hole_offset + plate_thickness];
flat_hole_loc = [hole_offset, hole_offset + plate_thickness];

// Tray
plate_size = 80;
cube_count = 2;
wall_thickness = 1.6;
floor_thickness = 1.2;
tray_height = 4.8;
fit_allowance = 0.8;

pitch = 3 * dim; // spacing between parts on the plate
// Each part below is moved so its lowest point sits on z = 0.

if (part == "all" || part == "connectors") {
  for (i = [0:3])
    translate([i * pitch, 0, 0])
      sleeve_corner_connector(dim, thickness, plate_thickness, hole_dia, corner_hole_loc);

  for (i = [0:3])
    translate([i * pitch, pitch, -thickness])
      corner_connector(dim, thickness, plate_thickness, hole_dia, corner_hole_loc);

  for (i = [0:1])
    translate([i * pitch, 2 * pitch, thickness])
      sleeve_connector(dim, thickness, plate_thickness, hole_dia, flat_hole_loc);

  for (i = [0:1])
    translate([(i + 2) * pitch, 2 * pitch, 0])
      edge_connector(dim, thickness, hole_dia, flat_hole_loc);
}

if (part == "all" || part == "tray")
  translate([0, -pitch - plate_size, tray_height / 2])
    base_shell(
      plate_size=plate_size,
      cube_count=cube_count,
      connector_thickness=thickness,
      panel_thickness=plate_thickness,
      wall_thickness=wall_thickness,
      floor_thickness=floor_thickness,
      height=tray_height,
      fit_allowance=fit_allowance
    );
