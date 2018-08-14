local tbl = {}

hook.Add("PlayerInitialSpawn", "TVA_Spawn", function(ply)
	timer.Simple(0.5, function()
		ply:SetTeam(2)
	end)
end)

function Minigames:PlayedStoppedSpectating(ply)
	ply:SetTeam(TEAM_BLUE)
end

function Minigames:PlayerJoinedPreRound(ply)
	ply:Spawn()
end

function Minigames:PlayerConnectedPreround(ply)
	if not ply:IsPlayingGame() then
		ply:SetTeam(2)
	end
	
	if not ply:Alive() then
		ply:Spawn()
	end
end

function Minigames:CanStartGame()
	if #team.GetPlayers(2) >= 2 or #team.GetPlayers(3) > 0 then
		return true
	end
	
	return false
end

hook.Add("PlayerSpawn", "GiveCrowbar", function(ply)
	ply:Give("weapon_crowbar")
end)

hook.Add("PreRoundBegin", "TVA_PRB", function()
	local spawn = table.Random(ents.FindByClass("info_player_terrorist"))
	local picked = table.Random(Minigames:ReturnBlueAlive())
		
	if not IsValid(picked) then
		Minigames.RoundState = -1
		Minigames:CheckForPlayers()
	else
		picked:KillSilent()
		picked:SetTeam(TEAM_RED)
		picked:Spawn()
		picked:SetPos(spawn:GetPos())
		picked:SetPlayerColor(Vector(1,0,0))
	end	
	
end)

hook.Add("PreRoundPlayer", "TVA_Colour", function(ply)
	ply:SetPlayerColor(Vector(0,0,1))
end)

hook.Add("RoundBegin", "TVA_Checkwin", function()
	timer.Create("CheckTSAEnd", 1, 0, function()
		Minigames:CheckWinningTeam()
	end)
end)

hook.Add("RoundEnd", "TVA_KillTimer", function()
	timer.Destroy("CheckTSAEnd")

	for k, v in pairs(player.GetAll()) do
		if v:Team() == TEAM_RED then
			v:SetTeam(TEAM_BLUE)
		end
		
		v:KillSilent()
	end
end)

hook.Add("PlayerSpawn", "Speed_TVS", function(ply)
	ply:SetWalkSpeed(Minigames.TwoVersusAll.WalkSpeed)
	ply:SetRunSpeed(Minigames.TwoVersusAll.RunSpeed)
end)
