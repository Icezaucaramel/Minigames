function Minigames:LoadTeddy()
	local mapfile = file.Exists("data/minigames/" .. game.GetMap() .. ".txt", "GAME")
	
	if mapfile then
		local read = file.Read("minigames/" .. game.GetMap() .. ".txt")
		
		local split_1 = string.Split(read, "/")
		local pos = split_1[1]
		local ang = split_1[2]
		
		local teddy = ents.Create("ac_teddy")
		teddy:SetPos(Vector(pos))
		teddy:SetAngles(Angle(ang))
		teddy:Spawn()
	end
end

function Minigames:CanStartGame()
	if #team.GetPlayers(2) >= 2 then 
		return true
	end
	
	return false
end

function Minigames:PlayerJoinedDuringRound(ply)
end

function Minigames:PlayerJoinedPreRound(ply)
end

function Minigames:CheckForPlayers()

	if not Minigames:CanStartGame() then
		timer.Simple(2, function()
			Minigames:CheckForPlayers()
		end)
	else
		Minigames:PreRoundBegin()
	end
	
end

--

function Minigames:PreRoundBegin()

	if Minigames.RoundState == 0 then return end
	
	game.CleanUpMap()

	if Minigames:CanStartGame() then

		Minigames.RoundState = 0
			
		net.Start("Minigames_NotifyRound")
			net.WriteString(Minigames.RoundState)
		net.Broadcast()
		
		for k, v in pairs(player.GetAll()) do
			if v:IsPlayingGame() then
				Minigames:PreRoundPlayers(v)
			end	
		end
			
		if GhostMode then
			for k, v in pairs(player.GetAll()) do
				if v:IsGhostMode() then
					GhostMode:ToggleGhostMode(v)
					v:Spawn()
				end	
			end
		end
		
		local time = 0
		if Minigames.RoundNumber < 1 then
			time = Minigames.InitialPreRound
		else
			time = Minigames.PreRound
		end
		
		timer.Simple(time, function()
			Minigames:RoundBegin()
		end)
		
		game.CleanUpMap()
		hook.Call("PreRoundBegin", GAMEMODE)
		Minigames.RoundNumber = Minigames.RoundNumber + 1
	else
		Minigames:CheckForPlayers()
	end
end

function Minigames:PreRoundPlayers(ply)
	ply:SetModel(ply.PlayerModel or "models/player/gasmask.mdl")
	ply:Spawn()
	ply:SetJumpPower(300)
	ply:SetMoveType(MOVETYPE_WALK)

	hook.Call("PreRoundPlayer", GAMEMODE, ply)
end

--

function Minigames:RoundBegin()
	if Minigames.RoundState == 1 then return end
	
	Minigames.RoundState = 1
	Minigames:LoadTeddy()
		
	if SERVER then
		net.Start("Minigames_NotifyRound")
			net.WriteString(Minigames.RoundState)
		net.Broadcast()
	
		for k, v in pairs(player.GetAll()) do
			if v:IsPlayingGame() then
				Minigames:RoundPlayers(v)
			end
		end	
	end
		
	timer.Create("MinigamasesRoundTimer", GetGlobalInt("Minigames_RoundTime"), 1, function()
		Minigames:RoundEnd()
		timer.Destroy("MinigamesRoundTimer")
	end)
	
	hook.Call("RoundBegin", GAMEMODE)
end

function Minigames:RoundPlayers(ply)
	if ply:Team() == TEAM_RED or ply:Team() == TEAM_BLUE then
		if not ply:Alive() then
			ply:Spawn()
		end
	end
	
	hook.Call("RoundPlayer", GAMEMODE, ply)
end

function Minigames:RoundEnd(state_id, winnernick)

	if Minigames.RoundState == 2 then return end
	
	for k, v in pairs(player.GetActive()) do
		v:StripWeapons()
	end

	Minigames.RoundState = 2
	
	if not state_id then
		state_id = 0
	end
	
	winnernick = winnernick or ""
	
	net.Start("Minigames_NotifyRound")
		net.WriteString(Minigames.RoundState)
		net.WriteString(state_id)
		net.WriteString(winnernick)
	net.Broadcast()

	hook.Call("RoundEnd", GAMEMODE, state_id)
	
	if Minigames.RoundNumber < Minigames.RoundLimit then
		timer.Simple(Minigames.EndOfRoundTime, function()
			Minigames:PreRoundBegin()
		end)
	else
		Minigames:LoadGamemodeVotes()
		hook.Call("VotingBegin", GAMEMODE, nil)
	end
		
