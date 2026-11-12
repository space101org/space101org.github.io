/* Educational 1U CubeSat - Exploded Solid Bar Frame */

/* [View Options] */
view_mode = "Assembly"; // [Assembly, Print: Frame Bars Layout, Print: 2x Panels]
// Distance to separate parts for the exploded view
explode_spacing = 15; // [0:1:50]

/* [Dimensions] */
// Outer width/depth of the main structure (100mm standard)
cubesat_size = 100; // [80:1:120]
// Total end-to-end length of the vertical rails (113.5mm standard)
cubesat_height = 113.5; // [80:0.5:150]
// Distance the rails protrude beyond the top/bottom frame (6.75mm standard)
rail_protrusion = 6.75; // [0:0.25:15]
// Width and depth of the square bar elements
bar_thickness = 8.0; // [6:0.5:15]

/* [CubeSat Spec Features] */
// Official spec requires minimum 1mm 45-degree chamfer on +/- Z ends
rail_tip_chamfer = 1.0; // [0:0.1:3]
// Official spec requires rounded/chamfered longitudinal edges
rail_edge_chamfer = 0.5; // [0:0.1:2]

/* [Panel Settings] */
// Thickness (Z-height) of the top and bottom panels
plate_thickness = 1.5; // [0.5:0.1:5.0]
// Width of the plate's outer mounting frame (matches bar_thickness to sit perfectly over them)
frame_width = 8.0; // [2:0.5:20]
// Width of the diagonal cross beams
cross_width = 5.0; // [2:0.5:20]
// Diameter of weight-saving holes in the cross beams
cross_hole_dia = 2.0; // [0:0.5:10]
// Spacing gap between weight-saving holes
cross_hole_gap = 2.0; // [0.5:0.5:10]

/* [Hardware & Tolerances] */
// Diameter for self-tapping pilot holes
screw_diameter = 2.0; // [1:0.1:4]
// Clearance gap for 3D printed parts fitting together
joint_tolerance = 0.5; // [0:0.1:1.5]

/* [Appearance] */
rail_color = "#EBCB8B";
beam_color = "#D08770";
plate_color = "#2E3440";

// --- Derived Metrics ---
offset = cubesat_size / 2 - bar_thickness / 2;
inner_len = cubesat_size - bar_thickness * 2;
body_height = cubesat_height - 2 * rail_protrusion; 
body_z_bot = -body_height / 2;
body_z_top = body_height / 2;
$fn = 30;

// Universal horizontal crossbeam (Solid)
module crossbeam_mesh() {
    difference() {
        // Main solid body
        cube([inner_len, bar_thickness, bar_thickness], center=true);
        
        // Pilot holes on the ends for connecting to vertical rails
        for(x = [-inner_len/2, inner_len/2]) {
            translate([x, 0, -1.5])
                rotate([0, 90, 0])
                    cylinder(h=bar_thickness + 10, d=screw_diameter, center=true);
        }
        
        // Vertical pilot holes on the face for mounting top/bottom accessory plates
        for(x = [-inner_len/2 + 12, inner_len/2 - 12]) {
            translate([x, 0, 0])
                cylinder(h=bar_thickness + 10, d=screw_diameter, center=true);
        }
    }
}

// Universal vertical corner rail (Solid, with CubeSat spec chamfers)
module vertical_rail_mesh() {
    difference() {
        // Main solid body with spec-compliant chamfers
        intersection() {
            // Tip chamfers (Z ends) - 1mm x 45 deg per CubeSat Spec
            hull() {
                cube([bar_thickness, bar_thickness, cubesat_height - 2*rail_tip_chamfer], center=true);
                cube([bar_thickness - 2*rail_tip_chamfer, bar_thickness - 2*rail_tip_chamfer, cubesat_height], center=true);
            }
            
            // Edge chamfers (longitudinal edges) to break sharp corners
            hull() {
                cube([bar_thickness, bar_thickness - 2*rail_edge_chamfer, cubesat_height + 2], center=true);
                cube([bar_thickness - 2*rail_edge_chamfer, bar_thickness, cubesat_height + 2], center=true);
            }
        }
        
        // --- Bottom Corner Joints ---
        translate([0, 0, body_z_bot + bar_thickness/2 - 1.5]) 
            rotate([0, 90, 0]) cylinder(h=bar_thickness + 10, d=screw_diameter, center=true);
        translate([0, 0, body_z_bot + bar_thickness/2 + 1.5]) 
            rotate([90, 0, 0]) cylinder(h=bar_thickness + 10, d=screw_diameter, center=true);
        
        // --- Top Corner Joints ---
        translate([0, 0, body_z_top - bar_thickness/2 - 1.5]) 
            rotate([90, 0, 0]) cylinder(h=bar_thickness + 10, d=screw_diameter, center=true);
        translate([0, 0, body_z_top - bar_thickness/2 + 1.5]) 
            rotate([0, 90, 0]) cylinder(h=bar_thickness + 10, d=screw_diameter, center=true);
        
        // --- Outer Panel Mounting Holes (Reverted to 3 holes) ---
        for (z = [-30, 0, 30]) {
            translate([0, 0, z + 1]) 
                rotate([0, 90, 0]) cylinder(h=bar_thickness + 10, d=screw_diameter, center=true);
            translate([0, 0, z - 1]) 
                rotate([90, 0, 0]) cylinder(h=bar_thickness + 10, d=screw_diameter, center=true);
        }
    }
}

