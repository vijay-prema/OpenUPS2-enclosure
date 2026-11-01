import numpy as np, trimesh

base = trimesh.load("base.stl", force="mesh")
lid  = trimesh.load("lid.stl",  force="mesh")

BX, BY = 3.4, 3.4
FLOOR_T, PAD_H = 2.4, 2.0
PCB_BOT, PCB_TOP = 8.9, 10.1
WALL_H = 29.4
BOSS_CLR = 4.0
BOSS_Z0 = PCB_TOP + BOSS_CLR          # 12.10
PORT_Z0 = PCB_TOP - 3.60 + 2.50       # 9.00  (15 mm tall -> 9.00 .. 24.00)
PORT_Z1 = PORT_Z0 + 15.00
WALL_Y  = 74.26
GR_Z0, GR_Z1, LIP_Z0 = 25.6, 27.4, 26.0
RIB_Z0  = WALL_H - 1.10               # 28.30
PLATE_Z = WALL_H + 0.5                # 29.90
H = [[BX+29.30, BY+4.07], [BX+105.90, BY+4.07],
     [BX+29.30, BY+65.78], [BX+105.90, BY+65.78]]

tests = [
    # ---- pads under the board's own offsets ----
    ("pad carries offset",       "b", (H[0][0]+2.0, H[0][1], 3.50), "solid"),
    ("pad 2 carries offset",     "b", (H[3][0]-2.0, H[3][1], 3.50), "solid"),
    ("bore through floor+pad",   "b", (H[0][0], H[0][1], 3.50), "void"),
    ("above pad is clear",       "b", (H[0][0], H[0][1], 5.50), "void"),
    ("screw counterbore",        "b", (H[0][0]+2.9, H[0][1], 0.80), "void"),
    ("  c'bore now Ø7.5",        "b", (H[0][0]+3.5, H[0][1], 0.80), "void"),
    ("  floor beside c'bore",    "b", (H[0][0]+4.2, H[0][1], 0.80), "solid"),
    # ---- three ports on one 15 mm band, lifted 2.5 ----
    ("P1 opening",               "b", (1.20, BY+7.93,  15.00), "void"),
    ("  P1 bottom edge lifted",  "b", (1.20, BY+7.93,   8.00), "solid"),
    ("  wall above P1",          "b", (1.20, BY+7.93,  26.50), "solid"),
    ("P2 opening",               "b", (1.20, BY+64.17, 15.00), "void"),
    ("middle port, low",         "b", (1.20, BY+36.87, 12.00), "void"),
    ("middle port, HIGH (new)",  "b", (1.20, BY+36.87, 21.50), "void"),
    ("  wall above middle port", "b", (1.20, BY+36.87, 26.50), "solid"),
    ("molex latch notch P1",     "b", (1.20, 11.33, 24.50), "void"),
    ("  notch is 6mm wide",      "b", (1.20, 15.33, 24.50), "solid"),
    ("  wall above the notch",   "b", (1.20, 11.33, 25.90), "solid"),
    ("molex latch notch P2",     "b", (1.20, 67.57, 24.50), "void"),
    ("  middle port has none",   "b", (1.20, 40.13, 24.50), "solid"),
    ("long wall is now solid",   "b", (BX+49.31, 1.20, 10.70), "solid"),
    ("  and solid higher up",    "b", (BX+49.31, 1.20, 20.00), "solid"),
    ("back wall above ports",    "b", (60.00, 75.40, 15.00), "solid"),
    # ---- DIP access (unchanged) ----
    ("DIP window, bottom face",  "b", (111.50, 35.60,  0.60), "void"),
    ("  floor is full thickness", "b", (105.00, 30.00,  0.60), "solid"),
    ("  no inset beside window",  "b", (105.00, 30.00,  1.80), "solid"),
    ("DIP floor window",         "b", (111.50, 35.60,  1.80), "void"),
    ("DIP side notch",           "b", (120.80, 35.60,  4.00), "void"),
    ("  floor beside DIP",       "b", (100.00, 35.60,  1.20), "solid"),
    # ---- vents ----
    ("floor vent 1",             "b", (44.00, 41.10,  1.20), "void"),
    ("  floor between vents",    "b", (50.00, 41.10,  1.20), "solid"),
    ("lid vent 1",               "l", (44.00, 41.10, PLATE_Z), "void"),
    ("lid vent 6 (last)",        "l", (104.00, 41.10, PLATE_Z), "void"),
    ("  lid between vents",      "l", (50.00, 41.10, PLATE_Z), "solid"),
    # ---- hinge ----
    ("groove in back wall",      "b", (60.00, WALL_Y+0.60, (GR_Z0+GR_Z1)/2), "void"),
    ("  wall above groove",      "b", (60.00, WALL_Y+0.60, RIB_Z0+0.25), "solid"),
    ("  wall below groove",      "b", (60.00, WALL_Y+0.60, GR_Z0-0.50), "solid"),
    ("  groove ends before x30", "b", (25.00, WALL_Y+0.60, (GR_Z0+GR_Z1)/2), "solid"),
    ("lid lip hangs down",       "l", (60.00, 73.00, LIP_Z0+0.50), "solid"),
    ("lid toe in groove",        "l", (60.00, 75.00, LIP_Z0+0.55), "solid"),
    ("lid lip ends clear",       "l", (29.70, 73.00, LIP_Z0+0.50), "void"),
    ("  nothing in base there",  "b", (60.00, 73.00, LIP_Z0+0.50), "void"),
    # ---- lid screw boss, now 2 mm clear of the PCB ----
    ("boss 4mm above PCB",       "b", (78.00, 5.00, 13.00), "void"),
    ("  boss starts at 14.1",    "b", (78.00, 5.00, 14.60), "solid"),
    ("  boss thickened to 6.9",  "b", (78.00, 6.60, 20.00), "solid"),
    ("  boss ends at 6.9",       "b", (78.00, 7.40, 20.00), "void"),
    ("  boss is solid",          "b", (78.00, 4.00, 20.00), "solid"),
    ("6-32 pilot",               "b", (84.00, 4.15, 24.00), "void"),
    ("  boss beside pilot",      "b", (85.60, 4.15, 24.00), "solid"),
    ("lid screw clearance",      "l", (84.00, 4.15, 30.00), "void"),
    ("lid screw counterbore",    "l", (84.00, 4.15, 31.00), "void"),
    ("  lid c'bore now Ø7.5",    "l", (84.00+3.5, 4.15, 31.00), "void"),
    ("  ...and no bigger",       "l", (84.00+4.1, 4.15, 31.00), "solid"),
    ("  lid beside screw hole",  "l", (86.00, 4.15, 30.00), "solid"),
    ("  rib cleared at boss",    "l", (84.00, 3.20, RIB_Z0+0.55), "void"),
    ("  rib present elsewhere",  "l", (50.00, 3.20, RIB_Z0+0.55), "solid"),
    ("lid rib on back wall",     "l", (60.00, 73.40, RIB_Z0+0.55), "solid"),
    ("lid plate over cells",     "l", (50.00, 41.10, PLATE_Z), "solid"),
]

