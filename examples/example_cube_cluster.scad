include <../cube_cluster.scad>

dim = 40;
th = 1.2;

cubes = [
  [0, 0, 0],
  [1, 0, 0],
  [1, 1, 0],
  [2, 1, 0],
  [1, 1, 1],
  [1, 2, 1],
  [0, 2, 1],
  [0, 2, 2],
];

cube_cluster(dim, th, cubes);
