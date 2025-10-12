// =======================================
// geometry_utils.scad — adjacency + faces
// =======================================

CUBE_FACE_NORMS = [
  [1, 0, 0],
  [-1, 0, 0],
  [0, 1, 0],
  [0, -1, 0],
  [0, 0, 1],
  [0, 0, -1],
];

function has_cube_at(pos, arr) =
  len([for (a = arr) if (a == pos) 1]) > 0;

function exposed_faces(pos, all) =
  [for (n = CUBE_FACE_NORMS) if (!has_cube_at(pos + n, all)) n];

module triangle(p1, p2, p3) {
  polygon(points=[p1, p2, p3]);
}
