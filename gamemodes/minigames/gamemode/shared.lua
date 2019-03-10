--Core stuff - don't touch this!
DeriveGamemode( "base" )
Minigames = Minigames or {}
Minigames.TeamDeathmatch = Minigames.TeamDeathmatch or {}
Minigames.TeamSurvival = Minigames.TeamSurvival or {}
Minigames.FreeForAll = Minigames.FreeForAll or {}
Minigames.AssaultCourse = Minigames.AssaultCourse or {}
Minigames.TwoVersusAll = Minigames.TwoVersusAll or {}
Minigames.CaptureTheFlag = Minigames.CaptureTheFlag or {}

-- Credits
GM.Name		= "Minigames"
GM.Author	= "Icez&Co"
GM.Email	= "i don't do that anymore, fuck off (original creator)"
GM.Website	= "thisbitchempty.dot.uk.com"

TEAM_BLUE = 2
TEAM_RED = 3

TEAM_UNASSIGNED = -1

function GM:CreateTeams()

	team.SetUp(TEAM_BLUE, "Blue", Color(34,167,240), true)  
	team.SetSpawnPoint(TEAM_BLUE, {"info_player_counterterrorist"})
	
	team.SetUp(TEAM_RED, "Red", Color(242,38,19), false)  
	team.SetSpawnPoint(TEAM_RED, {"info_player_terrorist"}) 	

    team.SetUp(TEAM_SPECTATOR, "Spectators", Color(200,200,200), true)  
    team.SetSpawnPoint(TEAM_SPECTATOR, {"info_player_start"})
	
	team.SetUp(TEAM_UNASSIGNED, "Unassigned", Color(200,200,200), true)  
    team.SetSpawnPoint(TEAM_UNASSIGNED, {"info_player_start"})
end

hook.Add("Initialize", "Minigames_DetectGameOnMap", function()

	if SERVER then
		local dir = file.Exists("data/minigames", "GAME")

		if not dir then
			file.CreateDir("minigames")
			print("[MINIGAMES] Missing /minigames folder in data! (There was one included in this addon, please add it)")
		end
		
		
	end

	SetGlobalString("Minigames_CurrentGamemode", "Minigames")
	SetGlobalInt("Minigames_RoundTime", 60*3)
	Minigames.RoundLimit = 5

	if Minigames:IsPlayingTeamDeathmatch() then
		
		SetGlobalString("Minigames_CurrentGamemode", "Team Deathmatch")
		SetGlobalInt("Minigames_RoundTime", Minigames.TeamDeathmatch.RoundTime)
		Minigames.RoundLimit = Minigames.TeamDeathmatch.NumberOfRounds
		
	elseif Minigames:IsPlayingFreeForAll() then
	
		SetGlobalString("Minigames_CurrentGamemode", "Free For All")
		SetGlobalInt("Minigames_RoundTime", Minigames.FreeForAll.RoundTime)
		Minigames.RoundLimit = Minigames.FreeForAll.NumberOfRounds
	
	elseif Minigames:IsPlayingAssaultCourse() then
	
		SetGlobalString("Minigames_CurrentGamemode",  "Assault Course")
		SetGlobalInt("Minigames_RoundTime", Minigames.AssaultCourse.RoundTime)
		Minigames.RoundLimit = Minigames.AssaultCourse.NumberOfRounds
	
	elseif Minigames:IsPlayingTwoVersusAll() then
	
		SetGlobalString("Minigames_CurrentGamemode", "Two Versus All")
		SetGlobalInt("Minigames_RoundTime", Minigames.TwoVersusAll.RoundTime)
		Minigames.RoundLimit = Minigames.TwoVersusAll.NumberOfRounds
	
	elseif Minigames:IsPlayingTeamSurvival() then
	
		SetGlobalString("Minigames_CurrentGamemode", "Team Survival")
		SetGlobalInt("Minigames_RoundTime", Minigames.TeamSurvival.RoundTime)
		Minigames.RoundLimit = Minigames.TeamSurvival.NumberOfRounds
	
	elseif Minigames:IsPlayingCaptureTheFlag() then
	
		SetGlobalString("Minigames_CurrentGamemode", "CTF")
		SetGlobalInt("Minigames_RoundTime", Minigames.CaptureTheFlag.RoundTime)
		Minigames.RoundLimit = Minigames.CaptureTheFlag.NumberOfRounds
	
	end
	
	Minigames.RoundState = -1
	Minigames.RoundNumber = 0
	
	if SERVER then
		Minigames:CheckForPlayers()
		Minigames.RTVUsers = {}
	end
	
	print(string.upper("[minigames] we're playing " .. Minigames:ReturnGamemodeString()))

end)

concommand.Add("AC_AddTeddy", function(ply)

	if not ply:IsAdmin() or ply:IsSuperAdmin() then return end
	chat.AddText(Color(242,99,91), "[MINIGAMES] ", Color(255,255,255), "Spawned a teddy at ", Color(67,191,227), ply:Nick() .. "'s position")

	net.Start("Minigames_WriteTeddy")
		net.WriteEntity(ply)
	net.SendToServer()
end)

hook.Add("ShouldCollide", "MG_Collide", function(ent1,ent2)
	if Minigames:IsPlayingFreeForAll() then
		if ent1:IsPlayer() and ent2:IsPlayer() then
			return true
		end
	else
		if ent1:IsPlayer() and ent2:IsPlayer() then
			if ent1:Team() == ent2:Team() then
				return false
			end
		end
	end
	
	return true
end)

Minigames.Gamemodes = {
["Team Deathmatch"] = 0,
["Free For All"] = 0,
["Assault Course"] = 0,
["Two Versus All"] = 0,
["Team Survival"] = 0,
["Capture The Flag"] = 0
}

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
	else
		return Minigames.AssaultCourse.Maps
	end
end