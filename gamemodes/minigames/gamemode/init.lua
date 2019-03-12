--AddCSLuaFile
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("ply_extension.lua")
AddCSLuaFile("config_general.lua")
AddCSLuaFile("config_maps.lua")
AddCSLuaFile("cl_networkstrings.lua")
AddCSLuaFile("cl_fonts.lua")
AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("cl_fonts.lua")
AddCSLuaFile("cl_mapvote.lua")
AddCSLuaFile("cl_scoreboard.lua")
AddCSLuaFile("config_mapvote.lua")

--Include
include("shared.lua")
include("sv_chatcommands.lua")
include("config_maps.lua")
include("config_general.lua" )
include("sv_rounds.lua")
include("ply_extension.lua")
include("config_mapvote.lua")
include("sv_mapvote.lua")

--Network Strings
util.AddNetworkString("Minigames_NotifyRound")
util.AddNetworkString("Minigames_PointsOnKill")
util.AddNetworkString("Minigames_ChoosePlayerModel")
util.AddNetworkString("Minigames_WriteTeddy")
util.AddNetworkString("Minigames_AvatarHUD")
util.AddNetworkString("Minigames_MapVote")
util.AddNetworkString("Minigames_MapVote_CtS")
util.AddNetworkString("Minigames_MapVote_SbtC")
util.AddNetworkString("Minigames_MapChoice")
util.AddNetworkString("Minigames_SendMap")
util.AddNetworkString("Minigames_NotifyRTV")
util.AddNetworkString("MG_VOTENotif")
util.AddNetworkString("Team_Select")
util.AddNetworkString("Team_Select_Serverside")
util.AddNetworkString("F_Help")
util.AddNetworkString("F_Teams")
util.AddNetworkString("MG_DisplayWinner")
util.AddNetworkString("MG_RequestRTVFromClient")
util.AddNetworkString("MG_NotifyTeamBalance")
util.AddNetworkString("MG_NotifyScramble")
util.AddNetworkString("CTF_FlagToggle")
util.AddNetworkString("CTF_Reset")
util.AddNetworkString("CTF_Capt")
util.AddNetworkString("CTF_SendCaptures")
util.AddNetworkString("CTF_AddCapture")
util.AddNetworkString("MG_SendInitalData")
util.AddNetworkString("MG_Killfeed")


local misc = file.Find("materials/niandralades/minigames/*.png", "MOD" )
local icons = file.Find("materials/niandralades/minigames/mapicons/*.png", "MOD" )
if Minigames.EnableFastDL then
	
	resource.AddFile("resource/fonts/Nexa Light.otf")
	
	//this feels a bit sloppy???
	
	for k, v in pairs(misc) do
		resource.AddFile("materials/niandralades/minigames/" .. v)
	end
	
	for k, v in pairs(icons) do
		resource.AddFile("materials/niandralades/minigames/mapicons/" .. v)
	end
	
else
	resource.AddWorkshop("621724216")
end

if Minigames:IsPlayingFreeForAll() then
	include("sh_freeforall.lua")
end

if Minigames:IsPlayingTwoVersusAll() then
	include("sh_twoversusall.lua")
end

if Minigames:IsPlayingAssaultCourse() then
	include("sh_assaultcourse.lua")
end

if Minigames:IsPlayingTeamDeathmatch() then
	include("sh_teamdeathmatch.lua")
end

if Minigames:IsPlayingTeamSurvival() then
	include("sh_teamsurvival.lua")
end

if Minigames:IsPlayingCaptureTheFlag() then
	include("sh_capturetheflag.lua")
end

function GM:ShowHelp(ply)
	net.Start("F_Help")
	net.Send(ply)
end

function GM:ShowTeam(ply)
	Minigames:ShowTeamSelect(ply)
end

net.Receive("Team_Select_Serverside", function(len,ply)
	local teamstring = net.ReadString()
	
	if teamstring == "blue" then
		ply:SetTeam(TEAM_BLUE)
	elseif teamstring == "red" then
		ply:SetTeam(TEAM_RED)
	else
		Minigames:SetAFK(ply)
	end
	
	if ply:Team() == TEAM_RED or ply:Team() == TEAM_BLUE then
		if Minigames.RoundState == 1 then
			Minigames:PlayerJoinedDuringRound(ply)
		elseif Minigames.RoundState == 0 then
			Minigames:PlayerJoinedPreRound(ply)
		end
	end	
end) 

net.Receive("MG_RequestRTVFromClient", function(len,ply)
	Minigames:PlayerRequestedRTV(ply)
end)

net.Receive("Minigames_WriteTeddy", function()
	
	local ent = net.ReadEntity()
	local pos = ent:GetPos()
	local ang = ent:GetAngles()
	
	local concat = tostring(pos) .. "/" .. tostring(ang)

	file.Write("minigames/" .. game.GetMap() .. ".txt",concat)
end)

function Minigames:PlayerConnectedPreround(ply)
	//do nothin by default
end

