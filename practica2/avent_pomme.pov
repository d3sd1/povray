// ========================================
// Apple and stone texture
// -----------------------------------------
// Made for Persistence of vision 3.6
//==========================================  
// Copyright 2006 Gilles Tran http://www.oyonale.com
// -----------------------------------------
// This work is licensed under the Creative Commons Attribution License. 
// To view a copy of this license, visit http://creativecommons.org/licenses/by/2.0/ 
// or send a letter to Creative Commons, 559 Nathan Abbott Way, Stanford, California 94305, USA.
// You are free:
// - to copy, distribute, display, and perform the work
// - to make derivative works
// - to make commercial use of the work
// Under the following conditions:
// - Attribution. You must give the original author credit.
// - For any reuse or distribution, you must make clear to others the license terms of this work.
// - Any of these conditions can be waived if you get permission from the copyright holder.
// Your fair use and other rights are in no way affected by the above. 
//==========================================  
#include "colors.inc"
#declare RadOK=2; // 0=no radiosity ; 1= low quality rad; 2= good quality
#declare AppleOK=1; // turns all snails on
#declare BlurOK=0; // focal blur
#declare AreaOK=1; // area light
global_settings {
    max_trace_level 5
    //---------------------------------------
    // change gamma if necessary (scene too bright for instance)
    //---------------------------------------
    assumed_gamma 1
    //---------------------------------------
    noise_generator 1
    #if (RadOK>0)
        radiosity{
            #switch (RadOK)
                #case (1)
                    count 35 error_bound 1.8 
                #break
                #case (2)
                    count 100 error_bound 0.1
                #break
            #end    
            nearest_count 5 
            recursion_limit 1  
            low_error_factor 0.2 
            gray_threshold 0 
            minimum_reuse 0.015 
            brightness 1 
            adc_bailout 0.01/2      
            normal on
            media off
        }
    #end
}


#declare Camera=camera{
        location z*-30+y*10
        direction z*2
        up y
        right x*image_width/image_height
        look_at <0,4,0>
        #if (BlurOK=1)
            aperture 3
            blur_samples 20
            focal_point <0,4,0> 
            confidence 0.96
            variance 1/300 
        #end
}
#declare Camera2=camera{ // test camera
      location z*-1000+y*1000
      direction z*1
      up y
      right x*image_width/image_height
      look_at <0,2,0>
}
camera{Camera}
//camera{Camera2}

#declare C_Sun= rgb <1,0.98,0.96>;

light_source{-z*10000,color C_Sun*1.5 rotate x*30 rotate y*88
    #if (AreaOK=1)
        area_light 50*x,50*y,5,5 adaptive 1 jitter orient circular
    #end
}


sky_sphere{pigment{gradient y color_map{[0.5 White][0.6 rgb <92,126,202>/225]}}}



#if (AppleOK=1)
    
    
    #declare P_Apple_Skin=pigment{image_map{jpeg "apple_map.jpg" interpolate 2} }	    
    #declare N_Apple_Skin=normal{bump_map{jpeg "apple_bump.jpg" interpolate 2} bump_size 3}	
    #declare F_Apple_Skin = finish{ambient 0 diffuse 1 specular 0.9 roughness 0.002
    reflection{0,0.3 fresnel on}
    } 
        
    #declare P_Apple_Stem=pigment{image_map{jpeg "stem_map.jpg" interpolate 2} }	    
    #declare N_Apple_Stem=normal{bump_map{jpeg "stem_bump.jpg" interpolate 2} bump_size 2 }	    
    
    
    #declare T_Apple_Skin= texture{ // Peau
        pigment{P_Apple_Skin} 
        normal{N_Apple_Skin} 
        finish{F_Apple_Skin} 
    } 
    
    #declare T_Apple_Stem = texture{ // Stem
    	pigment { P_Apple_Stem}
    	normal{N_Apple_Stem} 
    	finish{ambient 0 diffuse 1 specular 0.05 roughness 0.01}
    }
    
    
    
    #include "apple.inc"
    #declare Apple=union{
        object{Apple_Skin interior{ior 1.55}}
        object{Apple_Stem}
        scale 8/18
    } 

    #declare P_Apple_Skin=pigment{image_map{jpeg "apple_red_map.jpg" interpolate 2} }	    
    #declare T_Apple_Skin= texture{ // Peau
        pigment{P_Apple_Skin} 
        normal{N_Apple_Skin} 
        finish{F_Apple_Skin} 
    } 
    #include "apple.inc"
    #declare Apple2=union{
        object{Apple_Skin interior{ior 1.55}}
        object{Apple_Stem}
        scale 8/18
    } 

#else
    #declare Apple=sphere{0,4 translate y*4 texture{pigment{Yellow}finish{ambient 0 diffuse 1 specular 0.05 roughness 0.01}}}
    #declare Apple2=sphere{0,4 translate y*4 texture{pigment{Yellow}finish{ambient 0 diffuse 1 specular 0.05 roughness 0.01}}}
#end
// stone ground
#declare Ground=plane{y,0 
    texture{
        pigment{
            bozo turbulence 1 lambda 3 color_map{[0 rgb <0.9,0.83,0.77>*0.7][1 rgb <0.64,0.52,0.33>*0.5]}
            scale 10
        }

        normal{
            bump_map{jpeg "stone11.jpg"} 
            bump_size 5
            rotate x*90
            scale 40
        }

        finish{
            ambient 0 
            diffuse 1
        }
        rotate -y*20
       
    }
}
//==========================================  
// All the objets
//==========================================  

object{Ground}
object{Ground rotate x*-90 translate z*4}
object{Apple translate x*3}
object{Apple2 scale 0.8 rotate y*90 translate x*-4}
              