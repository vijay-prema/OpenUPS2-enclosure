// =====================================================================
//  Mini-Box OpenUPS2  —  3D printable enclosure   (rev B)
// ---------------------------------------------------------------------
//  Board data measured from Mini-Box's official STEP model and dimensioned
//  drawing (both in vendor/):
//    board        115.20 x 69.86 x 1.20 mm
//    mount holes 4 x dia 4.32 @ (29.30, 4.07) (105.90, 4.07)
//                              (29.30,65.78) (105.90,65.78)
//    tallest part +15.01 above PCB top (battery holders)
//    deepest part -4.50 below PCB top  (P5 3-way DIP switch, underside)
//
//  rev B changes, made after the owner inspected the real board:
//   * the board has its own 4.5 mm screw offsets underneath, so the base has
//     NO posts - just 4 counterbored holes in the floor.  M3 screws go up
//     from underneath into the board's own offsets.
//   * the 4 lid screws on top are gone.  The lid is held by a lip on the back
//     edge that hooks into a groove in the base (tilt it in), plus ONE
//     standard PC case screw (6-32 UNC) at the front.
//   * four 2 mm pads on the floor carry the board's own offsets, which lifts
//     the underside of the PCB clear for the DIP switch and airflow.
//
//  Connectors (the two sides cables exit from):
//    LEFT  edge : P1 4-pin mini-FIT JR in  y  2.93..12.93  z -3.60..11.40
//                 P2 4-pin mini-FIT JR out y 59.17..69.17  z -3.60..11.40
//                 P7 LED / P9 relay / P10 button (3x JST PH)
//                                          y 27.68..46.07  z -3.40.. 6.00
//    FRONT edge : P3 USB / P6 power-sw / P8 SMBUS (3x JST PH)
//                                          x 32.88..65.75  z -3.40.. 6.00
//
//  Board coordinate system used below:
//    origin = board corner nearest P1/P2, x along 115.20, y along 69.86,
//    z = 0 at the PCB TOP face.
//
//  PRINT: 0.4 mm nozzle, 0.2 mm layers, 3 perimeters, 4 top/bottom.
//         Base floor-down, lid outside-up.  No supports required.
// =====================================================================

/* [What to render] */
part = "base";          // "base", "lid", "both", "none"

/* [Board placement] */
BX        = 3.4;        // board origin x inside the enclosure
BY        = 3.4;        // board origin y inside the enclosure
BOARD_OFF = 4.50;       // built-in screw offsets under the board
PCB_T     = 1.20;

/* [Shell] */
FLOOR_T = 2.40;
WALL_T  = 2.40;
CLEAR   = 1.00;         // air gap board edge -> inside wall
WALL_H  = 29.40;        // top of the base walls (+1 for battery clearance)
LID_T   = 2.20;         // lid plate thickness
CORNER  = 4.00;         // outside corner radius

/* [Board fixing: M3 up from underneath into the board's own offsets] */
PAD_D    = 8.00;        // short pads on the floor that the board's offsets sit on
PAD_H    = 2.00;
SCR_D    = 3.40;        // clearance through floor + pad
SCR_CB_D = 6.40;        // counterbore, underside, for the screw head
SCR_CB_H = 1.60;

/* [Lid hinge: lip on the back edge hooks into this groove] */
HINGE_X0 = 30.0;
HINGE_X1 = 92.0;
GR_Z0    = 25.60;       // groove floor
GR_Z1    = 27.40;       // groove ceiling
GR_DEPTH = 1.30;        // how far it cuts into the back wall
LIP_Y0   = 72.30;       // inner face of the lid lip
LIP_Y1   = 74.00;       // outer face of the lip (0.26 off the wall face)
LIP_Z0   = 26.00;       // bottom of the lip
TOE_CLR  = 0.20;        // toe clearance behind the groove
LIP_END  = 0.30;        // clearance at each end of the lip

/* [Cable ports: 2.5 mm lift, all three openings on the same 15 mm band] */
PORT_LIFT = 2.50;
PORT_H    = 15.00;
MOLEX_NOTCH_W = 6.00;   // locking-latch relief at the top centre of each molex port
MOLEX_NOTCH_H = 1.50;

