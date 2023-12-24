part_w_in = 2.25;
part_l_in = 2;
thickness_mm = 5;
$fn = 150;

part_w = part_w_in*25.4;
part_l = part_l_in*25.4;


/////////////////////////////////////////////////////////////
// Building blocks
/////////////////////////////////////////////////////////////
module rounded_rect(x,y,z,r)
{
    minkowski()
    { 
        cube([x-r,y-r,z-r]);
        sphere(r);
    }
}

module holes(gridx, gridy, space, radius)
{
    for (i = [0:gridx-1])
    {
        translate([(i%2)*space/2,i*space,0])
        for (j = [0:gridy-1])
        {
            translate([j*space,0,0]) linear_extrude(thickness_mm*2) circle(radius,$fn=6);
        }
    }
}

///////////////////////////////////////////////////////////////
// The part itself
///////////////////////////////////////////////////////////////

difference()
{
    
    rounded_rect(part_w,part_l,thickness_mm,1);

 
    // The slot. Should parameterize better...
    translate([part_w/2, part_l/2,-1])
    union()
    {
        translate([0,-25.4/4,0]) cylinder(h=thickness_mm*1.5, r1=16/2, r2=24/2);
        translate([0,-25.4/4,0]) minkowski()
        {      
        cube([1,(3/4)*25.4,1]);
        cylinder(h=thickness_mm*1.5, r1=7/2, r=12/2);
        }
    }
    
    // A grid of holes, with a solid chunk in the middle
    difference()
    {
        // This is a bit of a mess, eyeballed to make it work out
        translate([25.4/12,25.4/4,0]) scale([22,25, 1]) holes(16,24, .1,.04);
        translate([(5/8)*25.4,0,0]) cube([25.4,1.8*25.4,10]);
    }
    translate([25.4/8,2,-2])cube([2*25.4,2,10]);

}