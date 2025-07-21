game.AddParticles( "particles/t.pcf" )
PrecacheParticleSystem("core_warpbase")
PrecacheParticleSystem("core_warp**")
PrecacheParticleSystem("core_warp*")
PrecacheParticleSystem("core_warp*1")
PrecacheParticleSystem("core_warp")
PrecacheParticleSystem("1")
PrecacheParticleSystem("2")
PrecacheParticleSystem("3")
PrecacheParticleSystem("or")

---- FOR WORDS FROM ME LOOK AT SHARED IN WEAPONS :)
---- Copyright frestylek 2022 :D

---- FOR HANDS YEY 
---- Thanks to "Twilight Sparkle"
---- https://steamcommunity.com/id/twil_spark

function PlayShiftAnim(ply)
	if game.SinglePlayer() and SERVER then
		ply:SendLua('if VManip then VManip:PlayAnim("phase") end')
		return
	end
	if CLIENT then
		VManip:PlayAnim("phase")
	end
end
----- ENDS HANDS






if SERVER then
resource.AddFile("particles/t.pcf")
PrecacheParticleSystem("core_warpbase")
PrecacheParticleSystem("core_warp**")
PrecacheParticleSystem("core_warp*")
PrecacheParticleSystem("core_warp*1")
PrecacheParticleSystem("core_warp")
PrecacheParticleSystem("1")
PrecacheParticleSystem("2")
PrecacheParticleSystem("3")
PrecacheParticleSystem("or")
end	

CreateConVar( "frest_Phasesee", 1, {FCVAR_REPLICATED, FCVAR_ARCHIVE}, "If Enable you can see other people \n when phaseing in the same time" ) 
CreateConVar( "frest_Cooldown", 5, {FCVAR_REPLICATED, FCVAR_ARCHIVE}, "Cooldown on phaseshifting" ) 
CreateConVar( "frest_Long", 7, {FCVAR_REPLICATED, FCVAR_ARCHIVE}, "How long you can Phaseshift" )
if CLIENT then
	CreateClientConVar( "frest_bindp", KEY_G, true, true, "Key for Phase Shift" ) 
end

if CLIENT then

	function frestStandsSetting(panel)
		check = panel:CheckBox("If Enable you can see other people\nwhen phaseing in the same time", "frest_Phasesee")
		check:SetValue(true)		
		check = panel:NumSlider("Sets Cooldown for phase\n0 will delete cooldown", "frest_Cooldown",0,60 )
		check:SetValue(5)		
		check = panel:NumSlider("How long you can stay\ninside phase", "frest_Long",3,60 )
		check:SetValue(7)
		check1 = panel:KeyBinder("Bind for Phase Shift", "frest_bindp" )
		
	end
end

function frestsetting()
	spawnmenu.AddToolMenuOption("Options", "frestsetting", "frestset", "PhaseShift Options", "", "", frestStandsSetting)
end

hook.Add("PopulateToolMenu", "frestsetting", frestsetting)

if SERVER then
util.AddNetworkString( "blinking" )
util.AddNetworkString( "check" )
end

local pattern = Material("pp/texturize/plain.png")

		hook.Add( "RenderScreenspaceEffects", "blink", function()
		if LocalPlayer():GetNWBool("blinking",false) == true then
		DrawTexturize( 1, pattern )
		DrawMaterialOverlay("effects/water_warp01",0.06)
		end
		end )

function Spawnparicles()
	if !IsValid(CMOON) and SERVER then 
		local stando = ents.Create("ent_fres_part")
		if stando:IsValid() then
				stando:Spawn()
				CMOON = stando
		end 
	end
end

hook.Add("PostCleanupMap", "blink", Spawnparicles)

hook.Add( "PlayerInitialSpawn", "blink", function( ply )
	if !IsValid(CMOON) then
	Spawnparicles()
	end
end)

  	
if SERVER then
net.Receive("blinking", function()
	local player = net.ReadEntity()
	local player2 = net.ReadEntity()
	check(player,player2)
end)
end