end

function Minigames:PlayerRequestedRTV(ply)

	if not Minigames.CanRTV then return end

	if not Minigames.ActiveRTV then
		
		if Minigames.Cooldown and Minigames.Cooldown > CurTime() then
			ply:ChatPrint("Désolé, vous devez attendre.")
			return
		end
	
		Minigames.ActiveRTV = true
		timer.Create("Minigames_CheckRTV", Minigames.VotingTime, 1, function()
			Minigames:RTVHasFinished(false)
		end)
	end
	

	if table.HasValue(Minigames.RTVUsers, ply) then
		ply:ChatPrint("Désolé ! Tu as déjà voté!")
	else
		
		net.Start("Minigames_NotifyRTV")
			net.WriteString(ply:Nick())
			net.WriteString("voting")
		net.Broadcast()	
		table.insert(Minigames.RTVUsers, ply)
		if #Minigames.RTVUsers >= math.Round(#player.GetAll()/Minigames.RTVPercentage) then
			timer.Destroy("Minigames_CheckRTV")
			Minigames:RTVHasFinished(true)
		end
	end
end

function Minigames:RTVHasFinished(bool)
	if not Minigames.ActiveRTV then return end
	Minigames.RTVUsers = {}
	Minigames.ActiveRTV = false
	
	if bool then
		if Minigames.RoundState == 1 then
			Minigames.RoundNumber = Minigames.RoundLimit
		else
			timer.Simple(3, function()
				Minigames:LoadGamemodeVotes()
			end)
		end
		net.Start("Minigames_NotifyRTV")
			net.WriteString("")
			net.WriteString("success")
		net.Broadcast()	
	else
		net.Start("Minigames_NotifyRTV")
			net.WriteString("")
			net.WriteString("failed")
		net.Broadcast()
		Minigames.Cooldown = CurTime() + Minigames.RTVCooldown
	end
end

function Minigames:CheckWinningTeam()
	if Minigames.RoundState ~= 1 then return end
	if #Minigames:ReturnBlueAlive() <= 0 and #Minigames:ReturnRedAlive() > 0 then
		Minigames:RoundEnd(3)
	elseif #Minigames:ReturnBlueAlive() > 0 and #Minigames:ReturnRedAlive() <= 0 then
		Minigames:RoundEnd(2)
	elseif #Minigames:ReturnBlueAlive() <= 0 and #Minigames:ReturnRedAlive() <= 0 then
		Minigames:RoundEnd(4)
	end
	
end

local autobalance_cooldown = nil
function Minigames:CheckAutobalance()

	if autobalance_cooldown and autobalance_cooldown > CurTime() then return end

	local highest_team = nil
	local lowest_team = nil
	if #team.GetPlayers(2) == 1 and #team.GetPlayers(3)== 1 then return end
	
	if #team.GetPlayers(2) > #team.GetPlayers(3) then
		highest_team = 2
		lowest_team = 3
	elseif #team.GetPlayers(3) > #team.GetPlayers(2) then
		highest_team = 3
		lowest_team = 2
	end
	
	if not highest_team and not lowest_team then return end
	
	local swaps = false
	local difference = (#team.GetPlayers(highest_team)) - (#team.GetPlayers(lowest_team))
	if difference > 1 then
		swaps = true
	end
	
	if swaps then
		local score = 999
		local lowest_scoring = nil
		for k, v in pairs(team.GetPlayers(highest_team)) do
			if v:Frags() < score then
				score = v:Frags()
				lowest_scoring = v
			end
		end
		autobalance_cooldown = CurTime() + 2
		lowest_scoring:SetTeam(lowest_team)
		lowest_scoring:Kill()
		timer.Simple(1, function()
			lowest_scoring:Spawn()
		end)
		net.Start("MG_NotifyTeamBalance")
			net.WriteString(lowest_scoring:Nick())
			net.WriteString(lowest_team)
		net.Broadcast()	
	end

end
