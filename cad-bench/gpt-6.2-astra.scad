/* HAUGR / round-shield charging dock. Dimensions in mm.
   Print AS DRAWN, chord and two runners on bed. PLA, 0.4 nozzle,
   0.20 layers, 3 perimeters, 15% infill. ESTIMATE: 4-6 h, 75-100 g.
   The chord removes the fast-growing lowest part of the circular outline.
   Relief grows on shallow bevels; runners, seats and lips rise from the bed.
   No suspended crossbar, enclosed socket, or support material.

   Two flat staves touch the case back; coplanar shelves support the bottom
   square to that back. The twin lips leave FDM allowance in thickness;
   width is not clamped. Center the case: the open bay between the shelves
   lets a straight plug enter on the phone axis and the lead turn forward.
   Designed for a reasonably flat case back (not an extended grip).
*/
phone_w=76;            // case outside width
phone_t=11.5;          // case outside thickness, normal to screen
recline=15;            // degrees behind vertical
fit=0.9;               // free space at front of seated case, not per side
shield_d=148;          // full binding outside diameter
chord_frac=0.57;       // center height / radius: stable clipped heel
board=5;               // plank-field thickness behind face datum
rim_w=9;               // binding radial width
rim_h=2.4;             // proud of field
bevel=2;               // radial run per unit relief height
boss_r=19;             // iron umbo skirt radius
boss_h=8;              // boss projection
rivet_r=2.4;           // binding nail head radius
rivet_h=1;             // height above binding
nails=16;              // equally spaced binding nails around untrimmed ring
seam_w=1.2;            // recessed vertical plank joints
seam_d=1;              // shallow groove depth
plank=23;              // stave pitch
boss_gap=2.5;          // backrest beyond foremost metalwork
seat_z=32;             // vertical port clearance at rear bottom corner
bay=24;                // cable opening width, open right to the desk
edge_inset=3;          // shelf ends inside case side edges
lip=6;                 // lip rise, measured along screen
wall=3.2;              // lip thickness (and minimum runner top land)
heel=32;               // runner reach aft of shield face at bed level
heel_rise=26;          // local height of rear buttress above clipped heel
rail_top=40;           // rail top relative to shield center along stave
join=0.1;              // internal Boolean overlap, not a printed detail
$fn=96;                // final circle resolution
R=shield_d/2; H=R*chord_frac; gap=phone_t+fit;
b=boss_h+boss_gap; s=(seat_z-H-b*sin(recline))/cos(recline);
outer=phone_w/2-edge_inset; low=-shield_d; // sacrificial extent below bed
bound=shield_d+heel+gap+b+wall; // clipping envelope
assert(outer-bay/2>=wall && rim_w-bevel*rim_h>=2*rivet_r-1 && board-seam_d>=2.4);
assert(boss_r>bevel*boss_h && rail_top<R && rail_top>s+lip && seat_z>lip);
// Local axes: X across, U up the board, D normal toward the viewer.
module relief(points){rotate_extrude() polygon(points);}
module tacks(){for(i=[0:nails-1]) rotate([0,0,i*360/nails])
 translate([R-rivet_r,0,rim_h-join]) cylinder(h=rivet_h+join,r1=rivet_r,r2=rivet_r-rivet_h);}
module shield(){
 difference(){translate([0,0,-board]) cylinder(h=board,r=R);
  for(i=[-ceil(R/plank):ceil(R/plank)]) translate([(i+0.5)*plank-seam_w/2,-R,-seam_d]) cube([seam_w,2*R,seam_d+join]);}
 // Inner bevel merges with wood; outer binding continues the disc edge.
 relief([[R-rim_w,-seam_d-join],[R,-seam_d-join],[R,rim_h],[R-rim_w+bevel*rim_h,rim_h],[R-rim_w,0]]);
 relief([[0,-join],[boss_r,-join],[boss_r,0],[boss_r-bevel*boss_h,boss_h],[0,boss_h]]);
 tacks();}
// Extrude a (D,U) section across X. Profile outlines both the cable-side
// bearing surface and the solid foot below it -- the lip isn't a bridge.
module runner(x){multmatrix([[0,0,1,x],[0,1,0,0],[1,0,0,0],[0,0,0,1]])
 linear_extrude(height=outer-bay/2) polygon([
 [-heel,low],[b+gap+wall,low],[b+gap+wall,s+lip],[b+gap,s+lip],
 [b+gap,s],[b,s],[b,rail_top],[-board+join,rail_top],
 [-board+join,-H+heel_rise],[-heel,-H+wall]]);}
intersection(){translate([-bound,-bound,0]) cube([2*bound,2*bound,2*bound]);
 translate([0,0,H]) rotate([90-recline,0,0]) union(){shield(); runner(bay/2);runner(-outer);}}
