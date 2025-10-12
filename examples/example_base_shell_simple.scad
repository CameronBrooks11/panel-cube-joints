use <../base_shell.scad>;

// ---- Example Usage ----
plate_dim_example = 80;
cube_count_example = 2;
fit_example = 0.8;
wall_example = 2.4;
panel_th_example = 1.4;
connector_th_example = 2.0;

base_shell(
  plate_size=plate_dim_example,
  cube_count=cube_count_example,
  connector_thickness=connector_th_example,
  panel_thickness=panel_th_example,
  wall_thickness=wall_example,
  fit_allowance=fit_example
);
