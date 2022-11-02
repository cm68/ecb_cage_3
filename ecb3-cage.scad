/*
 * $Id: ecb3-cage.scad 2023 2022-11-01 18:48:36 curt
 * card cage for the retrobrew ecb 3 slot motherboard.
 * the motherboard is held on 3 sides by the cage, and the
 * last side is open to allow somewhat permissive placement of
 * the molex power connector and power switch.  
 * the molex can't really be placed vertically, since it would interfere with the
 * card slide of the bottom card.  
 * placing the molex power connector at a right angle is fine, 
 * the back of motherboard is fine also, after rotating the connector of course.
 *
 * CAUTION: this is my first openscad program, so there may be truly horrific
 * stylistic faux pas in here that a more seasoned openscad programmer would never
 * do.  this is not a showcase of awesome openscad chops, which I do not have.
 */
 
 /*
  * this strange hack is used to express the above designs as individual
  * layers, possibly rotated into the assembled unit.
  * if the string contains 'a', then display everything in assembled orientation
  * if the string contains any of 'lrtb', 
  * display the corresponding left, right, top, bottom side
  * this facility is what I use to test fit the cage together.
  * there may be a better way to do this, but I haven't seen it yet.  
  * as soon as I do, I'll grab it.  
  * there's way too many magic numbers in the translations.
  * this would be possibly made cleaner using some form of a 'min' or 'max'
  * of an object
  */
express = "lrtba";

 /*
  * none of the variables in this file are really tunable
  * they're here to make the code a bit more readable
  * and to create the possiblity of making a future version of this source
  * code work for some other card cage
  */
pitch = 20.54;                  // space between slots
railwidth = 5;                  // size of rail body
gapwidth = pitch - railwidth;   // the space between rails

rails = 3;
railheight = 5;

conlength = 17;
edge = (railwidth + gapwidth) * rails + railwidth + 2;

/*
 * a card guide with a groove on a rail
 */
 module rail(width, height, length, groovewidth, grooveheight) { 
    difference() {
        cube([width, length, height]);
        translate([(width - groovewidth) / 2, -1, height - grooveheight]) 
            cube([groovewidth, length+2, grooveheight + 1]);
    }
}

/*
 * the rails for the 160mm cards
 * there's an extra rail that won't be used for card, but for a cover.
 * this has a little too much slop in the card for my taste, but a 2x2 groove
 * seems to allow easy assembly
 */
module side() {
    /* when building a side, i'll fill the space betwen rails with holes */
    holes = 5;
    holemargin = 10;
    holespace = 10;
    holewidth = 20;
    
    for (i = [0 : rails]) {
        translate ([i * (railwidth + gapwidth), 0, 0]) {
            rail (railwidth, railheight, 160, 2, 2);
            // the last rail, no gap - there's probably a prettier way to do this.
            if (i != rails) {
                translate ([railwidth, 0, 0]) {
                    difference() {
                        cube ([gapwidth, 160, 2]);  // the gap
                        for (h = [0: holes - 1]) {  // has holes
                            translate([0, holemargin + ((holewidth + holespace) * h), -1]) 
                                cube([gapwidth, holewidth, 4]);
                        }
                    }
                }
            }   
        }
    }
}

/*
 * little tabs on the edge to interlock with top and bottom
 * the argument is strictly to make the 'difference' case do a sightlier cutout.
 * it is a hack.
 */
module support(sh = 0) {
    cube([railheight, 5, 5+sh]);
    translate([0, -10, 0]) cube([railheight, 5, 5+sh]);
}

/*
 * decorate each edge with a crenelation. 
 * this is used to dovetail the sides together.
 */
module hooks() {
    translate([0, 10, 0]) support();
    translate([0, 160 - 5, 0]) support();
    translate([0, 82, 0]) support();
}

/*
 * this side is built up with space for pins on the bottom board,
 * plus a support and grove for the motherboard.
 */
module left() {
    translate([-5, 0, 0]) hooks();
    cube([2, 160, railheight]);
    translate([2, 0, 0]) side();
    translate([edge, 0, 0]) hooks();
    
    translate([0, -17, 0]) difference() {
        cube([edge, 17, 5]);
        translate([-1,2,3]) cube([2+edge, 2, 3]);
    }
}

/*
 * this side has no support for the motherboard, as this might block
 * access to the power connector, switch, LED, reset.
 * essentially, I do nothing.  arguably:
 * I should have the slot start higher on the side, giving complete access to the vertical molex
 *      connector
 * the side should support the motherboard, necessitating a very different architecture, 
 * either high rails, a really thick board, an additional surface, etc.
 */
module right() {
    side();
    translate([edge - 2, 0, 0]) 
        cube([2, 160, railheight]);
    
    translate([-5, 0, 0]) hooks();
    translate([edge, 0, 0]) hooks();
}

/*
 * the top and bottom differ in the height of the motherboard holder, 
 * as the boards have component sides using more space than the solder side.
 */
module top() {
    difference () {
        cube([100 + 6, 160, 5]);
        translate([0, 10, -1]) support(2);
        translate([0, 160 - 5, -1]) support(2);
        translate([0, 82, -1]) support(2);
        translate([101, 82, -1]) support(2);
        translate([101, 10, -1]) support(2);
        translate([101, 160 - 5, -1]) support(2);
        translate([10, 10, -1]) cube([86, 65, 7]);
        translate([10, 85, -1]) cube([86, 65, 7]);
        translate([7, 7, 2]) cube([92, 146, 4]);
    }
    translate([0, -17, 0]) {
        cube([106, 17, 5]);
        difference() {
            translate([5, 0, 5]) cube([101, 6, 12]);            
            translate([-1, 2, 14]) cube([108, 2, 4]);           
        }
    }
}

module bottom() {
    
    difference () {
        cube([100 + 6, 160, 5]);
        translate([0, 10, -1]) support(2);
        translate([0, 160 - 5, -1]) support(2);
        translate([0, 82, -1]) support(2);
        translate([101, 82, -1]) support(2);
        translate([101, 10, -1]) support(2);
        translate([101, 160 - 5, -1]) support(2);
        translate([10, 10, -1]) cube([86, 65, 7]);
        translate([10, 85, -1]) cube([86, 65, 7]);
        translate([7, 7, 2]) cube([92, 146, 4]);
    }
    translate([0, -17, 0]) {
        cube([106, 17, 5]);
        difference() {
            translate([0, 0, 5]) cube([101, 6, 5]);            
            translate([-1, 2, 7]) cube([108, 2, 4]);            
        }
    }
}


color("green") {
    if (search("l", express)) {
        left();
    }
}

color ("yellow") {
    if (search("r", express)) {
        if (search("a", express)) {
            translate([edge, 0, 100+6]) 
                rotate([0, 180, 0]) 
                    right();
        } else {
            right();
        }
    }
}

color ("blue") {
    if (search("t", express)) {
        if (search("a", express)) {
            translate([edge+5, 0, 0]) 
                rotate([0, -90, 0]) 
                    top();
        } else {
            top();
        }
    }
}

color("red") {
    if (search("b", express)) {
        if (search("a", express)) {
            translate([-5, 0, 106]) 
                rotate([0, 90, 0]) 
                    bottom();
        } else {
            bottom();
        }
    }
}




