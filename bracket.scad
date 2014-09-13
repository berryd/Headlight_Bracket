//printable=true;

//otherside=true;
$fn=90;

/*
bed=140;
#translate([0,0,-10]) rotate([0,0,45]) square(bed,center=true);
*/

bracket_shiny_side_out = false;

bracket_thick = 5;
washer = 0;

hole_count = 4;

//####### 43 MM #######
/*
fork_out_dia=43;
tweak=-4;
ridge=0;
washer = -2.5;
*/
//####### 43 MM #######

//####### 50 MM #######
/*
fork_out_dia=50;
tweak=0;
ridge=0;
*/
//####### 50 MM #######

//####### 55 MM #######

fork_out_dia=55;
tweak=2;
ridge=0.35;

//####### 55 MM #######

//length=130;
length=90;

inset_length=.75;
shift_inset=10;

outer_end=15; //or 20
//end_hole=16;
end_hole=9.5;

fork_end_w=70;
fork_end_h=20;

hole=4.2;
head=15;

tab_w=10;
tab_h=12;
tab_r=45;

module round_inset() {
        translate([((length*inset_length)/2-12.5)+(length-130)*0.12,17,0]) {
            difference() {
                square(10);
                circle(2.5);
            }
        }
        translate([(length*inset_length)/2-30,17+2.5,0]) {
            square(20);
        }
}

module 2d_bracket() {
    dimple_offset = 25+(25-length/5.2);
    difference() {
        hull() {
            union() {
                translate([-length/2,0,0]) { 
                    circle(outer_end);
                }
                translate([length/2-fork_end_h+fork_end_h/4,0,0])
                    square([fork_end_h,fork_end_w],center=true);
            }
        }

        translate([-length/2,0,0]) {
            circle(end_hole/2);
        }
 
        translate([-dimple_offset,-(length+bracket_thick),0]) circle(length-10);
        translate([-dimple_offset,length+bracket_thick,0]) circle(length-10);

        difference() {
            translate([-shift_inset*(130/length),0,0]) square([length*inset_length,fork_end_w],center=true);
            translate([-dimple_offset,-(length-bracket_thick),0]) circle(length-10);
            translate([-dimple_offset,length-bracket_thick,0]) circle(length-10);
            round_inset();
            mirror([0,1,0]) round_inset();
        }

        for ( i=[-fork_end_w/2-fork_end_w/(2*hole_count) : fork_end_w/hole_count : fork_end_w/2+fork_end_w*(2*hole_count)] ) {
            translate([length/2-15,i,0]) circle(hole/2);
        }
    }

    difference() {
        translate([-length/2,0,0]) { 
            circle(outer_end);
        }
        translate([-length/2,0,0]) {
            circle(end_hole/2);
        }
    }

    translate([-(length*.05),0,0])
    square([bracket_thick*2,fork_end_h+10],center=true);
}

module 2d_mount() {
    shifty=-(50-fork_out_dia)/2;
    module template() {    
        difference() {
            union() {
                circle(fork_out_dia/2+bracket_thick);
                rotate([0,0,-tab_r])
                hull() {
                    translate([tab_w/2,fork_out_dia/2+tab_h,0]) circle(2.5);
                    translate([-tab_w/2,fork_out_dia/2+tab_h,0]) circle(2.5);
                    translate([tab_w/2,0,0]) circle(2.5);
                    translate([-tab_w/2,0,0]) circle(2.5);
                }    

                difference() {
                    translate([-(fork_out_dia/2+bracket_thick/2)-21,-(fork_out_dia/2+bracket_thick),0]) 
                        square([50,fork_out_dia/2+bracket_thick/2+5]);
                    hull() {
                        translate([-(fork_out_dia)*.925+ridge,bracket_thick/3,0]) circle(fork_out_dia/3);
                        translate([-(fork_out_dia),-bracket_thick/2-1+(50-fork_out_dia)/4,0]) circle(fork_out_dia/3);
                    }
                    translate([-120,-16.6,0]) square(70);
                }
            }
            circle(fork_out_dia/2);
        }
    }
    //sort of a hack or workaround
    translate([shifty,0,0]) 
        template();
}

