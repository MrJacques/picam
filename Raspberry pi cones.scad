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

$fn = 100;

LED_DIAMETER = 18.9;
LED_HEIGHT = 16;

module ring(delta, label = "") {
    difference() {
        union() {
            cylinder(d=LED_DIAMETER+delta+1, h=LED_HEIGHT);
            
            if (len(label) > 0) {
                translate([(LED_DIAMETER+delta+1)/2-2, -5, 0])
                cube([12, 10, 2]);
               
                color("red")
                translate([(LED_DIAMETER+delta+1)/2+5, -4.75, 1.5])
                linear_extrude(height = 2)
                text(text = label, 
                    font="Liberation Sans", 
                    size = 9, 
                    halign = "center");
            }
        }

        cylinder(d=LED_DIAMETER+delta, h=LED_HEIGHT);
    }
}

translate([40,40,0])
ring(0.5);

