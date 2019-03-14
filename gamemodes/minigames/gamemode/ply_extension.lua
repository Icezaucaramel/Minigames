local meta = FindMetaTable( "Player" )

function meta:IsPlayingGame()
	if self:Team() == TEAM_BLUE or self:Team() == TEAM_RED then
		return true
	end
	
	return false
end

function Minigames:IsPlayingCaptureTheFlag()
	if table.HasValue(Minigames.CaptureTheFlag.Maps, game.GetMap()) then
		return true
	end

	return false
end

function Minigames:IsPlayingTeamDeathmatch()
	if table.HasValue(Minigames.TeamDeathmatch.Maps, game.GetMap()) then
		return true
	end

	return false
end

function Minigames:IsPlayingTeamSurvival()
	if table.HasValue(Minigames.TeamSurvival.Maps, game.GetMap()) then
		return true
	end

	return false
end

function Minigames:IsPlayingFreeForAll()
	if table.HasValue(Minigames.FreeForAll.Maps, game.GetMap()) then
		return true
	end

	return false
end

function Minigames:IsPlayingAssaultCourse()
	if table.HasValue(Minigames.AssaultCourse.Maps, game.GetMap()) then
		return true
	end

	return false
end

function Minigames:IsPlayingTwoVersusAll()
	if table.HasValue(Minigames.TwoVersusAll.Maps, game.GetMap()) then
		return true
	end

	return false
end

function Minigames:ReturnGamemodeString()
	return GetGlobalString("Minigames_CurrentGamemode")
end

function Minigames:AreTeamsBalanced()
	if #team.GetPlayers(2) == #team.GetPlayers(3) then
		return true
	end
	
	return false
end

function Minigames:CanJoinBlue()
	if  Minigames:IsPlayingFreeForAll() or Minigames:IsPlayingAssaultCourse() or Minigames:IsPlayingTwoVersusAll() then
		return true
	else
		if Minigames:AreTeamsBalanced() then
			return true
		else
			if #team.GetPlayers(2) < #team.GetPlayers(3) then
				return true
			else
				return false
			end
		end
	end
	
	return false
end

-- I know it's kinda sloppy to have two functions when I could merge them into one but I just thought this would be less messy cuz you gotta take into consideration the various gamemodes n stuff
function Minigames:CanJoinRed()
	if  Minigames:IsPlayingFreeForAll() or Minigames:IsPlayingAssaultCourse() or Minigames:IsPlayingTwoVersusAll() then
		return false
	else
		if Minigames:AreTeamsBalanced() then
			return true
		else
			if #team.GetPlayers(3) < #team.GetPlayers(2) then
				return true
			else
				return false
			end
		end
	end
	
	return false
end


function player.GetActive()
	local tbl = {}
	
	for k, v in pairs(player.GetAll()) do
		if v:Alive() and v:Team() ~= TEAM_SPECTATOR and v:Team() ~= TEAM_UNASSIGNED then
			table.insert(tbl,v)
		end
	end
	
	return tbl
end

function player.GetAliveTeammates(ply)
	local tbl = {}
	
	for k, v in pairs(team.GetPlayers(ply:Team())) do
		if v:Alive() then
			table.insert(tbl,v)
		end
	end
	
	return tbl
end

function Minigames:ReturnBlueAlive()
	local tbl = {}
	
	for k, v in pairs(team.GetPlayers(2)) do
		if v:Alive() then
			table.insert(tbl,v)
		end
	end
	
	return tbl

end

function Minigames:ReturnRedAlive()
		local tbl = {}
	
	for k, v in pairs(team.GetPlayers(3)) do
		if v:Alive() then
			table.insert(tbl,v)
		end
	end
	
	return tbl
end

function meta:IsGhostMode()
	return self:GetNWBool("Set_GhostMode", true)
end

function meta:SetGhost(boolean)
	return self:SetNWBool("Set_GhostMode", boolean)
end


function Minigames:DebugKick()
	for k, v in pairs(player.GetAll()) do
		if v:IsBot() then
			v:Kick()
		end
	end
end