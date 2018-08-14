local HiddenHudElements = {
	CHudHealth = 1,
	CHudBattery = 1,
	CHudAmmo = 1,
	CHudSecondaryAmmo = 1,
	CHudSuitPower = 1,
	CHudPoisonDamageIndicator = 1,
}

hook.Add("HUDShouldDraw", "MG_Hidedefault", function(key)
	if HiddenHudElements[key] then return false end
end)

local height = 64+20+20
local width = 300
local size = width-40-20-64-4
local Default_HUD = Material("materials/niandralades/minigames/HUD.png")
local Red_HUD = Material("materials/niandralades/minigames/hud_red.png")
local Spec_HUD = Material("materials/niandralades/minigames/hud_else.png")

local team_string = "Unassigned"

local hud_img = Default_HUD

local ctf_flag = Material("materials/niandralades/minigames/ctf_flag.png")
function GM:HUDPaint()

	if Minigames.CustomHUD then return end
	if Minigames.ScoreboardOpen then return end
	if Minigames.MapvoteOpen then return end
	
	if not Minigames.RoundState or Minigames.RoundState < 0 then
		draw.RoundedBox(0,0,20,ScrW(), 55, Color(0,0,0,100))
		draw.DrawText("Two or more players needed to start!", "NexaLight55", ScrW()/2, 20, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)
	else
	
		if LocalPlayer():Team() == TEAM_BLUE then
			team_string	= "Team Blue"
			hud_img = Default_HUD
		elseif LocalPlayer():Team() == TEAM_RED then
			team_string	= "Team Red"
			hud_img = Red_HUD
		elseif LocalPlayer():Team() == TEAM_SPECTATOR then
			team_string	= "Spectator"
			hud_img = Spec_HUD
		elseif LocalPlayer():Team() == TEAM_GHOST then
			team_string	= "Ghost-Mode"
			hud_img = Spec_HUD
		end

		surface.SetDrawColor(Color(255,255,255,255)) 
		surface.SetMaterial(hud_img)
		surface.DrawTexturedRect(ScrW()/2-128,-20,256,256)
		draw.DrawText(team_string, "Roboto15", ScrW()/2, 74, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)
		
		if timer.Exists("MinigamesRoundTimer") then
			draw.DrawText(string.ToMinutesSeconds(timer.TimeLeft("MinigamesRoundTimer")), "NexaLight55", ScrW()/2, 3, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)
		else
			draw.DrawText("00:00", "NexaLight55", ScrW()/2, 3, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)
		end
	end
	
	if Minigames:IsPlayingCaptureTheFlag() then
		if Minigames.RoundState == 1 or Minigames.RoundState == 0 then
			local pos = GetGlobalVector("CTF_BlueBase", Vector(0,0,0))
			local sceenpos = pos:ToScreen()
				
			surface.SetDrawColor(52, 152, 219)	
			surface.SetMaterial(ctf_flag)
			surface.DrawTexturedRect(sceenpos.x, sceenpos.y-50,32,32)
			
			local pos = GetGlobalVector("CTF_RedBase", Vector(0,0,0))
			local sceenpos = pos:ToScreen()
				
			surface.SetDrawColor(242, 38, 19)	
			surface.SetMaterial(ctf_flag)
			surface.DrawTexturedRect(sceenpos.x, sceenpos.y-50,32,32)
			
		surface.SetDrawColor(52, 152, 219) 
		surface.SetMaterial(ctf_flag)
		surface.DrawTexturedRect(ScrW()/2-128-50,10,32,32)
		draw.DrawText(Minigames.BlueCaps or 0, "NexaLight55", ScrW()/2-128-35, 40, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)
		
		surface.SetDrawColor(242, 38, 19) 
		surface.SetMaterial(ctf_flag)
		surface.DrawTexturedRect(ScrW()/2+128+20,10,32,32)
		draw.DrawText(Minigames.RedCaps or 0, "NexaLight55", ScrW()/2+128+35, 40, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)
			
		end
	end

	if not LocalPlayer():Alive() then return end
	
	local h = LocalPlayer():Health()
	local s = math.Round(LocalPlayer():GetVelocity():Length())
	local s_text = math.Round(LocalPlayer():GetVelocity():Length())

	draw.RoundedBox(0, 20-2, ScrH()-20-height-2,width+4,height+4,Color(29, 33, 38))
	draw.RoundedBox(0, 20, ScrH()-20-height,width,height,Color(47, 53, 61))
	
	draw.RoundedBox(0, 20+64+20+20, ScrH()-20-20-64,width-124.5,30,Color(29, 33, 38))
	draw.RoundedBoxEx(0, 20+64+20+20+2, ScrH()-20-20-60-2,math.Clamp(h*2-10,1,size),13,Color(220, 40, 57),true,true,false,false)
	draw.RoundedBoxEx(0, 20+64+20+20+2, ScrH()-20-20-60+11,math.Clamp(h*2-10,1,size),13,Color(204, 26, 46),false,false,true,true)

	draw.RoundedBox(0, 20+64+20+20, ScrH()-20-20-13-13,width-124.5,30,Color(29, 33, 38))
	draw.RoundedBoxEx(0, 20+64+20+20+2, ScrH()-20-20-24,math.Clamp(s/2-14,1,size),13,Color(48, 165, 230),true,true,false,false)
	draw.RoundedBoxEx(0, 20+64+20+20+2, ScrH()-20-20-20+9,math.Clamp(s/2-14,1,size),13,Color(47, 126, 220),false,false,true,true)

	
	draw.DrawText(h, "Roboto15", 120+90,ScrH()-40-26-30, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)
	draw.DrawText(s_text, "Roboto15", 120+90,ScrH()-40-18, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)
	
	GAMEMODE:HUDDrawTargetID()
