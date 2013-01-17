use <clamp.scad>;
use <offset_bracket.scad>;
use <light_mount.scad>;
include <config.scad>;
include <offset_bracket_config.scad>;
include <light_mount_config.scad>;

fork_spread = 120;

module left_assembly() {
    translate([0,0,clamp_vertical_offset]) upper_clamp();
    translate([0,0,-clamp_vertical_offset]) lower_clamp();
    translate([-(clamp_outer_dia/2+clamp_2_offset_boss_h+plate_thickness-plate_thickness/2-clamp_inset_depth),
                    -(ob_width/2-plate_thickness/2), 0]) 
    rotate([0,90,0]) offset_bracket();
    translate([-(clamp_outer_dia/2+clamp_2_offset_boss_h+plate_thickness+lm_length/2-clamp_inset_depth),
                    -(clamp_outer_dia/2-clamp_boss/2), 0])
    rotate([90,0,180]) light_mount();
}

translate([0,-fork_spread,0]) left_assembly();
mirror([0,1,0]) translate([0,-fork_spread,0]) left_assembly();

