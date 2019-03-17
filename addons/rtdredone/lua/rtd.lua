
  --  New Code Author: [MK] MadkillerMax
--	Original AUTHOR: Wesnc
--	CREDITS:MakeR, |Flapjack|, Ram
	
--	TODO:
--		(6-24-2011)ADD TEXT COLOR!

AddCSLuaFile("cl_rtd.lua")
AddCSLuaFile("autorun/rtd_load.lua")

local rtd = CreateConVar("rtd_enabled", 1) -- Enable/Disable Roll The Dice
local name = CreateConVar("rtd_roll_name", 1) -- Setting to any other number will disable
local point = CreateConVar("rtd_roll_pointshop", 0) -- set to 1 if you have pointshop (google gmod pointshop facepunch) if not, set it to ANY OTHER NUMBER!
local noclip = CreateConVar("rtd_roll_noclip_allow", 0) -- Allow players to have noclip as RTD
local golden = CreateConVar("rtd_roll_goldenforge", 0) -- set to 1 if you have goldenforge (google gmod goldenforge) if not, set it to ANY OTHER NUMBER!
local maxrolls = CreateConVar("rtd_rolls_max", 200) -- max rolls per user
local rollinterval = CreateConVar("rtd_rolls_interval", 10) -- interval between rolls in seconds

local dice = {} -- Things with methods need to be global  

local rtd = rtd:GetInt()
local pointshop = point:GetInt()
local goldenforge = golden:GetInt()
local name = name:GetInt()
local noclip = noclip:GetInt()
local rollinterval = rollinterval:GetInt()
local timeleft = rollinterval

local health = math.random(-75,75)
local frags = math.random(-5,10)
local duration = math.random(6,19)
local armor = math.random(10,25)

local meta = FindMetaTable("Player")

function meta:RTD(reason)
	if (reason) then
		umsg.Start("rtd_cmsg", self)
			umsg.String(tostring(reason))
		umsg.End()
	end
end

