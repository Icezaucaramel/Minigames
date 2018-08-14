Minigames = Minigames or {}
Minigames.SuicideBarrels = Minigames.SuicideBarrels or {}

if SERVER then
	util.AddNetworkString("MG_SendInfoString_SB")
	
	include("mg_sb_config.lua")
	AddCSLuaFile("mg_sb_config.lua")
	
	hook.Add("PlayerInitialSpawn", "GetDLCInfo", function(ply)
		if Minigames.IsPlayingSB then
			net.Start("MG_SendInfoString_SB")
				net.WriteString(Minigames.InfoString)
			net.Send(ply)
		end
	end)
	
	net.Receive("MG_SendInfoString_SB", function()
		Minigames.InfoString = net.ReadString()
	end)
end

function Minigames:IsPlayingSB()
	if table.HasValue(Minigames.SuicideBarrels.Maps, game.GetMap()) then
		return true
	end

	return false
end

if Minigames:IsPlayingSB() then
	include("sv_suicidebarrels.lua")
end

hook.Add("InitPostEntity", "Minigames_DetectGameOnMap", function()

	if not Minigames.Gamemodes then return end

	if Minigames:IsPlayingSB() then
		SetGlobalString("Minigames_CurrentGamemode", "SB")
		SetGlobalInt("Minigames_RoundTime", Minigames.SuicideBarrels.RoundTime)
		Minigames.RoundLimit = Minigames.SuicideBarrels.NumberOfRounds
		Minigames.InfoString = "We're playing Suicide Barrels !"
		print("DLC GAMEMODE RUNNING: " .. GetGlobalString("Minigames_CurrentGamemode"))
		Minigames.IsPlayingDLC = true
	end
	Minigames.Gamemodes["Suicide Barrels"] = 0 
	
	
	function Minigames:DefineVoteInfo(winning_key)
		if winning_key == "Team Deathmatch" then
			return Minigames.TeamDeathmatch.Maps
		elseif winning_key == "Free For All" then
			return Minigames.FreeForAll.Maps
		elseif winning_key =="Assault Course" then
			return Minigames.AssaultCourse.Maps
		elseif winning_key == "Two Versus All" then
			return Minigames.TwoVersusAll.Maps
		elseif winning_key == "Team Survival" then
			return Minigames.TeamSurvival.Maps
		elseif winning_key == "Capture The Flag" then
			return Minigames.CaptureTheFlag.Maps	
		elseif winning_key == "One In The Chamber" then
			return Minigames.OneInTheChamber.Maps
		elseif winning_key == "Freeze Tag" then
			return Minigames.FreezeTag.Maps
		elseif winning_key == "VIP" then
			return Minigames.VIP.Maps
		elseif winning_key == "Suicide Barrels" then
			return Minigames.SuicideBarrels.Maps
		else
			return Minigames.AssaultCourse.Maps
		end
	end
end)
