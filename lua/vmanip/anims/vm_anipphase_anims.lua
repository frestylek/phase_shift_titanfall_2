AddCSLuaFile()

VManip:RegisterAnim("phase",
{
["model"]="c_arms_phasewalk.mdl",
["lerp_peak"]= 10,
["lerp_speed_in"]=0.4,
["lerp_speed_out"]=1,
["lerp_curve"]=2.5,
["speed"]=1,
["startcycle"]=0.1,
["loop"]=false,
["cam_angint"]={1,1,1},
["cam_ang"]=Angle(0,0,0),
["holdtime"]= 0.3
}
)


