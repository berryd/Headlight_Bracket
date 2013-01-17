include <config.scad>;
use <screw.scad>;

module bevel(cfillet) {
    translate([-cfillet/2, -cfillet/2, 0])
    difference() {
        square(cfillet/1.5);
        circle(r=cfillet/2, $fn=smooth);
    }
}

module clamp(clamp_dia) {
    module bevels() {
        translate([clamp_boss_w,clamp_outer_dia/2+clamp_boss/2,0]) bevel(fillet);
    }

    module basic_shape() {
       difference() {
            difference() {
                union() {
                    translate([0,-(clamp_outer_dia+clamp_boss)/2,0]) 
                        square([clamp_boss_w,(clamp_outer_dia+clamp_boss)]);                    
                    circle(r=clamp_outer_dia/2, $fn=smooth);
                }
                circle(r=clamp_dia/2, $fn=smooth);
            }
            //slice in half
            translate([-(clamp_outer_dia+clamp_boss)+split-2, 0,0]) 
                square((clamp_outer_dia+clamp_boss)*2+2, center=true);

            bevels();
            mirror([0,1,0]) {
                bevels();
            }
        }

    }

    module half() {
        translate([0,0,-plate_thickness/2]) {
            linear_extrude(height=plate_thickness)
            basic_shape();
        }
    }

    module draw() {

        module clamps() {
            union() {
                half();
                mirror([1,0,0]) half();
            }
        }

        module offset_boss() {
            module boss_2d() {
                difference() {
                    square([clamp_outer_dia/2+clamp_2_offset_boss_h, clamp_2_offset_boss_w/2]);
                    translate([clamp_outer_dia/2+clamp_2_offset_boss_h,clamp_2_offset_boss_w/2,0]) bevel(fillet);
                    circle(r=clamp_outer_dia/2, $fn=smooth);                
                }
                translate([clamp_outer_dia/2+clamp_2_offset_boss_h-clamp_2_offset_boss_h-fillet,clamp_2_offset_boss_w/2,0]) {
                    rotate([0,0,-180]) {
                        difference() {
                            bevel(fillet);
                            translate([-fillet/2,-fillet/2,0]) rotate([0,0,-90]) square(fillet*2);
                        }
                    }
                }
            }

            module boss_half() {
                translate([0,0,-plate_thickness/2]) linear_extrude(height=plate_thickness) 
                    boss_2d();
            }
            rotate([0,0,180]) {
                boss_half();
                mirror([0,1,0]) boss_half();
            }
        }

        difference() {
            union() {
                difference() {
                    clamps();
                    union() {
                        translate([0,(clamp_outer_dia/2+clamp_boss/2)-(((clamp_outer_dia+clamp_boss)-clamp_outer_dia)/2)+1,0]) 
                            screw(1);
                        translate([0,-(clamp_outer_dia/2+clamp_boss/2)+(((clamp_outer_dia+clamp_boss)-clamp_outer_dia)/2)-1,0]) 
                            screw(1);
                    }
                }
                offset_boss();
            }
            rotate([0,0,180]) translate([clamp_outer_dia/2+clamp_2_offset_boss_h/4,0]) screw(0);
        }

    }

    draw();
}

module upper_clamp() {
    clamp(upper_clamp_dia);
}

module lower_clamp() {
    clamp(lower_clamp_dia);
}

lower_clamp();
//upper_clamp();
   