/* VIKING ROUND SHIELD / portrait charging stand — units: mm
   PRINT ORIENTATION (as exported): flat shield BACK on the bed, boss up.
   Do not rotate onto the desk sole. The sole grows toward the bottom of the
   shield at tan(recline) mm per layer-mm; the toe and guide ramps grow at
   ramp_run mm per mm of rise in the print. The rear sole corners grow at
   45 degrees. Other details taper inward, stay above previous layers, or
   begin on the bed. The cable bay has no roof.
   SLICE: 0.20 mm layers, 0.4 mm nozzle, 4 perimeters, 5 top/bottom layers,
   18% gyroid, PLA or PETG, supports off. Use a brim if bed adhesion is marginal.
   ESTIMATE (PLA, 18%, 45–60 mm/s): 10–14 hours, 145–175 g; slicer dependent.

   FIT: the case back bears on two coplanar pads; the square lower edge seats
   across two shelves. The top is open to clear a camera bump; check its lower
   edge against the pad limit for your case. Gravity loads the pads rearward.
   There is 0.55 mm lateral play per side and 0.65 mm between the case front
   and the start of the toe ramp. The toe is a wedge, not a friction grip.
   These allowances account for case variation and 0.4 mm nozzle FDM error;
   adjust for elephant foot/overextrusion and measure the case, not the phone.
   Plug in from the front through the open bay, or plug in before seating.
   The bay width includes clearance for a molded USB plug. No tunnel to thread.
   When docked the phone covers the boss; the circular rim remains visible
   around it. The whole shield face is visible when undocked.

   Coordinates: x = across, s = along phone toward its top, p = print height
   (normal toward the screen). In print coordinates these are X,Y,Z.
   Desk height = s*cos(recline) + p*sin(recline). The sole is at height zero.
*/

/* [Phone and cradle] */
phone_w = 76;              // Cased phone width
phone_t = 11.5;            // Cased phone thickness, including any front bezel
phone_h = 155;             // Cased height; sets maximum pad reach
recline = 15;              // Degrees back from desk vertical
side_play = 0.55;          // Lateral fit allowance, each side
front_play = 0.65;         // Normal clearance to start of front lip
seat_s = 16;               // Seat position along the shield axis
back_p = 49;               // Distance from shield back to phone back
camera_keepout = 50;       // Leave this much of phone top unsupported
pad_x = 30;                // Center offset of each backrest pad
pad_w = 4.8;               // Pad width
pad_root_extension = 9;    // Extra s-length at pad root for stiffness
lip_h = 4.5;               // Toe height measured along the phone
lip_top_run = 3.2;         // Solid length of toe plateau normal to phone
side_h = 7;                // Side-guide height above seat
side_t = 3.2;              // Side-guide thickness
ramp_run = 0.9;            // s growth per p layer-mm (less than 45 deg from print vertical)

/* [Base and charging] */
sole_w = 103;              // Width of continuous desk sole
sole_t = 4.2;              // Floor thickness measured perpendicular to desk
sole_overrun = 2.6;        // Floor extension ahead of the toes in print coordinates
sole_corner = 2;           // Sole footprint corner cut, grown at 45 degrees at rear
plug_w = 16;               // Max. plug body width for the default fit
plug_slack = 3.5;          // Extra bay opening on each side of the plug
port_offset = 0;           // Port x-offset from phone center (positive right)
plug_drop = 22;            // Required depth for plug body and strain relief

