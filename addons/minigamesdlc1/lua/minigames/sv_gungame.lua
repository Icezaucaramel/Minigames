-- We are gonna use TDM as a skeleton here

hook.Add("InitPostEntity", "GG_Overrides", function()
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

hook.Add("RoundEnd", "GG_CheckEND", function()
	timer.Destroy("CheckEnd")
	
	for k, v in pairs(player.GetAll()) do
		v:StripWeapons()
		v.WeaponLvl = 1
	end
end)

function Minigames:PlayerJoinedPreRound(ply)
	ply:Spawn()
end

hook.Add("RoundBegin", "GG_CheckStart", function()
	timer.Create("CheckEnd", 1, 0, function()
		Minigames:CheckAutobalance()
	end)
end)


hook.Add("PlayerInitialSpawn", "GG_Pis", function(ply)
	if not ply:IsBot() then
		Minigames:ShowTeamSelect(ply)
	else
		ply:SetTeam(3)
	end
	
	ply.WeaponLvl = 1
end)

hook.Add("PlayerSpawn", "GG_Spawn", function(ply)
	if ply:Team() == TEAM_RED then
		ply:SetPlayerColor(Vector(1,0,0))
		local tbl = table.Random(ents.FindByClass("info_player_terrorist"))
		ply:SetPos(tbl:GetPos())
		
		ply:Give(Minigames.GG.Weapons[ply.WeaponLvl])
		ply:Give("weapon_crowbar")
	elseif ply:Team() == TEAM_BLUE then
		ply:SetPlayerColor(Vector(0,0,1))
		local tbl = table.Random(ents.FindByClass("info_player_counterterrorist"))
		ply:SetPos(tbl:GetPos())
		
		ply:Give(Minigames.GG.Weapons[ply.WeaponLvl or 1])
		ply:Give("weapon_knife")
	end
	
	ply:SetWalkSpeed(Minigames.GG.WalkSpeed)
	ply:SetRunSpeed(Minigames.GG.RunSpeed)
	
	if Minigames.GG.SpawnProtection > 0 then
		ply:GodEnable()
		
		timer.Simple(Minigames.GG.SpawnProtection, function()
			ply:GodDisable()
		end)
	end
	
end)

hook.Add("PlayerDeath", "GG_Death", function(ply,inflic,attacker)

	if attacker:IsPlayer() and attacker != ply then
		attacker:StripWeapon(Minigames.GG.Weapons[attacker.WeaponLvl])
		
		attacker.WeaponLvl = attacker.WeaponLvl + 1
		attacker:Give(Minigames.GG.Weapons[attacker.WeaponLvl])
		attacker:SelectWeapon(Minigames.GG.Weapons[attacker.WeaponLvl])
		
		if attacker.WeaponLvl >= #Minigames.GG.Weapons then
			if Minigames.UsePointshop then
				ply:PS_GivePoints(Minigames.GG.WinnerPoints)
			elseif Minigames.UsePointshop_2 then
				attacker:PS2_AddStandardPoints(Minigames.GG.WinnerPoints, "",true)
			end
			
			net.Start("MG_NotifyGG")
			net.Send(attacker)
			
			Minigames:RoundEnd(attacker:Team())
		end
		
		timer.Simple(Minigames.GG.RespawnTime, function()
			ply:Spawn()
		end)
	end
end)

hook.Add("PlayerShouldTakeDamage", "GG_Damage", function(ply,attacker)
	if attacker:IsPlayer() and ply:IsPlayer() and attacker:Team() == ply:Team() then
		return false
	end

	return true
end)

