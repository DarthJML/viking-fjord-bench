// =====================================================================
//  VIKING ROUND-SHIELD PHONE STAND            (single file, pure OpenSCAD)
// =====================================================================
//  What it is
//    A desk stand for a phone in its case.  The phone leans back 15 deg
//    on a flat backrest, its bottom edge sits on a seat that is square to
//    the backrest, and a front lip catches it.  Behind the cradle stands a
//    vertical Viking round shield (planked disc, raised bevelled rim,
//    domed boss on a riveted flange) facing the room, tied to the cradle by
//    two ribs and a common base plate.  From across the desk you see the
//    shield; the shield is tall enough that a ~160 mm phone does not poke
//    over its rim.
//
//  Coordinates / units
//    mm.  x = across the phone (left/right), y = away from the user
//    (+y = toward the back / across the desk), z = up.  Desk = z 0.
//
//  PRINT ORIENTATION
//    Exactly as it is used: base plate flat on the bed, shield standing
//    vertical, cradle in front.  Why no supports are needed:
//      * every downward-facing surface is at most 45 deg from vertical:
//        - backrest back face and lip inner face lean 15 deg (recline);
//        - shield faces are vertical; the shield edge is a double 45 deg
//          bevel (front bevel + back rim slope), so even the bottom of
//          the disc is a 45 deg overhang, never a flat one;
//        - plank grooves end in 45 deg ramps, not square steps;
//        - the boss is a 45 deg cone blended into a spherical cap (the
//          "bullet" is tangent at 45 deg), its flange and rivets are
//          45 deg bevels;
//        - the cable tunnel and the cable "mouse hole" have 45 deg gable
//          (pointed) roofs, so there is no unsupported bridge;
//      * ribs, notch walls and side faces are vertical; seat, lip top,
//        rib tops and base top all face upward.
//    Measured on the exported STL: the steepest downward facet is 45.0 deg
//    from vertical, apart from one 0.017 mm^2 tessellation sliver at 47.6
//    deg where a plank groove meets the rim ramp (too small to matter).
//    Run the "check" modes at the bottom of this header to re-verify.
//
//  STABILITY
//    Stand ~178 g, centre of mass at y ~30 mm; a 220 g phone puts the
//    combined centre of mass at y ~22 mm, 51 mm behind the front edge and
//    53 mm ahead of the rear edge of the 130 mm wide base.  A horizontal
//    push of ~1.1 N at the phone's top edge (~1.9 N mid-screen) is needed
//    to tip it backward; light taps are under that, a hard jab at the very
//    top edge can rock it.
//
//  SLICING SUGGESTION  (PLA or PETG, 0.4 mm nozzle)
//    0.20 mm layers (0.16 mm if you want smoother boss/rim bevels),
//    3 perimeters (1.2 mm), 5 top / 4 bottom layers, 15 % gyroid infill,
//    supports OFF, no brim needed (big flat base).  Optional: slow outer
//    perimeters to ~40 mm/s for the 45 deg bevels.
//
//  ESTIMATE (not measured on a real print):
//    Solid model volume 302 cm^3 (from the exported STL).  A trial slice
//    (0.20 mm, 2 walls, 20 % cubic infill, no supports) used ~59.8 m of
//    1.75 mm filament = 144 cm^3
//    -> ESTIMATE ~175-180 g PLA (about 60 m of filament).
//    -> ESTIMATE print time ~7-9 h on a fast CoreXY / Bambu-class printer,
//       ~20-22 h on a stock bed-slinger at 60 mm/s walls.
//    Footprint: 194 mm (x, shield width) x 104 mm (y); height 194.5 mm.
//    Fits a 220 x 220 mm bed; needs >= 195 mm of Z.
//
//  FITS  (which surfaces touch the phone, and the tolerance left)
//    * BACKREST front face (plane w = 0): the phone's back lies flat on it
//      by gravity.  Zero designed clearance -- it is a datum face, not a
//      slot, so FDM over-extrusion cannot make it tight.  Contact area is
//      the full cradle width x rest_h (76 x 100 mm by default).
//    * SEAT (plane s = 0, square to the backrest): the phone's bottom edge
//      stands on it, again a datum face with zero clearance.  The cable
//      notch removes the middle notch_w mm; the phone stands on two
//      31 mm wide pads either side.
//    * LIP inner face: parallel to the backrest at phone_t + phone_clear_t.
//      phone_clear_t = 1.0 mm: FDM walls typically print 0.1-0.25 mm fat
//      per face with a 0.4 mm nozzle, and real cases vary +-0.3 mm, so
//      1.0 mm leaves the phone a loose drop-in without rattle-out.  The
//      phone normally does NOT touch the lip; it only catches the bottom
//      edge if the phone is bumped forward.  A 1 mm 45 deg chamfer on the
//      lip's inner top edge guides the phone in.
//    * Width: the channel is open at both ends, so any phone width fits;
//      phone_w only sizes the cradle/backrest.
//    * Seat/backrest inside corner: an FDM inside corner rounds by about
//      the nozzle radius (~0.2-0.4 mm).  Phone cases have >= 1 mm edge
//      radii, so the bottom edge still seats fully on both faces.
//    * Cable: notch_w = 14 mm (USB-C/Lightning over-molds are <= 12.5 mm
//      wide, ~7 mm thick).  Tunnel and mouse hole are 14 x 17 mm so the
//      plug end can be threaded through from behind.
//
//  CABLE PATH
//    Port (centre of the phone's bottom edge) -> straight down through the
//    open notch in the seat/lip (plug points along the phone's axis) ->
//    cable bends back on the base floor -> gable-roofed tunnel through the
//    cradle's back wall -> along the floor between the ribs -> gable
//    "mouse hole" under the shield -> out behind the shield.  (Or just let
//    it leave forward out of the open front of the notch.)  The seat
//    height is derived from plug length + bend radius, so the plug never
//    bottoms out.
//
//  CHECK MODES  (openscad -D check=N -o out.stl viking-shield-phone-stand.scad)
//    0  the part (default)
//    1  part  AND  phone (shrunk 0.02 off its two datum faces)  -> must be EMPTY
//    2  part  AND  cable/plug dummy                              -> must be EMPTY
//    3  part  AND  phone at full channel width (t + clear - 0.02)-> must be EMPTY
//    4  part  AND  0.3 mm slab just behind the phone's back      -> full slab
//       (volume = (phone_w-1) * 0.3 * (rest_h-1)): backrest touches the
//       phone over its whole width and rest height
//    5  part  AND  0.3 mm slab just under the phone's bottom     -> full slab
//       minus notch: seat carries the bottom edge
//    6  part  AND  phone pushed 0.3 mm past the clearance forward -> NON-empty
//       (the lip really catches the phone)
//    7  phone + cable dummies only (for visual inspection in the GUI)
// =====================================================================