end

net.Receive("Minigames_AvatarHUD", function()
	local toggle = net.ReadBool()
	Minigames:ToggleAvatar(toggle)
end)

local a_tbl = {}
function Minigames:ToggleAvatar(toggle)
	if toggle then
		if Minigames.MapvoteOpen then return end
	
		local frame = vgui.Create("DFrame")
		frame:SetSize(68,68)
		frame:ShowCloseButton(false)
		frame:SetTitle("")
		frame:SetPos(20+20, ScrH()-20-20-64)
		frame.Paint = function()
			draw.RoundedBox(0, 0, 0,frame:GetWide(),frame:GetTall(),Color(29, 33, 38))
		end
		
		table.insert(a_tbl, frame)
		
		local avatar = vgui.Create("AvatarImage", frame)
		avatar:SetPos(2,2)
		avatar:SetSize(64,64)
		avatar:SetPlayer(LocalPlayer(), 64)
	else
		
		Minigames:RemoveAvatarHUD()
	end
end

function Minigames:RemoveAvatarHUD()
	if #a_tbl < 1 then return end
	for k, v in pairs(a_tbl) do
		v:Remove()
	end
end	

net.Receive("MG_Killfeed", function()
	Minigames:KillFeed(net.ReadEntity(),net.ReadEntity())
end)

Minigames.KillFeedNum = 0
function Minigames:KillFeed(killer,victim)
	local frame = vgui.Create("DFrame")
	frame:SetSize(32*3+15,42)
	frame:SetPos(ScrW()+frame:GetWide(),5+Minigames.KillFeedNum*frame:GetTall()+10)
	frame:ShowCloseButton(false)
	frame:SetTitle("")
	frame.Paint = function()
		draw.RoundedBox(0,0,0,frame:GetWide(),frame:GetTall(),Color(29, 33, 38))
	end

	frame:MoveTo(ScrW()-frame:GetWide(),frame.y,0.5,0,1, function()
		frame:MoveTo(ScrW()+frame:GetWide(),frame.y,0.5,3,1, function()
			frame:Remove()
			Minigames.KillFeedNum = Minigames.KillFeedNum - 1
		end)
	 end)
	 
	 	
	Minigames.KillFeedNum = Minigames.KillFeedNum + 1
	
	local kill = vgui.Create("DImage", frame)
	kill:SetImage("materials/niandralades/minigames/kill.png")
	kill:SetSize(32,32)
	kill:SetPos(41,5)
	if killer:IsPlayer() then
		kill:SetImageColor(team.GetColor(killer:Team()))
	
		local attacker = vgui.Create("AvatarImage", frame)
		attacker:SetPos(5,5)
		attacker:SetSize(32,32)
		attacker:SetPlayer(killer, 32)
	else
	
	end
	
	local dead = vgui.Create("AvatarImage", frame)
	dead:SetPos(64+10,5)
	dead:SetSize(32,32)
	dead:SetPlayer(victim, 32)
end
