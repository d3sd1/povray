//Projection of a cube

//Load some interesting colors and textures
#include "colors.inc"
#include "stones.inc"
#include "glass.inc"
#include "metals.inc"
#include "woods.inc"

//Describe the location of the camera and where it is aimed
camera { 
  location <3,0,-6>
  look_at <0,0,0> 
  angle 65
}

//Define a background color
background { color White }

//Describe the location and color of the light sources
light_source { 
  <0,5000,0> 
  color White*2
  }   
  
light_source {
 <5,-2,-4>
 color White*3
 }
 
//Define the coordinates of the eight vertices
#declare p1 = <-1,-1,-1>;
#declare p2 = <-1,-1,1>;
#declare p3 = <-1,1,-1>;
#declare p4 = <-1,1,1>;
#declare p5 = <1,-1,-1>;
#declare p6 = <1,-1,1>;
#declare p7 = <1,1,-1>;
#declare p8 = <1,1,1>;

//radius of framework
#declare r = .1;

//texture of cube elements
#declare ss = texture{T_Copper_3B};
#declare cs = texture{T_Copper_3B};

//the cubical framework

object{union{
sphere { p1, r texture{ss}} 
sphere { p2, r texture{ss}}
sphere { p3, r texture{ss}} 
sphere { p4, r texture{ss}} 
sphere { p5, r texture{ss}} 
sphere { p6, r texture{ss}} 
sphere { p7, r texture{ss}} 
sphere { p8, r texture{ss}} 

cylinder { p1,p2,r texture{cs}}
cylinder { p1,p3,r texture{cs}}
cylinder { p1,p5,r texture{cs}}
cylinder { p2,p6,r texture{cs}}
cylinder { p2,p4,r texture{cs}}
cylinder { p3,p7,r texture{cs}}
cylinder { p3,p4,r texture{cs}}
cylinder { p4,p8,r texture{cs}}
cylinder { p5,p7,r texture{cs}}
cylinder { p5,p6,r texture{cs}}
cylinder { p6,p8,r texture{cs}}
cylinder { p7,p8,r texture{cs}}
}
rotate y*45
rotate x*55
translate y}

//projection surface
polygon{5, <-4,-2,-4>,<-4,-2,4>,<4,-2,4>,<4,-2,-4>,<-4,-2,-4>
texture{T_Stone18}} 