/* [Phone (in its case)] */
phone_w        = 76;    // phone + case width, mm
phone_t        = 11.5;  // phone + case thickness, mm  (sizes the channel)
phone_h        = 160;   // phone + case height, mm (checks / echo only)
recline        = 15;    // screen recline from vertical, deg

/* [Fit] */
phone_clear_t  = 1.0;   // channel clearance on top of phone_t, mm (see FITS)

/* [Cradle] */
lip_h          = 9;     // lip height above the seat, along the phone, mm
lip_wall       = 4;     // lip thickness, mm (>= 2.4)
lip_chamfer    = 1;     // 45 deg lead-in on the lip's inner top edge, mm
back_t         = 4;     // backrest plate thickness, mm (>= 2.4)
rest_h         = 100;   // backrest length up the phone from the seat, mm
rib_t          = 4;     // thickness of the two ribs tying backrest to shield
rib_overlap    = 1.5;   // how far ribs sink into backrest / shield, mm
floor_embed    = 1;     // cradle + ribs start this high (inside the base), mm

/* [Cable] */
plug_len       = 22;    // rigid plug over-mold + strain relief below the port, mm
plug_w         = 12.5;  // plug over-mold width, mm
plug_t         = 7;     // plug over-mold thickness, mm
cable_d        = 4;     // cable diameter, mm
cable_bend_r   = 6;     // centre-line bend radius at the bottom, mm
cable_clear    = 0.5;   // gap between the bent cable and the floor, mm
notch_w        = 14;    // width of the cable notch through seat + lip, mm
tunnel_w       = 14;    // width of tunnel / mouse hole (plug passes), mm
tunnel_wall_h  = 10;    // vertical wall height of tunnel / hole before the 45 deg gable

