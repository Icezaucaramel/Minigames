hook.Add("PlayerInitialSpawn", "FFF_Spawn", function(ply)
	timer.Simple(0.5, function()
		ply:SetTeam(TEAM_BLUE)
	end)
end)

hook.Add("PlayerSpawn", "Speed_FF", function(ply)
	ply:SetWalkSpeed(Minigames.FreeForAll.WalkSpeed)
	ply:SetRunSpeed(Minigames.FreeForAll.RunSpeed)
end)

function Minigames:PlayedStoppedSpectating(ply)
	ply:SetTeam(TEAM_BLUE)
end

function Minigames:CanStartGame()
	if #team.GetPlayers(2) >= 2 then
		return true
	end
	
	return false
end

hook.Add("RoundBegin", "FFA_CheckWinner", function()
	timer.Create("FreeForAllWinner", 0.5, 0, function()
		Minigames:CheckFreeForAllWinner()
	end)
end)

hook.Add("RoundEnd", "FFA_Over", function(winner)
	timer.Destroy("FreeForAllWinner")
end)

function Minigames:CheckFreeForAllWinner()

	if Minigames.RoundState != 1 then return end
	
	if #player.GetActive() == 1 then
		for k, v in pairs(player.GetActive()) do
			Minigames:RoundEnd(1, v:Nick())
			Minigames:FreeForAllWinner(v)
		end
	elseif #player.GetActive() < 1 then
		Minigames:RoundEnd(4)
	end
end

function Minigames:FreeForAllWinner(winner)
	if SERVER then
		winner:SendLua([[LocalPlayer():ConCommand("act dance")]])
		winner:StripWeapons()
	end
end