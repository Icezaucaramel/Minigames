hook.Add("RoundBegin", "TDM_Check", function()
	timer.Create("CheckEnd", 1, 0, function()
		Minigames:CheckWinningTeam()
		Minigames:CheckAutobalance()
	end)
end)

hook.Add("RoundEnd", "TDM_End", function()
	timer.Destroy("CheckEnd")
end)

hook.Add("PreRoundPlayer", "TDM_GE", function(ply)
    ply:GodEnable()
    ply:Freeze(true)
end)

hook.Add("RoundPlayer", "TDM_GE", function(ply)
    ply:GodDisable()
    ply:Freeze(false)
end)

function Minigames:PlayerJoinedPreRound(ply)
	ply:Spawn()
end

hook.Add("PlayerInitialSpawn", "TDM_Select", function(ply)
	if not ply:IsBot() then
		Minigames:ShowTeamSelect(ply)
	else
		ply:SetTeam(3)
	end
end)

function Minigames:PlayedStoppedSpectating(ply)
	Minigames:ShowTeamSelect(ply)
end

function Minigames:CanStartGame()
	if #team.GetPlayers(2) >= 1 and #team.GetPlayers(3) >= 1 then
		return true
	end
	
	return false
end

hook.Add("PlayerSpawn", "TDM_Color", function(ply)
	if ply:Team() == TEAM_RED then
		ply:SetPlayerColor(Vector(1,0,0))
		local tbl = table.Random(ents.FindByClass("info_player_terrorist"))
		ply:SetPos(tbl:GetPos())
	elseif ply:Team() == TEAM_BLUE then
		ply:SetPlayerColor(Vector(0,0,1))
		local tbl = table.Random(ents.FindByClass("info_player_counterterrorist"))
		ply:SetPos(tbl:GetPos())
	end
	
	ply:SetWalkSpeed(Minigames.TeamDeathmatch.WalkSpeed)
	ply:SetRunSpeed(Minigames.TeamDeathmatch.RunSpeed)
	Minigames:GiveRandom(ply)
end)

hook.Add("PlayerShouldTakeDamage", "TDM_TD", function(ply,attacker)
	if attacker:IsPlayer() and ply:IsPlayer() and attacker:Team() == ply:Team() then
		return false
	end

end)

hook.Add("RoundEnd", "TDM_Strip", function()
	for k, v in pairs(player.GetAll()) do
		v:StripWeapons()
	end
end)
