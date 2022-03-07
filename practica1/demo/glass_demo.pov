#include "colors.inc"

#declare ReflectionOK= 1; // turns on / off reflection
#declare TransparentOK= 1; // turns on / off transparency
#declare InteriorOK= 1;// turns on / off interior
#declare RadOK= 0; // turns on / off radiosity (use 2 for best quality)
#declare BlurOK= 1; // turns on / off focal blur
#declare Glass3OK= 1;
#declare DiceOK= 1;

global_settings {
    assumed_gamma 1
    max_trace_level 30
    #if (RadOK>0)
        radiosity {
            #if (RadOK=1)
                count 50
                error_bound 2
            #else
                count 200
                error_bound 0.1
            #end
            recursion_limit 2
            nearest_count 8
            brightness 1
            normal on
        }
    #end
}

// -----------------------------------------
// Camera
// -----------------------------------------
#declare Cam_Pos=<-60,94,-100>;
#declare Cam_Lookat=<-30,90,-40>;
#declare Focal_Point=vaxis_rotate(vaxis_rotate(-15*z,y,5),y,45)+<-25,85,-30>; // points to glass with icecube
#declare Focal_Point=vaxis_rotate(<4,0,3>,y,45)+<-25,85,-30>; // points to ashtray
#declare Focal_Point=<-10,85,-20>; // points to pitcher
#declare Focal_Point=<-31.5,82,-43>; // points to dices
camera{
    location Cam_Pos
    angle 28
    look_at Cam_Lookat
    #if (BlurOK=1)
        focal_point Focal_Point
        aperture 2
        confidence 0.99
        variance 0
        blur_samples 100
    #end
}

// -----------------------------------------
// Lighting
// -----------------------------------------
#if (RadOK=0)
    light_source{x*10000 White rotate z*35 rotate y*60}
    light_source{x*300 White*0.2 rotate z*35 rotate y*160 shadowless}
#end
sphere{
    0,1
    texture{
        pigment{
            gradient y
            scale 2
            translate -y
            color_map{
                [0.5 White]
                [1 rgb <150,200,255>/255]
            }
        }
        finish{ambient 12 diffuse 0}
    }
    scale 10000
    no_shadow
}


// ----------------------------------------------------
// Textures
// ----------------------------------------------------
#declare T_Clear=texture{pigment{Clear}finish{ambient 0 diffuse 0}}

#if (TransparentOK=1)
    #declare F_Glass=finish {
        ambient 0
        diffuse 0
        specular 0.8
        roughness 0.0003
        phong 1 
        phong_size 400
        reflection {
            0.01, 1
            fresnel on
        }
        conserve_energy
    }

    #declare T_Glass =texture{
        pigment{rgbf<1,1, 1, 0.95>}
        finish {F_Glass}
    }        

    #declare T_ColoredGlass =texture{
        pigment{rgbf<12*3,63*3, 11*3, 0.95*255>/255}
        finish {F_Glass}
    }        
    #declare T_Dice =texture{
        pigment{rgbf<0.34,0.32, 0.89, 0.95>}
        finish {F_Glass}
    }        

    #declare F_Liquid=finish{
        ambient 0
        diffuse 0
        phong 1
        phong_size 200
        reflection {
            0.01, 1
            fresnel on
        }
        conserve_energy
    }

    #declare I_Glass=interior{
        ior 1.51
        fade_distance 10
        fade_power 2
    }
    #declare I_Liquid=interior{
        ior 1.33
        fade_distance 10
        fade_power 2
    }

#else
    #declare F_Glass=finish{
        ambient 0
        diffuse 1
    }
               
    #declare T_Glass =texture{
        pigment{White}
        finish {F_Glass}
    }        
    #declare T_ColoredGlass =texture{
        pigment{Green}
        finish {F_Glass}
    }        
    #declare T_Dice =texture{
        pigment{SkyBlue}
        finish {F_Glass}
    }        
    #declare F_Liquid=finish{F_Glass}
    

#end

// ----------------------------------------------------
// Dice
// ----------------------------------------------------
#debug "Dice\n"
#declare V_WorldBoundMin = <-100.000015, -100.000000, -100.000000>;
#declare V_WorldBoundMax = <100.000000, 100.000008, 100.000000>;