dice.outcomes = {
	
	Ignite = function( ply ) 
		for k, v in pairs(player.GetAll()) do
			v:RTD(ply:Nick().." has been ignited for "..duration.." seconds!") 
		end  
		ply:Ignite(duration, 0) 
		ply:SetColor(255, 0, 0, 255)
		timer.Simple(duration, function(ply)
			ply:SetColor(255, 255, 255, 255)
		end, ply)
    end,
	
	Noclipinvis = function( ply )
		if noclip == 1 then
			for k, v in pairs(player.GetAll()) do
				v:RTD(ply:Nick().." got extreme luck! He won noclip and partial invisablility for "..duration.." seconds!")
			end
			ply:SetMoveType(MOVETYPE_NOCLIP)
			ply:SetNoDraw(true)
			timer.Simple(duration, function(ply)
				ply:Freeze(false)
				for k, v in pairs(player.GetAll()) do
					v:RTD(ply:Nick().." no longer had noclip and his partial invisability!")
				end
				ply:SetMoveType(MOVETYPE_WALK)
				ply:SetNoDraw(false)
			end, ply)
		else
			local out = table.Random(dice.outcomes)
			out(ply)
		end
	end,
    
	Moneygive = function( ply )
		if pointshop == 1 then
			pay = math.random(50,300)
			for k, v in pairs(player.GetAll()) do
				v:RTD(ply:Nick().." has found  $"..pay.."!") 
			end 
			RunConsoleCommand("ps_givepoints",ply:Nick()..pay)
		elseif goldenforge == 1 then
			pay = math.random( 50, 300 )
			for k, v in pairs(player.GetAll()) do
				v:RTD(ply:Nick().." has found  $"..pay.."!")
				v:GiveScrapMetal(pay)
			end
		end
		if not (pointshop == 1 and goldenforge == 1) then
			for k, v in pairs(player.GetAll()) do
				v:RTD(" Tell the Server Owner to get pointshop or goldenforge!")
			end
		end
	end,
	
	Moneytake = function( ply )
		if pointshop == 1 then
			gonepay = math.random(50,300)
			for k, v in pairs(player.GetAll()) do
				v:RTD(ply:Nick().." got his money stolen! He lost $"..gonepay.."!") 
			end
			RunConsoleCommand("ps_takepoints",ply:Nick()..gonepay)
		elseif goldenforge == 1 then
			gonepay = math.random( 50, 300 )
			for k, v in pairs(player.GetAll()) do
				v:RTD(ply:Nick().." got his money stolen! He lost  $"..gonepay.."!") 
				if (v:CanAffordScrapMetal(gonepay)) then
					v:RemoveScrapMetal(gonepay)
				else
					v:RTD(" Can't afford his money loss! So we killed him instead.")
					ply:Kill()
				end
			end
		end
		if not (pointshop == 1 and goldenforge == 1) then
			for k, v in pairs(player.GetAll()) do
				v:RTD(" Tell the Server Owner to get pointshop or goldenforge!")
			end
		end
	end,
	  
	Kill = function( ply ) 
		for k, v in pairs(player.GetAll()) do
			v:RTD(ply:Nick().." has been killed!") 
		end 	
        ply:Kill()  
	end,  
      
	Colors = function( ply )
		for k, v in pairs(player.GetAll()) do
			v:RTD(ply:Nick().." got their color changed!") 
		end 
        ply:SetColor(math.Rand(0, 255), math.Rand(0, 255), math.Rand(0, 255), 255)  
	end,  
      
	Nothing = function( ply ) 
		for k, v in pairs(player.GetAll()) do
			v:RTD(ply:Nick().." got JACK SHIT!") 
		end 
	end,   
      
	Health = function( ply ) 
		for k, v in pairs(player.GetAll()) do
			v:RTD(ply:Nick().." got their health added by "..health.."!") 
		end  		
        ply:SetHealth(ply:Health()+health) 
	end,  
      
	Frags = function( ply ) 
		for k, v in pairs(player.GetAll()) do
			v:RTD(ply:Nick().." got their frags set to "..frags.."!") 
		end
		ply:SetFrags(frags)  
	end, 
	
	Freeze = function( ply )
		for k, v in pairs(player.GetAll()) do
			v:RTD(ply:Nick().." got frozen for "..duration.." seconds!") 
		end 	 
		ply:Freeze(true)
		ply:SetColor(0, 0, 255, 255)
		ply:EmitSound("physics/glass/glass_sheet_break1.wav")
		timer.Simple(duration, function(ply)
			ply:Freeze(false)
			for k, v in pairs(player.GetAll()) do
				v:RTD(ply:Nick().." got unfrozen!") 
			end 	
			ply:SetColor(255, 255, 255, 255)
		end, ply)
	end,
	
	Strip = function( ply )
		for k, v in pairs(player.GetAll()) do
			v:RTD(ply:Nick().." got stripped of all their weapons!") 
		end 
		ply:StripWeapons()
		ply:Give("weapon_crowbar")
	end,
	
	Ragdoll = function( ply )
		for k, v in pairs(player.GetAll()) do
			v:RTD(ply:Nick().." got ragdoll'd for "..duration.." seconds!") 
		end 
		
		local ent = ents.Create("prop_ragdoll")
		ent:SetPos(ply:GetPos())
		ent:SetAngles(ply:GetAngles())
		ent:SetModel(ply:GetModel())
		ent:Spawn()
		ent:Activate()
		ent:SetColor(255, 255, 25, 255)
		
		ply:SetParent(ent)
		ply:Spectate(OBS_MODE_CHASE)
		ply:SpectateEntity(ent)
		ply:StripWeapons()
		
		timer.Simple(duration, function(ply)
			for k, v in pairs(player.GetAll()) do
				v:RTD(ply:Nick().." got unragdoll'd!") 
			end 
			ply:SetParent()
			ply:Spawn()
			
			entpos = ent:GetPos()
			entpos.z = entpos.z + 75
			ply:SetPos(entpos)
			ent:Remove()
		end, ply)	
	end,

	Rocket = function( ply )
		for k, v in pairs(player.GetAll()) do
			v:RTD(ply:Nick().." got shot the fuck up and exploded!") 
		end 
		
		if ply:GetMoveType() == MOVETYPE_NOCLIP then
			ply:SetMoveType(MOVETYPE_WALK)
		end

		ply:SetVelocity(Vector(0, 0, 9999))
		timer.Simple(3, function( ply )
			local exp = ents.Create("env_explosion")
			exp:SetPos(ply:GetPos())
			exp:Spawn()
			exp:Fire("Explode", 0, 0)
			ply:KillSilent()
			ply:KillSilent()
		end, ply)
	end,
	
	Name = function( ply )
		if name == 1 then
			local names = table.Random(dice.names)
			for k, v in pairs(player.GetAll()) do
				v:RTD(ply:Nick().." got their name changed to "..names.."!") 
			end
			ply:SetName(names)
		else
			local out = table.Random(dice.outcomes)
			out(ply)
		end
	end,
	
	Crush = function( ply )
		if ply:GetMoveType() == MOVETYPE_NOCLIP then
			ply:SetMoveType(MOVETYPE_WALK)
		end
		
		ply:Freeze(true)
		ply:GodDisable()
    	for k, v in pairs(player.GetAll()) do
			v:RTD(ply:Nick().." got fucking crushed!") 
		end 
		
		local models = {
		"models/props_c17/FurnitureWashingmachine001a.mdl",
		"models/Cliffs/rockcluster02.mdl",
		"models/props_wasteland/rockcliff_cluster02a.mdl",
		"models/props_wasteland/rockcliff05f.mdl",
		"models/props_wasteland/rockcliff_cluster03c.mdl",
		"models/props_foliage/rock_coast02h.mdl",
		"models/props_junk/TrashDumpster02.mdl",
		"models/props_wasteland/cargo_container01.mdl",
		"models/props_wasteland/laundry_dryer002.mdl",
		"models/props_foliage/rock_coast02h.mdl"}
		
		local entc = ents.Create("prop_physics")
		entc:SetModel(table.Random(models))
		entc:SetPos(ply:GetPos()+Vector(0, 0, 500))
		entc:Spawn()
		
		phys = entc:GetPhysicsObject()
		phys:SetMass(999)
		entc:SetVelocity(Vector(0, 0, -999))

		
		timer.Simple(6, function( ply )
			entc:Remove()
			ply:Freeze(true)
			ply:KillSilent()
		end, ply)
	end,
	
	Invis = function( ply )
		for k, v in pairs(player.GetAll()) do
			v:RTD(ply:Nick().." got invisablity for "..duration.." seconds!") 
		end 
		ply:SetNoDraw(true)
		
		timer.Simple(duration, function( ply )
			for k, v in pairs(player.GetAll()) do
				v:RTD(ply:Nick().." is visable once again!") 
			end
			ply:SetNoDraw(false)
			ply:SetColor(255, 255, 255, 255)
		end, ply)
	end,
	
	Godmode = function( ply )
		for k, v in pairs(player.GetAll()) do
			v:RTD(ply:Nick().." got godmoded for "..duration.." seconds!") 
		end 
		ply:GodEnable()
		
		timer.Simple(duration, function( ply )
			for k, v in pairs(player.GetAll()) do
				v:RTD(ply:Nick().." got ungodmoded!") 
			end 
			ply:GodDisable()
		end, ply)
	end,
	
	Scream = function( ply )
    	for k, v in pairs(player.GetAll()) do
			v:RTD(ply:Nick().." got screamed at!") 
		end 
		ply:EmitSound("npc/fast_zombie/fz_scream1.wav", 500, 20)
		ply:EmitSound("npc/fast_zombie/fz_scream1.wav", 500, 30)
		ply:EmitSound("npc/fast_zombie/fz_scream1.wav", 500, 40)
		ply:EmitSound("npc/fast_zombie/fz_scream1.wav", 500, 50)
		ply:EmitSound("npc/fast_zombie/fz_scream1.wav", 500, 60)
		ply:EmitSound("npc/fast_zombie/fz_scream1.wav", 500, 70)
		ply:EmitSound("npc/fast_zombie/fz_scream1.wav", 500, 80)
		ply:EmitSound("npc/fast_zombie/fz_scream1.wav", 500, 90)
		timer.Simple(2, function( ply )
			ply:EmitSound("npc/fast_zombie/fz_scream1.wav", 500, 20)
			ply:EmitSound("npc/fast_zombie/fz_scream1.wav", 500, 30)
			ply:EmitSound("npc/fast_zombie/fz_scream1.wav", 500, 40)
			ply:EmitSound("npc/fast_zombie/fz_scream1.wav", 500, 50)
			ply:EmitSound("npc/fast_zombie/fz_scream1.wav", 500, 60)
			ply:EmitSound("npc/fast_zombie/fz_scream1.wav", 500, 70)
			ply:EmitSound("npc/fast_zombie/fz_scream1.wav", 500, 80)
			ply:EmitSound("npc/fast_zombie/fz_scream1.wav", 500, 90)
		end, ply)
		timer.Simple(4, function( ply )
			ply:EmitSound("npc/fast_zombie/fz_scream1.wav", 500, 20)
			ply:EmitSound("npc/fast_zombie/fz_scream1.wav", 500, 30)
			ply:EmitSound("npc/fast_zombie/fz_scream1.wav", 500, 40)
			ply:EmitSound("npc/fast_zombie/fz_scream1.wav", 500, 50)
			ply:EmitSound("npc/fast_zombie/fz_scream1.wav", 500, 60)
			ply:EmitSound("npc/fast_zombie/fz_scream1.wav", 500, 70)
			ply:EmitSound("npc/fast_zombie/fz_scream1.wav", 500, 80)
			ply:EmitSound("npc/fast_zombie/fz_scream1.wav", 500, 90)
		end, ply)
	end,
	
	Jail = function( ply )
		for k, v in pairs(player.GetAll()) do
			v:RTD(ply:Nick().." got jailed for "..duration.." seconds!") 
		end 
		ply:SetColor(255, 0, 0, 255)
		
		jail = ents.Create("prop_physics")
		jail:SetModel("models/props_junk/TrashDumpster02.mdl")
		jail:SetPos(ply:GetPos()+Vector(0, 0, 150))
		jail:SetAngles(Angle(0, 0, 180))
		jail:SetMoveType(MOVETYPE_NONE)
		jail:Spawn()
		jail:Activate()
		jail:SetColor(255, 0, 0, 100)
		
		timer.Simple(duration, function( ply )
			for k, v in pairs(player.GetAll()) do
				v:RTD(ply:Nick().." got unjailed!") 
			end 
	        v:RTD(ply:Nick().." got unjailed!")
			ply:SetColor(255, 255, 255, 255)
			jail:Remove()
		end, ply)
	end,
	
	Armor = function( ply )  
		for k, v in pairs(player.GetAll()) do
			v:RTD(ply:Nick().." got their armor added by "..armor.."!") 
		end 
		ply:SetArmor(ply:Armor()+armor)  
	end,
	
	Blind = function( ply )
		for k, v in pairs(player.GetAll()) do
			v:RTD(ply:Nick().." got blinded for "..duration.." seconds!") 
		end 
	   
		timer.Simple(1, function(ply)
                	umsg.Start( "BlindPlayer", ply )
						umsg.Short(duration)
                	umsg.End()
                	ply:SetColor(0, 0, 0, 255)
        	end, ply)
       
		timer.Simple(duration, function( ply )
			ply:SetColor(255, 255, 255, 255)
			for k, v in pairs(player.GetAll()) do
				v:RTD(ply:Nick().." got unblinded!") 
			end
		end, ply)
	end
}

