//ROUND NOTIFICATIONS
net.Receive("Minigames_NotifyRound", function()
	local number = tonumber(net.ReadString())
	local winner = tonumber(net.ReadString())
	local winner_nick = net.ReadString()
	
	Minigames.RoundState = number
	
	if number != 1 then
		if timer.Exists("MinigamesRoundTimer") then
			timer.Destroy("MinigamesRoundTimer")
		end
	else
		timer.Create("MinigamesRoundTimer", GetGlobalInt("Minigames_RoundTime"), 1, function()
			timer.Destroy("MinigamesRoundTimer")
		end)
	end
	
	if number == 0 then
		
		local time = 0
		if Minigames.RoundNumber < 1 then
			time = Minigames.InitialPreRound
		else
			time = Minigames.PreRound
		end
	
		chat.AddText(Color(242,99,91), "[MINIGAMES] ", Color(255,255,255), "Préparez vous! Le Round commence dans ", Color(67,191,227), time .. " secondes", Color(255,255,255), ".")
	elseif number == 1 then
		chat.AddText(Color(242,99,91), "[MINIGAMES] ", Color(255,255,255), "Tu joues à", Color(67,191,227), Minigames:ReturnGamemodeString(), Color(255,255,255), "! Appuie sur F1 pour les règles.")
	elseif number == 2 then
		Minigames.RoundNumber = Minigames.RoundNumber + 1
		if winner == 0 then
			chat.AddText(Color(242,99,91), "[MINIGAMES] ", Color(255,255,255), "Round términé! Le timer s'est écoulé.")
		elseif winner == 1 then
			chat.AddText(Color(242,99,91), "[MINIGAMES] ", Color(255,255,255), "Round términé! Le gagnant est", Color(67,191,227), winner_nick, Color(255,255,255), "!" )
		elseif winner == 2 then
			chat.AddText(Color(242,99,91), "[MINIGAMES] ", Color(255,255,255), "Round términé! Le gagnant est", Color(67,191,227), " Équipe Bleu", Color(255,255,255), "!" )
		elseif winner == 3 then
			chat.AddText(Color(242,99,91), "[MINIGAMES] ", Color(255,255,255), "Round términé! Le gagnant est", Color(67,191,227), " Équipe Rouge", Color(255,255,255), "!" )
		elseif winner == 4 then
			chat.AddText(Color(242,99,91), "[MINIGAMES] ", Color(255,255,255), "Round términé! Pas de gagnants." )
		end
	end
end)

//KILLING
net.Receive("Minigames_PointsOnKill", function()
	local attacker = net.ReadString()
	local ply = net.ReadString()
	
	chat.AddText(Color(242,99,91), "[MINIGAMES] ", Color(255,255,255), "Tu as reçu ", Color(67,191,227), Minigames.PointsPerKill .. " points ", Color(255,255,255), "pour avoir tué ", Color(67,191,227), ply, Color(255,255,255), "!")
end)

net.Receive("MG_NotifyTeamBalance", function()
	local ply = net.ReadString()
	local moved = net.ReadString()
	
	local strng = nil
	if moved == "2" then
		strng = "Blue"
	else
		strng = "Red"
	end

	chat.AddText(Color(242,99,91), "[MINIGAMES] ", Color(67,191,227),ply, Color(255,255,255), " as été déplacé",  Color(67,191,227), " Équipe " .. strng, Color(255,255,255), " par l'auto-balance!")
end)

net.Receive("CTF_FlagToggle", function()
	local toggle = net.ReadBool()
	local ply = net.ReadString()
	local flag = tonumber(net.ReadString())
	
	local teamstring = "Team Blue"
	if flag == 3 then
		teamstring = "Team Red"
	end
	
	if toggle then
		chat.AddText(Color(242,99,91), "[MINIGAMES] ", Color(67,191,227), ply, Color(255,255,255), " A pris ", Color(67,191,227),teamstring, Color(255,255,255), "Drapeau!")
	else
		chat.AddText(Color(242,99,91), "[MINIGAMES] ", Color(67,191,227), teamstring, Color(255,255,255), "Drapeau est tombé! Reset dans", Color(61,191,227), tostring(Minigames.CaptureTheFlag.FlagReset), Color(255,255,255), " seconds!")
	end
end)

net.Receive("CTF_Reset", function()
	local flag = tonumber(net.ReadString())
	
	local teamstring = "Team Blue"
	if flag == 3 then
		teamstring = "Team Red"
	end

	chat.AddText(Color(242,99,91), "[MINIGAMES] ", Color(67,191,227), teamstring, Color(255,255,255), "Drapeau a été reset")
end)

net.Receive("CTF_Capt", function()
	local flag = tonumber(net.ReadString())
	
	local teamstring = "Team Blue"
	if flag == 3 then
		teamstring = "Team Red"
	end

	chat.AddText(Color(242,99,91), "[MINIGAMES] ", Color(67,191,227), teamstring, Color(255,255,255), " a capturé la drapeau")
end)

net.Receive("CTF_SendCaptures", function()
	Minigames.BlueCaps = net.ReadString()
	Minigames.RedCaps = net.ReadString()
end)

net.Receive("CTF_AddCapture", function()
	local team_add = net.ReadString()
	
	if team_add == "blue" then
		Minigames.BlueCaps = Minigames.BlueCaps + 1
	else
		Minigames.RedCaps = Minigames.RedCaps + 1	
	end
end)

net.Receive("MG_DisplayWinner", function()
	local winning_key = net.ReadString()

	chat.AddText(Color(242,99,91), "[MINIGAMES] ", Color(255,255,255), "Le choix du gamemode est finit! Le gagnant est ", Color(67,191,227), winning_key, Color(255,255,255), "!")
end)

net.Receive("Minigames_NotifyRTV", function()
	local user = net.ReadString()
	local state = net.ReadString()
	
	if state == "voting" then
		chat.AddText(Color(242,99,91), "[MINIGAMES] ", Color(67,191,227), user, Color(255,255,255), " veux RTV! écrivez ", Color(67,191,227), "/rtv", Color(255,255,255), " pour changer de map.")
	elseif state == "failed" then
		chat.AddText(Color(242,99,91), "[MINIGAMES] ", Color(255,255,255), "RTV failed! Pas assez de gens ont votés.")
	elseif state == "success" then
		chat.AddText(Color(242,99,91), "[MINIGAMES] ", Color(255,255,255), "RTV Réussis!")
	end	
end)

net.Receive("MG_SendInitalData", function()
	Minigames.RoundNumber = tonumber(net.ReadString())
	Minigames.RoundLimit = tonumber(net.ReadString())
	
end)


net.Receive("Team_Select", function()
	Minigames:SelectTeams()
end)

net.Receive("F_Help", function()
	Minigames:OpenHelpMenu()
end)

net.Receive("MG_NotifyScramble", function()
	local ply = net.ReadString()
	
	chat.AddText(Color(242,99,91), "[MINIGAMES] ", Color(67,191,227), ply, Color(255,255,255), "à mélanger les équipes!")
end)