#declare T_Dots=texture{pigment{White}finish{ambient 0 diffuse 1}}
#if(DiceOK=1)
    #include "dice_o.inc"
    #declare Dice1=object{
        Dice 
        #if (InteriorOK=1)
            interior{ior 1.5}
        #end 
        translate y*100 
        scale 1/100
    }
    #declare Dice2=object{
        Dice 
        #if (InteriorOK=1)
            interior{ior 1.5}
        #end 
        rotate x*90
        translate y*100 
        scale 1/100
    }
#else
    #declare Dice=box{V_WorldBoundMin,V_WorldBoundMax texture{T_Dice}}
    #declare Dice1=object{Dice translate y*100 scale 1/100}
    #declare Dice2=object{Dice rotate x*90 translate y*100 scale 1/100}
#end

// ----------------------------------------------------
// Glass 3 (tall)
// ----------------------------------------------------
#debug "Glass 3\n"
#declare yGlass3=21.2;
#if (Glass3OK=1)
    #declare V_WorldBoundMin = <-4.562918, 0.021400, -4.562918>;
    #declare V_WorldBoundMax = <4.562918, 31.787682, 4.562918>;
    #declare T_Liquid= texture{
        pigment{rgbf<1, 0.3, 0.2, 0.9>*0.8} 
        finish{F_Liquid}
    }        
    #include "glass3_o.inc"    
    #include "glass3_liquid_bottom_o.inc"
    #declare Glass3_Empty=union{ 
        
            object{ Dice1 }
            object{ Dice2 }
        object{ Glass3 
            #if (InteriorOK=1) 
                interior{I_Glass}
            #end
        }
        object{ Glass3_Liquid
            #if (InteriorOK=1) 
                interior{I_Liquid}
            #end
        }
        translate -y*V_WorldBoundMin.y
        scale yGlass3/(V_WorldBoundMax.y-V_WorldBoundMin.y)
    }                        

#else    
    #declare Glass3_Empty=cylinder{0,y*yGlass3,3 texture{pigment{Red}}}
#end

// ----------------------------------------------------
// Tiles
// ----------------------------------------------------
#declare T_Ceramic=texture{
    pigment{White}
    finish{ambient 0 diffuse 0.8 specular 1 roughness 1/30 reflection{0.2 fresnel on}}
}


#declare C_Tile1=rgb <249,242,148>/255;
#declare C_Tile2=C_Tile1;//rgb <21,41,71>/255; // use for checkers
#declare T_Tile1=texture{
    pigment{C_Tile1}
    normal{bumps 0.08 scale 100}
    finish{ambient 0 diffuse 0.7 specular 1 roughness 1/30 reflection{0.1 fresnel}}
}

#declare T_Tile2=texture{T_Tile1}
#declare C_Mortar=rgb <116,114,99>*2/255;
#declare T_Mortar=texture{
    pigment{granite color_map{[0 C_Mortar][1 C_Mortar*0.7]}}
    finish{ambient 0 diffuse 1}
}
#declare T_Spots=texture{
    pigment{
        dents
        color_map{
            [0.7 Clear]
            [1 rgbf <C_Tile1.red,C_Tile1.green,C_Tile1.blue, 1>*0.2]
        }
    }
    finish{ambient 0 diffuse 0.2}
    scale 1/4
}

#declare Sink=box{<-150,-11.5,-60>,<0,0,0> texture{T_Ceramic}}
#declare rd=seed(0);
#macro mTile(xTile,yTile,rTile,T_Tile)
    union{
        box{<rTile,rTile,-rTile>,<xTile-rTile,yTile-rTile,0>}
        cylinder{x*rTile,x*(xTile-rTile),rTile translate y*rTile}
        cylinder{x*rTile,x*(xTile-rTile),rTile translate y*(yTile-rTile)}
        cylinder{y*rTile,y*(yTile-rTile),rTile translate x*rTile}
        cylinder{y*rTile,y*(yTile-rTile),rTile translate x*(xTile-rTile)}
        sphere{<rTile,rTile,0>,rTile}
        sphere{<xTile-rTile,rTile,0>,rTile}
        sphere{<rTile,yTile-rTile,0>,rTile}
        sphere{<xTile-rTile,yTile-rTile,0>,rTile}
        scale <1,1,0.25>
        texture{T_Tile translate rand(rd)*10}
        texture{T_Spots translate rand(rd)*10 scale 1+rand(rd)*2}
    }