/* [Shield] */
shield_d       = 194;   // shield diameter, mm (<= 220 for the bed; 194 hides a 160 mm phone)
shield_t       = 4;     // planked disc thickness, mm
rim_h          = 3;     // rim height above the back face, mm
rim_bevel_f    = 2;     // 45 deg bevel on the front edge, mm
rim_crest      = 1.6;   // flat crest width on the rim, mm (>= 0.8)
shield_gap     = 3;     // min. gap phone-back-plane -> shield front at shield top
shield_lift    = 0.5;   // shield lowest point sits this far up inside the base
plank_w        = 24;    // plank width, mm
groove_w       = 1.2;   // plank groove width, mm (>= 0.8)
groove_d       = 0.8;   // plank groove depth, mm (front grooves offset half a plank)
boss_r         = 24;    // boss base radius, mm
boss_cap_r     = 13;    // radius of the boss's spherical crown (<= boss_r/sqrt 2)
flange_r       = 30;    // boss flange radius, mm
flange_h       = 2;     // boss flange height, mm
rivet_n        = 8;     // rivets on the flange
rivet_r        = 1.6;   // rivet base radius, mm (45 deg cone, top r = rivet_r - rivet_h)
rivet_h        = 0.8;   // rivet height, mm

/* [Base] */
base_t         = 4;     // base plate thickness, mm
base_w         = 130;   // base plate width (x), mm
base_front     = 3;     // base extends this far in front of the cradle foot, mm
base_rear      = 25;    // base extends this far behind the shield back face, mm
base_corner_r  = 12;    // plan-view corner radius, mm
base_chamfer   = 1.2;   // 45 deg chamfer on the base's top edge, mm

/* [Quality / debug] */
$fn            = 96;    // >= 64 for the final shape
check          = 0;     // see CHECK MODES above
eps            = 0.01;  // tiny overlap to avoid coincident faces

// ---------------------------------------------------------------------
//  Derived geometry
// ---------------------------------------------------------------------
ca   = cos(recline);
sa   = sin(recline);
chan = phone_t + phone_clear_t;           // channel width backrest -> lip

// Seat height (phone's bottom-back corner B) from the cable: the plug
// hangs plug_len below the port, then the cable bends back with radius
// cable_bend_r; its lowest point = plug end - r*(1+sin a) - cable_d/2.
z_B = base_t + cable_clear + cable_d/2 + cable_bend_r*(1 + sa)
      + plug_len*ca - (phone_t/2)*sa;

// Phone frame -> world (y, z).  s = along the phone (up), w = toward the
// screen (out of the backrest).  B = P(0,0) sits at y = 0.
function P(s, w)      = [s*sa - w*ca, z_B + s*ca + w*sa];
function s_at_z(z, w) = (z - z_B - w*sa) / ca;          // s on line w at height z
function yz(p) = [0, p[0], p[1]];
// Same frame as a 3-D rotation (local x, -w, s) -> world, det = +1.
FR = [[1, 0, 0, 0], [0, ca, sa, 0], [0, -sa, ca, z_B], [0, 0, 0, 1]];

