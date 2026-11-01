"""Boolean check: do the four 2 mm pads clash with any real board component?

The pads sit on the floor (enclosure z 2.40 .. 4.40).  Mini-Box's own STEP models
the board's under-offsets as 6.03 mm tall, while the owner measured 4.5 mm, so
those four modelled offsets are excluded here - they are exactly what the pads
are meant to sit under.
"""
import cadquery as cq
from cadquery import importers

p = "vendor/OpenUPS2.step"
S = importers.importStep(p).val().Solids()

PCB_TOP = 10.10                      # enclosure coords
z_lo, z_hi = 2.40 - PCB_TOP, 4.40 - PCB_TOP     # -> STEP z -7.70 .. -5.70

parts = []
for s in S:
    b = s.BoundingBox()
    if abs(b.xlen-5.56) < 0.02 and abs(b.ylen-5.56) < 0.02 and b.zmin < -7.0:
        continue                     # vendor's own under-offsets
    parts.append(s)
print("board solids under test:", len(parts))

holes = [(29.30, 4.07), (105.90, 4.07), (29.30, 65.78), (105.90, 65.78)]
worst = 0.0
for (hx, hy) in holes:
    cyl = (cq.Workplane("XY").workplane(offset=z_lo + 0.05)
           .center(hx, hy).circle(4.00).extrude((z_hi - z_lo) - 0.05).val())
    hits = []
    for s in parts:
        b = s.BoundingBox()
        if b.zmax <= z_lo or b.zmin >= z_hi - 0.05:
            continue
        if b.xmax < hx-4.0 or b.xmin > hx+4.0 or b.ymax < hy-4.0 or b.ymin > hy+4.0:
            continue
        v = cyl.intersect(s).Volume()
        if v > 0.005:
            hits.append((round(v, 3), round(b.xmin, 2), round(b.xmax, 2),
                         round(b.ymin, 2), round(b.ymax, 2), round(b.zmin, 2)))
    worst = max([worst] + [h[0] for h in hits])
    print("pad (%.2f,%.2f) dia8 : %d clash(es) %s" % (hx, hy, len(hits), hits if hits else "CLEAR"))

print("\nworst intersection volume: %.3f mm3 -> %s" % (
    worst, "CLEAR" if worst < 0.005 else "CLASH"))