// Lightweight cross-pattern panel designed to lie perfectly flush over the beams
module panel_mesh() {
    difference() {
        // Intersect bounds with the frame + cross shapes
        intersection() {
            // Master bounding box matching the full cubesat layout so frames sit ON the beams
            cube([cubesat_size, cubesat_size, plate_thickness], center=true);
            
            union() {
                // Outer square frame (width defined by frame_width)
                difference() {
                    cube([cubesat_size, cubesat_size, plate_thickness + 2], center=true);
                    cube([cubesat_size - 2*frame_width, cubesat_size - 2*frame_width, plate_thickness + 4], center=true);
                }
                
                // Diagonal cross beam 1
                rotate([0, 0, 45])
                    cube([cubesat_size * 1.5, cross_width, plate_thickness + 2], center=true);
                // Diagonal cross beam 2
                rotate([0, 0, -45])
                    cube([cubesat_size * 1.5, cross_width, plate_thickness + 2], center=true);
            }
        }
        
        // Corner cutouts to wrap around the vertical rails perfectly
        for (x=[-1, 1], y=[-1, 1]) {
            translate([x*offset, y*offset, 0])
                cube([bar_thickness + joint_tolerance, bar_thickness + joint_tolerance, plate_thickness + 2], center=true);
        }
        
        // Mounting holes aligned with the crossbeams underneath
        for (y=[-1, 1], x=[-1, 1]) {
            // Holes matching X-axis beams
            translate([x*(inner_len/2 - 12), y*offset, 0])
                cylinder(h=plate_thickness + 2, d=screw_diameter, center=true);
            // Holes matching Y-axis beams
            translate([y*offset, x*(inner_len/2 - 12), 0])
                cylinder(h=plate_thickness + 2, d=screw_diameter, center=true);
        }
        
        // Weight-saving holes along the diagonal cross beams
        if (cross_hole_dia > 0) {
            pitch = cross_hole_dia + cross_hole_gap;
            // Calculate max radius so holes don't cut into the outer frame
            max_r = ((cubesat_size - 2*frame_width) / 2) * sqrt(2) - cross_hole_dia;
            
            for (angle = [45, -45]) {
                rotate([0, 0, angle]) {
                    for (r = [0 : pitch : max_r]) {
                        // Place holes symmetrically outwards from the center
                        translate([r, 0, 0]) cylinder(h=plate_thickness + 10, d=cross_hole_dia, center=true);
                        translate([-r, 0, 0]) cylinder(h=plate_thickness + 10, d=cross_hole_dia, center=true);
                    }
                }
            }
        }
    }
}

// --- Output Rendering ---

if (view_mode == "Assembly") {
    e = explode_spacing;
    
    // 1. Vertical Rails
    color(rail_color) {
        for (x=[-1, 1], y=[-1, 1]) {
            translate([x*(offset + e), y*(offset + e), 0])
                vertical_rail_mesh();
        }
    }
    
    // 2. Horizontal Crossbeams
    color(beam_color) {
        // Bottom X-axis
        translate([0, offset + e, body_z_bot + bar_thickness/2 - e]) crossbeam_mesh();
        translate([0, -(offset + e), body_z_bot + bar_thickness/2 - e]) crossbeam_mesh();
        
        // Bottom Y-axis
        translate([offset + e, 0, body_z_bot + bar_thickness/2 - e]) rotate([180, 0, 90]) crossbeam_mesh();
        translate([-(offset + e), 0, body_z_bot + bar_thickness/2 - e]) rotate([180, 0, 90]) crossbeam_mesh();
        
        // Top X-axis
        translate([0, offset + e, body_z_top - bar_thickness/2 + e]) rotate([180, 0, 0]) crossbeam_mesh();
        translate([0, -(offset + e), body_z_top - bar_thickness/2 + e]) rotate([180, 0, 0]) crossbeam_mesh();
        
        // Top Y-axis
        translate([offset + e, 0, body_z_top - bar_thickness/2 + e]) rotate([0, 0, 90]) crossbeam_mesh();
        translate([-(offset + e), 0, body_z_top - bar_thickness/2 + e]) rotate([0, 0, 90]) crossbeam_mesh();
    }
    
    // 3. X-Pattern Panels
    color(plate_color) {
        // Bottom Panel
        translate([0, 0, body_z_bot + bar_thickness + plate_thickness/2 - e * 0.5])
            panel_mesh();
            
        // Top Panel
        translate([0, 0, body_z_top - bar_thickness - plate_thickness/2 + e * 0.5])
            panel_mesh();
    }
    
} else if (view_mode == "Print: Frame Bars Layout") {
    color(rail_color) {
        for(i=[0:3]) {
            translate([0, i*12, bar_thickness/2]) 
                rotate([0, 90, 0]) 
                    vertical_rail_mesh();
        }
    }
    color(beam_color) {
        for(i=[0:7]) {
            translate([0, 55 + i*12, bar_thickness/2]) 
                rotate([0, 90, 0]) 
                    crossbeam_mesh();
        }
    }
    
} else if (view_mode == "Print: 2x Panels") {
    color(plate_color) {
        translate([0, cubesat_size/2 + 2, plate_thickness/2]) 
            panel_mesh();
        translate([0, -cubesat_size/2 - 2, plate_thickness/2]) 
            panel_mesh();
    }
}