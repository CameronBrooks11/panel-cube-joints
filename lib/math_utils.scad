// =======================================
// math_utils.scad — vector math utilities
// =======================================

EPS = 1e-9;

function dot(a, b) = a.x * b.x + a.y * b.y + a.z * b.z;
function normv(v) = max(EPS, norm(v));
function clamp(x, a, b) = min(b, max(a, x));

function rot_angle_from_x(n) = acos(clamp(dot([1, 0, 0], n) / normv(n), -1, 1));

function rot_axis_from_x(n) =
    let (c = cross([1, 0, 0], n)) (norm(c) < EPS && dot([1, 0, 0], n) < 0) ? [0, 0, 1] : c;
