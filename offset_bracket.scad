include <config.scad>;
include <offset_bracket_config.scad>
use <screw.scad>

module ob_2d() {
    fr = fillet/2;
    difference() {
        hull() {
            translate([(ob_height/2-fr),(ob_width/2-fr),0]) circle(r=fr, $fn=smooth);
            translate([-(ob_height/2-fr),(ob_width/2-fr),0]) circle(r=fr, $fn=smooth);
            translate([-(ob_height/2-fr),-(ob_width/2-fr),0]) circle(r=fr, $fn=smooth);
            translate([(ob_height/2-fr),-(ob_width/2-fr),0]) circle(r=fr, $fn=smooth);
        }
        translate([0,-(ob_width/4-fr/2),0])
        scale(v=[.75,.75,.75])
        hull() {
            translate([0,(ob_width/4-fr),0]) circle(r=fr/2, $fn=smooth);
            translate([(ob_height/2-fr*4),0,0]) circle(r=fr/2, $fn=smooth);
            translate([0,-(ob_width/4-fr),0]) circle(r=fr/2, $fn=smooth);
            translate([-(ob_height/2-fr*4),0,0]) circle(r=fr/2, $fn=smooth);
        }
    }
}

module ob_basic() {
    linear_extrude(height=plate_thickness) ob_2d();
}

module slots() {
    module slot_cylinder() {
        hull() {
            translate([0,-(ob_width/2-plate_thickness/2),0]) screw_holes();
            translate([0,0,0]) screw_holes();
        }
        hull() {
            translate([0,-(ob_width/2-plate_thickness/2),0]) cylinder(cap_h+1,cap_dia/2,cap_dia/2,$fn=smooth);
            translate([0,0,0]) cylinder(cap_h+1,cap_dia/2,cap_dia/2,$fn=smooth);
        }
    }

    translate([(ob_height/2-plate_thickness/2),0,0]) slot_cylinder();
    translate([(ob_height/2-plate_thickness/2),0,0]) slot_cylinder();
}



module offset_bracket() {
    module inset() {
        translate([(ob_height/2-plate_thickness/2)+1,(ob_width/2-plate_thickness/2),
                       (plate_thickness-plate_thickness/2)-clamp_inset_depth])
        linear_extrude(height=plate_thickness)
        square([plate_thickness+2,clamp_2_offset_boss_w], center=true);
    }

    difference() {
        translate([0,0,-plate_thickness/2]) ob_basic();
        translate([(ob_height/2-plate_thickness/2),(ob_width/2-plate_thickness/2),0]) screw_holes();
        translate([-(ob_height/2-plate_thickness/2),(ob_width/2-plate_thickness/2),0]) screw_holes();
        translate([-(ob_height/2-plate_thickness/2),-(ob_width/2-plate_thickness/2),0]) screw_holes();
        translate([(ob_height/2-plate_thickness/2),-(ob_width/2-plate_thickness/2),0]) screw_holes();
        slots();
        mirror(0,0,1) slots();
        inset();
        mirror(0,0,1) inset();
    }
}

offset_bracket();