/* [Shield styling] */
shield_d = 140;            // Full shield diameter
shield_center = 76;        // Disc center along s, measured from rear of sole
field_t = 3.8;             // Disc thickness before shallow plank lines
rim_w = 5.4;               // Bound edge width
rim_rise = 2.1;            // Raised bound edge height
rim_bevel = 0.85;          // Inset of either rim edge on its face
rim_studs = 20;            // Evenly spaced rim rivets
stud_d = 2.9;              // Rivet root diameter
stud_crown_d = 1.5;        // Rivet flat crown diameter
stud_h = 1.2;              // Rivet relief
plank_pitch = 17;          // Distance between plank seams
plank_lines = 6;           // Count of plank seams (use an even number)
seam_w = 0.95;             // Recess width
seam_depth = 0.9;          // Recess depth
seam_end_gap = 2.5;        // Solid land between seams and rim
boss_r = 17;               // Boss flange radius
boss_flange = 2.4;         // Boss flange height
boss_shoulder_r = 12;      // Dome radius at flange
boss_crown_r = 2.2;        // Flat at top of boss
boss_h = 9;                // Rise of dome above flange
boss_studs = 6;            // Rivets attaching the boss flange
boss_stud_inset = 2.4;     // Rivet axis distance from flange edge

/* [Fabrication limits] */
wall_min = 2.4;            // Minimum structural wall
feature_min = 0.8;         // Minimum nominal detail size (bevel edges excluded)
bed = 220;                 // Square build plate
segments = 96;             // Facet count for circular features
join = 0.04;               // Boolean overlap only; not a fabrication feature
$fn = segments;

// Derived fit: channel has no independent hard-coded front coordinate.
channel_half = phone_w/2 + side_play;
cradle_half = channel_half + side_t;
toe_start = back_p + phone_t + front_play;
toe_crest = toe_start + lip_h/ramp_run;
toe_end = toe_crest + lip_top_run;
sole_end = toe_end + sole_overrun;
bay_lo = port_offset - plug_w/2 - plug_slack;
bay_hi = port_offset + plug_w/2 + plug_slack;
side_ramp_start = back_p - side_h/ramp_run;
pad_end = seat_s + phone_h - camera_keepout;
r = shield_d/2;
sole_slope = tan(recline);
sole_ds = sole_t/cos(recline);
function desk_s(p) = -p*sole_slope;
function chord_x(s) = sqrt(max(0, r*r - (s-shield_center)*(s-shield_center)));

assert(segments >= 64 && recline > 0 && recline <= 45);
assert(ramp_run > 0 && ramp_run <= 1 && side_ramp_start > field_t);
assert(shield_center >= r && max(sole_w, shield_d) <= bed &&
       shield_center+r-desk_s(sole_end) <= bed, "Outside bed or below desk");
assert(sole_w/2-sole_corner >= cradle_half && sole_overrun >= sole_corner);
assert(side_t >= wall_min && pad_w >= wall_min && sole_t >= wall_min &&
       field_t-seam_depth >= wall_min && lip_top_run >= wall_min);
assert(seam_w >= feature_min && seam_depth >= feature_min &&
       rim_bevel >= feature_min && rim_w-2*rim_bevel >= wall_min &&
       stud_crown_d >= feature_min);
assert(bay_lo > -phone_w/2+wall_min && bay_hi < phone_w/2-wall_min);
assert(seat_s-(desk_s(back_p+phone_t/2)+sole_ds) >= plug_drop,
       "Not enough charge-plug depth under the seat");
assert(pad_x-pad_w/2 > max(boss_r, abs(bay_lo), abs(bay_hi)) &&
       pad_x+pad_w/2 < phone_w/2 && pad_end > seat_s);
assert(min(chord_x(seat_s),chord_x(pad_end+pad_root_extension)) > pad_x+pad_w/2,
       "Backrest pad roots must be inside the disc");
assert(back_p > field_t+boss_flange+boss_h && seat_s > sole_ds &&
       shield_center-r < sole_ds+seat_s,
       "Boss clearance or base-to-shield fit invalid");

