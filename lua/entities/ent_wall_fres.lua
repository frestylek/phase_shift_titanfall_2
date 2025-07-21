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
	self.Owner = self:GetOwner()
	self:PhysicsInit( SOLID_NONE ) 
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_NONE )
	self.a = CurTime() + 1
	self.b = CurTime() + 0.3
	self:DrawShadow( false ) 
	self:EmitSound( "phase.wav", 55, 100, 1, CHAN_AUTO )
	if SERVER then
	self:SetPos(self.Owner:EyePos())
	self.start = self.Owner:EyePos()
	end
		ParticleEffect( "core_warpbase", self.start or self:GetPos(), Angle(0,0,0),self)
		 

		end

function ENT:Think()
local t = self:GetOwner()
local owner = self:GetOwner()
	if self.a <= CurTime() and SERVER then
		self:Remove()
	end
	if self.b <= CurTime() and SERVER then
		
			if t != nil then 
				self.b = CurTime() + 30
				t:SetNWBool("blinking",!t:GetNWBool("blinking",false))
				t:CollisionRulesChanged()
				check(t)
				t:SetLaggedMovementValue( 1 )
				t:SetNWFloat("blinking1",0)
				t:SetNoTarget(t:GetNWBool("blinking",false))
		end
	end
	if owner:GetNWFloat("blinking1",0) > 0 and CLIENT then
	owner:SetNWFloat("blinking1",owner:GetNWFloat("blinking1",0)+0.01)
	end
end
	
 
function ENT:OnRemove()
end

 
 
 
 
 
 
 
 
 
 
 
 
 