R       = shield_d/2;
zc      = R + shield_lift;                              // shield centre height
// Shield front face: behind the backrest plane at the shield's top + gap.
y_S     = (zc + R - z_B) * tan(recline) + shield_gap;
yr      = shield_t + rim_h;                             // rim crest depth
bb      = yr - rim_bevel_f;                             // back rim slope run
r_in    = R - bb - rim_crest - rim_h;                   // rim inner edge on back face

// Cradle outline points (y, z)
Q1 = P(rest_h, -back_t);                         // backrest back-top
Q2 = P(rest_h, 0);                               // backrest front-top
Q3 = P(0, 0);                                    // seat / backrest corner (B)
Q4 = P(0, chan);                                 // seat / lip corner
Q5a= P(lip_h - lip_chamfer, chan);               // lip chamfer start
Q5b= P(lip_h, chan + lip_chamfer);               // lip chamfer end
Q6 = P(lip_h, chan + lip_wall);                  // lip front-top
Q7 = P(s_at_z(floor_embed, chan + lip_wall), chan + lip_wall);  // front foot
Q8 = P(s_at_z(floor_embed, -back_t), -back_t);                  // back foot
y_front_desk = P(s_at_z(0, chan + lip_wall), chan + lip_wall)[0];

by0 = y_front_desk - base_front;                 // base front edge
by1 = y_S + shield_t + base_rear;                // base rear edge
tun_apex = base_t + tunnel_wall_h + tunnel_w/2;  // tunnel / hole apex height

// Boss crown centre above its base so the hull side is a 45 deg cone.
boss_zc = boss_r - sqrt(2)*boss_cap_r;

// ---------------------------------------------------------------------
//  Sanity asserts (design rules)
// ---------------------------------------------------------------------
assert(lip_wall >= 2.4 && back_t >= 2.4 && rib_t >= 2.4 && base_t >= 2.4,
       "walls must be >= 2.4 mm");
assert(shield_t - groove_d >= 2.4, "disc under a groove must stay >= 2.4 mm");
assert(groove_w >= 0.8 && groove_d >= 0.8 && rim_crest >= 0.8 &&
       2*(rivet_r - rivet_h) >= 0.8, "min feature 0.8 mm");
assert(boss_zc >= 0, "boss_cap_r too big: boss side would exceed 45 deg");
assert(notch_w > plug_w && tunnel_w > plug_w, "plug must pass notch/tunnel");
assert(tun_apex < P(0, -back_t)[1] - 3, "tunnel must stay under the seat");
assert(Q1[0] + rib_overlap < y_S, "shield must sit behind the backrest");
assert(shield_d <= 220 && base_w <= 220 && (by1 - by0) <= 220, "bed is 220 x 220");
assert(flange_r + flange_h + groove_d < r_in, "flange must fit inside rim");
assert($fn >= 64, "$fn >= 64");

echo(str("seat corner z_B = ", z_B, "  shield front y_S = ", y_S));
echo(str("shield top z = ", zc + R, "   phone top-front z = ",
         P(phone_h, phone_t)[1], "  (phone ", (P(phone_h, phone_t)[1] > zc + R)
         ? "pokes over" : "hidden behind", " the shield)"));
echo(str("footprint x = ", max(shield_d, base_w), "  y = ", by1 - by0,
         "  (", by0, " .. ", by1, ")"));
echo(str("phone CoM y = ", P(phone_h/2, phone_t/2)[0], "  base y range ", by0, " .. ", by1));

// ---------------------------------------------------------------------
//  Helpers
// ---------------------------------------------------------------------
// extrude a (y,z) polygon along x from x0 to x1
module yz_extrude(x0, x1)
    multmatrix([[0, 0, 1, x0], [1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 0, 1]])
        linear_extrude(x1 - x0) children();

