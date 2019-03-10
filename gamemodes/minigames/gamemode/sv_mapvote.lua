net.Receive("Minigames_SendMap", function(len,ply)

	if not Minigames.InVote then return end
	
	local votestring = net.ReadString()
	
	if not ply.LastVotedMap then
		Minigames.VotedMaps[votestring] = Minigames.VotedMaps[votestring] + 1
	else
		Minigames.VotedMaps[ply.LastVotedMap] = Minigames.VotedMaps[ply.LastVotedMap] - 1
		Minigames.VotedMaps[votestring] = Minigames.VotedMaps[votestring] + 1
	end
	
	net.Start("MG_VOTENotif")
		net.WriteEntity(ply)
		net.WriteString(votestring)
		net.WriteString(ply.LastVotedMap or "")
	net.Broadcast()	
	
	ply.LastVotedMap = votestring

end)

net.Receive("Minigames_MapVote_CtS", function(len,ply)

	if not Minigames.InVote then return end
	
	local votestring = net.ReadString()
	
	//if ply not previously voted...
	if not ply.LastVotedGamemode then
		Minigames.Gamemodes[votestring] = Minigames.Gamemodes[votestring] + 1
	else
		Minigames.Gamemodes[ply.LastVotedGamemode] = Minigames.Gamemodes[ply.LastVotedGamemode] - 1
		Minigames.Gamemodes[votestring] = Minigames.Gamemodes[votestring] + 1
	end
	
	local tbl = {
		votestring,
		ply.LastVotedGamemode or nil,
	}

	net.Start("Minigames_MapVote_SbtC")
		net.WriteTable(tbl)
	net.Broadcast()
	
	net.Start("MG_VOTENotif")
		net.WriteEntity(ply)
		net.WriteString(votestring)
		net.WriteString(ply.LastVotedGamemode or "")
	net.Broadcast()
	
	ply.LastVotedGamemode = votestring
end)

--


function Minigames:LoadGamemodeVotes()

	if not Minigames.DefaultMapvote then return end

	for k, v in pairs(player.GetAll()) do
		v:StripWeapons()
		v:Freeze(true)
	end

	Minigames.InVote = true
	timer.Create("Minigames_GamemodeVote", Minigames.GamevoteTimer, 1, function()
		
		local winning_num = 0
		local winning_key = nil
		
		for k, v in pairs(Minigames.Gamemodes) do
			if v > winning_num then
				winning_num = v
				winning_key = k
			end
		end
		
	
		if not winning_key then
			local random = table.Random(Minigames.Gamemodes)
			winning_key = table.KeyFromValue(Minigames.Gamemodes,random)
		end
		
			net.Start("MG_DisplayWinner")
				net.WriteString(winning_key)
			net.Broadcast()	
			
			local tbl = {}
			
			for i=1,10 do
				local map = table.Random(Minigames:DefineVoteInfo(winning_key))
				table.insert(tbl, map)
				
				//ABSOLUTELY DISGUSTING
				--table remove was being a silly billy
				if Minigames:DefineVoteInfo(winning_key)[table.KeyFromValue(Minigames:DefineVoteInfo(winning_key), map)] then
					Minigames:DefineVoteInfo(winning_key)[table.KeyFromValue(Minigames:DefineVoteInfo(winning_key), map)] = nil
				end	
			end
		
			for k, v in pairs(tbl) do
				Minigames.VotedMaps[v] = 0
			end
		
			net.Start("Minigames_MapChoice")
				net.WriteString(winning_key)
				net.WriteTable(tbl)
			net.Broadcast()
			
			timer.Create("Minigames_MapVote", Minigames.Map_Timer, 1, function()
				Minigames:LoadWinningMap()
			end)

	end)
	
	Minigames.VotedMaps = {}
	
	net.Start("Minigames_MapVote")
		net.WriteBool(true)
	net.Broadcast()
	
end 

function Minigames:LoadWinningMap()
	
	local winning_num = 0
	local winning_key = nil

	for k, v in pairs(Minigames.VotedMaps) do
		if v > winning_num then
			winning_num = v
			winning_key = k
		end
	end
	
	if not winning_key then
		local random = table.Random(Minigames.VotedMaps)
		winning_key = table.KeyFromValue(Minigames.VotedMaps,random)
	end
	
	RunConsoleCommand("changelevel", winning_key)
	
	timer.Simple(2, function()
		print("[MINIGAMES] " .. winning_key .. " could not load! Missing from /maps. Changing to "..Minigames.FallbackMap.." instead.")
		for k, v in pairs(player.GetAll()) do
			v:ChatPrint("[MINIGAMES] " .. winning_key .. " ne peut pas charger! Missing from /maps. Changing to "..Minigames.FallbackMap.." instead.")
		end
		RunConsoleCommand("changelevel", Minigames.FallbackMap)
	end)
end