if ( SERVER ) then
AddCSLuaFile()
end
SWEP.PrintName		= "Phase Shift"
SWEP.Author		= "frestylek"
SWEP.Instructions	= ""
SWEP.Category		= "frestStands TitanFall 2"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize	= -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo	= "none"

SWEP.Slot			= 2
SWEP.SlotPos			= 1
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true

SWEP.ViewModelFOV		= 54
SWEP.ViewModel = ""
SWEP.WorldModel = ""
SWEP.UseHands   		= true 

SWEP.HitDistance = 40
SWEP.Damage = 0

SWEP.OldColor = Color( 255, 255, 255, 255 )
SWEP.AlphaLerp = 255


-- Hi to everyone who read this. I hope you have fun with this mod!	Copper you too																																																																																																				i dont give permision to anyone to copy addon or animation or code from here :D you can ask first or i will report this <3
-- This time Phase Shift :D i made it in one night XD. so have fun and pls dont steal it just ask for it.

-- i really want to thanks Copper for inspiration that push me to learn code in gmod. without copper i will never make anythink in gmod!


-- Authors frestylek#1898
-- Discord: https://discord.gg/3VtCsUvAFf


game.AddParticles( "particles/t.pcf" )
PrecacheParticleSystem("core_warpbase")
PrecacheParticleSystem("core_warp**")
PrecacheParticleSystem("core_warp*")
PrecacheParticleSystem("core_warp*1")
PrecacheParticleSystem("core_warp")
PrecacheParticleSystem("1")
PrecacheParticleSystem("2")
PrecacheParticleSystem("3")

if SERVER then
util.AddNetworkString( "blinking" )
end



function SWEP:Think()
local owner = self:GetOwner()


end

function SWEP:Initialize()
self:SetHoldType( "normal" )
self.MIH = nil
self.timer = CurTime() - 1
end 

function SWEP:blink()
self.t = self:GetOwner()
		if SERVER then
		if self.Owner:GetNWBool("blinking",false) == true then
		self:SetNextPrimaryFire( CurTime() + GetConVar("frest_Cooldown"):GetInt() )
		end
		if SERVER and (self.MIH == nil or !self.MIH:IsValid()) then

		stando = ents.Create("ent_wall_fres")
		if stando:IsValid() then
			stando:SetOwner( self.Owner )
			stando:SetPos(self.Owner:EyePos() - Vector(0,0,math.random(5,15)))
			stando:Spawn()
			self.MIH = stando
		end
		self.Owner:SetLaggedMovementValue( 0.3 )
		self.Owner:SetNWFloat("blinking1",0.01)
		timer.Simple(0.3,function()
			if self.t != nil then 
				self.t:SetNWBool("blinking",!self.t:GetNWBool("blinking",false))
				self.t:CollisionRulesChanged()
					check(self.t)
				self.t:SetLaggedMovementValue( 1 )
				self.t:SetNWFloat("blinking1",0)
					self.t:SetNoTarget(self.t:GetNWBool("blinking",false))
		end
		end)
	end

	
	end

end


function SWEP:PrimaryAttack()
local ply = self:GetOwner()
local Owner = self:GetOwner()
if !IsValid(ply:GetNWEntity("blink",nil)) and ply:GetNWFloat("blinkt",CurTime()) <= CurTime() then
			if ply:GetNWBool("blinking",false) == true then
				Owner:SetNWFloat("blinky",CurTime())
			else
				Owner:SetNWFloat("blinky",CurTime() + GetConVar("frest_Long"):GetInt())
			end
			
			if SERVER and !IsValid(ply:GetNWEntity("blink",nil)) then
				Owner = ply
				Owner:SetCustomCollisionCheck(true) 
				Owner:SetNWFloat("blinkt",CurTime() + 2 )
				blinkfrest(ply)
			end
		end
end


function SWEP:Holster( wep )
	local owner = self:GetOwner()
		return true
end

function SWEP:SecondaryAttack()

end

function SWEP:Reload()

end

function SWEP:OnRemove()	
self.Owner = self:GetOwner()
	if IsValid(self.Owner) then
	if CLIENT then
	self.Owner:SetNWFloat("blinking1",0)
	self.Owner:CollisionRulesChanged()
	end
	if SERVER then
	self.Owner:SetNWBool("blinking",false)
	self.Owner:SetNWFloat("blinking1",0)
	self.Owner:CollisionRulesChanged()
	check(self.Owner)
	end
	end
end
	
function SWEP:OnDrop()
	self:Remove() -- You can't drop fists-
end