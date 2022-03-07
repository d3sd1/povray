#include "colors.inc"
#include "textures.inc"
#include "woods.inc"

camera        { location<0,0,-4> up y right x look_at <0,0,4>     }
light_source  { <0, 600,-500> color rgb <1,1,1>                   }
light_source  { <0,-600,-500> color rgb <1,1,1>                   }

#declare PdV=<0,55,-80>;
#declare PdA=<0,12,10>;
#declare R1 = seed(1);
#macro ra_angle()
  50*(rand(R1)-0.5)
#end

#declare R2 = seed(2);
#macro leaf_flower()
#declare l=0; #if (rand(R1)<0.7) #declare l=1; #end
l
#end

#declare wood_texture = texture {
   pigment { P_WoodGrain6A color_map { M_Wood6A }
   rotate z*90
   scale 0.1
   }
}

#declare leaf_texture = texture {
   pigment { color rgb <0,1,0> }
   finish {phong .1 phong_size 1        }
}

#declare leaf = disc { <1,0,0>, <0,0,1>, 1
    texture {leaf_texture                     }
    normal {wrinkles .2 scale <.5, 1, .2>     }
    scale <0.5,0.2,0.5>
}

#declare twig = union {
    cylinder {<0,0,0>,<1,0,0>, 0.1 }
    sphere   {<1,0,0>, 0.1         }
    texture  {wood_texture         }
}

#declare petal = cylinder {<1, 0, -1>, <1, 0, 1>, 1
    clipped_by {sphere {<0, 1, 0>, 1 scale <2, 1, 1>}}
    pigment {onion
       color_map {[0 rgb <1, 1, .3>] [.5 rgb <1,1,1>]}
       scale 3}
    normal {wrinkles .2 scale <.5, 1, .2>}
    finish {phong .1 phong_size 1}
    scale <1, 0.6, 0.4>}
                                      
#declare flower = union {                
    #declare phi = 0;                    
    #while (phi < 360)
       object {petal rotate y * phi}
       #declare phi = phi + (360/7);
    #end
    sphere {y, 1 scale <0.3, 0.2, 0.3>
       pigment {rgb <.9, .8, .4>}
       normal  {bumps 1 scale 0.02}}
    sphere {y, 1 scale <0.35, 0.35, 0.35> translate y * -0.3}
    cylinder {<0,-1,0>,<0,0,0>, 0.07}
      pigment {rgb <0.3, 0.5, 0.2>}
      finish {phong .1 phong_size 2}
    rotate z*(-90) scale 0.4 translate x*0.5
}

#macro draw_twig(i) 
  #if (i=0)  twig #else draw_twig(i-1) #end
#end

#macro draw_leaf(i)
  #if (i=0) #if (leaf_flower()=1) leaf #else flower #end
  #else union {
     object{ draw_twig(i-1) translate -x                          }
     object{ draw_leaf(i-1) rotate z*(45+ra_angle()) rotate x*0*360/3 }
     object{ draw_leaf(i-1) rotate z*(45+ra_angle()) rotate x*1*360/3 }
     object{ draw_leaf(i-1) rotate z*(45+ra_angle()) rotate x*2*360/3 }
     translate x scale 0.6
  }
  #end
#end

#macro draw_plant(i)
  object{ draw_leaf(i) rotate z*90 translate y*(-0.8) scale 2.0}
#end

object{ draw_plant(7) rotate y*360*clock }


sky_sphere{pigment{gradient y color_map{[0.5 White][0.6 rgb <92,126,202>/225]}}}
    #declare P_Apple_Skin=pigment{image_map{jpeg "apple_map.jpg" interpolate 2} }	    
    #declare N_Apple_Skin=normal{bump_map{jpeg "apple_bump.jpg" interpolate 2} bump_size 3}	
    #declare F_Apple_Skin = finish{ambient 0 diffuse 1 specular 0.9 roughness 0.002
    reflection{0,0.3 fresnel on}
    } 
        
    #declare P_Apple_Stem=pigment{image_map{jpeg "stem_map.jpg" interpolate 2} }	    
    #declare N_Apple_Stem=normal{bump_map{jpeg "stem_bump.jpg" interpolate 2} bump_size 2 }	    
    
    
    #declare T_Apple_Skin= texture{
        pigment{P_Apple_Skin} 
        normal{N_Apple_Skin} 
        finish{F_Apple_Skin} 
    } 
    
    #declare T_Apple_Stem = texture{
    	pigment { P_Apple_Stem}
    	normal{N_Apple_Stem} 
    	finish{ambient 0 diffuse 1 specular 0.05 roughness 0.01}
    }
    
    
    
    #include "apple.inc"
    #declare Apple=union{
        object{Apple_Skin interior{ior 1.55}}
        object{Apple_Stem}
        scale 0.01
    } 


#declare Ground=plane{y,-1.3
    texture{
        pigment{
            bozo turbulence 1 lambda 3 color_map{[0 rgb <0.1,0.1,0.1>*0.7][1 rgb <0.64,0.52,0.33>*0.5]}
            scale 0.2
        }
       
    }
}
#declare Sky=plane{y,-50
    texture{
        pigment{
            bozo turbulence 1 lambda 3 color_map{[0 rgb <0.1,0.1,0.9>*0.7][1 rgb <0.64,0.52,0.33>*0.5]}
            scale 0.2
        }
       
    }
}
//==========================================  
// Details
//==========================================  

object{Sky rotate x*-90}

object{Ground translate z*4}
object{Apple translate x*-1.2 translate y*-0.2}
object{Apple translate x*-1.3 translate y*0.35}
object{Apple translate x*-1.3 translate y*-0.35}
object{Apple translate x*-1 translate y*0.5}
object{Apple translate x*1.1 translate y*0.5}
object{Apple translate x*1.1 translate y*0.1}
object{Apple translate x*0.9 translate y*0.25}
object{Apple translate x*0.45 translate y*-0.5}