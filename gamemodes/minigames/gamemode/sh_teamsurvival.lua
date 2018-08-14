hook.Add("PlayerInitialSpawn", "TS_Select", function(ply)
	Minigames:ShowTeamSelect(ply)
end)

function Minigames:PlayedStoppedSpectating(ply)
	Minigames:ShowTeamSelect(ply)
end

function Minigames:PlayerJoinedPreRound(ply)
	ply:Spawn()
end

function Minigames:CanStartGame()
	if #team.GetPlayers(2) >= 1 and #team.GetPlayers(3) >= 1 then
		return true
	end
	
	return false
end

hook.Add("PlayerSpawn", "TS_Colour", function(ply)
	if ply:Team() == TEAM_RED then
		ply:SetPlayerColor(Vector(1,0,0))
		local tbl = table.Random(ents.FindByClass("info_player_terrorist"))
		ply:SetPos(tbl:GetPos())
	elseif ply:Team() == TEAM_BLUE then
		ply:SetPlayerColor(Vector(0,0,1))
		local tbl = table.Random(ents.FindByClass("info_player_counterterrorist"))
		ply:SetPos(tbl:GetPos())
	end

	ply:SetWalkSpeed(Minigames.TeamSurvival.WalkSpeed)
	ply:SetRunSpeed(Minigames.TeamSurvival.RunSpeed)
end)

hook.Add("RoundBegin", "TS_Timer", function()
	timer.Create("CheckTSWin", 0.5, 0, function()
		Minigames:CheckWinningTeam()
		Minigames:CheckAutobalance()
	end)
end)

hook.Add("RoundEnd", "TS_KT", function()
	timer.Destroy("CheckTSWin")
end)