// Raspberry pi 3 / 4 model case by pkoehlers

// Original copyright / license notice:
// Raspberry pi 4 model case by George Onoufriou (Raven, GeorgeRaven, Archer) C 2019-06-30
// please see licence in project root https://github.com/DreamingRaven/RavenSCAD/blob/master/LICENSE

// |-=========---------| <-The back right of the board is the point everything else is relative to
// | o            o    |
// | o            o    |
// ||_|----------------|

/* [General] */

// currently only RPI3b and 4 are supported: RPI3b is supported as 3, any other value is for RPI4
// Raspberry Pi model
rpi_model = 4; // [3, 4]
render_part = "top"; // ["top", "bottom", "all"]

// Further value e.g. for the pi will be increased by this tolerance to make it fit more easily
tolerance = 1.2;

// how detailed the circular components are
$fn = 90; 


// add holder for the external zigbee antenna
antenna_connector_enabled=true;

/* [Advanced measures] */

// the space for the board itself only
board_thickness = 1.5; 
// the min space that the throughhole components require underneath
pin_space = 3;
//thickness of the case
case_thickness = 2;
// this is the length of the pi board only
pil = 85.5; 
// this is the width / depth of the pi board only
pid = 56;

/* [fan mount options] */
// the diameter of the fan holes
fan_pin_diam = 3.5;
// the offset of the fan from the right
fan_position_x = 44.3; 
// the offset of the fan from the top
fan_position_y = 17; 
// the distance between the mount holes
fan_pin_distance = 32; 

/* [antenna options] */
// defines how far from the edge of the case the holder will be placed
antenna_position_y=11; 
// how far the holder will stand out
antenna_holder_length=27;
// diameter of the antenna connector
antenna_connector_diameter=8;
// extra space for the connector
antenna_connector_spacing = 1.5;


module __Customizer_Limit__ () {}  

extension = 50; // extension to lengths so case can be subtractiveley created
inhibitionzone_height = 22; // creates an inhibition zone for surface components

pih = board_thickness;
sd_height = pin_space + case_thickness + board_thickness; // is how tall the sd card part sticking out is so if you increase it will cut more out for case
mount_pin_height = 2*board_thickness + 2*case_thickness + pin_space + inhibitionzone_height;//31; // this is the most awkward one of the set as it sets the mount point pin size

antenna_connector_case_width=antenna_connector_diameter+(antenna_connector_spacing*2);


if (render_part == "top") {
    topCase();
}
if (render_part == "bottom") {
    bottomCase();
}
if (render_part == "all") {
    full_case_for_debugging();
}



module topCase() {
    difference() {
     translate([0,0,inhibitionzone_height + case_thickness + board_thickness]) rotate([0,180,0]) intersection(){ // top of case
      rpi4_case();
      topSelector();
    }
    topCaseTolerance();
    translate([0, pid + case_thickness, 0])
    topCaseTolerance();
}
}
module bottomCase() {
    translate([30,0,case_thickness]) rotate([0,-90,0]) 
    difference(){ // bottom of case
      rpi4_case();
      topSelector();
    }
}

module full_case_for_debugging() {
    translate([-pil,pid+case_thickness*2+5]) rpi4_case(); // the whole unsplit case
    translate([extension+17.44,pid+case_thickness*2+5,0]) rpi4(); // the raspberry pi 4 and associated tolerances
}

// here follows all the modules used to generate what you want.
module topSelector()
{
  difference(){ // this difference selects the top and bottom parts of the case with a small lip for the IO
    translate([-case_thickness,0,0]) cube([tolerance*2+pil+2*case_thickness+antenna_holder_length,pid+tolerance*2,pin_space+inhibitionzone_height+case_thickness+tolerance]);  // test hull
    translate([-case_thickness,0,0]) cube([case_thickness,pid+case_thickness*2,board_thickness]);
  }
}

module topCaseTolerance() {
    translate([0,0,inhibitionzone_height]) rotate([0,180,0])
    translate([-case_thickness,0,-case_thickness*2])
      color ("#F00") cube([pil+case_thickness*2+tolerance+2,tolerance/2,inhibitionzone_height+case_thickness*2+tolerance*2]);
}