#end
#declare xTile=11;
#declare yTile=11;
#declare yTile2=4;
#declare rTile=0.6;
#declare Tiles_Back=union{
    #declare i=0;
    #while (i<15)
        #declare j=0;
        #while (j<7)
            #if (mod(j+i,2)=0)
                #declare T_Tile=texture{T_Tile1}
             #else
                #declare T_Tile=texture{T_Tile2}
             #end
            object{mTile(xTile,yTile,rTile,T_Tile) translate <-xTile-xTile*i,yTile*j,0>}
            #declare j=j+1;
        #end
        #declare i=i+1;
     #end
    box{<-rTile,-rTile,-rTile*0.1>,<-xTile*15+rTile,yTile*4+rTile,rTile> texture{T_Mortar}}
}
#declare Tiles_Side=union{
    union{
        #declare i=0;
        #while (i<3)
            #declare j=0;
            #if (mod(j+i,2)=0)
                #declare T_Tile=texture{T_Tile1}
             #else
                #declare T_Tile=texture{T_Tile2}
             #end
            #while (j<4)
                object{mTile(xTile,yTile,rTile,T_Tile) translate <xTile*i,yTile*j,0>}
                #declare j=j+1;
            #end
            #declare i=i+1;
         #end
        box{<-rTile,-rTile,-rTile*0.1>,<xTile*3+rTile,yTile*4+rTile,rTile> texture{T_Mortar}}
    }
    union{
        object{mTile(xTile,yTile,rTile,T_Tile1)}
        object{mTile(xTile,yTile,rTile,T_Tile2) translate x*xTile}
        object{mTile(xTile,yTile,rTile,T_Tile1) translate x*xTile*2}
        union{
            object{mTile(xTile,yTile2,rTile,T_Tile2)}
            object{mTile(xTile,yTile2,rTile,T_Tile1) translate x*xTile}
            object{mTile(xTile,yTile2,rTile,T_Tile2) translate x*xTile*2}
            translate y*yTile
        }
        box{<-rTile,-rTile,-rTile*0.1>,<xTile*3+rTile,yTile+yTile2+rTile,rTile> texture{T_Mortar}}
        translate x*xTile*3
    }
    rotate y*90
} 

// ----------------------------------------------------
// Room
// ----------------------------------------------------
#declare T_Room=texture{
    pigment{Red}
    finish{ambient  diffuse 1}
}
#declare PanelWindow=difference{
    box{<0,0,-2>,<100,130,5>}
    box{<6,6,-3>,<94,124,7>}
    box{<4,4,-4>,<96,126,-1>}
}
#declare Window=union{
    difference{
        box{<-5,-5,-1>,<105,135,4>}
        box{<0,0,-2>,<100,130,5>}
    }
    union{
        object{PanelWindow}
        object{PanelWindow translate x*100}
    }
    union{
        cylinder{0,y*130,4 scale <1,1,0.3>}
        union{
            cylinder{0,-z*4,2}
            sphere{0,1 scale <4,7,1> translate -z*4}
            translate y*130/3
        }
    }
}

#declare Room=union{
    difference{
        box{<-321,-1,-601>,<25,271,1>}
        box{<-320,0,-600>,<0,270,0>}
        box{<-1,0,0>,<30,130,-200> translate <0,80+yTile+yTile2,-3*xTile-5>}
//        box{<-1,0,0>,<30,130,-200> translate <0,80+yTile+yTile2,-3*xTile-250>}
        box{<-350,0,0>,<-300,130,-200> translate <0,80+yTile+yTile2,-3*xTile-250>}
    }
    object{Window rotate y*90 translate <0,80+yTile+yTile2,-3*xTile-5>}
//    object{Window rotate y*90 translate <0,80+yTile+yTile2,-3*xTile-250>}
    object{Window rotate y*90 scale <-1,1,1> translate <-320,80+yTile+yTile2,-3*xTile-250>}
    texture{T_Room}
}

// ----------------------------------------------------
// Scene
// ----------------------------------------------------
#declare Glassware=union{
    
    object{Glass3_Empty translate -16*z rotate y*14}
    
    
}

object{Room}

union{
    
    union{
        object{Glassware rotate y*45 translate <-25,0,-30>}
        
        object{Dice1 rotate y*40 translate <-32,0,-42>}
        object{Dice2 rotate -y*25 translate <-31,0,-47>}
        
        translate y*rTile*0.25
    }
    translate y*80
}

//sphere{0,10 pigment{Black}finish{reflection 1} translate Cam_Lookat}
