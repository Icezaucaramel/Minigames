hook.Add("RoundBegin", "SB_Check", function()
	timer.Create("CheckEnd", 1, 0, function()
		Minigames:CheckWinningTeam()
	end)
end)

hook.Add("RoundEnd", "SB_End", function()
	timer.Destroy("CheckEnd")
end)

hook.Add("PlayerInitialSpawn", "SB_Select", function(ply)
	timer.Simple(0.5, function()
		ply:SetTeam(TEAM_BLUE)
	end)
	timer.Simple(0.6, function()
		local choices = {}
		for k,v in pairs(player.GetAll()) do
		  if !v:IsSpec() and !v:IsActiveTraitor() then
			 table.insert(choices, v)
		  end
		end
		local pick = math.random(1, #choices)
		local target = choices[pick]
		target:SetTeam(TEAM_RED)
	end) 
end)

function Minigames:PlayerJoinedPreRound(ply)
	ply:Spawn()
end

function Minigames:CanStartGame()
	if #team.GetPlayers(2) >= 1 and #team.GetPlayers(3) >= 1 then
		return true
	end
	
	return false
end

function Minigames:PlayedStoppedSpectating(ply)
	ply:SetTeam(TEAM_RED)
end

hook.Add("PlayerShouldTakeDamage", "SB_TD", function(ply,attacker)
	if attacker:IsPlayer() and ply:IsPlayer() and attacker:Team() == ply:Team() then
		return false
	end
end)

hook.Add("RoundEnd", "SB_Strip", function()
	for k, v in pairs(player.GetAll()) do
		v:StripWeapons()
	end
end)

hook.Add("PlayerDeath", "SB_Die", function(ply)
	if ply:Team() == TEAM_RED then
	ply:ChatPrint("Respawning in " .. Minigames.SuicideBarrels.RespawnTime .. " seconds!")
	timer.Simple(Minigames.SuicideBarrels.RespawnTime, function()
		if ply:Team() == TEAM_BLUE then
			ply:SetTeam(TEAM_RED)
		end
		ply:Spawn()
	end)
end)

hook.Add("PlayerSpawn", "TDM_Color", function(ply)
	if ply:Team() == TEAM_RED then
		local tbl = table.Random(ents.FindByClass("info_player_terrorist"))
		ply:SetModel(models\props_phx\oildrum001_explosive.mdl)
		ply:SetPos(tbl:GetPos())
		ply:SetWalkSpeed(Minigames.SuicideBarrels.Barrels.WalkSpeed)
		ply:SetRunSpeed(Minigames.SuicideBarrels.Barrels.RunSpeed)
		ply:Give("weapon_sb_barrelsuicider")
	elseif ply:Team() == TEAM_BLUE then
		local tbl = table.Random(ents.FindByClass("info_player_counterterrorist"))
		ply:SetPos(tbl:GetPos())
		ply:SetWalkSpeed(Minigames.SuicideBarrels.Humans.WalkSpeed)
		ply:SetRunSpeed(Minigames.SuicideBarrels.Humans.RunSpeed)
		ply:Give("weapon_sb_barrelslayer")
	end
	
end)

hook.Add("RoundEnd", "SB_Strip", function()
	for k, v in pairs(player.GetAll()) do
		v:StripWeapons()
	end
end)