dice.notimers = {
	"Armor", 
	"Health", 
	"Moneygive",
	"Moneytake",
	"Name", 
	"Frags", 
	"Scream", 
	"Crush", 
	"Nothing", 
	"Strip", 
	"Colors",
	"Kill"
}

dice.names = {
	"Cookies",
	"Name Here",
	"More Names Here",
	"Someone make new names!",
	"I SEW YOU!",
	"I wish i had a name",
	"Player Name"
}

function dice:Roll( ply )
	local maxrolls = maxrolls:GetInt()

	if not ply:Alive() then return end
	
	if ply:GetNWInt("rolls") >= maxrolls then
		ply:RTD(" Wait "..rollinterval.." seconds to roll again!") 
	elseif ply:GetNWInt("rolling") == 1 then
		ply:RTD(" Wait "..rollinterval.." seconds to roll again!")
	else
		ply:SetNWInt("rolls", ply:GetNWInt("rolls")+1)
		local outcome = table.Random(dice.outcomes)
		local hasduration = true
		for _, v in ipairs(dice.notimers) do
			if dice.outcomes[v] == outcome then
				hasduration = false
				break
			end
		end
		if hasduration then
			ply:SetNWInt("rolling", 1)
			timer.Simple(duration, function( ply )
				ply:SetNWInt("rolling", 0)
			end, ply)
		end
		outcome(ply)
	end
	
	timer.Simple(rollinterval, function( ply )
		ply:SetNWInt("rolls", 0)
	end, ply)
	
end 
  
local function diceplayerSay( ply, text )
	if (string.sub(text, 1, 3) == "rtd") or (string.sub(text, 1, 4) == "!rtd") then
		if rtd == 1 then
			if ply:Alive() then
				dice:Roll(ply)
			elseif not ply:Alive() then
				ply:RTD(" You must be alive to use this command!")
			end
		elseif not rtd == 1 then
			ply:RTD(" Tell the server owner to enable RTD!")
		end
	end
end
hook.Add("PlayerSay", "rtdcmdsy", diceplayerSay)  

concommand.Add("rtd", diceplayerSay)