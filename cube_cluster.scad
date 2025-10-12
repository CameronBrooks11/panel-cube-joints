// ==================================================
// cube_cluster.scad — multi-cube assembly system
// ==================================================

include <lib/math_utils.scad>
include <lib/color_utils.scad>
include <lib/geometry_utils.scad>

module unit_cube(dim, col) color(col) cube([dim, dim, dim], center=true);

module panelled_cube(
  dim,
  th,
  faces,
  pos,
  use_palette = true,
  rgb_fallback = [0, 1, 0],
  alpha = 1.0
) {
  for (n = faces) {
    col = select_rgba(use_palette, PALETTE_PANEL, rgb_fallback, pos + n, alpha);
    color(col)
      rotate(a=rot_angle_from_x(n), v=rot_axis_from_x(n))
        translate([dim / 2 + th / 2, 0, 0])
          cube([th, dim, dim], center=true);
  }
}

module cube_cluster(
  dim,
  th,
  cubes,
  show_panels = true,
  use_block_palette = true,
  use_panel_palette = true,
  block_rgb = [0.10, 0.60, 1.00],
  panel_rgb = [0.10, 1.00, 0.10],
  block_alpha = 0.35,
  panel_alpha = 0.9
) {
  for (p = cubes) {
    block_col = select_rgba(use_block_palette, PALETTE_BLOCK, block_rgb, p, block_alpha);
    translate(p * dim) {
      unit_cube(dim, block_col);
      if (show_panels)
        panelled_cube(
          dim, th, exposed_faces(p, cubes), p,
          use_panel_palette, panel_rgb, panel_alpha
        );
    }
  }
}
