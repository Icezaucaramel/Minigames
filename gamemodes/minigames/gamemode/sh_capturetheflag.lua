hook.Add("PlayerSpawn", "CTF_COlour", function(ply)
	if ply:Team() == TEAM_RED then
		ply:SetPlayerColor(Vector(1,0,0))
		local tbl = table.Random(Minigames.CaptureTheFlag.RedSpawns or ents.FindByClass("info_player_terrorist"))
		ply:SetPos(tbl:GetPos())
	elseif ply:Team() == TEAM_BLUE then
		ply:SetPlayerColor(Vector(0,0,1))
		local tbl = table.Random(Minigames.CaptureTheFlag.BlueSpawns or ents.FindByClass("info_player_counterterrorist"))
		ply:SetPos(tbl:GetPos())
	end
	
	ply:SetWalkSpeed(Minigames.CaptureTheFlag.WalkSpeed)
	ply:SetRunSpeed(Minigames.CaptureTheFlag.RunSpeed)
	Minigames:GiveRandom(ply)
end)

function Minigames:PlayerJoinedDuringRound(ply)
	ply:Spawn()
end

function Minigames:PlayerJoinedPreRound(ply)
	if not ply.WaitingForRevive then
		ply:Spawn()
	end
end

hook.Add("PlayerDisconnected", "CTF_KillCarrier", function(ply)
	if Minigames.CaptureTheFlag.Holders[ply:Team()] == ply then
		Minigames.CaptureTheFlag.Holders[ply:Team()] = nil
	end
end)

hook.Add("PlayerInitialSpawn", "CTF_Spawn", function(ply)
	if not ply:IsBot() then
		Minigames:ShowTeamSelect(ply)
	else
		ply:SetTeam(3)
	end
	
	timer.Simple(1, function()
	net.Start("CTF_SendCaptures")
		net.WriteString(Minigames.CaptureTheFlag.BlueCaptures or 0)
		net.WriteString(Minigames.CaptureTheFlag.RedCaptures or 0)
	net.Send(ply)
	end)
end)

hook.Add("PreRoundBegin", "CTF_SetUpVar", function()
	Minigames.CaptureTheFlag.BlueCaptures = 0
	Minigames.CaptureTheFlag.RedCaptures = 0
	
	Minigames.CaptureTheFlag.Holders = {}
	
	local tbl = table.Random(ents.FindByClass("info_player_counterterrorist"))
	Minigames.CaptureTheFlag.BlueFlag = ents.Create("mg_ctf")
	Minigames.CaptureTheFlag.BlueFlag:SetPos(tbl:GetPos())
	Minigames.CaptureTheFlag.BlueFlag:Spawn()
	Minigames.CaptureTheFlag.BlueFlag.StartingPos = Minigames.CaptureTheFlag.BlueFlag:GetPos()
	Minigames.CaptureTheFlag.BlueFlag.TeamID = 2
	SetGlobalVector("CTF_BlueBase",Minigames.CaptureTheFlag.BlueFlag:GetPos())
	
	Minigames.CaptureTheFlag.BlueSpawns = {}
	for k, v in pairs(ents.GetAll()) do
		if v:GetClass() == "info_player_counterterrorist" then
			if v:GetPos() ~= Minigames.CaptureTheFlag.BlueFlag.StartingPos then
				table.insert(Minigames.CaptureTheFlag.BlueSpawns,v)
			end
		end
	end
	 
	local tbl_2 = table.Random(ents.FindByClass("info_player_terrorist"))
	Minigames.CaptureTheFlag.RedFlag = ents.Create("mg_ctf")
	Minigames.CaptureTheFlag.RedFlag:SetPos(tbl_2:GetPos())
	Minigames.CaptureTheFlag.RedFlag:Spawn()
	Minigames.CaptureTheFlag.RedFlag.StartingPos = Minigames.CaptureTheFlag.RedFlag:GetPos()
	Minigames.CaptureTheFlag.RedFlag.TeamID = 3
	SetGlobalVector("CTF_RedBase",Minigames.CaptureTheFlag.RedFlag:GetPos())
	
	Minigames.CaptureTheFlag.RedSpawns = {}
	for k, v in pairs(ents.GetAll()) do
		if v:GetClass() == "info_player_terrorist" then
			if v:GetPos() ~= Minigames.CaptureTheFlag.RedFlag.StartingPos then
				table.insert(Minigames.CaptureTheFlag.RedSpawns,v)
			end
		end
	end
end)

hook.Add("RoundBegin", "CTF_Timers", function()
	timer.Create("CTF_Timer", 1, 0, function()
		Minigames:CheckAutobalance()
		Minigames:CheckFlagWinners()
	end)
end)

hook.Add("PlayerDeath", "CTF_Die", function(ply)
	ply.WaitingForRevive = true
	ply:ChatPrint("Respawn dans " .. Minigames.CaptureTheFlag.RespawnTime .. " seconds!")
	timer.Simple(Minigames.CaptureTheFlag.RespawnTime, function()
		ply:Spawn()
		ply.WaitingForRevive = false
	end)
	
	for k, v in pairs(Minigames.CaptureTheFlag.Holders) do
		if v == ply then
			if k == 2 then
				Minigames.CaptureTheFlag.BlueFlag:DroppedFlag()
			else
				Minigames.CaptureTheFlag.RedFlag:DroppedFlag()
			end
		end
	end
end)

hook.Add("RoundEnd", "CTF_RoundEnd", function()
	timer.Destroy("CTF_Timer")
end)

function Minigames:CanStartGame()
	if #team.GetPlayers(2) >= 1 and #team.GetPlayers(3) >= 1 then
		return true
	end
	
	return false
end

function Minigames:CheckFlagWinners()
	if Minigames.CaptureTheFlag.BlueCaptures >= Minigames.CaptureTheFlag.WinCondition then
		Minigames:RoundEnd(2)
	end
	
	if Minigames.CaptureTheFlag.RedCaptures >= Minigames.CaptureTheFlag.WinCondition then
		Minigames:RoundEnd(3)
	end
end

function Minigames:PlayedStoppedSpectating(ply)
	Minigames:ShowTeamSelect(ply)
end