// extrude an (x,z) polygon along y from y0 to y1
module xz_extrude(y0, y1)
    multmatrix([[1, 0, 0, 0], [0, 0, -1, y1], [0, 1, 0, 0], [0, 0, 0, 1]])
        linear_extrude(y1 - y0) children();

// box in the phone frame: x0..x1, w0..w1 (toward screen), s0..s1 (up the phone)
module frame_box(x0, x1, w0, w1, s0, s1)
    multmatrix(FR) translate([x0, -w1, s0]) cube([x1 - x0, w1 - w0, s1 - s0]);

// pointed-arch (45 deg gable) opening profile, floor slightly below base top
module gable_profile(w)
    polygon([[-w/2, base_t - 1], [w/2, base_t - 1], [w/2, base_t + tunnel_wall_h],
             [0, base_t + tunnel_wall_h + w/2], [-w/2, base_t + tunnel_wall_h]]);

module rrect(w, y0, y1, r)
    translate([-w/2 + r, y0 + r]) offset(r = r) square([w - 2*r, y1 - y0 - 2*r]);

// ---------------------------------------------------------------------
//  Parts
// ---------------------------------------------------------------------
module base_plate()
    hull() {
        linear_extrude(base_t - base_chamfer) rrect(base_w, by0, by1, base_corner_r);
        translate([0, 0, base_t - base_chamfer - eps])
            linear_extrude(base_chamfer + eps)
                rrect(base_w - 2*base_chamfer, by0 + base_chamfer, by1 - base_chamfer,
                      base_corner_r - base_chamfer);
    }

module cradle()
    difference() {
        yz_extrude(-phone_w/2, phone_w/2)
            polygon([Q8, Q7, Q6, Q5b, Q5a, Q4, Q3, Q2, Q1]);
        // cable notch: everything in front of the backrest plane, full height
        yz_extrude(-notch_w/2, notch_w/2)
            polygon([P(s_at_z(base_t - 1, 0), 0), P(lip_h + 3, 0),
                     P(lip_h + 3, 60), P(s_at_z(base_t - 1, 60), 60)]);
        // gable tunnel through the back wall under the seat
        xz_extrude(Q3[0] - 30, Q8[0] + 15) gable_profile(tunnel_w);
    }

module ribs() {
    wr  = -back_t + rib_overlap;                 // inside the backrest plate
    top = P(rest_h - 1, wr);
    for (sx = [-1, 1])
        let(x0 = sx < 0 ? -phone_w/2 : phone_w/2 - rib_t)
        yz_extrude(x0, x0 + rib_t)
            polygon([P(s_at_z(floor_embed, wr), wr), top,
                     [y_S + rib_overlap, top[1]], [y_S + rib_overlap, floor_embed]]);
}

