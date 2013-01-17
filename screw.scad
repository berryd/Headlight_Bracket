include <config.scad>;

module screw(shaft) {
    if (screws_on == 1) {
        rotate([0,-90,0])
        translate([0,0,-clamp_boss_w-1]) {
            cylinder(clamp_boss_w*2+2, screw_thread_id/2, screw_thread_id/2, $fn=smooth);
            if(shaft == 1) cylinder(clamp_boss_w+2, screw_thread_od/2, screw_thread_od/2, $fn=smooth);
            cylinder(cap_h+2, cap_dia/2, cap_dia/2, $fn=smooth);
        }
    }
}

module screw_holes() {
    if(screws_on == 1) {
        translate([0,0,-(plate_thickness+2)/2])
        cylinder(plate_thickness+2, screw_thread_od/2, screw_thread_od/2, $fn=smooth);
    }
}