local weapons_tbl = {
	"weapon_ak47",
	"weapon_mac10",
	"weapon_m4a1",
	"weapon_tmp",
	"weapon_famas",
	"weapon_galil",
	"weapon_aug",
	"weapon_g3sg1",
	"weapon_awp",
	"weapon_mp5navy"
}

local seconday_tbl = {
	"weapon_deagle",
	"weapon_p228",
	"weapon_elite",
	"weapon_fiveseven",
	"weapon_glock",
	"weapon_usp"
}

function Minigames:GiveRandom(ply)
	if ply:Team() == TEAM_SPECTATOR or ply:Team() == TEAM_UNASSIGNED then return end
	ply:Give(table.Random(weapons_tbl))
	ply:Give(table.Random(seconday_tbl))
	ply:Give("weapon_crowbar")
end

function Minigames:ShowTeamSelect(ply)
	net.Start("Team_Select")
	net.Send(ply)
end

function GM:PlayerInitialSpawn(ply)

	ply.PlayerModel = ply:GetPData("PlayerModel") or "models/player/kleiner.mdl"
	ply:AllowFlashlight(true)
	ply:SetCanZoom(false)
	ply:SetCustomCollisionCheck(true)
	
	if GetGlobalString("Minigames_CurrentGamemode") == "Minigames" then
		ply:SetTeam(TEAM_BLUE)
	end
	
	timer.Simple(1, function()
		if Minigames.RoundState == 0 then
			Minigames:PlayerConnectedPreround(ply)
		else
			ply:KillSilent()
			ply:SetMoveType(MOVETYPE_NOCLIP)
		end
	end)
	
	net.Start("MG_SendInitalData")
		net.WriteString(Minigames.RoundNumber)
		net.WriteString(Minigames.RoundLimit)
	net.Send(ply)
end

function GM:PlayerDisconnected(ply)
	ply:SetPData("PlayerModel", ply.PlayerModel)
	
	if #player.GetAll() <= 1 then
		Minigames:RoundEnd(nil, nil)
		Minigames:CheckForPlayers()
	end
end

function GM:ShutDown()
	for k, v in pairs(player.GetAll()) do
		v:SetPData("PlayerModel", v.PlayerModel)
	end
end

--fuck this noise
function GM:PlayerDeathSound()
	return true
end

function GM:PlayerSpawn(ply)

	ply:SetModel(ply.PlayerModel or "models/player/arctic.mdl")

	if ply:GetModel() == "models/player.mdl" then
		ply.PlayerModel = "models/player/arctic.mdl"
		ply:SetModel(ply.PlayerModel)
		print("[minigames] you shouldn't see this message!")
	end	

	ply:SetupHands()
	if not ply:IsGhostMode() then
		ply.OriginalTeam = ply:Team()
	end
	ply:UnSpectate()
	
	if Minigames.RoundState >= 0 then
		net.Start("Minigames_AvatarHUD")
			net.WriteBool(true)
		net.Send(ply)
	end
	
end

function GM:PlayerDeath(ply,inflictor,attacker)
	if Minigames.UsePointshop then
		if attacker:IsValid() and attacker != ply and attacker:IsPlayer() then
			attacker:PS_GivePoints(Minigames.PointsPerKill)
			net.Start("Minigames_PointsOnKill")
				net.WriteString(attacker:Nick())
				net.WriteString(ply:Nick())
			net.Send(attacker)	
		end
	elseif Minigames.UsePointshop_2 then
		if attacker:IsValid() and attacker != ply and attacker:IsPlayer() then
			attacker:PS2_AddStandardPoints(Minigames.PointsPerKill, "",true)
			net.Start("Minigames_PointsOnKill")
				net.WriteString(attacker:Nick())
				net.WriteString(ply:Nick())
			net.Send(attacker)	
		end
	end
	
	net.Start("Minigames_AvatarHUD")
		net.WriteBool(false)
	net.Send(ply)
	
	net.Start("MG_Killfeed")
		net.WriteEntity(attacker)
		net.WriteEntity(ply)
	net.Broadcast()	
	
	timer.Simple(0.5, function()		
		ply:Spectate(OBS_MODE_ROAMING)
	end)

end


hook.Add("KeyPress", "SpeccySpec", function(ply,key)
	
	if ply:Alive() then return end

	if key == IN_ATTACK then
		local ent = table.Random(player.GetActive())
		ply:Spectate(OBS_MODE_CHASE)
		ply:SpectateEntity(ent)
	elseif key == IN_ATTACK2 then
		ply:Spectate(OBS_MODE_ROAMING)
	end
end)

function GM:PlayerDeathThink()
end

hook.Add("KeyPress", "GhstMde", function(ply,key)
	if not GhostMode then return end
	
	if key == IN_ZOOM then
		GhostMode:ToggleGhostMode(ply)
	end
end)

net.Receive("Minigames_ChoosePlayerModel", function(len,ply)
	ply.PlayerModel = net.ReadString()
end)

function GM:PlayerCanPickupWeapon(ply,weapon)
	if ply:HasWeapon(weapon:GetClass()) then
		return false
	end
	
	return true 
end