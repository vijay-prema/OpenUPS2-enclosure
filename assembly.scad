// Exploded assembly preview: base + real OpenUPS2 board model + lid
part = "none";
include <enclosure.scad>

EXPLODE = 42;

color("DarkGoldenrod")
    base();

// the real board, exported from the official STEP at the same offset
translate([0, 0, EXPLODE])
    color("ForestGreen")
        import("board_in_case.stl", convexity = 10);

// lid, lifted clear
translate([0, 0, EXPLODE * 2])
    color("Gold")
        lid();
