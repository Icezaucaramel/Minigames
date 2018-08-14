Minigames = Minigames or {}
Minigames.OneInTheChamber = Minigames.OneInTheChamber or {}
Minigames.FreezeTag = Minigames.FreezeTag or {}
Minigames.VIP = Minigames.VIP or {}
Minigames.GG = Minigames.GG or {}

Minigames.IsPlayingDLC = false
Minigames.DLC = true

if SERVER then
	util.AddNetworkString("MG_SendInfoString")
	util.AddNetworkString("MG_NotifyPicked")
	util.AddNetworkString("MG_NotifyFrozen")
	util.AddNetworkString("MG_NotifyGG")
	util.AddNetworkString("MG_OITC_Notify")
	
	hook.Add("PlayerInitialSpawn", "GetDLCInfo", function(ply)
		if Minigames.IsPlayingDLC then
			net.Start("MG_SendInfoString")
				net.WriteString(Minigames.InfoString)
			net.Send(ply)
		end
	end)
	include("mg_ff1_config.lua")
	AddCSLuaFile("mg_ff1_config.lua")
	AddCSLuaFile("sv_assassination.lua")
	
	if Minigames.FastDL_DLC then
		resource.AddFile("materials/niandralades/minigames/dlc/vip.png")
		resource.AddFile("materials/niandralades/minigames/dlc/protect.png")
	else
		resource.AddFile("684715114")
	end
