// =======================================
// color_utils.scad — palette + color logic
// =======================================

PALETTE_BLOCK = [
  [0.90, 0.10, 0.10],
  [0.10, 0.55, 0.95],
  [0.10, 0.75, 0.35],
  [0.95, 0.70, 0.10],
  [0.60, 0.35, 0.95],
  [0.90, 0.30, 0.55],
  [0.15, 0.80, 0.80],
  [0.65, 0.65, 0.65],
];

PALETTE_PANEL = [
  [0.05, 0.85, 0.25],
  [0.95, 0.50, 0.15],
  [0.20, 0.70, 0.95],
  [0.95, 0.85, 0.20],
  [0.65, 0.40, 0.90],
  [0.90, 0.25, 0.70],
  [0.30, 0.90, 0.90],
  [0.45, 0.45, 0.45],
];

function hash3i(p) = p.x * 73856093 + p.y * 19349663 + p.z * 83492791;

function palette_pick(palette, key) =
  let (i = abs(hash3i(key)) % len(palette)) palette[i];

function rgba_from_rgb_alpha(rgb, a) = [rgb[0], rgb[1], rgb[2], a];

function select_rgba(use_palette, palette, fallback_rgb, key, alpha) =
  use_palette ? rgba_from_rgb_alpha(palette_pick(palette, key), alpha)
  : rgba_from_rgb_alpha(fallback_rgb, alpha);
