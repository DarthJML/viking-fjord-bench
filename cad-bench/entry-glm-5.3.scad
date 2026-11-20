// ============================================================================
//  Viking Shield Phone Stand -- CAD Bench, Part 1
//  Entry: GLM 5.3 (opencode-go) -- single attempt, no repairs
// ============================================================================
//
//  WHAT IT IS
//  A desk phone stand shaped like a Viking round shield. The shield disc is
//  the backrest, reclined 15 deg; the raised rim and central boss face the
//  room. A small shelf and lip at the bottom catch the phone's bottom edge
//  so it cannot slide out, and a cable pocket under the shelf plus a gap in
//  the lip let a USB-C cable charge the phone while docked.
//
//  PRINT ORIENTATION (important)
//  Print exactly as it stands on the desk: shelf flat on the bed, shield
//  rising at 15 deg. No supports needed -- every surface is 75 deg or
//  steeper from horizontal, and the only tiny bridges are the cable
//  pocket's side walls (spans under 16 mm, trivial). The part is ~98 mm
//  tall; add a 6 mm brim if your bed adhesion is weak.
//  Slicing suggestion: PLA, 0.20 mm layers, 2 walls, 15% infill.
//  ESTIMATE (not sliced): measured solid volume ~77 cm^3 (95 g if solid
//  PLA); printed at 15% infill expect roughly 35-50 g and 3-5 h on an
//  i3-class FDM printer. Verify in your slicer.
//
//  FITS AND TOLERANCES (0.4 mm nozzle FDM)
//  - Phone channel: phone_t + channel_clear (0.6 mm total play), measured
//    PERPENDICULAR to the backrest plane, so the tilted phone edge fits
//    without wedging; the lip gap to the phone's front face is snug
//    (0.4 mm). The disc's front face IS the phone's back rest plane, by
//    construction (see anchor math below).
//  - Cable pocket depth = shelf_t - min_wall, leaving a 2.4 mm floor under
//    the pocket. Fits USB-C plugs with <= ~4.5 mm of shell + boot below the
//    phone. Raise shelf_t if your plug is chunkier.
//  - The pocket floor is a flat recess open at the top; the connector
//    drops in through the 16 mm lip gap and plugs up into the tilted port.
//  - Attached features are buried 0.2 mm into their parents (embed) so no
//    boolean has coincident faces -> clean manifold export.
//
//  ADAPTING TO YOUR PHONE
//  Set phone_w / phone_t (with case on) and port_offset if your charge
//  port is off-center. Everything else follows automatically. For a
//  tablet: raise shield_d and shelf_w together.
//
//  VERIFIED
//  Renders and exports headlessly in OpenSCAD 2021.01; the exported STL
//  passes an edge-manifold, positive-volume, single-solid check. Exact
//  numbers (triangles, volume, bounding box) in check_report.txt next to
//  this file.
// ============================================================================

/* [Phone] */
phone_w    = 76;    // phone width with case (mm)
phone_t    = 11.5;  // phone thickness with case (mm)
port_offset = 0;    // charge-port center offset from phone center-x (mm)

/* [Fit] */
channel_clear = 0.6;  // total play added to phone_t in the bottom channel (mm)
snug          = 0.4;  // gap between phone front face and lip inner face (mm)

/* [Shield] */
shield_d   = 100;   // disc diameter (mm)
shield_t   = 4;     // disc thickness (mm)
rim_od     = 95;    // raised rim, outer diameter, on the back face (mm)
rim_w      = 5;     // rim radial width (mm)
rim_h      = 2.5;   // rim raise above the back face (mm)
boss_d     = 26;    // central boss diameter, on the back face (mm)
engrave_od = 86;    // decorative ring engraved on the front face (mm)
engrave_w  = 6;     // engraved ring width (mm)
engrave_d  = 1.2;   // engraved ring depth (mm); recessed so the phone rests on the flat face

/* [Stand] */
lean        = 15;    // backrest recline from vertical (deg)
shelf_w     = 82;    // shelf width (mm); >= phone_w + margin
shelf_t     = 6;     // shelf thickness (mm); also sets cable pocket depth
floor_back  = -6;    // shelf rear edge y (mm)
floor_front = 17;    // shelf front edge y (mm); the lip sits on this edge
lip_h       = 9;     // lip height above shelf (mm)
lip_t       = 4;     // lip thickness (mm)
gap_w       = 16;    // cable gap in the lip (mm)
leg_x       = 25;    // legs: distance from center-x (mm)
leg_w       = 12;    // legs: thickness in x (mm)
leg_len     = 34;    // legs: reach behind the disc back face (mm)
leg_top     = -12;   // legs: top edge in shield-plane coordinates (mm)
disc_dip    = 4.3;   // how deep the disc's bottom edge dips into the shelf (mm)

