/* 
 Copyright (c) 2021.  Jacques Parker

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without restriction, 
including without limitation the rights to use, copy, modify,
merge, publish, distribute, sublicense, and/or sell copies of the
Software, and to permit persons to whom the Software is furnished 
to do so, subject to the following conditions: 

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of # the Software. 

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND 
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT 
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR 
OTHER DEALINGS IN THE SOFTWARE. 

MIT License  copyright@judyandjacques.com

*/

$fn=100;

ENCLOSURE_HEIGHT = 50;
ENCLOSURE_Y = 83;

BASE_X = 77;
BASE_Y = 68;
BASE_Z = 1.5;

CORNER_RADIUS = 4;

SMALL_TABS_WIDTH = 4.5;
SMALL_TABS_X = 9.5 - SMALL_TABS_WIDTH/2;

linear_extrude(height = BASE_Z, convexity = 10, twist = 0)
difference() {
    square([BASE_X, BASE_Y]);
    
    circle(CORNER_RADIUS);
    
    translate([0, BASE_Y])
    circle(CORNER_RADIUS);
    
    translate([0, BASE_Y])
    circle(CORNER_RADIUS);
    
    translate([BASE_X, BASE_Y])
    circle(CORNER_RADIUS);
    
    translate([BASE_X, 0])
    circle(CORNER_RADIUS);
    
//    if (BASE_ONLY) {
//        translate([10, 10])
//        square([BASE_X-20, BASE_Y-20]);
//    }
}

//translate([BASE_X, (BASE_Y-32)/2, 0])
//cube([4, 34, BASE_Z ]);

// For Pi Zero
// Source-https://github.com/daprice/PiHoles/
PI_HOLE_LOCATIONS = 
    [[3.5, 3.5], [61.5, 3.5], [3.5, 26.5], [61.5, 26.5]];

PI_HEIGHT = 1.25;
PI_POST_HEIGHT = 7;

// Post to snap pi onto
PI_X = PI_HOLE_LOCATIONS[1][0]-PI_HOLE_LOCATIONS[0][0];
PI_Y = PI_HOLE_LOCATIONS[2][1]-PI_HOLE_LOCATIONS[0][1];

color("blue")
translate([ BASE_X-PI_X+6, (BASE_Y-PI_Y)/2])
for(holePos = PI_HOLE_LOCATIONS) {
    translate([holePos[0]-5/2, holePos[1]-5/2, 0]) 
    union() {
        cylinder(d=2, h=PI_POST_HEIGHT);
        cylinder(d1=5, d2=2, h=PI_POST_HEIGHT-PI_HEIGHT-0.25);

        translate([0, 0.4, PI_POST_HEIGHT]) 
        scale([1.1, 1.1, 1]) 
        cylinder(d=2, h=0.5);
    }
}

translate([BASE_X-1, (BASE_Y-32)/2, 0])
cube([11, 9, BASE_Z ]);

translate([BASE_X-1, BASE_Y/2+10, 0])
cube([11, 9, BASE_Z ]);


CAMERA_HEIGHT = 25;
CANERA_LENGTH = 80;
CAMERA_WIDTH = 20;
CAMERA_THICKNESS = 0.9;
CAMERA_ELEVATION = ENCLOSURE_HEIGHT - CAMERA_HEIGHT - 2;

CAM_POST_D = CAMERA_WIDTH + 2;
CAM_POST_BOTTOM = CAMERA_ELEVATION;
CAM_POST_TOP = CAM_POST_BOTTOM+2 * CAMERA_THICKNESS;

module CameraPost() {
    difference() {
        union() {
            cylinder(h = CAM_POST_TOP, d = CAM_POST_D);
            
            translate([0, 0,  CAM_POST_TOP])
            difference() {
                cylinder(h = 0.5, d = CAM_POST_D);
                
                cylinder(h = 0.5, d = CAMERA_WIDTH - 0.25);
            }
        }
        
        translate([0, 0, CAM_POST_BOTTOM])
        cylinder(h = CAM_POST_TOP-CAM_POST_BOTTOM, d = CAMERA_WIDTH);

        translate([-(CAM_POST_D+2)/2, 0 , 0])
        cube([CAM_POST_D+2, CAM_POST_D+2, CAM_POST_TOP+2]);
    } 
}

top_x = CAMERA_WIDTH/2 + 1;
center_y =(BASE_Y-CANERA_LENGTH + CAMERA_WIDTH)/2;

color("red")
difference() {
    translate([top_x, center_y, 0])
    union() {
        CameraPost();
        
        translate([0, CANERA_LENGTH-CAMERA_WIDTH, 0])
        rotate([0, 0, 180])
        CameraPost();
    }

    translate([-1, 0, 0])
    cylinder(r = CORNER_RADIUS+1, h = CAMERA_ELEVATION+10);
    
    translate([-1, BASE_Y, 0])
    cylinder(r = CORNER_RADIUS+1, h = CAMERA_ELEVATION+10);

    translate([0, center_y, 0])
    translate([SMALL_TABS_X, -CAM_POST_D/2, 0])
    union() {
        cube([SMALL_TABS_WIDTH, 2, CAMERA_ELEVATION+10]);

        translate([0, ENCLOSURE_Y-3, 0])
        cube([SMALL_TABS_WIDTH, 2, CAMERA_ELEVATION+10]);
    }
}

POST_X = 10;
POST_Y = 4;
POST_Z = ENCLOSURE_HEIGHT-2;

PR_X = 3.6;
CAP_X = 3.6;

WR = 0.6;
JR = 0.75;

color("purple")
translate([CAMERA_WIDTH + 20, 8, 0]) 
rotate([0,0,180])
difference() {
    cube([POST_X, POST_Y, POST_Z]);

    translate([(POST_X-PR_X-WR)/2, (POST_Y-WR)/2, POST_Z + 1])
    rotate([200, 0, 0])
    cylinder(r = WR, h = 10);

    translate([(POST_X+PR_X-WR)/2, (POST_Y-WR)/2, POST_Z + 1])
    rotate([200, 0, 0])
    cylinder(r = WR, h = 10);

    translate([(POST_X-PR_X-WR)/2, (POST_Y-WR)/2+3, POST_Z - 10])
    rotate([90, 0, 0])
    cylinder(r = WR, h = 6);

    translate([(POST_X+PR_X-JR)/2, (POST_Y-JR)/2+3, POST_Z - 12])
    rotate([90, 0, 0])
    cylinder(r = JR, h = 6);

    translate([(POST_X+PR_X-WR)/2, (POST_Y-WR)/2+3, POST_Z - 10])
    rotate([90, 0, 0])
    cylinder(r = WR, h = 6);

    translate([(POST_X-PR_X-JR)/2, (POST_Y-JR)/2+3, POST_Z - 12])
    rotate([90, 0, 0])
    cylinder(r = JR, h = 6);

    translate([(POST_X-PR_X-WR)/2, (POST_Y-WR)/2+3, POST_Z - 14])
    rotate([90, 0, 0])
    cylinder(r = WR, h = 6);

    cap_z = POST_Z-14-CAP_X;
    translate([(POST_X-PR_X-WR)/2, (POST_Y-WR)/2+3, cap_z])
    rotate([90, 0, 0])
    cylinder(r = WR, h = 6);

    translate([(POST_X-PR_X-JR)/2, (POST_Y-JR)/2+3, cap_z-2])
    rotate([90, 0, 0])
    cylinder(r = JR, h = 6);
}