module rpi4_case()
{
  difference(){ // subtracts the rpi4 model from a cube to generate the case
    translate([-case_thickness,-case_thickness,-(case_thickness + pin_space)])
     union() {
             cube([pil+(2*case_thickness)+tolerance*2,
      pid+(2*case_thickness)+tolerance*2,
      pin_space+inhibitionzone_height+board_thickness+(2*case_thickness)+tolerance*2]); // the case itself
      if( antenna_connector_enabled) {
         translate([pil+tolerance*2, antenna_position_y, inhibitionzone_height+board_thickness-(antenna_connector_diameter)+(2*case_thickness) + tolerance*2])
        cube([antenna_holder_length,antenna_connector_case_width,antenna_connector_case_width]);
                  //antenna holder outer body
      }
     }

    union(){
      rpi4();
      pins(); // generating the pins themselves so the holes can be inhibited
    }
  }
}

module rpi4(){
  
  difference(){ // this creates the mount holes
    
    translate([0,0,board_thickness]){ // two translations cancel out but make maths simpler before they do
      translate([0,0,-(board_thickness)]) // the translation which ^ cancels out
      {
        cube([pil+tolerance*2,pid+tolerance*2,board_thickness+tolerance*2]); // the board only (not the underpins)
      }
      scale([1.03,1.03,1.03]) {
      // these are the big surface level components
      usb_width = 14.7;
      ethernet_width = 17.9;

      if (rpi_model == 3) {

          translate([-(2.81+extension),2.15,0]) cube([17.44+extension,usb_width,15.6]);  // USB 3.0
          translate([-(2.81+extension),22.6-(ethernet_width-usb_width),0]) cube([17.44+extension,usb_width,15.6]);  // USB 2.0
          translate([-(2.81+extension),39.6-(ethernet_width-usb_width),0]) cube([21.3+extension,ethernet_width,13.6]);   // Ethernet port
          translate([67.1,55,0]) cube([12.2,7.4+extension,4.5]);                     // USB micro power
          translate([42.3,50,0]) cube([17.5,7.8+extension,7.4]);                    // HDMI
          
      } else {
          translate([-(2.81+extension),2.15,0]) cube([21.3+extension,ethernet_width,13.6]);   // Ethernet port
          translate([-(2.81+extension),22.6,0]) cube([17.44+extension,usb_width,15.6]);  // USB 3.0
          translate([-(2.81+extension),39.6,0]) cube([17.44+extension,usb_width,15.6]);  // USB 2.0
          translate([67.1,55,0]) cube([12.2,7.4+extension,4.5]);                     // USB type c power
          translate([54.5,50,0]) cube([8.5,7.8+extension,4.5]);                    // Micro HDMI0
          translate([40.7,50,0]) cube([8.5,7.8+extension,4.5]);                    // Micro HDMI1
      }
      translate([27.36,1,0]) cube([40.7,5.0,8.6+extension]);                    // GPIO pins
      //translate([21,7.15,0]) cube([5.0,5.0,8.6+extension]);                     // Power over ethernet pins
      translate([48.0,16.3,0]) cube([15.0,15.0,2.5]);                           // cpu
      translate([67.5,6.8,0]) cube([10.8,13.1,1.8]);                            // onboard wifi
      //translate([79,17.3,0]) cube([2.5,22.15,5.4+extension]);                   // display connector
      //translate([37.4,34.1,0]) cube([2.5,22.15,5.4+extension]);                 // CSI camera connector
      translate([26.9,43.55,0]) cube([8.5,14.95+extension,6.9]);                  // Audio jack
      translate([85,22.4,-(board_thickness+sd_height)]) cube([2.55+extension,11.11,sd_height+tolerance]); // SD card (poking out)
      }
      //following lines are the cutout for the antenna holder
      if( antenna_connector_enabled) {
        antenna_holder_cutout();
      }
      translate([fan_position_x,fan_position_y,0]) cylinder(extension,d=fan_pin_diam, center=false);                            // fan mount top-r
      translate([fan_position_x,fan_position_y+fan_pin_distance,0]) cylinder(extension,d=fan_pin_diam, center=false);                 // fan mount bot-r
      translate([fan_position_x+fan_pin_distance,fan_position_y,0]) cylinder(extension,d=fan_pin_diam, center=false);                 // fan mount top-l
      translate([fan_position_x+fan_pin_distance,fan_position_y+fan_pin_distance,0]) cylinder(extension,d=fan_pin_diam, center=false);      // fan mount bot-l
      translate([fan_position_x+0.5*fan_pin_distance,fan_position_y+0.5*fan_pin_distance,0]) cylinder(extension,d=fan_pin_distance+fan_pin_diam, center=false);      // fan air hole
      translate([53,7.8,0]){ scale([10,1,1]){

        translate([0,0,-extension-board_thickness-pin_space])  cylinder(extension,d=5, center=false);      // under-side air hole
        translate([0,10,-extension-board_thickness-pin_space]) cylinder(extension,d=5, center=false);      // under-side air hole
        translate([0,20,-extension-board_thickness-pin_space]) cylinder(extension,d=5, center=false);      // under-side air hole
        translate([0,30,-extension-board_thickness-pin_space]) cylinder(extension,d=5, center=false);      // under-side air hole
        translate([0,40,-extension-board_thickness-pin_space]) cylinder(extension,d=5, center=false);      // under-side air hole
             translate([pil, 0, inhibitionzone_height+board_thickness+case_thickness-(antenna_connector_case_width)])
            rotate([0,90,0])
            translate([-antenna_connector_diameter /2 - 1, antenna_connector_diameter /2 + 1,0])
            cylinder(h=antenna_holder_length, r = antenna_connector_diameter/2);
      }
      }

      difference(){ // this creates the mount points around the mount holes esp the underneath ones
        union(){
          translate([0,0,0]) cube([pil+tolerance*2,pid+tolerance*2,inhibitionzone_height]);                           // cpu
          translate([0,0,-(pin_space+board_thickness)]) cube([pil+tolerance*2,pid+tolerance*2,pin_space]); // underpins only
        }
        mounts(); // the material which is above and below the board to keep it in place which the pins go through
      }
    } // end of translation cancel
  pins(); // the hole which will be screwed into to put both halves of the case and board together
  
  }
  
}
module antenna_holder_cutout() {
    pos_x = pil - case_thickness + tolerance;
    pos_y = antenna_position_y + antenna_connector_diameter/4 + antenna_connector_spacing;
    pos_z = inhibitionzone_height+board_thickness+case_thickness-(antenna_connector_diameter) + antenna_connector_spacing / 2 + tolerance*2;
    height = antenna_holder_length + case_thickness;
    diameter = antenna_connector_diameter;
    
