#!/usr/bin/env python3
"""CAD bench STL sanity checker. Pure stdlib, CPU-light.

Checks:
  - parses binary or ASCII STL
  - edge-manifold: every undirected edge shared by exactly 2 triangles
  - consistent winding: each shared edge used once in each direction
  - single connected component (via vertex adjacency)
  - positive signed volume (and reports it)
  - zero-area / degenerate triangle count
  - bounding box, triangle count
  - optional material mass at PLA 1.24 g/cm^3 (density assumption stated)

Usage: check_stl.py <file.stl>
Exit code 0 = all structural checks PASS.
"""
import sys, struct, math
from collections import defaultdict

PLA_DENSITY_G_CM3 = 1.24  # assumption, stated in output


def load_stl(path):
    with open(path, "rb") as f:
        data = f.read()
    # ASCII heuristic: starts with 'solid' and has 'facet' near the top
    if data[:5] == b"solid" and b"facet" in data[:1024]:
        tris = []
        verts = []
        for line in data.decode("ascii", "replace").splitlines():
            parts = line.split()
            if not parts:
                continue
            if parts[0] == "vertex":
                verts.append(tuple(float(x) for x in parts[1:4]))
                if len(verts) == 3:
                    tris.append(tuple(verts))
                    verts = []
        return tris
    if len(data) < 84:
        raise ValueError("file too small to be a binary STL")
    n = struct.unpack("<I", data[80:84])[0]
    expected = 84 + 50 * n
    if len(data) < expected:
        raise ValueError(f"binary STL truncated: header says {n} tris, "
                         f"need {expected} bytes, have {len(data)}")
    tris = []
    off = 84
    for _ in range(n):
        rec = struct.unpack("<12fH", data[off:off + 50])
        tris.append(((rec[0], rec[1], rec[2]),
                     (rec[3], rec[4], rec[5]),
                     (rec[6], rec[7], rec[8])))
        off += 50
    return tris


def main(path):
    tris = load_stl(path)
    print(f"file: {path}")
    print(f"triangles: {len(tris)}")

    # zero-area faces
    zero = 0
    for (a, b, c) in tris:
        ux, uy, uz = b[0]-a[0], b[1]-a[1], b[2]-a[2]
        vx, vy, vz = c[0]-a[0], c[1]-a[1], c[2]-a[2]
        cx, cy, cz = uy*vz-uz*vy, uz*vx-ux*vz, ux*vy-uy*vx
        if math.sqrt(cx*cx+cy*cy+cz*cz) < 1e-9:
            zero += 1
    print(f"zero-area triangles: {zero}")

    # edge map: undirected edge -> directions seen
    edges = defaultdict(list)
    for i, (a, b, c) in enumerate(tris):
        for (p, q) in ((a, b), (b, c), (c, a)):
            edges[(p, q) if p <= q else (q, p)].append(1 if p <= q else -1)

    bad_count = sum(1 for d in edges.values() if len(d) != 2)
    bad_wind = sum(1 for d in edges.values() if len(d) == 2 and d[0] == d[1])
    print(f"edges total: {len(edges)}")
    print(f"edges not shared by exactly 2 triangles: {bad_count}")
    print(f"edges with inconsistent winding: {bad_wind}")

    # signed volume
    vol = 0.0
    for (a, b, c) in tris:
        vol += (a[0]*(b[1]*c[2]-b[2]*c[1])
                - a[1]*(b[0]*c[2]-b[2]*c[0])
                + a[2]*(b[0]*c[1]-b[1]*c[0])) / 6.0
    print(f"signed volume: {vol:.1f} mm^3 ({vol/1000.0:.1f} cm^3)")
    if vol > 0:
        print(f"mass if solid PLA @ {PLA_DENSITY_G_CM3} g/cm^3: "
              f"{vol/1000.0*PLA_DENSITY_G_CM3:.0f} g (design volume; real print has infill)")

    # connected components via vertex adjacency
    vert_tris = defaultdict(list)
    for i, t in enumerate(tris):
        for v in t:
            vert_tris[v].append(i)
    seen = [False] * len(tris)
    comps = 0
    for i in range(len(tris)):
        if seen[i]:
            continue
        comps += 1
        stack = [i]
        seen[i] = True
        while stack:
            t = stack.pop()
            for v in tris[t]:
                for j in vert_tris[v]:
                    if not seen[j]:
                        seen[j] = True
                        stack.append(j)
    print(f"connected components: {comps}")

    # bounding box
    xs, ys, zs = [], [], []
    for t in tris:
        for v in t:
            xs.append(v[0]); ys.append(v[1]); zs.append(v[2])
    print(f"bounding box: x [{min(xs):.2f}, {max(xs):.2f}]  "
          f"y [{min(ys):.2f}, {max(ys):.2f}]  z [{min(zs):.2f}, {max(zs):.2f}]")
    dx, dy, dz = max(xs)-min(xs), max(ys)-min(ys), max(zs)-min(zs)
    print(f"size: {dx:.1f} x {dy:.1f} x {dz:.1f} mm "
          f"(fits 220x220 bed: {'yes' if dx <= 220 and dy <= 220 and dz <= 250 else 'NO'})")

    ok = (bad_count == 0 and bad_wind == 0 and comps == 1 and vol > 0 and zero == 0)
    print(f"RESULT: {'PASS - edge-manifold, consistently wound, single solid, positive volume' if ok else 'FAIL'}")
    return 0 if ok else 1


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print(__doc__)
        sys.exit(2)
    sys.exit(main(sys.argv[1]))
