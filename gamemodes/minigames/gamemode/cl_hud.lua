local HiddenHudElements = {
	CHudHealth = 1,
	CHudBattery = 1,
	CHudAmmo = 1,
	CHudSecondaryAmmo = 1,
	CHudSuitPower = 1,
	CHudPoisonDamageIndicator = 1,
	CHudCrosshair = 1,
}

function draw.Circle( x, y, radius, seg )
	local cir = {}

	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end

	local a = math.rad( 0 ) -- This is needed for non absolute segment counts
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

	surface.DrawPoly( cir )
end

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

surface.CreateFont( "DermaLargepetit", {
	font = "DermaLarge", 
	 size = 33 ,
	 outline = true,

	} )

surface.CreateFont( "DermaLargeround", {
	font = "DermaLarge", 
	 size = 31 ,
	 outline = true,

	} )


function GM:HUDPaint()

	if Minigames.CustomHUD then return end
	if Minigames.ScoreboardOpen then return end
	if Minigames.MapvoteOpen then return end
	

local w = 261
local h = 36

    surface.SetDrawColor(0,0,0,200)                      -- Carré des rounds
    surface.DrawRect(ScrW()/2 - w/2,30,w,h)          -- (827,30,261,36)
   

	surface.SetDrawColor(0,0,0)
    surface.DrawOutlinedRect(ScrW()/2 - w/2,30,w,h)              -- (827,30,261,36)
    surface.DrawOutlinedRect( ScrW()/2 - w/2 - 1,30 - 1,w + 1,h + 1)  						--(828,31,261,36)
    surface.DrawOutlinedRect( ScrW()/2 - w/2 - 2,30 - 2,w + 3,h + 3)					-- (829,32,261,36)
    surface.DrawOutlinedRect( ScrW()/2 - w/2 - 2,30 - 2,w + 4,h + 4)
   



local w = -165
local h = 36

    if timer.Exists("MinigamesRoundTimer") then
			draw.SimpleTextOutlined(string.ToMinutesSeconds(timer.TimeLeft("MinigamesRoundTimer")), "DermaLargepetit", ScrW()/2 - w/2,48, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,2,Color(0,0,0,255)) else
			draw.SimpleTextOutlined("00:00", "DermaLargepetit", ScrW()/2 - w/2,48, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,2,Color(0,0,0,255))
		end

 

local roundlimit
if Minigames:IsPlayingCaptureTheFlag() then
roundlimit  = Minigames.CaptureTheFlag.NumberOfRounds
elseif Minigames:IsPlayingTeamDeathmatch() then
roundlimit  = Minigames.TeamDeathmatch.NumberOfRounds
elseif Minigames:IsPlayingAssaultCourse() then
roundlimit  = Minigames.AssaultCourse.NumberOfRounds
elseif Minigames:IsPlayingFreeForAll() then
roundlimit  = Minigames.FreeForAll.NumberOfRounds
elseif Minigames:IsPlayingTeamSurvival() then
roundlimit  = Minigames.TeamSurvival.NumberOfRounds
elseif Minigames:IsPlayingTwoVersusAll() then
roundlimit  = Minigames.TwoVersusAll.NumberOfRounds
elseif Minigames:IsPlayingOneInTheChamber() then
roundlimit  = Minigames.OneInTheChamber.NumberOfRounds
elseif Minigames:IsPlayingFreezeTag() then
roundlimit  = Minigames.FreezeTag.NumberOfRounds
elseif Minigames:IsVIP() then
roundlimit  = Minigames.VIP.NumberOfRounds
elseif Minigames:IsGG() then
roundlimit  = Minigames.GG.NumberOfRounds
end

local w = 111
local h = 36

draw.SimpleTextOutlined("Round : ".. Minigames.RoundNumber .. "/" .. roundlimit, "DermaLargeround", ScrW()/2 - w/2,48, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,2,Color(0,0,0,255))	

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

	if LocalPlayer():Team() == TEAM_BLUE then
		team_string	= "Team Blue"
		surface.SetDrawColor(0, 0, 255, 255 )
		w = width-190
	elseif LocalPlayer():Team() == TEAM_RED then
		team_string	= "Team Red"
		surface.SetDrawColor(255, 0, 0, 255 )
		w = width-190
	elseif LocalPlayer():Team() == TEAM_SPECTATOR then
		team_string	= "Spectator"
		surface.SetDrawColor(150, 150, 150, 255 )
		w = width-190
	elseif LocalPlayer():Team() == TEAM_GHOST then
		team_string	= "Ghost-Mode"
		surface.SetDrawColor(150, 150, 150, 255 )
		w = width-180
	else
		team_string	= "Préparation"
		surface.SetDrawColor(150, 150, 150, 255 )
		w = width-180
	end
	draw.NoTexture()
	draw.Circle( 20+20+64+20+20, ScrH()-5-20-64, 10, 200)

	draw.RoundedBox(0, 20+64+20+20, ScrH()-20-20-64, w,30,Color(29, 33, 38, 150))
	
	draw.RoundedBox(0, 20+64+20+20, ScrH()-5-64,width-124.5,30,Color(29, 33, 38))
	draw.RoundedBoxEx(0, 20+64+20+20+2, ScrH()-5-60-2,math.Clamp(h*2-10,1,size),13,Color(220, 40, 57),true,true,false,false)
	draw.RoundedBoxEx(0, 20+64+20+20+2, ScrH()-5-60+11,math.Clamp(h*2-10,1,size),13,Color(204, 26, 46),false,false,true,true)
	
	draw.DrawText(team_string, "Roboto15", 20+20+20+64+20+20, ScrH()-12-20-64, Color(255, 255, 255, 255),TEXT_ALIGN_LEFT)
	draw.DrawText(h, "Roboto15", 120+90,ScrH()-5-26-30, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)
	
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