// shield in local coords: disc axis = local z, front face z = 0,
// back face z = shield_t; local y becomes world -z after placement.
module shield_local() {
    g = groove_d;
    difference() {
        // planked disc + bevelled rim, all slopes exactly 45 deg
        rotate_extrude()
            polygon([[0, 0], [R - rim_bevel_f, 0], [R, rim_bevel_f],
                     [R - bb, yr], [R - bb - rim_crest, yr], [r_in, shield_t],
                     [0, shield_t]]);
        // back plank grooves, ending in 45 deg ramps under the rim
        intersection() {
            for (i = [-ceil(R/plank_w) : ceil(R/plank_w)])
                translate([(i + 0.5)*plank_w - groove_w/2, -R - 1, shield_t - g])
                    cube([groove_w, 2*R + 2, g + 1]);
            rotate_extrude()
                polygon([[0, shield_t - g], [r_in - g, shield_t - g],
                         [r_in + 1, shield_t + 1], [0, shield_t + 1]]);
        }
        // front plank grooves (offset half a plank so the disc stays >= 3.2 mm)
        intersection() {
            for (i = [-ceil(R/plank_w) : ceil(R/plank_w)])
                translate([i*plank_w - groove_w/2, -R - 1, -1])
                    cube([groove_w, 2*R + 2, g + 1]);
            rotate_extrude()
                polygon([[0, g], [r_in - g, g], [r_in + 1, -1], [0, -1]]);
        }
    }
    // boss flange (45 deg outer bevel, base reaches groove floor)
    rotate_extrude()
        polygon([[0, shield_t - g], [flange_r + flange_h + g, shield_t - g],
                 [flange_r, shield_t + flange_h], [0, shield_t + flange_h]]);
    // boss: 45 deg cone tangent to a spherical crown
    // (the cone starts 1 mm down inside the flange with r + 1 so it passes
    //  the flange top at exactly boss_r -- no micro-step at the junction)
    zf = shield_t + flange_h;
    hull() {
        translate([0, 0, zf - 1]) cylinder(r = boss_r + 1, h = eps);
        translate([0, 0, zf + boss_zc]) sphere(r = boss_cap_r);
    }
    // flange rivets (45 deg cones)
    for (i = [0 : rivet_n - 1])
        rotate([0, 0, (i + 0.5)*360/rivet_n])
            translate([(boss_r + flange_r)/2, 0, shield_t + flange_h - 0.4])
                cylinder(r1 = rivet_r + 0.4, r2 = rivet_r - rivet_h, h = rivet_h + 0.4);
}

module shield()
    difference() {
        translate([0, y_S, zc]) rotate([-90, 0, 0]) shield_local();
        // cable mouse hole under the shield (gable roof)
        xz_extrude(y_S - 1, y_S + yr + 1) gable_profile(tunnel_w);
    }

module stand() union() { base_plate(); cradle(); ribs(); shield(); }

// ---------------------------------------------------------------------
//  Check dummies
// ---------------------------------------------------------------------
module phone_dummy(w0 = 0.02, w1 = phone_t, s0 = 0.02)
    frame_box(-phone_w/2, phone_w/2, w0, w1, s0, phone_h);

module cable_dummy() {
    r  = cable_bend_r;
    pe = P(-plug_len, phone_t/2);                 // plug end (y,z)
    cc = pe + r*[ca, -sa];                        // bend centre
    a0 = 180 - recline;  a1 = 270;  n = 16;
    function arc(i) = cc + r*[cos(a0 + (a1 - a0)*i/n), sin(a0 + (a1 - a0)*i/n)];
    frame_box(-plug_w/2, plug_w/2, phone_t/2 - plug_t/2, phone_t/2 + plug_t/2,
              -plug_len, 0);
    for (i = [0 : n - 1])
        hull() { translate(yz(arc(i))) sphere(d = cable_d, $fn = 24);
                 translate(yz(arc(i + 1))) sphere(d = cable_d, $fn = 24); }
    hull() { translate(yz(arc(n))) sphere(d = cable_d, $fn = 24);
             translate(yz([by1 + 10, arc(n)[1]])) sphere(d = cable_d, $fn = 24); }
}

// ---------------------------------------------------------------------
//  Output
// ---------------------------------------------------------------------
if (check == 0) stand();
else if (check == 1) intersection() { stand(); phone_dummy(); }
else if (check == 2) intersection() { stand(); cable_dummy(); }
else if (check == 3) intersection() { stand(); phone_dummy(0.02, chan - 0.02); }
else if (check == 4) intersection() { stand();
        frame_box(-phone_w/2 + 0.5, phone_w/2 - 0.5, -0.3, 0, 0.5, rest_h - 0.5); }
else if (check == 5) intersection() { stand();
        frame_box(-phone_w/2 + 0.5, phone_w/2 - 0.5, 0.3, phone_t - 0.3, -0.3, 0); }
else if (check == 6) intersection() { stand(); phone_dummy(0.02, chan + 0.3); }
else if (check == 7) { phone_dummy(); cable_dummy(); }