else
	include("mg_ff1_config.lua")
	local extract_png =  Material("materials/niandralades/minigames/dlc/vip.png")
	local protect_png =  Material("materials/niandralades/minigames/dlc/protect.png")
	
	net.Receive("MG_SendInfoString", function()
		Minigames.InfoString = net.ReadString()
	end)
	
	net.Receive("MG_OITC_Notify", function()
		
		local bool = net.ReadBool() 
	
		if bool then
			if not LocalPlayer().NumberOfBullets then
				LocalPlayer().NumberOfBullets = 1
			end
		
			LocalPlayer().NumberOfBullets = LocalPlayer().NumberOfBullets + 1
		else
			LocalPlayer().NumberOfBullets = false
		end
	end)
	
	net.Receive("MG_NotifyFrozen", function()
		local ply = net.ReadEntity()
		
		if ply != LocalPlayer() then
			chat.AddText(Color(242,99,91), "[MINIGAMES] ", Color(67,191,227), ply:Nick(), Color(255,255,255), " has been been frozen!")
		else
			surface.PlaySound("physics/glass/glass_bottle_impact_hard1.wav")
		end
	end)
	
	net.Receive("MG_NotifyGG", function()		
		chat.AddText(Color(242,99,91), "[MINIGAMES] ", Color(255,255,255), "You got ", Color(67,191,227),  tostring(Minigames.GG.WinnerPoints) .. " Points", Color(255,255,255), " for winning Gun Game!")
	end)
	
	
	net.Receive("MG_NotifyPicked", function()
		local ply = net.ReadEntity()
		
		chat.AddText(Color(242,99,91), "[MINIGAMES] ", Color(67,191,227), ply, Color(255,255,255), " has been picked as the VIP!")
		if ply != LocalPlayer() then
			if ply:Team() == LocalPlayer():Team() then
				chat.AddText(Color(242,99,91), "[MINIGAMES] ", Color(255,255,255), "Protect ", Color(67,191,227), ply:Nick(), Color(255,255,255), " and get them to the extract point!")
			else
				chat.AddText(Color(242,99,91), "[MINIGAMES] ", Color(255,255,255), "Kill ", Color(67,191,227), ply:Nick(), Color(255,255,255), " and stop them from getting to the extract point!")
			end
		else
			chat.AddText(Color(242,99,91), "[MINIGAMES] ", Color(255,255,255), "You must get to the extract point!")
		end
		
		Minigames:UpdateVIP(ply)
	end)
	
	function Minigames:UpdateVIP(ply)
		Minigames.VIP_CS = ply
	end
	
	local mat = Material("materials/niandralades/minigames/bullets.png")
	hook.Add("HUDPaint", "VIP_C", function()
		if Minigames.CustomHUD then return end
		if Minigames.ScoreboardOpen then return end
		if Minigames.MapvoteOpen then return end
		
		if Minigames:IsPlayingOITC() then
			if LocalPlayer():Alive() then
				surface.SetDrawColor(Color(255,255,255,255)) 
				surface.SetMaterial(mat)
				surface.DrawTexturedRect(20, ScrH()-32-64-32-38,32,32)
				draw.DrawText(LocalPlayer().NumberOfBullets or 1, "NexaLight55", 32+32, ScrH()-32-64-32-50, Color(255,255,255, 255),TEXT_ALIGN_LEFT)
			end
		end
	
		if Minigames.VIP_CS and Minigames.VIP_CS:Alive() then
			if LocalPlayer() == Minigames.VIP_CS then
				draw.DrawText("You are the VIP. Get to the extract point!", "Roboto15", ScrW()/2, 100, Color(34,167,240),TEXT_ALIGN_CENTER)
			else
				if LocalPlayer():Team() == Minigames.VIP_CS:Team() then
					draw.DrawText("You are protecting: " .. Minigames.VIP_CS:Nick(), "Roboto15", ScrW()/2, 100, Color(34,167,240),TEXT_ALIGN_CENTER)
				elseif LocalPlayer():Team() == 3 then
					draw.DrawText("You are hunting: " .. Minigames.VIP_CS:Nick(), "Roboto15", ScrW()/2, 100, Color(242,38,19),TEXT_ALIGN_CENTER)
				else
					draw.DrawText("VIP: " .. Minigames.VIP_CS:Nick(), "Roboto15", ScrW()/2, 100, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)
				end
			end
			
			local pos = GetGlobalVector("VIP_Extract", Vector(0,0,0))
			local sceenpos = pos:ToScreen()
			
			surface.SetDrawColor(52, 152, 219)	
			local png = nil
			if LocalPlayer() == Minigames.VIP.CS then
				png = extract_png
			else
				if LocalPlayer():Team() == TEAM_BLUE then
					png = extract_png
				elseif LocalPlayer():Team() == TEAM_RED then
					png = protect_png
					surface.SetDrawColor(242, 38, 19)	
				end
			end
			
			surface.SetMaterial(png)
			surface.DrawTexturedRect(sceenpos.x, sceenpos.y-50,32,32)

		end
		
		if Minigames:IsPlayingFreezeTag() then
			if LocalPlayer():IsFrozen() then
				draw.RoundedBox(0,0,0,ScrW(), ScrH(), Color(34,167,240,50))
			end
		end
	end)
end

function Minigames:IsPlayingOITC()
	if table.HasValue(Minigames.OneInTheChamber.Maps, game.GetMap()) then
		return true
	end

	return false
end

if Minigames:IsPlayingOITC() then
	include("sv_oneinthechamber.lua")
end

function Minigames:IsPlayingVIP()
	if table.HasValue(Minigames.VIP.Maps, game.GetMap()) then
		return true
	end

	return false
end


if Minigames:IsPlayingVIP() then
	include("sv_assassination.lua")
end

function Minigames:IsPlayingFreezeTag()
	if table.HasValue(Minigames.FreezeTag.Maps, game.GetMap()) then
		return true
	end
	
	return false
end

if Minigames:IsPlayingFreezeTag() then
	include("sv_freezetag.lua")
end

function Minigames:IsPlayingGunGame()
	if table.HasValue(Minigames.GG.Maps, game.GetMap()) then
		return true
	end
	
	return false
end

if Minigames:IsPlayingGunGame() then
	include("sv_gungame.lua")
end

