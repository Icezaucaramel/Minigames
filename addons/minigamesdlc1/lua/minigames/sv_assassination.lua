//We are gonna use TDM as a skeleton here
hook.Add("RoundEnd", "OITC_END", function()
	timer.Destroy("CheckEnd")
end)

hook.Add("InitPostEntity", "VIP_Override", function()
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


hook.Add("PreRoundBegin", "VIP", function()
	Minigames.VIP.VIP = table.Random(team.GetPlayers(2))
	Minigames.VIP.VIP:SetModel("models/player/breen.mdl")
	Minigames.VIP.ExtractPoint = table.Random(ents.FindByClass("info_player_terrorist"))

	local finish = ents.Create("vip_extract")
	finish:SetPos(Minigames.VIP.ExtractPoint:GetPos())
	finish:Spawn()
	
	net.Start("MG_NotifyPicked")
		net.WriteEntity(Minigames.VIP.VIP)
	net.Broadcast()
	
	timer.Create("CheckBalance", 1, 0, function()
		Minigames:CheckAutobalance()
	end)
	
	SetGlobalVector("VIP_Extract",finish:GetPos())
end)

hook.Add("PlayerDeath", "VIP_Kill", function(ply,inflic,attacker)
	if ply == Minigames.VIP.VIP then
		Minigames:RoundEnd(3)
	else
		timer.Simple(Minigames.VIP.RespawnTime, function()
			ply:Spawn()
		end)
	end
end)

function Minigames:PlayerJoinedPreRound(ply)
	ply:Spawn()
end

hook.Add("PlayerInitialSpawn", "OITC_Select", function(ply)
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


local civs = {
	"models/player/Group03/male_01.mdl",
	"models/player/Group03/male_02.mdl",
	"models/player/Group03/male_04.mdl",
	"models/player/Group03m/male_01.mdl",
	"models/player/Group03m/female_03.mdl",
	"models/player/Group03m/female_01.mdl",
}

hook.Add("PlayerSpawn", "VIPC_Color", function(ply)
	if ply:Team() == TEAM_RED then
		
		ply:SetModel("models/player/phoenix.mdl")
		ply:SetPlayerColor(Vector(1,0,0))
		local tbl = table.Random(ents.FindByClass("info_player_terrorist"))
		ply:SetPos(tbl:GetPos())
	elseif ply:Team() == TEAM_BLUE then
		ply:SetModel(table.Random(civs))
		ply:SetPlayerColor(Vector(0,0,1))
		local tbl = table.Random(ents.FindByClass("info_player_counterterrorist"))
		ply:SetPos(tbl:GetPos())
	end
	
	ply:SetWalkSpeed(Minigames.VIP.WalkSpeed)
	ply:SetRunSpeed(Minigames.VIP.RunSpeed)
	
	timer.Simple(1, function()
		if ply == Minigames.VIP.VIP then
			ply:Give("weapon_crowbar")
		else
			Minigames:GiveRandom(ply)
		end
	end)
end)

hook.Add("PlayerShouldTakeDamage", "OITC_CHECK", function(ply,attacker)
	if attacker:IsPlayer() and ply:IsPlayer() and attacker:Team() == ply:Team() then
		return false
	end

	return true
end)

hook.Add("RoundEnd", "VIP_end", function()
	for k, v in pairs(player.GetAll()) do
		v:StripWeapons()
		
		if v:Team() == 2 then
			v:SetTeam(3)
		elseif v:Team() == 3 then
			v:SetTeam(2)
		end
		
		v:ChatPrint("Swapping teams!")
	end
	
	timer.Destroy("CheckBalance")
	
end)

hook.Add("ShouldCollide", "VIP_Coll", function(a,b)
	if a:IsPlayer() and b:GetClass() == "vip_extract" then
		if a:Team() == 3 then
			return false
		end
	end
end)