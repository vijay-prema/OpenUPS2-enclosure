import cadquery as cq
from cadquery import importers

p = "vendor/OpenUPS2.step"
S = importers.importStep(p).val().Solids()

keep = []
skipped = 0
for s in S:
    b = s.BoundingBox()
    # drop the vendor's 4 standoff bosses (5.56 dia, 7.5 tall, mostly below board)
    if abs(b.xlen-5.56) < 0.02 and abs(b.ylen-5.56) < 0.02 and b.zmin < -7.0:
        skipped += 1
        continue
    if s.Volume() < 2.0:      # copper pads / tiny SMD, irrelevant for fit checks
        skipped += 1
        continue
    keep.append(s)
print("kept %d solids, skipped %d" % (len(keep), skipped))

board = cq.Compound.makeCompound(keep)
board = board.translate((3.4, 3.4, 10.1))     # board origin -> enclosure coords
cq.exporters.export(cq.Workplane("XY").newObject([board]), "board_in_case.stl")
bb = board.BoundingBox()
print("board-in-case bbox x %.2f..%.2f y %.2f..%.2f z %.2f..%.2f" % (
    bb.xmin, bb.xmax, bb.ymin, bb.ymax, bb.zmin, bb.zmax))
