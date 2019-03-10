include("shared.lua")
include("config_maps.lua")
include("ply_extension.lua")
include("cl_networkstrings.lua")
include("cl_fonts.lua")
include("cl_hud.lua")
include("cl_mapvote.lua")
include("config_mapvote.lua")
include("config_general.lua")


Minigames.SBT = Minigames.SBT or {}

function AddScoreboardButton(num,options)
	Minigames.SBT[num] = {
		ButtonName = options.ButtonName,
		Icon = options.Icon,
		Function = options.Function
	} 
end

-- I know using a table instead of a bool is weird, but the other wasnt working correctly :(
local f2open = {}
function Minigames:SelectTeams()

	if #f2open >= 1 then
		 Minigames:CloseTeamMenu()
		 return
	end

	if Minigames.ScoreboardOpen then
		Minigames:HideScoreboard()
	end

	local frame = vgui.Create("DFrame")
	frame:SetSize(310, 420)
	frame:SetTitle("")
	frame:ShowCloseButton(false)
	frame:Center()
	frame:ShowCloseButton(false)
	frame.Paint = function()
		draw.RoundedBox(0,0,0,frame:GetWide(),50,Color(0,0,0,100))
		draw.DrawText("Team Select", "NexaLight35",frame:GetWide()/2,5, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)
	end
	frame.Think = function()
		gui.EnableScreenClicker(true)
	end
	
	
	table.insert(f2open,frame)
	
	local team_blue = vgui.Create("DButton", frame)
	team_blue:SetSize(150, 300)
	team_blue:SetPos(0,60)
	team_blue:SetText("")
	team_blue.DoClick = function()
		if LocalPlayer():Team() != TEAM_BLUE then
			if Minigames:CanJoinBlue() then
				net.Start("Team_Select_Serverside")
					net.WriteString("blue")
				net.SendToServer()
				chat.AddText(Color(255,60,60), "[MINIGAMES] ", Color(255,255,255), "Vous avez rejoins l'équipe ", Color(98,177,255), "Bleu", Color(255,255,255),"!")
				 Minigames:CloseTeamMenu()
			else
				chat.AddText(Color(255,60,60), "[MINIGAMES] ", Color(255,255,255), "Désolé, l'équipe est", Color(98,177,255), "pleine", Color(255,255,255),"!")
			end
		else
			chat.AddText(Color(255,60,60), "[MINIGAMES] ", Color(255,255,255), "Tu es déja dans l'équipe", Color(98,177,255), "Bleu", Color(255,255,255),"!")
			Minigames:CloseTeamMenu()
		end
	end
	team_blue.Paint = function()
		draw.RoundedBox(0,0,0,team_blue:GetWide(),team_blue:GetTall(),Color(1,155,223,150))
		draw.DrawText("Equipe", "NexaLight35",team_blue:GetWide()/2,5, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)
		draw.DrawText("Bleu", "NexaLight55",team_blue:GetWide()/2,team_blue:GetTall()-60, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)
		draw.DrawText(#team.GetPlayers(2), "NexaLight120",team_blue:GetWide()/2,team_blue:GetTall()/2-60, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)
	end
	
	local team_red = vgui.Create("DButton", frame)
	team_red:SetSize(150, 300)
	team_red:SetPos(160,60)
	team_red:SetText("")
	team_red.DoClick = function()
		if LocalPlayer():Team() != TEAM_RED then
			if Minigames:CanJoinRed() then
				net.Start("Team_Select_Serverside")
					net.WriteString("red")
				net.SendToServer()
				chat.AddText(Color(255,60,60), "[MINIGAMES] ", Color(255,255,255), "Tu as rejoins l'équipe ", Color(98,177,255), "Rouge", Color(255,255,255),"!")
				 Minigames:CloseTeamMenu()
			else
				chat.AddText(Color(255,60,60), "[MINIGAMES] ", Color(255,255,255), "Désolé, cette équipe est ", Color(98,177,255), "pleine", Color(255,255,255),"!")
			end
		else
			Minigames:CloseTeamMenu()
		end
	end
	team_red.Paint = function()
		draw.RoundedBox(0,0,0,team_red:GetWide(),team_red:GetTall(),Color(223,32,1,150))
		draw.DrawText("Equipe", "NexaLight35",team_red:GetWide()/2,5, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)
		draw.DrawText("Rouge", "NexaLight55",team_red:GetWide()/2,team_red:GetTall()-60, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)
		draw.DrawText(#team.GetPlayers(3), "NexaLight120",team_blue:GetWide()/2,team_blue:GetTall()/2-60, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)

	end
	
	local spectator = vgui.Create("DButton", frame)
	spectator:SetSize(frame:GetWide(), 50)
	spectator:SetPos(0,frame:GetTall()-50)
	spectator:SetText("")
	spectator.DoClick = function()
		if LocalPlayer():Team() != TEAM_SPECTATOR then
			net.Start("Team_Select_Serverside")
				net.WriteString("spec")
			net.SendToServer()
			chat.AddText(Color(255,60,60), "[MINIGAMES] ", Color(255,255,255), "Tu as rejoins les", Color(98,177,255), "Spectateurs", Color(255,255,255),"!")
			Minigames:CloseTeamMenu()
		else
			 Minigames:CloseTeamMenu()
		end
	end
	spectator.Paint = function()
		draw.RoundedBox(0,0,0,spectator:GetWide(),spectator:GetTall(),Color(0,0,0,100))
		draw.DrawText("Spectateurs", "NexaLight35",spectator:GetWide()/2,7, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)
	end
	
	function Minigames:CloseTeamMenu()
		for k, v in pairs(f2open) do
			v:Remove()
		end
		f2open = {}
		gui.EnableScreenClicker(false)
	end
end

Minigames.InfoString = Minigames.InfoString or "On ne joue pas a un gamemode particulier, le dernier en vie gagne."
if Minigames:IsPlayingTeamDeathmatch() then
	Minigames.InfoString = "Nous jouons actuellement en Team Deathmatch. C'est simple - Élimine l'équipe adverse \avant qu'ils ne te tue ! Chaque round, tout les joueurs reçoivent une arme random \nuse.\n\n Ci dessous est la liste des commandes utilisables."
elseif Minigames:IsPlayingTeamSurvival() then
	Minigames.InfoString = "Nous jouons actuelle en Team Survival. Les joueurs sont séparés en 2 équipes et doivent accomplir des défis, la dérnière équipe en vie gagne!"
elseif Minigames:IsPlayingFreeForAll() then
	Minigames.InfoString = "Nous jouons actuelle en Free For All. C'est simple, c'est chacun pour soi ! \nand la dérnière personne en vie l'emporte"
elseif  Minigames:IsPlayingAssaultCourse() then
	Minigames.InfoString = "Nous jouons actuelle en Assault Course. C'est comme un deathrun, mais les pièges sont activés par la map ou \nCrée toi un chemin jusqu'à l'arriver tout en évitant les pièges"
elseif Minigames:IsPlayingTwoVersusAll() then
	Minigames.InfoString = "Nous jouons actuelle en Two Versus All. 2 jours sont choisis aléatoirement à chaque round \net Leur but est de vous éléminer, le votre de survivre. La dérnière équipe en vie gagne!"
elseif Minigames:IsPlayingCaptureTheFlag() then
	Minigames.InfoString = "Nous jouons actuelle en Capture The Flag. Chaque équipe a un drapeau au  \nspawn. L'équipe énemie peut ramasser votre drapeau en marchant dessus et doivent le ramener \na leur propre drapeau. Les tuer leur fait tomber votre drapeau et " .. Minigames.CaptureTheFlag.FlagReset .. " en quelque secondes \nreviendra à votre base."
end

local f1open = {}
function Minigames:OpenHelpMenu()

	if #f1open >= 1 then
		 Minigames:CloseF1Menu()
		 return
	end
	
	local frame = vgui.Create("DFrame")
	frame:SetSize(400,300)
	frame:Center()
	frame:SetTitle("")
	frame.Paint = function()
		draw.RoundedBox(0,0,0,frame:GetWide(),frame:GetTall(),Color(26,26,26,150))
		draw.DrawText("Welcome to", "NexaLight20", frame:GetWide()/2, 10, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)
		draw.DrawText("Minigames!", "NexaLight40", frame:GetWide()/2, 20, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)
	end
	frame.Think = function()
		gui.EnableScreenClicker(true)
	end
	
	table.insert(f1open, frame)
	
	local desc_panel = vgui.Create("DPanel", frame)
	desc_panel:SetSize(frame:GetWide()-20, 100)
	desc_panel:SetPos(10,65)
	desc_panel.Paint = function() --bbbb
		draw.RoundedBox(0,0,0,desc_panel:GetWide(),desc_panel:GetTall(),Color(26,26,26,150))
	end
	
	local desc = vgui.Create("DLabel", desc_panel)
	desc:SetText(Minigames.InfoString)
	desc:SizeToContents()
	desc:SetPos(5,5)
	desc:SetColor(Color(255,255,255))
	
	local pos = frame:GetTall()-table.Count(Minigames.HelpCommands)*25
	
	local commands_pnl = vgui.Create("DPanel", frame)
	commands_pnl:SetSize(frame:GetWide(), 25)
	commands_pnl:SetPos(0,pos-25)
	commands_pnl:SetText("Commands")
	commands_pnl.Paint = function() --bbbb
		draw.RoundedBox(0,0,0,commands_pnl:GetWide(),commands_pnl:GetTall(),Color(37,37,37,150))
		draw.DrawText("Commands", "Tahoma15", frame:GetWide()/2, 5, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)
	end
	
	local num = 0
	for k, v in pairs(Minigames.HelpCommands) do
		local commands_k = vgui.Create("DPanel", frame)
		commands_k:SetSize(frame:GetWide()/2, 25)
		commands_k:SetPos(0, pos+num*25)
		commands_k.Paint = function()
			draw.RoundedBox(0,0,0,commands_k:GetWide(),commands_k:GetTall(),Color(46,46,46,150))
			draw.RoundedBox(0,0,0,commands_k:GetWide(),1,Color(155,155,155))
			draw.DrawText(k, "Tahoma15", commands_k:GetWide()/2, 5, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)
		end
		
		local commands_v = vgui.Create("DPanel", frame)
		commands_v:SetSize(frame:GetWide()/2, 25)
		commands_v:SetPos(commands_k:GetWide(), pos+num*25)
		commands_v.Paint = function()
			draw.RoundedBox(0,0,0,commands_v:GetWide(),commands_v:GetTall(),Color(46,46,46,150))
			draw.RoundedBox(0,0,0,commands_v:GetWide(),1,Color(155,155,155))
			draw.DrawText(v, "Tahoma15", commands_v:GetWide()/2, 5, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)
		end
		num = num + 1
	end	
	
	function Minigames:CloseF1Menu()
		for k, v in pairs(f1open) do
			v:Remove()
		end
		f1open = {}
		gui.EnableScreenClicker(false)
	end
	
end

function Minigames:PlayerModel()
	
	local selected = LocalPlayer():GetModel()

	local frame = vgui.Create("DFrame")
	frame:SetSize(600,500)
	frame:SetTitle("Select Player Model")
	frame:Center()
	frame.OnClose = function()
		gui.EnableScreenClicker(false)
	end
	frame.Paint = function()
		draw.RoundedBox(0,0,0,frame:GetWide(),frame:GetTall(),Color(26,26,26))
	end
	frame.Think = function()
		gui.EnableScreenClicker(true)
	end
	
	local background = vgui.Create("DScrollPanel", frame)
	background:SetSize(frame:GetWide()-50,frame:GetTall()-75)
	background:SetPos(25,50)
	background.Paint = function()
	end
	

	local num = 0
	for k, v in pairs(Minigames.GenericPlayerModels) do
		local pm_panels = vgui.Create("DButton", background)
		pm_panels:SetText(v)
		pm_panels:SetColor(Color(255,255,255))
		pm_panels:SetFont("Bebas40")
		pm_panels:SetSize(550, 64)
		pm_panels:SetPos(0, 0+num*65)
		pm_panels.Paint = function()
			if v != selected then
				draw.RoundedBox(0,0,0,pm_panels:GetWide(),pm_panels:GetTall(),Color(49,49,49))
			else
				draw.RoundedBox(0,0,0,pm_panels:GetWide(),pm_panels:GetTall(),Color(242,99,91))
			end
		end
		pm_panels.DoClick = function()
			net.Start("Minigames_ChoosePlayerModel")
				net.WriteString(v)
			net.SendToServer()
			selected = v
			chat.AddText(Color(242,99,91), "[MINIGAMES] ", Color(255,255,255), "Player model selected!")
		end
		
		local v_model = vgui.Create("SpawnIcon", pm_panels)
		v_model:SetModel(v)
		v_model:SetSize(64,64)
		v_model:SetPos(0,0)
		
		num = num + 1
	end	
	
end

function Minigames:RequestRTVFromClient()
	net.Start("MG_RequestRTVFromClient")
	net.SendToServer()
end

include("cl_scoreboard.lua")