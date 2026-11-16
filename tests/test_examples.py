"""Render the examples and check the parts they make.

usage: python3 tests/test_examples.py [OPENSCAD]

- Every example renders with --hardwarnings.
- The two-cube box is 12 connectors and a tray: 13 separate closed solids, each
  with its lowest point on z = 0.
- The edge connector's volume is two 20 mm right-triangle plates, 2 mm thick,
  less a round 1.7 mm hole in each: 790.94 mm3 with the hole's 64 facets. A
  hole drawn with OpenSCAD's default 5 sides, as files that `use`
  connectors.scad used to get, leaves about 2.2 mm3 more.
- The tray's outside is the two cubes plus the connector, panel, fit and wall
  on each side: 171.6 x 91.6 x 4.8 mm.
"""

import os
import struct
import subprocess
import sys
import tempfile

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
EXAMPLES = sorted(f for f in os.listdir(os.path.join(ROOT, "examples")) if f.endswith(".scad"))


def solids(path):
    """Each separate solid in a binary STL as (signed volume, [xmin, ymin, zmin], [xmax, ymax, zmax])."""
    data = open(path, "rb").read()
    (n,) = struct.unpack_from("<I", data, 80)
    tris = [struct.unpack_from("<9f", data, 84 + i * 50 + 12) for i in range(n)]
    parent = {}

    def find(v):
        while parent[v] != v:
            parent[v] = parent[parent[v]]
            v = parent[v]
        return v

    for t in tris:
        pts = (t[0:3], t[3:6], t[6:9])
        for p in pts:
            parent.setdefault(p, p)
        root = find(pts[0])
        for p in pts[1:]:
            parent[find(p)] = root
    parts = {}
    for t in tris:
        a, b, c = t[0:3], t[3:6], t[6:9]
        vol = (a[0] * (b[1] * c[2] - b[2] * c[1]) - a[1] * (b[0] * c[2] - b[2] * c[0])
               + a[2] * (b[0] * c[1] - b[1] * c[0])) / 6
        part = parts.setdefault(find(a), [0.0, [1e9] * 3, [-1e9] * 3])
        part[0] += vol
        for p in (a, b, c):
            for i in range(3):
                part[1][i] = min(part[1][i], p[i])
                part[2][i] = max(part[2][i], p[i])
    return list(parts.values())


results = []


def check(label, ok, got):
    results.append(bool(ok))
    print(f"{'ok  ' if ok else 'FAIL'} {label}: {got}")


def render(openscad, out, example, *defines):
    r = subprocess.run([openscad, "--hardwarnings", "--export-format", "binstl", "-o", out, *defines,
                        os.path.join(ROOT, "examples", example)], capture_output=True, text=True)
    bad = [l for l in r.stderr.splitlines() if "WARNING" in l or "ERROR" in l]
    return r.returncode == 0 and not bad, (bad[:1] or [f"exit {r.returncode}"])[0]


def main():
    openscad = sys.argv[1] if len(sys.argv) > 1 else "openscad"
    with tempfile.TemporaryDirectory() as tmp:
        out = os.path.join(tmp, "out.stl")

        for example in EXAMPLES:
            ok, why = render(openscad, out, example)
            check(f"{example} renders", ok, "no warnings" if ok else why)

        ok, why = render(openscad, out, "example_two_cube_box.scad")
        if ok:
            parts = solids(out)
            closed = all(p[0] > 0 for p in parts)
            on_bed = all(abs(p[1][2]) < 1e-3 for p in parts)
            check("two-cube box is 13 closed solids on z = 0", len(parts) == 13 and closed and on_bed,
                  f"{len(parts)} solids, all closed: {closed}, all on z = 0: {on_bed}")

        ok, why = render(openscad, out, "example_connectors.scad", "-D", 'render_part="edge"')
        if ok:
            parts = solids(out)
            vol = sum(p[0] for p in parts)
            check("edge connector volume (round 1.7 mm holes)", len(parts) == 1 and abs(vol - 790.94) < 0.1,
                  f"{len(parts)} solid(s), {vol:.2f} mm3; want 1, 790.94")
        else:
            check("edge connector renders", False, why)

        ok, why = render(openscad, out, "example_two_cube_box.scad", "-D", 'part="tray"')
        if ok:
            parts = solids(out)
            size = [parts[0][2][i] - parts[0][1][i] for i in range(3)] if len(parts) == 1 else []
            want = [171.6, 91.6, 4.8]
            check("tray size", len(parts) == 1 and all(abs(a - b) < 0.01 for a, b in zip(size, want)),
                  f"{len(parts)} solid(s), {' x '.join(f'{s:.2f}' for s in size)} mm; want 171.60 x 91.60 x 4.80")
        else:
            check("tray renders", False, why)

    print(f"{sum(results)} of {len(results)} checks passed")
    sys.exit(0 if all(results) else 1)


main()
