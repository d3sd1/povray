#include "colors.inc"

  /*
  PoV-Ray v3.1d example scene file of poker playing chips.
  Copyright Ken Tyler tylereng@pacbell.net  created 02-28-1999

  You are free to do with this as you wish.

  The playing cards are not included with this file. The cards can be
  downloaded seperatly form the Pov Objects collection at either:
  http://twysted.net or at the home page of the Pov Objects collection
  creater: http://thor.prohosting.com/%7Emriser/
  */ 

  // **** WARNING ****
  // Pov is going to complain that the bounding for this object is unecessary.
  // If you leave it in it will render faster by about 20%-30%.
  // If you remove the bounding the render time will increase but Pov will
  // quit complaining about it. It's up to you but you have been warned.

  global_settings{assumed_gamma 2 max_trace_level 125 max_intersections 128}

  // Finishes for the objects
  #declare Ph = finish{ambient .25 diffuse .35 phong .5 phong_size 20}
  #declare F  = finish{ambient .35 diffuse .25 specular 1 roughness .0001}

  // Pigments for the chip pieces
  #declare P1 = rgb<1,1,1>;
  #declare P2 = rgb<1,0,0>;
  #declare P3 = rgb<1,1,0>;
  #declare P4 = rgb<0,0,1>;
  #declare P5 = rgbf<1,1,1,1>;

  // This create a series of rotated boxes that make up the patterns
  // on the inside face of the poker chips.
  #declare Rot = 0;
    #declare Set2 = 
     union {
      #while (Rot< 18)
       union {
         box{-.5,.5 rotate 45*y scale<.25,3.2,.02>translate z*-.07}
         box{-.5,.5 rotate 45*y scale<.25,3.2,.02>translate z* .07}
         pigment{P1}finish{F}
        rotate 90*-z
       rotate z*10*Rot
      } // end union
     #declare Rot = Rot + 1;
    #end
   } // end union


  // Make one 12.25 degree wedge
  #declare Section =
   intersection{
    cylinder{z*-0.1,z*0.1, 2}
     plane{y,0 rotate 78.75*-z} 
    plane{y,0 rotate 78.75* z}
   } // end intersection


  // This operation rotates the individual "sections" 22.5 degrees
   // alternating between white and one of the three other colors.

  // White Sections
  #declare WSec =
   union {
     object{Section rotate z*0.0}
     object{Section rotate z*45 }
     object{Section rotate z*90 }
     object{Section rotate z*135}
     object{Section rotate z*180}
     object{Section rotate z*225}
     object{Section rotate z*270}
     object{Section rotate z*315}
     pigment{P1}
    finish{F}
   } // end union


  // Red Sections
  #declare RSec =
   union {
     object{Section rotate z*22.5 }
     object{Section rotate z*67.5 }
     object{Section rotate z*112.5}
     object{Section rotate z*157.5}
     object{Section rotate z*202.5}
     object{Section rotate z*247.5}
     object{Section rotate z*292.5}
     object{Section rotate z*337.5}
     pigment{P2}
    finish{F}
   } // end union


  // Yellow Sections
  #declare YSec =
   union {
     object{Section rotate z*22.5 }
     object{Section rotate z*67.5 }
     object{Section rotate z*112.5}
     object{Section rotate z*157.5}
     object{Section rotate z*202.5}
     object{Section rotate z*247.5}
     object{Section rotate z*292.5}
     object{Section rotate z*337.5}
     pigment{P3}
    finish{F}
   } // end union


  // Blue Sections
  #declare BSec =
   union {
     object{Section rotate z*22.5 }
     object{Section rotate z*67.5 }
     object{Section rotate z*112.5}
     object{Section rotate z*157.5}
     object{Section rotate z*202.5}
     object{Section rotate z*247.5}
     object{Section rotate z*292.5}
     object{Section rotate z*337.5}
     pigment{P4}
    finish{F}
   } // end union


  // The inside union combines one white group and one color group to
  // produce a circle with alternating colors. The difference is used
  // to punch a hole through the middle. The outside union attaches a
  // one more cylinder as a plug for the middle and is used with the
  // declare for the object

  #declare Tx =  texture{pigment{P1}finish{F}}

  // red chips
  #declare Chip1 =
  union { 
    difference{ 
      union{
       object{WSec}
       object{RSec}
       } // end union
      cylinder{z*-0.11,z*0.11,1.3}texture{Tx}
     } //end difference
    cylinder{z*-0.08,z*0.08,1.4 texture{Tx}}
   } // end union

   // yellow chips
  #declare Chip2 =
  union { 
    difference{ 
      union{
       object{WSec}
       object{YSec}
       } // end union
      cylinder{z*-0.11,z*0.11,1.3}texture{Tx}
     } // end difference
    cylinder{z*-0.08,z*0.08,1.4 texture{Tx}}
   } // end union

   // blue chips
  #declare Chip3 =
  union { 
    difference{ 
       union {
       object{WSec}
       object{BSec}
       } // end union
      cylinder{z*-0.11,z*0.11,1.3}texture{Tx}
     } //end difference
    cylinder{z*-0.08,z*0.08,1.4 texture{Tx}}
   } // end union


  // These are the different colored chips combined with object "Set2"

  #declare Chip1A =
   union{
    object{Chip1}
    object{Set2 }
    bounded_by{cylinder{z*-0.11,z*0.11, 2.02}}
   } // end union

  #declare Chip2A =
   union{
    object{Chip2}
    object{Set2 }
    bounded_by{cylinder{z*-0.11,z*0.11, 2.02}}
   }
  
  #declare Chip3A =
   union{
    object{Chip3}
    object{Set2 }
    bounded_by{cylinder{z*-0.11,z*0.11, 2.02}}
   }


  // These are just a mechanism to rotate and stack the chips.
  #declare R = seed(pi);

  // Stack of red chips
  #declare RedChips = 
   union {
    #declare A =  0;
    #while  (A < 23)
     object{Chip1A 
     rotate<90,-5*A*rand(R),0>
     translate<-12,0.202*A,6>}
    #declare A = A + 1;
   #end
  } // end union

  // Stack of yellow chips
  #declare YellowChips = 
   union {
    #declare B =  0;
    #while  (B < 18)
     object{Chip2A 
     rotate<90,5*B*rand(R),0>
     translate<-8,0.202*B,12>}
    #declare B = B + 1;
   #end 
  } // end union

  // Stack blue chips
  #declare BlueChips =
   union {
    #declare C =  0;
    #while  (C < 15)
     object{Chip3A
     rotate<90,5*C*rand(R),0>
     translate<-6,0.202*C,-1>}
    #declare C = C + 1;
   #end
  } // end union

  // The stacks of chip objects
  object{RedChips   }
  object{BlueChips  }
  object{YellowChips}
  object{BlueChips translate<4,0,45>}


  // Table chips random placement
  object{Chip1A rotate 90*x translate<-3,0.202,24>}
  object{Chip1A rotate 90*x translate<-6,0.202,27>}
  object{Chip3A rotate 90*x translate< 3,0.202,29>}
  object{Chip2A rotate 90*x translate<-7,0.202,18>}
  object{Chip2A rotate 90*x translate< 2,0.202,36>}
  object{Chip2A rotate 90*x translate<12,0.202,45>}
  object{Chip2A rotate 90*x translate<12,0.404,45>}
  object{Chip1A rotate 90*x translate<12,0.606,45>}

  // The playing surface
  plane{y,-.02 
  texture{pigment{rgb<0,.39,0>}}
  texture{pigment{bozo color_map{
  [.3 rgbf<0,.390,0,.3>][.5 rgbf<1,1,1,1>]
  [.7 rgbf<0,.385,0,.3>][ 1 rgbf<1,1,1,1>]}scale .20}}
  texture{pigment{bozo color_map{
  [.3 rgbf<0,.390,0,.6>][.4 rgbf<1,1,1,1>]
  [.6 rgbf<0,.385,0,.6>][ 1 rgbf<1,1,1,1>]}scale .15}}
  finish{ambient .25 diffuse .32}}

  // The wood borders around the playing - there is no fany work here. They
  // are only a facade to create the illusion of quality a gaming table
  #include "woods.inc"
  cylinder{x*-15, x* 15,5 scale<1,.2,.75>texture{T_Wood16 rotate 90*y}translate  z*-8}
  cylinder{x*-135,x*135,8 scale<1,.2,5.0>texture{T_Wood16 rotate 90*y}translate z*120}
  cylinder{x*-135,x*135,8 scale<1,.2,3.0>rotate 90*y texture{T_Wood16}translate  x*60}
  cylinder{x*-135,x*135,8 scale<1,.2,3.0>rotate 90*y texture{T_Wood16}translate -x*60}

  // The playing cards
  #include "../object/CARDS.INC"
  union{
  object{CardBack scale .85 rotate<90,0,0>translate<1.1,0.0,4.75>} 
  object{CardBack scale .85 rotate<90,0,0>translate<1.0,0.1,3.25>} 
  object{CardAce  scale .85 rotate<89,9,0>translate<1.4,0.2,1.00>}}

  union{
  object{CardBack  scale 1 rotate<90,0,0>translate<-.1,0.0,4.75>} 
  object{CardBack  scale 1 rotate<90,0,0>translate<0.2,0.1,3.25>} 
  object{CardQueen scale 1 rotate<91,0,0>translate<0.0,0.2,0.00>}
  rotate 175*y translate<-10,0,37>}

  light_source{<-70,120,30>rgb 1}

  camera{location<0,10,-12>look_at y*2.8}

  // This last section uses a linear spline lathe to create a cocktail
  // glass. It is not of very good quality but I wanted some thing there
  // to fill in the scene. It's a god working examle of how to use a
  // complex shape to create the liquid it holds.

  #declare Pilsner =
  lathe { linear_spline 89,
  <0.0000,0.2666>,<0.0111,0.2638>,<0.0888,0.2444>,<0.2777,0.1972>,<0.5333,0.1333>,
  <0.7972,0.0694>,<1.0444,0.0222>,<1.2638,0.0027>,<1.4666,0.0000>,<1.6598,0.0017>,
  <1.8119,0.0136>,<1.8963,0.0433>,<1.9435,0.0884>,<1.9859,0.1419>,<2.0066,0.1904>,
  <1.9649,0.2252>,<1.7752,0.2652>,<1.3848,0.3306>,<0.9181,0.4216>,<0.5255,0.5278>,
  <0.2858,0.6188>,<0.2326,0.6706>,<0.2890,0.7072>,<0.3642,0.7582>,<0.4216,0.8297>,
  <0.4454,0.9209>,<0.4488,1.0274>,<0.4458,1.1431>,<0.4250,1.2588>,<0.3742,1.3710>,
  <0.3029,1.5036>,<0.2298,1.6863>,<0.1873,1.9456>,<0.2025,2.2958>,<0.2686,2.7073>,
  <0.3650,3.1411>,<0.4880,3.5646>,<0.4904,3.9455>,<0.5373,4.2448>,<0.6438,4.4403>,
  <0.8165,4.5848>,<1.0450,4.7412>,<1.2989,4.9384>,<1.5419,5.1917>,<1.7341,5.4962>,
  <1.8466,5.8368>,<1.8978,6.1773>,<1.9234,6.5380>,<1.9794,7.1845>,<2.0948,8.3705>,
  <2.1693,10.056>,<2.1071,12.122>,<1.9584,14.422>,<1.8003,16.725>,<1.6730,18.489>,
  <1.5920,19.281>,<1.5109,19.442>,<1.3904,19.406>,<1.2800,19.238>,<1.2358,18.922>,
  <1.2528,18.504>,<1.3122,18.017>,<1.4021,17.388>,<1.5104,16.547>,<1.6186,15.563>,
  <1.7119,14.519>,<1.7952,13.414>,<1.8734,12.258>,<1.9312,11.184>,<1.9516,10.303>,
  <1.9312,9.5242>,<1.8751,8.7522>,<1.8088,8.0874>,<1.7578,7.6299>,<1.7272,7.2850>,
  <1.7136,6.9341>,<1.7000,6.5576>,<1.6643,6.1700>,<1.5776,5.8232>,<1.4212,5.5648>,
  <1.2240,5.3889>,<1.0157,5.2707>,<0.7821,5.1849>,<0.5146,5.1058>,<0.2725,5.0489>,
  <0.1151,5.0242>,<0.0341,5.0208>,<0.0042,5.0208>,<0.0000,5.0208>}

  // The Liquid for the glass
  #declare Liquid =
   intersection{
    intersection{
     sphere{<0,2.5,0>,1.5}
      object{Pilsner 
      scale<.6,.3,.6>
      translate<0,0,0>
      inverse }
     } // end intersection
    plane{y,2.75 }
   } // end intersection

  // Put the liquid in the glass
  #declare Drink =
  union{
    object{Pilsner 
     scale<.6,.3,.6>
      translate<0,.2,0>
       texture{
      pigment{rgbf<1,1,1,.98>}
     finish{ambient .1 diffuse .2 reflection .07}}
    interior{ior 1.43}
   }
      object{Liquid 
       translate y*.21
        pigment{rgbf<.8,.7,.2,1>}
       finish{ambient .35 diffuse .1 }
      interior{ior 1.33}
     scale .95
    }
   }

  // Put the glass on the coaster
  union{
  object{Drink translate 0 scale 1.5 }
  superellipsoid{<1,.5>scale<5,.02,5>pigment{rgb .75}finish{F}}
  translate<28,0,39>}

  // The End of this File - By: Ken Tyler 02-28-1999
