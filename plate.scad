use <clamp.scad>;
use <offset_bracket.scad>;
use <light_mount.scad>;
include <config.scad>;
include <offset_bracket_config.scad>;
include <light_mount_config.scad>;

module lower_clamp_front_half() {
    difference() {
        lower_clamp();
        translate([(clamp_outer_dia/2+clamp_boss),0,-plate_thickness/2-1]) linear_extrude(height = plate_thickness+2) 
        square(clamp_outer_dia+clamp_boss*2,center=true);
    }
}

module lower_clamp_back_half() {
    difference() {
        lower_clamp();
        translate([-(clamp_outer_dia/2+clamp_boss),0,-plate_thickness/2-1]) linear_extrude(height = plate_thickness+2) 
        square(clamp_outer_dia+clamp_boss*2,center=true);
    }
}

module upper_clamp_front_half() {
    difference() {
        upper_clamp();
        translate([(clamp_outer_dia/2+clamp_boss),0,-plate_thickness/2-1]) linear_extrude(height = plate_thickness+2) 
        square(clamp_outer_dia+clamp_boss*2,center=true);
    }
}

module upper_clamp_back_half() {
    difference() {
        upper_clamp();
        translate([-(clamp_outer_dia/2+clamp_boss),0,-plate_thickness/2-1]) linear_extrude(height = plate_thickness+2) 
        square(clamp_outer_dia+clamp_boss*2,center=true);
    }
}

module clamp_block() {
    offset = 50;
    translate([-offset/2,-lower_clamp_dia/1.25,0])
    for (j=[-1,1]) {
        for (i = [0,1]) {
            if(i == 0) {
                translate([i*offset,clamp_outer_dia/1.5+(j*lower_clamp_dia/1.25),0]) lower_clamp_front_half();
                translate([clamp_outer_dia/2.5+i*offset,clamp_outer_dia/1.5+(j*lower_clamp_dia/1.25),0]) rotate([0,180,0])  
                    lower_clamp_back_half();
            } else {
                translate([i*offset,clamp_outer_dia/1.5+(j*lower_clamp_dia/1.25),0]) upper_clamp_front_half();
                translate([clamp_outer_dia/2.5+i*offset,clamp_outer_dia/1.5+(j*lower_clamp_dia/1.25),0]) rotate([0,180,0])  
                    upper_clamp_back_half();
            }
        }
    }
}

module offset_bracket_block() {
     kerf = 10;
     for (j=[-1,1]) {
        for (i = [0,1]) {
            translate([-(ob_height+kerf)/2*j,-(ob_width+kerf)/2+i*(ob_width+kerf),0]) offset_bracket();
        }
    }
}

module light_mount_block() {
     kerf = 10;
     translate([0,lm_length/4,0])
     for (j=[-1,1]) {
        for (i = [0,1]) {
            if(j==-1) translate([-(lm_length+kerf)/2,-(ob_height+kerf)+i*(ob_height+kerf),0]) light_mount();
            else translate([(lm_length+kerf)/2,-(ob_height+kerf)/2+i*(ob_height+kerf),0]) mirror([1,0,0]) light_mount();
        }
    }
}

module parts() {
    translate([0,0,plate_thickness/2]) {
        translate([clamp_outer_dia*2.5,0,0]) clamp_block();
        translate([0,ob_width*1.5,0]) offset_bracket_block();
        translate([0,-lm_length,0]) rotate([0,0,90]) light_mount_block();
    }
}

module center_up() {
    translate([-50,80,0]) parts();
}

if(model == "all") {
    projection(cut=false) {
        center_up();
    }
}
