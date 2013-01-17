include <config.scad>;
include <offset_bracket_config.scad>;
include <light_mount_config.scad>;
use <screw.scad>;

module mount_holes() {
    if(screws_on == 1) {
        translate([0,0,-(plate_thickness+2)/2])
        cylinder(plate_thickness+2, lm_light_dia/2,lm_light_dia/2, $fn=smooth);
    }
}

module lm_2d_half() {
    fr = fillet/2;
    difference() {
        hull() {
            translate([(lm_length/2-fr),0,0]) circle(r=(lm_mount_dia+lm_mount_beef)/2, $fn=smooth);
            translate([-(lm_length/2-fr),(ob_height/2-fr),0]) circle(r=fr, $fn=smooth);
            translate([-(lm_length/2-fr),-(ob_height/2-fr),0]) circle(r=fr, $fn=smooth);
        }
        //translate([ob_height/2.5,lm_subtract_radius+ob_width/4,0]) circle(r=(lm_subtract_radius),$fn=smooth);
        translate([ob_height/4,lm_subtract_radius+ob_width/3,0]) circle(r=(lm_subtract_radius),$fn=smooth);
        translate([0,-ob_width/2,0]) square([lm_length+lm_mount_dia+lm_mount_beef,ob_width],center=true);
    }
}

module lm_modifier() {
    difference() {
        union() {
            difference() {
                lm_2d_half();
                scale(v=[.75,.5,.75]) lm_2d_half();
            }
            translate([-lm_mount_beef/12,0,0]) square([lm_mount_beef/6,ob_width]);
            translate([(lm_length/2-fillet/2),0,0]) circle(r=(lm_mount_dia+lm_mount_beef)/2, $fn=smooth);
        }
        translate([ob_height/4,lm_subtract_radius+ob_width/3,0]) circle(r=(lm_subtract_radius),$fn=smooth);
        translate([(lm_length/2-fillet/2),0,0]) circle(r=(lm_mount_dia)/2, $fn=smooth);
        translate([0,-ob_width/2,0]) square([lm_length+lm_mount_dia+lm_mount_beef,ob_width],center=true);
    }
}

module lm_whole() {
    lm_modifier();
    mirror([0,1,0]) lm_modifier();
}

module end_holes() {
    rotate([0,90,0]) screw_holes();
}

module lm_extrude() {
    difference() {
        translate([0,0,-plate_thickness/2]) linear_extrude(height=plate_thickness) lm_whole();
        translate([(plate_thickness/2)-lm_length/2,-(ob_height/2-plate_thickness/2),0]) end_holes();
        translate([(plate_thickness/2)-lm_length/2,(ob_height/2-plate_thickness/2),0]) end_holes();
    }
}

module light_mount() {
    lm_extrude();
}

light_mount();
