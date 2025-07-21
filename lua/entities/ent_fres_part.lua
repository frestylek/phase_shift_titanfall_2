AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"
-- solution for multiple gasterblaster in minigame
ENT.Editable		= true
ENT.PrintName		= "effect"
ENT.Spawnable 		= false
ENT.AdminSpawnable 	= false

--[[if SERVER then
util.AddNetworkString( "Sans Game" )

util.AddNetworkString( "sans stop" )
util.AddNetworkString( "sans win" )
end
if SERVER then
util.AddNetworkString("SansGameUpCoordinate")
end
net.Receive("SansGameUpCoordinate", function(_, ply)
  local gametag1 = net.ReadFloat()
  local sans = net.ReadEntity()
  local enemy = net.ReadEntity()
  local gametag = sans:Name()..enemy:Name()
  SetGlobalFloat("posy"..gametag,gametag1+10)
end)

]]

function ENT:Draw()

end




function ENT:Initialize()
	self:PhysicsInit( SOLID_NONE ) 
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_NONE )
	self:DrawShadow( false ) 

end

function ENT:Think()
if SERVER then
	for k,v in pairs(player.GetAll()) do
			if v:GetNWBool("blinking",false) == true and v:GetNWFloat("blinky",CurTime()) <= CurTime() then
				v:SendLua('if VManip and VManip:GetCurrentAnim() == "phase" then VManip:QuitHolding("phase") end')
				blinkfrest(v)
			end
			if IsValid(v) and (!v:Alive() or !v:HasWeapon("fres_blink")) and v:GetNWBool("blinking",false) == true then
				blinkfrest(v)
			end
	
		if v:GetNWBool("blinking",false) == false then self:SetPreventTransmit(v, true) ParticleEffect( "or", v:GetPos(), Angle(0,0,0),self)
		else 
			self:SetPreventTransmit(v, false)
			self:SetPos(v:GetPos())
		end
	end

	for k, v in pairs( ents.FindByClass( "npc_*" ) ) do
		if v:GetNWBool("blinking",false) == false then ParticleEffect( "or", v:GetPos(), Angle(0,0,0),self) end
	end
	
self:NextThink(CurTime()+2)

end
end
	
 
function ENT:OnRemove()
end

 
 
 
 
 
 
 
 
 
 
 
 
 