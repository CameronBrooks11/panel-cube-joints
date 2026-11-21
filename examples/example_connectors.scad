// The four connectors
// One each of the sleeve-corner, sleeve, corner and edge connectors.

use <../connectors.scad>;

// ===============================================================
//  Example layout showing all four connector types
// ===============================================================

// Select which part to render, or "all" to see all four
render_part = "all"; // "all", "sleeve", "corner", "sleeve-corner", "edge"

// Parameters for all parts
dim_ex = 20; // right triangle leg length
thickness_ex = 2; // plate extrusion thickness
plate_thickness_ex = 1.4; // small ledge/board support
hole_dia_ex = 1.7; // M2 self-tapping pilot; 2.2-2.4 to clear an M2 for a nut
hole_offset = 5;

// Derived parameters
corner_hole_loc_ex = [hole_offset + plate_thickness_ex, hole_offset + plate_thickness_ex]; // local hole position for corner pieces
flat_hole_loc_ex = [hole_offset, hole_offset + plate_thickness_ex]; // local hole position for flat pieces (no extra plate offset on x)

// Translation offset to separate parts when rendering all
translate_dim_ex = (render_part == "all") ? dim_ex : 0;

if (render_part == "all" || render_part == "sleeve-corner")
    translate([translate_dim_ex * 0, 0, 0]) color("red")
            sleeve_corner_connector(dim_ex, thickness_ex, plate_thickness_ex, hole_dia_ex, corner_hole_loc_ex);

if (render_part == "all" || render_part == "sleeve")
    translate([translate_dim_ex * 3, 0, 0]) color("green")
            sleeve_connector(dim_ex, thickness_ex, plate_thickness_ex, hole_dia_ex, flat_hole_loc_ex);

if (render_part == "all" || render_part == "corner")
    translate([0, translate_dim_ex * 3, 0]) color("blue")
            corner_connector(dim_ex, thickness_ex, plate_thickness_ex, hole_dia_ex, corner_hole_loc_ex);

if (render_part == "all" || render_part == "edge")
    translate([translate_dim_ex * 3, translate_dim_ex * 3, 0]) color("purple")
            edge_connector(dim_ex, thickness_ex, hole_dia_ex, flat_hole_loc_ex);