// Extrude an [s,p] section along x, or an [x,p] section along s.
module across(x0,x1,section) {
    multmatrix([[0,0,1,x0],[1,0,0,0],[0,1,0,0],[0,0,0,1]])
        linear_extrude(height=x1-x0) polygon(section);
}
module desk_shear() {
    multmatrix([[1,0,0,0],[0,1,-sole_slope,0],[0,0,1,0],[0,0,0,1]]) children();
}
module sole() {
    w = sole_w/2;
    c = sole_corner;
    // Chamfered footprint in [x,p]. Shear keeps the whole sole on the desk.
    desk_shear() multmatrix([[1,0,0,0],[0,0,1,0],[0,1,0,0],[0,0,0,1]])
        linear_extrude(height=sole_ds)
            polygon([[-w+c,0],[w-c,0],[w,c],[w,sole_end-c],
                     [w-c,sole_end],[-w+c,sole_end],[-w,sole_end-c],[-w,c]]);
}

module shoe(x0,x1) {
    base_s = sole_ds-join;
    // Both cheeks are full underneath the shelf. Removing the whole center
    // between them gives a continuous open bay, including through the lip.
    across(x0,x1,[[base_s,0],[seat_s,0],[seat_s,toe_start],
                   [seat_s+lip_h,toe_crest],[seat_s+lip_h,toe_end],
                   [desk_s(toe_end)+base_s,toe_end]]);
}
module side_guide(x0,x1) {
    across(x0,x1,[[seat_s-join,side_ramp_start],[seat_s,side_ramp_start],
                   [seat_s+side_h,back_p],[seat_s+side_h,toe_end],
                   [seat_s-join,toe_end]]);
}
module back_pad(x) {
    across(x-pad_w/2,x+pad_w/2,
           [[seat_s-join,field_t-seam_depth-join],
            [pad_end+pad_root_extension,field_t-seam_depth-join],
            [pad_end,back_p],[seat_s-join,back_p]]);
}

module stud(x,s,p) {
    translate([x,s,p-join]) cylinder(d1=stud_d,d2=stud_crown_d,h=stud_h+join);
}
module shield() {
    translate([0,shield_center,0]) {
        difference() {
            cylinder(r=r,h=field_t);
            intersection() {
                translate([0,0,field_t-seam_depth])
                    cylinder(r=r-rim_w-seam_end_gap,h=seam_depth+join);
                union() for(i=[0:plank_lines-1])
                    translate([(i-(plank_lines-1)/2)*plank_pitch-seam_w/2,
                               -r,field_t-seam_depth])
                        cube([seam_w,shield_d,seam_depth+join]);
            }
        }
        // Continuous raised binding, its extrusion narrows toward the face.
        rotate_extrude()
            polygon([[r-rim_w,field_t-join],[r,field_t-join],
                     [r-rim_bevel,field_t+rim_rise],
                     [r-rim_w+rim_bevel,field_t+rim_rise]]);
        for(i=[0:rim_studs-1]) {
            a = 360*(i+0.5)/rim_studs;
            rr = r-rim_w/2;
            stud(rr*cos(a),rr*sin(a),field_t+rim_rise);
        }
        translate([0,0,field_t-seam_depth-join])
            cylinder(r=boss_r,h=seam_depth+join+boss_flange);
        // Quarter-ellipse meridian: round crown, supported at every layer.
        translate([0,0,field_t+boss_flange-join]) rotate_extrude()
            polygon(concat([[0,0]],
                [for(i=[0:segments/4])
                    let(a=90*i/(segments/4))
                    [boss_crown_r+(boss_shoulder_r-boss_crown_r)*cos(a),
                     (boss_h+join)*sin(a)]], [[0,boss_h+join]]));
        for(i=[0:boss_studs-1]) {
            a = 360*i/boss_studs;
            rr = boss_r-boss_stud_inset;
            stud(rr*cos(a),rr*sin(a),field_t+boss_flange);
        }
    }
}

union() {
    shield();
    sole();
    shoe(-cradle_half,bay_lo);
    shoe(bay_hi,cradle_half);
    side_guide(-cradle_half,-channel_half);
    side_guide(channel_half,cradle_half);
    back_pad(-pad_x);
    back_pad(pad_x);
}
