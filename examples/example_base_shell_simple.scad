// The tray
// An open tray for two 80 mm cubes, with 1.6 mm walls and a 1.2 mm floor.

use <../base_shell.scad>;

// ---- Example Usage ----
// A tray for two 80 mm cubes: 1.6 mm walls, a 1.2 mm floor, 4.8 mm tall.
plate_dim_example = 80;
cube_count_example = 2;
fit_example = 0.8;
wall_example = 1.6;
floor_example = 1.2;
height_example = 4.8;
panel_th_example = 1.4;
connector_th_example = 2.0;

base_shell(
  plate_size=plate_dim_example,
  cube_count=cube_count_example,
  connector_thickness=connector_th_example,
  panel_thickness=panel_th_example,
  wall_thickness=wall_example,
  floor_thickness=floor_example,
  height=height_example,
  fit_allowance=fit_example
);
