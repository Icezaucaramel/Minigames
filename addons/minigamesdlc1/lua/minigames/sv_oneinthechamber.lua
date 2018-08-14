//We are gonna use TDM as a skeleton here

hook.Add("InitPostEntity", "OITC_Overrides", function()
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

hook.Add("RoundEnd", "OITC_END", function()
	timer.Destroy("CheckEnd")
end)

function Minigames:PlayerJoinedPreRound(ply)
	ply:Spawn()
end

hook.Add("RoundBegin", "TDM_Check", function()
	timer.Create("CheckEnd", 1, 0, function()
		Minigames:CheckWinningTeam()
		Minigames:CheckAutobalance()
	end)
end)


hook.Add("PlayerInitialSpawn", "OITC_Select", function(ply)
	if not ply:IsBot() then
		Minigames:ShowTeamSelect(ply)
	else
		ply:SetTeam(3)
	end
end)

hook.Add("PlayerSpawn", "OITC_Color", function(ply)
	if ply:Team() == TEAM_RED then
		ply:SetPlayerColor(Vector(1,0,0))
		local tbl = table.Random(ents.FindByClass("info_player_terrorist"))
		ply:SetPos(tbl:GetPos())
	elseif ply:Team() == TEAM_BLUE then
		ply:SetPlayerColor(Vector(0,0,1))
		local tbl = table.Random(ents.FindByClass("info_player_counterterrorist"))
		ply:SetPos(tbl:GetPos())
	end
	
	ply:SetWalkSpeed(Minigames.OneInTheChamber.WalkSpeed)
	ply:SetRunSpeed(Minigames.OneInTheChamber.RunSpeed)
	ply:Give("weapon_oitc_pistol")
	ply:Give("weapon_crowbar")
	
	ply.NumberOfBullets = 1
	
	net.Start("MG_OITC_Notify")
		net.WriteBool(false)
	net.Send(ply)
end)

hook.Add("PlayerDeath", "OITC_Bullets", function(ply,inflic,attacker)
	if attacker:IsPlayer() then
		attacker.NumberOfBullets = attacker.NumberOfBullets + 1
		
		net.Start("MG_OITC_Notify")
			net.WriteBool(true)
		net.Send(attacker)
	end
end)

hook.Add("PlayerShouldTakeDamage", "OITC_CHECK", function(ply,attacker)
	if attacker:IsPlayer() and ply:IsPlayer() and attacker:Team() == ply:Team() then
		return false
	end

	return true
end)

hook.Add("RoundEnd", "OITC_Strip", function()
	for k, v in pairs(player.GetAll()) do
		v:StripWeapons()
	end
end)

//look i'm shit at normal sweps, I have no idea how to make a fuckin melee one so let's cheat
hook.Add("EntityTakeDamage", "FT_Freee", function(ply,dmginfo)
	if not ply:IsPlayer() then return end
	
	if dmginfo:GetAttacker():IsPlayer() and dmginfo:GetAttacker():GetActiveWeapon():GetClass() == "weapon_crowbar" then
		dmginfo:ScaleDamage(100)
		dmginfo:GetAttacker().NumberOfBullets = attacker.NumberOfBullets + 1
		net.Start("MG_OITC_Notify")
			net.WriteBool(true)
		net.Send(ply)
	end
end)