print("%-28s %-6s %-6s %-6s %s" % ("test", "part", "expect", "found", "verdict"))
print("-" * 74)
fail = 0
for name, part, p, expect in tests:
    m = base if part == "b" else lid
    inside = bool(m.contains(np.array([p]))[0])
    found = "solid" if inside else "void"
    ok = found == expect
    fail += (not ok)
    print("%-28s %-6s %-6s %-6s %s" % (name, part, expect, found, "ok" if ok else "*** FAIL ***"))
print("\n%d/%d checks passed" % (len(tests) - fail, len(tests)))

print("\nport band %.2f .. %.2f  (wall above: %.2f, wall below: %.2f)" % (
    PORT_Z0, PORT_Z1, WALL_H-PORT_Z1, PORT_Z0-FLOOR_T))
print("boss bottom %.2f -> PCB top %.2f = %.2f mm clearance" % (BOSS_Z0, PCB_TOP, BOSS_CLR))
print("board top %.2f -> rib %.2f = %.2f mm battery clearance" % (
    PCB_TOP+15.01, RIB_Z0, RIB_Z0-(PCB_TOP+15.01)))
print("board top %.2f -> lip bottom %.2f = %.2f" % (
    PCB_TOP+15.01, LIP_Z0, LIP_Z0-(PCB_TOP+15.01)))
print("overall %.2f x %.2f x %.2f" % (122.0, 76.66, WALL_H+2.2))
print("counterbores: 4x board Ø7.50 x 1.60 deep (floor underside), lid Ø7.50 x 1.30")
print("lid c'bore rim -> lid front edge %.2f mm" % (4.15 - 7.50/2))