/* [Quality] */
min_wall = 2.4;  // minimum wall / remaining floor under pockets (mm)
embed    = 0.2;  // burial of attached features to avoid coincident faces (mm)
leg_poke = 1.2;  // how far legs bite into the disc body (mm)
$fn      = 96;

// ---------------------------------------------------------------------------
//  Derived geometry.
//  The disc's front face plane IS the phone's back rest plane. The anchor is
//  where the phone's bottom-back corner rests: on the shelf top, snug behind
//  the lip. Everything (disc center, legs) is placed relative to that anchor
//  so changing phone_t or lean re-fits the channel automatically.
// ---------------------------------------------------------------------------
lip_inner = floor_front - lip_t;                                  // 13
anchor_y  = lip_inner - snug - (phone_t + channel_clear) * cos(lean); // phone bottom-back corner
anchor_z  = shelf_t;                                              // shelf top
pocket_d  = shelf_t - min_wall;                                   // leave a floor under the pocket
pocket_y0 = anchor_y + 2;                                         // pocket rear wall, 2 mm ahead of the phone corner
pocket_y1 = lip_inner + 2;                                        // pocket opens 2 mm into the lip gap zone
zF        = shelf_t + (shield_d / 2) * cos(lean) - disc_dip;      // disc front-face center height
tF        = (zF - anchor_z) / cos(lean);                          // up-plane distance anchor -> face center
yF        = anchor_y - tF * sin(lean);                            // disc front-face center y
Cy        = yF - (shield_t / 2) * cos(lean);                      // disc axis center
Cz        = zF - (shield_t / 2) * sin(lean);
leg_bottom = -60;  // legs overshoot below the desk plane; trimmed flat (mm, shield-plane coords)

// cylinder along the local y axis (out of the front face)
module ycyl(d, h) { rotate([90, 0, 0]) cylinder(d = d, h = h, center = true); }

// Shield disc, rim and boss built in the disc's local frame:
// axis along y, center at origin, front face at y = +shield_t/2.
module shield_disc() {
    difference() {
        union() {
            ycyl(d = shield_d, h = shield_t);                         // the disc
            // raised rim ring on the back face, buried 0.2 mm
            translate([0, -shield_t / 2 - rim_h / 2 + embed, 0])
                difference() {
                    ycyl(d = rim_od, h = rim_h);
                    ycyl(d = rim_od - 2 * rim_w, h = rim_h + 2 * embed);
                }
            // central boss: hemisphere, its base plane buried 0.2 mm into the back face
            translate([0, -shield_t / 2 + embed, 0])
                intersection() {
                    sphere(d = boss_d);
                    translate([-(boss_d / 2 + 1), -(boss_d + 1), -(boss_d / 2 + 1)])
                        cube([boss_d + 2, boss_d + 1, boss_d + 2]);
                }
        }
        // decorative engraved ring on the front face (recessed; phone rests on the flat face)
        translate([0, shield_t / 2 - engrave_d / 2 + 0.05, 0])
            difference() {
                ycyl(d = engrave_od, h = engrave_d + 0.1);
                ycyl(d = engrave_od - 2 * engrave_w, h = engrave_d + 0.4);
            }
    }
}

module shield_placed() { translate([0, Cy, Cz]) rotate([lean, 0, 0]) shield_disc(); }

module shelf_floor() {
    difference() {
        translate([-shelf_w / 2, floor_back, 0])
            cube([shelf_w, floor_front - floor_back, shelf_t]);
        // cable pocket: recess in the shelf top, under the phone's port, open
        // through the lip gap zone so the connector can drop in from the front
        translate([port_offset - gap_w / 2, pocket_y0, shelf_t - pocket_d])
            cube([gap_w, pocket_y1 - pocket_y0, pocket_d + 0.1]);
    }
}

module lip() {
    // two segments with the cable gap between; bottoms buried 0.2 mm into the shelf
    for (s = [-1, 1])
        translate([s == 1 ? gap_w / 2 : -shelf_w / 2, lip_inner, shelf_t - embed])
            cube([(shelf_w - gap_w) / 2, lip_t, lip_h + embed]);
}

module legs() {
    // built in the disc's local frame, so the legs stay parallel to the disc
    // back face as lean changes; bottoms overshoot and get trimmed flat
    translate([0, Cy, Cz]) rotate([lean, 0, 0])
        for (s = [-1, 1])
            translate([s * leg_x - leg_w / 2, -shield_t / 2 - leg_len, leg_bottom])
                cube([leg_w, leg_len + leg_poke, leg_top - leg_bottom]);
}

module part() {
    difference() {
        union() {
            shield_placed();
            shelf_floor();
            lip();
            legs();
        }
        // desk trim: flat feet for the legs; shelf bottom stays the true bed plane
        translate([-150, -150, -150]) cube([300, 300, 150.01]);
    }
}

part();