/* [Lid screw: one 6-32 UNC PC case screw at the front] */
BOSS_X0 = 76.0;  BOSS_X1 = 92.0;   // boss on the inside of the front wall
BOSS_CLR = 4.00;                   // gap between PCB top and the boss bottom
BOSS_Y1 = 6.90;                    // how far it stands into the case (+1 for hole edge)
SCREW_X = 84.0;
SCREW_Y = 4.15;
PILOT_D = 2.75;                    // 6-32 tapping size for plastic
PILOT_H = 8.00;
LID_HOLE_D = 3.60;
LID_CB_D   = 7.00;
LID_CB_H   = 1.30;

/* [Vents: slots over the batteries, in the lid and in the floor] */
VENT_W   = 3.50;
VENT_LID = 55.0;
VENT_BOT = 50.0;
VENT_Y   = 41.10;
VENT_XS_LID   = [44, 56, 68, 80, 92, 104];
VENT_XS_FLOOR = [44, 56, 68, 80, 92];   // 104 dropped: too close to the DIP window

/* [P5 DIP switch access - underside, 3.8 mm in from the right edge] */
DIP_X0 = 106.50;  DIP_X1 = 116.50;
DIP_Y0 = 30.60;   DIP_Y1 = 40.60;

/* --------------------------------------------------------------------- */
BW = 115.20;  BH = 69.86;

IN_W = BW + 2*CLEAR;                 // 117.20
IN_H = BH + 2*CLEAR;                 //  71.86
OW   = IN_W + 2*WALL_T;              // 122.00
OH   = IN_H + 2*WALL_T;              //  76.66
TOTAL_H = WALL_H + LID_T;

PCB_BOT = FLOOR_T + PAD_H + BOARD_OFF;   // 8.90 = PCB underside
PCB_TOP = PCB_BOT + PCB_T;               // 10.10
PORT_Z0 = PCB_TOP - 3.60;                // 9.00 with the 2.5 lift applied below
PORT_TOP = PORT_Z0 + PORT_LIFT + PORT_H; // 24.00 = top edge of all three openings
WALL_Y  = IN_H + WALL_T;             // 74.26 = inside face of the back wall
TOE_Y   = WALL_Y + GR_DEPTH - TOE_CLR;   // 75.36 = outer face of the toe

HOLES = [[29.30, 4.07], [105.90, 4.07], [29.30, 65.78], [105.90, 65.78]];

$fn = 64;
eps = 0.01;

// ---------- helpers -------------------------------------------------
module outer_profile(h) {
    linear_extrude(height = h)
        translate([CORNER, CORNER])
            offset(r = CORNER)
                square([OW - 2*CORNER, OH - 2*CORNER]);
}

// ---------- base ----------------------------------------------------
module base() {
    difference() {
        union() {
            // floor + walls
            difference() {
                outer_profile(WALL_H);
                translate([WALL_T, WALL_T, FLOOR_T - eps])
                    cube([IN_W, IN_H, WALL_H]);
            }
            // screw boss for the lid, on the inside of the front wall
            translate([BOSS_X0, WALL_T, PCB_TOP + BOSS_CLR])
                cube([BOSS_X1 - BOSS_X0, BOSS_Y1 - WALL_T,
                      WALL_H - PCB_TOP - BOSS_CLR]);
            // short pads the board's own offsets sit on
            for (h = HOLES)
                translate([BX + h[0], BY + h[1], FLOOR_T])
                    cylinder(d = PAD_D, h = PAD_H + eps);
        }

        // ---- 4 board screws: through the floor, counterbored underneath
        for (h = HOLES) {
            translate([BX + h[0], BY + h[1], -eps])
                cylinder(d = SCR_D, h = FLOOR_T + PAD_H + 2*eps);
            translate([BX + h[0], BY + h[1], -eps])
                cylinder(d = SCR_CB_D, h = SCR_CB_H);
        }

        // ---- 6-32 pilot for the lid screw
        translate([SCREW_X, SCREW_Y, WALL_H - PILOT_H])
            cylinder(d = PILOT_D, h = PILOT_H + eps);

        // ---- hinge groove in the inside face of the back wall
        translate([HINGE_X0, WALL_Y - eps, GR_Z0])
            cube([HINGE_X1 - HINGE_X0, GR_DEPTH + eps, GR_Z1 - GR_Z0]);

        // ---- cable openings ---------------------------------------------
        // LEFT wall: P1 input (y 2.93..12.93) - 4-pin mini-FIT JR
        translate([-eps, BY + 2.93 - 1.0, PORT_Z0 + PORT_LIFT])
            cube([WALL_T + 2*eps, 12.00, PORT_H]);
        // LEFT wall: P2 output (y 59.17..69.17) - 4-pin mini-FIT JR
        translate([-eps, BY + 59.17 - 1.0, PORT_Z0 + PORT_LIFT])
            cube([WALL_T + 2*eps, 12.00, PORT_H]);
        // LEFT wall: middle port (P7 LED / P9 relay / P10 button), opened up to
        // the same 15 mm band as the two molex ports so cables can be pushed
        // out through here instead of through the long wall
        translate([-eps, BY + 27.68 - 0.3, PORT_Z0 + PORT_LIFT])
            cube([WALL_T + 2*eps, 18.69, PORT_H]);

        // locking-latch notch, 1 mm up from the top centre of each molex port
        for (yc = [BY + 2.93 - 1.0 + 6.00, BY + 59.17 - 1.0 + 6.00])
            translate([-eps, yc - MOLEX_NOTCH_W/2, PORT_TOP - eps])
                cube([WALL_T + 2*eps, MOLEX_NOTCH_W, MOLEX_NOTCH_H + eps]);

        // ---- P5 DIP switch: window in the floor ...
        translate([DIP_X0, DIP_Y0, -eps])
            cube([DIP_X1 - DIP_X0, DIP_Y1 - DIP_Y0, FLOOR_T + 2*eps]);
        // ---- ... carried out through the right-hand wall
        translate([DIP_X1 - 2.0, DIP_Y0, -eps])
            cube([OW - DIP_X1 + 2.0 + eps, DIP_Y1 - DIP_Y0, PCB_BOT + eps]);

        // ---- floor vents
        for (x = VENT_XS_FLOOR)
            translate([x - VENT_W/2, VENT_Y - VENT_BOT/2, -eps])
                cube([VENT_W, VENT_BOT, FLOOR_T + 2*eps]);
    }
}