hook.Add("InitPostEntity", "Minigames_DetectGameOnMap", function()

	if not Minigames.Gamemodes then return end

	if Minigames:IsPlayingOITC() then
		SetGlobalString("Minigames_CurrentGamemode", "OITC")
		SetGlobalInt("Minigames_RoundTime", Minigames.OneInTheChamber.RoundTime)
		Minigames.RoundLimit = Minigames.OneInTheChamber.NumberOfRounds
		Minigames.InfoString = "We're playing One In The Chamber!"
		print("DLC GAMEMODE RUNNING: " .. GetGlobalString("Minigames_CurrentGamemode"))
		Minigames.IsPlayingDLC = true
	elseif Minigames:IsPlayingVIP() then
		SetGlobalString("Minigames_CurrentGamemode", "VIP")
		SetGlobalInt("Minigames_RoundTime", Minigames.VIP.RoundTime)
		Minigames.RoundLimit = Minigames.VIP.NumberOfRounds
		Minigames.InfoString = "We're playing VIP! Here players are split into two teams. Someone on Blue will \nbe picked as VIP and must make it to the extraction point before Red kills them. Everyone else on Blue is tasked with protecting the VIP, stick close!"
		print("DLC GAMEMODE RUNNING: " .. GetGlobalString("Minigames_CurrentGamemode"))
		Minigames.IsPlayingDLC= true
	elseif Minigames:IsPlayingFreezeTag() then
		SetGlobalString("Minigames_CurrentGamemode", "Freeze Tag")
		SetGlobalInt("Minigames_RoundTime", Minigames.FreezeTag.RoundTime)
		Minigames.RoundLimit = Minigames.FreezeTag.NumberOfRounds
		Minigames.InfoString = "We're playing Freeze Tag. Here players are given weapons and instead of \nkilling your enemy, you freeze them. If you get frozen, teammates can shoot \nyou to undo it. Freeze the entire enemy team to win the round!"
		print("DLC GAMEMODE RUNNING: " .. GetGlobalString("Minigames_CurrentGamemode"))
		Minigames.IsPlayingDLC = true
	elseif Minigames:IsPlayingGunGame() then
		SetGlobalString("Minigames_CurrentGamemode", "Gun Game")
		SetGlobalInt("Minigames_RoundTime", Minigames.GG.RoundTime)
		Minigames.RoundLimit = Minigames.GG.NumberOfRounds
		Minigames.InfoString = "We're playing Gun Game."
		print("DLC GAMEMODE RUNNING: " .. GetGlobalString("Minigames_CurrentGamemode"))
		Minigames.IsPlayingDLC = true
	end
	Minigames.Gamemodes["One In The Chamber"] = 0 
	Minigames.Gamemodes["Gun Game"]  = 0 
	Minigames.Gamemodes["VIP"]  = 0 
	Minigames.Gamemodes["Freeze Tag"]  = 0 
	
	
	function Minigames:DefineVoteInfo(winning_key)
        if winning_key == "Team Deathmatch" then
            return Minigames.TeamDeathmatch.Maps
        elseif winning_key == "Free For All" then
            return Minigames.FreeForAll.Maps
        elseif winning_key =="Assault Course" then
            return Minigames.AssaultCourse.Maps
        elseif winning_key == "Two Versus All" then
            return Minigames.TwoVersusAll.Maps
        elseif winning_key == "Team Survival" then
            return Minigames.TeamSurvival.Maps
        elseif winning_key == "Capture The Flag" then
            return Minigames.CaptureTheFlag.Maps
        elseif winning_key == "One In The Chamber" then
            return Minigames.OneInTheChamber.Maps
        elseif winning_key == "Freeze Tag" then
            return Minigames.FreezeTag.Maps
        elseif winning_key == "VIP" then
            return Minigames.VIP.Maps
        elseif winning_key == "Suicide Barrels" then
            return Minigames.SuicideBarrels.Maps
        else
            return Minigames.AssaultCourse.Maps
        end
    end
end)