module mount_whole() {
    module render() {
        difference() {
            translate([length*(130/length)-21.5,fork_end_w/2,fork_out_dia/2+1.5])
            rotate([90,0,0])
            linear_extrude(height=fork_end_w) 2d_mount();
    
            linear_extrude(height=bracket_thick+1) 

            difference() {
                2d_bracket();
                translate([-25,0,0]) square([length,fork_end_w],center=true);
            }

            translate([-5,0,0]) cube([length,fork_end_w+10,bracket_thick*2+1],center=true);

        }

        if(bracket_shiny_side_out) {
            translate([(130-length)/2,0,1.5])
            linear_extrude(height=bracket_thick)
            difference() {
                2d_bracket();
                translate([-22,0,0]) square([length,fork_end_w],center=true);
            }
        } else {
            translate([(130-length)/2,0,-bracket_thick+1.5])
            linear_extrude(height=bracket_thick)
            difference() {
                2d_bracket();
                translate([-22,0,0]) square([length,fork_end_w],center=true);
            }
        }

    }

    module holes() {
        translate([length*(130/length)-21.5+tweak,0,fork_out_dia/2+1.5])
        rotate([0,-90+tab_r,0]) {
            for ( i = [-20 : 20 : 20] ) {
                translate([fork_out_dia/2+bracket_thick+hole,i,0])
                    cylinder(r1=hole/2,r2=hole/2,50,center=true);
                }
        }

        translate([length*(130/length)-21.5+tweak,0,fork_out_dia/2+1.5])
        rotate([0,180+(-90+tab_r),0]) {
            for ( i = [-20 : 20 : 20] ) {
                translate([fork_out_dia/2+bracket_thick+hole,i,0]) {
                    cylinder(r1=hole/2,r2=hole/2,50,center=true);
                    translate([0,0,10]) cylinder(r1=head/2,r2=head/2,20,center=true);
                    translate([0,0,-20]) cylinder(r1=head/2,r2=head/2,20,center=true);
                }
            }
        }
    }

    module boss() {
        translate([length*(130/length)-21.5+tweak,0,fork_out_dia/2+1.5])
        rotate([0,180+(-90+tab_r),0]) {
            for ( i = [-20 : 20 : 20] ) {
                translate([fork_out_dia/2+bracket_thick+hole,i,0]) {
                    difference() {
                        translate([0,0,-5-washer]) cylinder(r1=head/2,r2=head/2,20,center=true);
                        cylinder(r1=hole/2,r2=hole/2,50,center=true);
                    }
                }
            }
        }
    }

    difference() {
        render();
        holes();
    }
    boss();
}


module bracket() {
    translate([0,0,-bracket_thick+1.5])
    difference() {
        linear_extrude(height=bracket_thick*2) translate([(130-length)/2,0,0]) 2d_bracket();
        translate([0,0,0])
        linear_extrude(height=bracket_thick)
        difference() {
            translate([(130-length)/2,0,0]) 2d_bracket();
            translate([-22+(130-length)/2,0,0]) square([length,fork_end_w],center=true);
        }
    }
}

module mount(v) {
    module mask(forward) {
        if(forward) {
            translate([length*(130/length)-21.5+tweak,0,fork_out_dia/2+1.5])
            rotate([0,90+tab_r,0])
            translate([-fork_out_dia*2,-fork_out_dia,])
            cube([fork_out_dia*4,fork_out_dia*2,fork_out_dia*2]);
        } else {
            translate([length*(130/length)-21.5+tweak,0,fork_out_dia/2+1.5])
            rotate([0,180+90+tab_r,0])
            translate([-fork_out_dia*2,-fork_out_dia,])
            cube([fork_out_dia*4,fork_out_dia*2,fork_out_dia*2]);
        }
    }
    if(!printable) {
        difference() {
            mount_whole();
            mask(v);
        }
    } else {
        rotate([90,0,0])
        difference() {
            mount_whole();
            mask(v);
        }
    }
}


if(printable) {
    rotate([0,180,0])
    if(otherside) {
        mirror([0,1,0]) 
            bracket();
    } else {
        //bracket();
    }
} else {
    bracket();
}


if(otherside) {
    mirror([0,1,0]) {
        mount(true);
        mount(false);
    }
} else {
    mount(true);
    mount(false);
}