// ---------- lid hinge lip -------------------------------------------
module lid_lip() {
    // cross-section drawn in (z,y), extruded along -x, then placed
    translate([HINGE_X1 - LIP_END, 0, 0])
        rotate([0, -90, 0])
            linear_extrude(height = (HINGE_X1 - HINGE_X0) - 2*LIP_END)
                polygon(points = [
                    [LIP_Z0,        LIP_Y0],                    // bottom, inner
                    [WALL_H,        LIP_Y0],                    // up the inner face
                    [WALL_H,        LIP_Y1],                    // across the top
                    [GR_Z1 - 0.40,  LIP_Y1],                    // down the outer face
                    [GR_Z1 - 0.40,  TOE_Y],                     // toe top, outward
                    [GR_Z0 + 0.90,  TOE_Y],                     // toe outer face
                    [LIP_Z0,        TOE_Y - 0.50],              // 45 deg lead-in
                    [LIP_Z0,        LIP_Y0]                     // close along the bottom
                ]);
}

// ---------- lid -----------------------------------------------------
module lid() {
    difference() {
        union() {
            translate([0, 0, WALL_H]) outer_profile(LID_T);
            // registration rib
            translate([WALL_T + 0.25, WALL_T + 0.25, WALL_H - 1.10])
                difference() {
                    cube([IN_W - 0.50, IN_H - 0.50, 1.10 + eps]);
                    translate([1.20, 1.20, -eps])
                        cube([IN_W - 2.90, IN_H - 2.90, 1.10 + 3*eps]);
                }
            // hinge lip on the back edge
            lid_lip();
        }

        // clear the rib where the screw boss comes up to meet the lid
        translate([BOSS_X0 - 1, WALL_T - eps, WALL_H - 1.20])
            cube([BOSS_X1 - BOSS_X0 + 2, BOSS_Y1 - WALL_T + 1.0, 1.20 + 2*eps]);

        // 6-32 clearance hole + counterbore
        translate([SCREW_X, SCREW_Y, WALL_H - eps])
            cylinder(d = LID_HOLE_D, h = LID_T + 0.5);
        translate([SCREW_X, SCREW_Y, WALL_H + LID_T - LID_CB_H])
            cylinder(d = LID_CB_D, h = LID_CB_H + eps);

        // lid vents over the batteries
        for (x = VENT_XS_LID)
            translate([x - VENT_W/2, VENT_Y - VENT_LID/2, WALL_H - eps])
                cube([VENT_W, VENT_LID, LID_T + 2*eps]);
    }
}

// ---------- output --------------------------------------------------
if (part == "base")      base();
else if (part == "lid")  lid();
else if (part == "both") { base(); lid(); }
// part = "none" -> renders nothing (used by assembly.scad)