function check(player1,player2)
			if player2 == nil then
			for i, v in ipairs( player.GetAll() ) do
				if v:IsPlayer() or v:IsNPC() then
				player2 = player1
				player1 = v

				if (player1:GetNWBool("blinking",false) != player2:GetNWBool("blinking",false)) or (player1:GetNWBool("blinking",false) == true and player1:GetNWBool("blinking",false) == player2:GetNWBool("blinking",false) and GetConVar("frest_Phasesee"):GetBool() == false) then
					RecursiveSetPreventTransmit(player1, player2, true)
				elseif player1:GetNWBool("blinking",false) == player2:GetNWBool("blinking",false) and GetConVar("frest_Phasesee"):GetBool() == true then
					RecursiveSetPreventTransmit(player1, player2, false)
					RecursiveSetPreventTransmit(player2, player1, false)
				elseif player1:GetNWBool("blinking",false) == player2:GetNWBool("blinking",false) then
					RecursiveSetPreventTransmit(player1, player2, false)
					RecursiveSetPreventTransmit(player2, player1, false)
				end
				end
				player1 = player2
				player2 = nil
				end
			
			for i, v in ipairs( ents.FindByClass( "npc_*" ) ) do
				if v:IsPlayer() or v:IsNPC() then
				player2 = player1
				player1 = v
				
				if player2:GetNWBool("blinking",false) == false then
					RecursiveSetPreventTransmit2(player1, player2, false)
				elseif player2:GetNWBool("blinking",false) == true then
					RecursiveSetPreventTransmit2(player1, player2, true)
				end
				end
				end
			
				else
				if player1:GetNWBool("blinking",false) != player2:GetNWBool("blinking",false) then
					RecursiveSetPreventTransmit(player1, player2, true)
				elseif player1:GetNWBool("blinking",false) == player2:GetNWBool("blinking",false) and GetConVar("frest_Phasesee"):GetBool() == true then
					RecursiveSetPreventTransmit(player1, player2, false)
				elseif player1:GetNWBool("blinking",false) == player2:GetNWBool("blinking",false) then
					RecursiveSetPreventTransmit(player1, player2, false)
				end
			end
end

hook.Add("PrePlayerDraw", "blink", function(player)
					if player:GetNWBool("blinking",false) != LocalPlayer():GetNWBool("blinking",false) then
						net.Start("blinking")
							net.WriteEntity(player)
							net.WriteEntity(LocalPlayer())
						net.SendToServer()
					else
					return
					end
end)

function RecursiveSetPreventTransmit2(ent, ply, stopTransmitting)
    if ent ~= ply and IsValid(ent) and IsValid(ply) then
        ent:SetNoDraw(stopTransmitting)
        local tab = ent:GetChildren()
        for i = 1, #tab do
            RecursiveSetPreventTransmit2(tab[ i ], ply, stopTransmitting)
        end
    end
end

function RecursiveSetPreventTransmit(ent, ply, stopTransmitting)
    if ent ~= ply and IsValid(ent) and IsValid(ply) then
        ent:SetPreventTransmit(ply, stopTransmitting)
        local tab = ent:GetChildren()
        for i = 1, #tab do
            RecursiveSetPreventTransmit(tab[ i ], ply, stopTransmitting)
        end
    end
end
hook.Add("PlayerShouldTakeDamage", "blink", function( ent1, ent2 )
	if ent1:GetNWBool("blinking",false) != ent2:GetNWBool("blinking",false) then
			return false
	else
		return true
	end
end)
hook.Add("EntityTakeDamage", "blink", function( ent1, dmginfo )
		if ent1:GetNWBool("blinking",false) == true and dmginfo:IsExplosionDamage() then
			return true
		end
end)

if SERVER then
hook.Add("ShouldCollide", "blink", function( ent1, ent2 )
    -- If players are about to collide with each other, then they won't collide.
	if SERVER then
	if ent1:IsPlayer() and (ent2:IsPlayer() or ent2:IsNPC()) then
	if (ent1:GetNWBool("blinking",false) != ent2:GetNWBool("blinking",false)) or 
	(GetConVar("frest_Phasesee"):GetBool() == false and ent1:GetNWBool("blinking",false) == ent2:GetNWBool("blinking",false) and ent1:GetNWBool("blinking",false) == true) then
		return false
	end
	end
	end 
	return
end )
end

function blinkfrest(ply)
local Owner = ply
local t = ply
		if SERVER then
		if Owner:GetNWBool("blinking",false) == true and !IsValid(Owner:GetNWEntity("blink",nil)) then
		Owner:SetNWFloat("blinkt",CurTime() + GetConVar("frest_Cooldown"):GetInt())
		end
		if SERVER and !IsValid(Owner:GetNWEntity("blink",nil)) then

		stando = ents.Create("ent_wall_fres")
		if stando:IsValid() then
			stando:SetOwner( Owner )
			stando:SetPos(Owner:EyePos() - Vector(0,0,math.random(5,15)))
			stando:Spawn()
			Owner:SetNWEntity("blink",stando)
		end
		Owner:SetLaggedMovementValue( 0.3 )
		Owner:SetNWFloat("blinking1",0.01)
		end
		end
		end