    translate([pos_x, pos_y, pos_z])
    rotate([0,90,0])
    cylinder(h=height, d = diameter);
      
    translate([pos_x - 6, pos_y, pos_z])
    rotate([0,90,0])
    cylinder(h=height - 2.5, d = diameter+ 2.5);
}
module mounts(){
  translate([1.25 + tolerance,1.25 + tolerance,(0.5*mount_pin_height)-(board_thickness+case_thickness+pin_space)]){ // this is to move all the pins
          translate([22.2,2,0]) cylinder(mount_pin_height,d=6, center=true);     // mount top-r
          translate([22.2,51.1,0]) cylinder(mount_pin_height,d=6, center=true);  // mount bot-r
          translate([80.2,2,0]) cylinder(mount_pin_height,d=6, center=true);     // mount top-l
          translate([80.2,51.1,0]) cylinder(mount_pin_height,d=6, center=true);  // mount bot-l
        }
}

module pins(){
  translate([1.25 + tolerance,1.25 + tolerance,(0.5*mount_pin_height)-(board_thickness+case_thickness+pin_space)]){ // this is to move all the pins
    translate([22.2,2,0]) cylinder(mount_pin_height,d=3.2, center=true);     // hole  top-r
    translate([22.2,51.1,0]) cylinder(mount_pin_height,d=3.2, center=true);  // hole  bot-r
    translate([80.2,2,0]) cylinder(mount_pin_height,d=3.2, center=true);     // hole  top-l
    translate([80.2,51.1,0]) cylinder(mount_pin_height,d=3.2, center=true);  // hole  bot-l
  }
}
