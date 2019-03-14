hook.Add("PlayerInitialSpawn", "AC_SetTeam", function(ply)
	ply:SetTeam(TEAM_BLUE)
end)

hook.Add("PlayerSpawn", "Speed_AC", function(ply)
	ply:SetWalkSpeed(Minigames.AssaultCourse.WalkSpeed)
	ply:SetWalkSpeed(Minigames.AssaultCourse.RunSpeed)
	if ply:Team() == TEAM_BLUE then
		ply:Give("weapon_knife")
	end
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
	if #team.GetPlayers(2) >= 1 then
		return true
	end
end

hook.Add("RoundBegin", "AC_Begin", function()
	timer.Create("CheckDeaths", 0.5, 0, function()
		Minigames:CheckACDeaths()
	end)
end)

hook.Add("RoundEnd", "AC_RO", function(winner)
	timer.Destroy("CheckDeaths")
end)

hook.Add("PlayerShouldTakeDamage", "AC_Null", function(ply,attacker)
	if attacker:IsPlayer() and ply:IsPlayer() and attacker ~= ply then
		return false
	end

end)

function Minigames:CheckACDeaths()

	if Minigames.RoundState ~= 1 then return end
	
	if #player.GetActive() < 1 then
		Minigames:RoundEnd(4)
	end
end