hook.Add( "PlayerButtonDown", "blink", function( ply, button )
	if button == ply:GetInfoNum("frest_bindp",KEY_G) and ply:HasWeapon("fres_blink") and SERVER then 
		if !IsValid(ply:GetNWEntity("blink",nil)) and ply:GetNWFloat("blinkt",CurTime()) <= CurTime() then
			if ply:GetNWBool("blinking",false) == true then
				ply:SetNWFloat("blinky",CurTime())
			else
				ply:SetNWFloat("blinky",CurTime() + GetConVar("frest_Long"):GetInt())
			end
				ply:SendLua('if VManip and LocalPlayer():GetNWBool("blinking",false) == false and VManip:GetCurrentAnim() != "phase" then VManip:PlayAnim("phase") elseif VManip and VManip:GetCurrentAnim() == "phase" then VManip:QuitHolding("phase") end')
				
			if SERVER and !IsValid(ply:GetNWEntity("blink",nil)) then
				Owner = ply
				Owner:SetCustomCollisionCheck(true) 
				Owner:SetNWFloat("blinkt",CurTime() + 2 )
				blinkfrest(ply)
			end
		end
	end
	end)





hook.Add( "PostDrawHUD", "blink1", function()
if LocalPlayer():HasWeapon("fres_blink") then
	if czcionka != true and CLIENT then
		local mult = ScrW() / ScrH()
		czcionka = true
	surface.CreateFont("fontstand", {

		font = "Comic Sans MS",

		size = 15,
	
		weight = 600,
	
		blursize = 0,

		scanlines = 0,

		antialias = true,

		underline= false,

		rotary = false,

		shadow = false,

		additive = true,

		outline = false
			
	})
	end




------------ HUD PHASE
			local long = (LocalPlayer():GetNWFloat("blinky",CurTime()) - CurTime())/((CurTime()+ GetConVar("frest_Long"):GetInt()) - CurTime() )
			local at = ((LocalPlayer():GetNWFloat("blinkt",CurTime()) - CurTime())/ GetConVar("frest_Cooldown"):GetInt() )
			local longt = Lerp(long,500,0)
			local att = Lerp(at,0,500)
			
			local boxW,boxH = ScrW()*500/ 1920, 39 * ScrH() / 1920
			local boxofW, boxofH = ScrW() /2 - boxW/2 , ScrH() * 0.908
		
			
			
			
			
			
			
			
			
			if Lerp((LocalPlayer():GetNWFloat("blinkt",CurTime()) - CurTime())*0.2,0,500) == 0 and LocalPlayer():GetNWBool("blinking",false) == false then
				surface.SetDrawColor(100,255,100,200)
			else
				surface.SetDrawColor(200,100,100,200)
			end
			surface.DrawRect(boxofW, boxofH, boxW, boxH)
			if LocalPlayer():GetNWBool("blinking",false) == true then
			surface.SetDrawColor(0,0,0,200)
			surface.DrawRect(boxofW, boxofH, longt * ScrW() / 1920, boxH)
			elseif LocalPlayer():GetNWBool("blinking",false) == false and LocalPlayer():GetNWFloat("blinking1",0) == 0 then
				surface.SetDrawColor(0,0,0,200)
				surface.DrawRect(	boxofW, boxofH, att * ScrW() / 1920,boxH)
			end
		if LocalPlayer():GetNWFloat("blinkt",CurTime()) - CurTime() > 0 and LocalPlayer():GetNWBool("blinking",false) == false and LocalPlayer():GetNWFloat("blinking1",0) == 0 then
			
			draw.SimpleText( math.floor(( LocalPlayer():GetNWFloat("blinkt",CurTime()) - CurTime() ) +0,5), "fontstand", boxofW + boxW/2, boxofH, color_white, TEXT_ALIGN_CENTER )

		end
	end
end)

		hook.Add( "RenderScreenspaceEffects", "blink1", function()
			if LocalPlayer():GetNWFloat("blinking1",0) > 0 then
		DrawMaterialOverlay("effects/strider_pinch_dudv",LocalPlayer():GetNWFloat("blinking1",0)) 
		end

		end)



