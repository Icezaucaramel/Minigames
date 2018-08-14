hook.Add("InitPostEntity", "FT_Overrides", function()
	function Minigames:CanStartGame()
		if #team.GetPlayers(2) >= 1 and #team.GetPlayers(3) >= 1 then
			return true
		end
		
		return false
	end
	
	function Minigames:PlayedStoppedSpectating(ply)
		Minigames:ShowTeamSelect(ply)
	end

end)

hook.Add("RoundBegin", "FT_CHECK", function()
	timer.Create("CheckEnd", 1, 0, function()
		Minigames.FreezeTag:CheckWin()
		Minigames:CheckAutobalance()
	end)
end)

hook.Add("RoundEnd", "FT_Kill", function()
	timer.Destroy("CheckEnd")
end)

function Minigames:PlayerJoinedPreRound(ply)
	ply:Spawn()
end

hook.Add("PlayerInitialSpawn", "FT_Sleect", function(ply)
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

hook.Add("PlayerSpawn", "Ft_Col", function(ply)
	if ply:Team() == TEAM_RED then
		ply:SetPlayerColor(Vector(1,0,0))
	elseif ply:Team() == TEAM_BLUE then
		ply:SetPlayerColor(Vector(0,0,1))
	end
	
	ply:SetWalkSpeed(Minigames.TeamDeathmatch.WalkSpeed)
	ply:SetRunSpeed(Minigames.TeamDeathmatch.RunSpeed)
	
	for k, v in pairs(Minigames.FreezeTag.Weapons) do
		ply:Give(v)
	end
end)

hook.Add("PlayerDeath", "FT_Fallback", function(ply,i,a)
	timer.Simple(1, function()
		ply:Spawn()
	end)
end)

hook.Add("EntityTakeDamage", "FT_Freee", function(ply,dmginfo)
	if not ply:IsPlayer() then return end

	if not ply:IsFrozen() then
		if ply:Health()-dmginfo:GetDamage() <= 0 then
			dmginfo:SetDamage(0)
			ply:SetHealth(1)
			ply.OriginalCol = ply:GetColor()
			ply:Freeze(true)
			ply:SetColor(Color(0,0,255))
			dmginfo:GetAttacker():AddFrags(1)
			
			for k, v in pairs(player.GetAll()) do
				if v:Team() == ply:Team() then
					net.Start("MG_NotifyFrozen")
						net.WriteEntity(ply)
					net.Send(v)
				end
			end
		end
	else
		if ply:Team() == dmginfo:GetAttacker():Team() then
			local num = dmginfo:GetDamage()
			dmginfo:SetDamage(0)
			
			dmginfo:GetAttacker():AddFrags(1)
			ply:SetHealth(ply:Health()+num)
			
			if ply:Health() >= 100 then
				ply:Freeze(false)
				ply:SetColor(ply.OriginalCol)
			end
		end
	end
end)

function Minigames.FreezeTag:GetFrozen(teamid)
	local tbl = {}
	
	for k, v in pairs(team.GetPlayers(teamid)) do
		if v:IsFrozen() then
			table.insert(tbl,v)
		end
	end
	
	return tbl
end

function Minigames.FreezeTag:CheckWin()
	if #Minigames.FreezeTag:GetFrozen(2) == #Minigames:ReturnBlueAlive() then
		Minigames:RoundEnd(3)
	elseif #Minigames.FreezeTag:GetFrozen(3) == #Minigames:ReturnRedAlive() then
		Minigames:RoundEnd(2)
	end
end

hook.Add("PlayerShouldTakeDamage", "FT_Damage", function(ply,attacker)
	if attacker:IsPlayer() and ply:IsPlayer() then
		if attacker:Team() == ply:Team() then
			return false
		else
			if ply:IsFrozen() then
				return false
			else
				return true
			end
		end
	end
end)

hook.Add("RoundEnd", "TDM_Strip", function()
	for k, v in pairs(player.GetAll()) do
		v:StripWeapons()
		v:Freeze(false)
		if v.OriginalCol and v:GetColor() != v.OriginalCol then
			v:SetColor(v.OriginalCol)
		end
	end
end)
