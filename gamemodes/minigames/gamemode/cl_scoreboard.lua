AddScoreboardButton(1, {
	ButtonName = "Help",
	Icon = "materials/niandralades/minigames/help.png",
	Function = function() 
		Minigames:OpenHelpMenu()
	end
})

AddScoreboardButton(2, {
	ButtonName = "RTV",
	Icon = "materials/niandralades/minigames/exit.png",
	Function = function() 
		Minigames:RequestRTVFromClient()
	end
})

AddScoreboardButton(3, {
	ButtonName = "Model",
	Icon = "materials/niandralades/minigames/model.png",
	Function = function() 
		Minigames:PlayerModel()
	end
})

AddScoreboardButton(4, {
	ButtonName = "Team",
	Icon = "materials/niandralades/minigames/teams.png",
	Function = function() 
		Minigames:SelectTeams()
	end
})


AddScoreboardButton(5, {
	ButtonName = "Pointshop",
	Icon = "materials/niandralades/minigames/cash.png",
	Function = "http://www.google.co.uk"
})


AddScoreboardButton(6, {
	ButtonName = "Group",
	Icon = "materials/niandralades/minigames/community.png",
	Function = "https://forum.lesserruriers.fr/index.php"
})

AddScoreboardButton(7, {
	ButtonName = "Donate",
	Icon = "materials/niandralades/minigames/donate.png",
	Function = "https://forum.lesserruriers.fr/index.php"
})


function GM:ScoreboardShow()
	if Minigames.DefaultScoreboard then
		Minigames:ShowScoreboard()
		if LocalPlayer():Alive() then
			Minigames:ToggleAvatar(false)
		end	
	end	
end

function GM:ScoreboardHide()
	if Minigames.DefaultScoreboard then
		Minigames:HideScoreboard()
		if LocalPlayer():Alive() then
			Minigames:ToggleAvatar(true)
		end	
		gui.EnableScreenClicker(false)
	end	
end

function Minigames:GetSpecsNGhosts()
	local tbl = {}
	for k, v in pairs(player.GetAll()) do
		if v:Team() ~= TEAM_BLUE then
			if v:Team() ~= TEAM_RED then
				table.insert(tbl,v)
			end
		end
	end

	return tbl
end

Minigames.ScoreboardOpen = false
function Minigames:ShowScoreboard()

	Minigames.ScoreboardOpen = true

	local spacing = 20
	local frame = vgui.Create("DFrame")
	frame:SetSize(820,ScrH()-100)
	frame:Center()
	frame:ShowCloseButton(false)
	frame:SetTitle("")
	frame.Paint = function()
	end
	frame.Think = function()
		gui.EnableScreenClicker(true)
	end
	
	local host_dpanel = vgui.Create("DPanel", frame)
	host_dpanel:SetSize(frame:GetWide(),50)
	host_dpanel:SetPos(0,0)
	host_dpanel.Paint = function()
		draw.RoundedBox(0,0,0,host_dpanel:GetWide(),host_dpanel:GetTall(),Color(0,0,0,100))
		draw.DrawText(GetHostName(), "NexaLight35",host_dpanel:GetWide()/2,5, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)
	end
	
	local maths = Minigames.RoundLimit-Minigames.RoundNumber
	local misc_info_dpanel = vgui.Create("DPanel", frame)
	misc_info_dpanel:SetSize(frame:GetWide(),50)
	misc_info_dpanel:SetPos(0,frame:GetTall()-misc_info_dpanel:GetTall())
	misc_info_dpanel.Paint = function()
		draw.RoundedBox(0,0,0,host_dpanel:GetWide(),host_dpanel:GetTall(),Color(0,0,0,100))
		draw.DrawText(game.GetMap() .. " | " .. GetGlobalString("Minigames_CurrentGamemode") .. " | " .. maths .. " rounds restants", "NexaLight35",misc_info_dpanel:GetWide()/2,7, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)
	end
	
	local ply_info = vgui.Create("DPanel", frame)
	ply_info:SetSize(64+64+15, 74)
	ply_info:SetPos(0,frame:GetTall()-spacing-misc_info_dpanel:GetTall()-ply_info:GetTall())
	ply_info.Paint = function()
		draw.RoundedBox(0,0,0,ply_info:GetWide(),ply_info:GetTall(),Color(49,49,49,150))
	end
	
	local buttons_panel = vgui.Create("DPanel", frame)
	buttons_panel:SetSize(frame:GetWide(), 74)
	buttons_panel:SetPos(ply_info:GetWide(),frame:GetTall()-spacing-misc_info_dpanel:GetTall()-buttons_panel:GetTall())
	buttons_panel.Paint = function()
		draw.RoundedBox(0,0,0,buttons_panel:GetWide(),buttons_panel:GetTall(),Color(0,0,0,100))
		draw.RoundedBox(0,0,2,2,buttons_panel:GetTall()-4,Color(255,255,255,150))
	end
	
	local num = 0
	for k, v in pairs(Minigames.SBT) do
		local custom_buttons = vgui.Create("DButton", buttons_panel)
		custom_buttons:SetPos(7+num*69,5)
		custom_buttons:SetSize(64,64)
		custom_buttons:SetText("")
		custom_buttons.Paint = function()
			draw.RoundedBox(0,0,0,custom_buttons:GetWide(),custom_buttons:GetTall(),Color(70,154,180,150))
			draw.DrawText(v.ButtonName, "NexaLight15",custom_buttons:GetWide()/2,custom_buttons:GetTall()-20, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)
		end
		custom_buttons.DoClick = function()
			if isstring(v.Function) then
				gui.OpenURL(v.Function)
				
			else
				v.Function()
			end
		end
		
		local custom_icons = vgui.Create("DImage", custom_buttons)
		custom_icons:SetSize(32,32)
		custom_icons:SetImage(v.Icon)
		custom_icons:SetPos(custom_buttons:GetWide()/2-16,5)
		
		num = num + 1
	end
	
	local space = #Minigames.SBT*64+5*#Minigames.SBT+7
	local specnum = vgui.Create("DPanel", buttons_panel)
	specnum:SetPos(space, 5)
	specnum:SetSize(183, 64)
	specnum.Paint = function()
		draw.RoundedBox(0,0,0,specnum:GetWide(),specnum:GetTall(),Color(216,52,50,150))
		draw.DrawText(#Minigames:GetSpecsNGhosts(), "NexaLight55",15,5, Color(255, 255, 255, 255),TEXT_ALIGN_LEFT)
		draw.DrawText("Spectateurs", "NexaLight25",50,20, Color(255, 255, 255, 255),TEXT_ALIGN_LEFT)
	end
	
	
	local kills_pnl = vgui.Create("DPanel", ply_info)
	kills_pnl:SetPos(5,5)
	kills_pnl:SetSize(64,64)
	kills_pnl.Paint = function()
		draw.RoundedBox(0,0,0,kills_pnl:GetWide(),kills_pnl:GetTall(),Color(216,52,50,150))
		draw.DrawText("Kills", "NexaLight15",kills_pnl:GetWide()/2,kills_pnl:GetTall()-20, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)
		draw.DrawText(LocalPlayer():Frags(), "NexaLight40",kills_pnl:GetWide()/2,5, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)
	end
	
	local deaths = vgui.Create("DPanel", ply_info)
	deaths:SetPos(5+64+5,5)
	deaths:SetSize(64,64)
	deaths.Paint = function()
		draw.RoundedBox(0,0,0,deaths:GetWide(),deaths:GetTall(),Color(216,52,50,150))
		draw.DrawText("Morts", "NexaLight15",deaths:GetWide()/2,deaths:GetTall()-20, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)
		draw.DrawText(LocalPlayer():Deaths(), "NexaLight40",deaths:GetWide()/2,5, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)
	end
	
	local height = frame:GetTall()-spacing-spacing-spacing-74-50-50-50

	function Minigames:TeamScoreboard()
		local team_2_header = vgui.Create("DPanel", frame)
		team_2_header:SetSize(frame:GetWide()/2-spacing, 50)
		team_2_header:SetPos(0,host_dpanel:GetTall()+spacing)
		team_2_header.Paint = function()
			draw.RoundedBox(0,0,0,team_2_header:GetWide(),team_2_header:GetTall(),Color(0,0,0,100))
			draw.DrawText("Bleu", "NexaLight35",5,10, Color(255, 255, 255, 255),TEXT_ALIGN_LEFT)
			draw.DrawText(team.GetScore(2), "NexaLight40",team_2_header:GetWide()-5,7, Color(255, 255, 255, 255),TEXT_ALIGN_RIGHT)
		end
		
		local team_3_header = vgui.Create("DPanel", frame)
		team_3_header:SetSize(frame:GetWide()/2, 50)
		team_3_header:SetPos(team_2_header:GetWide()+spacing,host_dpanel:GetTall()+spacing)
		team_3_header.Paint = function()
			draw.RoundedBox(0,0,0,team_3_header:GetWide(),team_3_header:GetTall(),Color(0,0,0,100))
			draw.DrawText("Rouge", "NexaLight35",team_3_header:GetWide()-2-5,10, Color(255, 255, 255, 255),TEXT_ALIGN_RIGHT)
			draw.DrawText(team.GetScore(3), "NexaLight40",5,7, Color(255, 255, 255, 255),TEXT_ALIGN_LEFT)
		end
			
		local team_2_panel = vgui.Create("DPanel", frame)
		team_2_panel:SetPos(0,host_dpanel:GetTall()+team_2_header:GetTall()+spacing)
		team_2_panel:SetSize(team_2_header:GetWide(),26)
		team_2_panel.Paint = function()
			draw.RoundedBox(0,0,0,team_2_panel:GetWide(),team_2_panel:GetTall(),Color(65, 131, 215,150))
			draw.DrawText("PSEUDO", "NexaLight20",5,5, Color(255, 255, 255, 255),TEXT_ALIGN_LEFT)
			draw.DrawText("KILLS", "NexaLight20",team_2_panel:GetWide()/2-30,5, Color(255, 255, 255, 255),TEXT_ALIGN_LEFT)
			draw.DrawText("MORTS", "NexaLight20",team_2_panel:GetWide()/2+50,5, Color(255, 255, 255, 255),TEXT_ALIGN_LEFT)
			draw.DrawText("PING", "NexaLight20",team_2_panel:GetWide()-20,5, Color(255, 255, 255, 255),TEXT_ALIGN_RIGHT)
			draw.RoundedBox(0,0,25,team_2_panel:GetWide(),1,Color(255,255,255,150))
		end
		
		local team_2_scroll = vgui.Create("DScrollPanel", frame)
		team_2_scroll:SetPos(0,host_dpanel:GetTall()+team_2_header:GetTall()+spacing+26)
		team_2_scroll:SetSize(team_2_header:GetWide(),height-26)
		team_2_scroll.Paint = function()
			draw.RoundedBox(0,0,0,team_2_scroll:GetWide(),team_2_scroll:GetTall(),Color(1,155,223,150))
		end

		local num = 0
		for k, v in pairs(team.GetPlayers(2)) do
			local nick_lbl = vgui.Create("DButton", team_2_scroll)
			nick_lbl:SetText("")
			nick_lbl.DoClick = function()
				if v:IsMuted() then
					v:SetMuted(false)
					chat.AddText(Color(242,99,91), "[MINIGAMES] ", Color(255,255,255), "Tu as mute ", Color(67,191,227),  v:Nick(), Color(255,255,255), ".")
				else
					v:SetMuted(true)
					chat.AddText(Color(242,99,91), "[MINIGAMES] ", Color(255,255,255), "Tu as demute ", Color(67,191,227),  v:Nick(), Color(255,255,255), ".")
				end
			end
			nick_lbl:SizeToContents()
			nick_lbl:SetSize(team_2_panel:GetWide(),30)
			nick_lbl:SetPos(0,num*nick_lbl:GetTall())
			nick_lbl.Paint = function()
				draw.DrawText(v:Nick(), "NexaLight20",5,5, Color(255, 255, 255, 255),TEXT_ALIGN_LEFT)
				draw.DrawText(v:Frags(), "NexaLight20",team_2_panel:GetWide()/2-30,5, Color(255, 255, 255, 255),TEXT_ALIGN_LEFT)
				draw.DrawText(v:Deaths(), "NexaLight20",team_2_panel:GetWide()/2+50,5, Color(255, 255, 255, 255),TEXT_ALIGN_LEFT)
				draw.DrawText(v:Ping(), "NexaLight20",team_2_panel:GetWide()-20,5,Color(255, 255, 255, 255),TEXT_ALIGN_RIGHT)

				
				if not v:Alive() then
					draw.RoundedBox(0,0,0,nick_lbl:GetWide(),nick_lbl:GetTall(),Color(210, 215, 211,150))
				end
			end
			num = num + 1
		end
		
		local team_3_panel = vgui.Create("DPanel", frame)
		team_3_panel:SetPos(team_2_panel:GetWide()+spacing,host_dpanel:GetTall()+team_2_header:GetTall()+spacing)
		team_3_panel:SetSize(team_2_header:GetWide()+spacing,26)
		team_3_panel.Paint = function()
			draw.RoundedBox(0,0,0,team_3_panel:GetWide(),team_3_panel:GetTall(),Color(223,32,1,150))
			draw.DrawText("PSEUDO", "NexaLight20",5,5, Color(255, 255, 255, 255),TEXT_ALIGN_LEFT)
			draw.DrawText("KILLS", "NexaLight20",team_3_panel:GetWide()/2-30,5, Color(255, 255, 255, 255),TEXT_ALIGN_LEFT)
			draw.DrawText("MORTS", "NexaLight20",team_3_panel:GetWide()/2+50,5, Color(255, 255, 255, 255),TEXT_ALIGN_LEFT)
			draw.DrawText("PING", "NexaLight20",team_3_panel:GetWide()-20,5, Color(255, 255, 255, 255),TEXT_ALIGN_RIGHT)
			draw.RoundedBox(0,0,25,team_3_panel:GetWide(),1,Color(255,255,255,150))
		end
		
		local team_3_scroll = vgui.Create("DScrollPanel", frame)
		team_3_scroll:SetPos(team_2_panel:GetWide()+spacing,host_dpanel:GetTall()+team_2_header:GetTall()+spacing+26)
		team_3_scroll:SetSize(team_3_panel:GetWide(),height-26)
		team_3_scroll.Paint = function()
			draw.RoundedBox(0,0,0,team_3_scroll:GetWide(),team_3_scroll:GetTall(),Color(216,52,50,150,150))
		end
		
		local num = 0
		for k, v in pairs(team.GetPlayers(3)) do
			local nick_lbl = vgui.Create("DButton", team_3_scroll)
			nick_lbl:SetText("")
			nick_lbl.DoClick = function()
				if v:IsMuted() then
					v:SetMuted(false)
					chat.AddText(Color(242,99,91), "[MINIGAMES] ", Color(255,255,255), "Tu as mute ", Color(67,191,227),  v:Nick(), Color(255,255,255), ".")
				else
					v:SetMuted(true)
					chat.AddText(Color(242,99,91), "[MINIGAMES] ", Color(255,255,255), "Tu as demute ", Color(67,191,227),  v:Nick(), Color(255,255,255), ".")
				end
			end
			nick_lbl:SizeToContents()
			nick_lbl:SetSize(team_3_panel:GetWide(),30)
			nick_lbl:SetPos(5,num*nick_lbl:GetTall())
			nick_lbl.Paint = function()
				draw.DrawText(v:Nick(), "NexaLight20",0,5, Color(255, 255, 255, 255),TEXT_ALIGN_LEFT)
				draw.DrawText(v:Frags(), "NexaLight20",team_3_panel:GetWide()/2-35,5, Color(255, 255, 255, 255),TEXT_ALIGN_LEFT)
				draw.DrawText(v:Deaths(), "NexaLight20",team_3_panel:GetWide()/2+45,5, Color(255, 255, 255, 255),TEXT_ALIGN_LEFT)
				draw.DrawText(v:Ping(), "NexaLight20",team_3_panel:GetWide()-25,5,Color(255, 255, 255, 255),TEXT_ALIGN_RIGHT)
			end
			num = num + 1
		end
	end	
	
	function Minigames:SoloScoreboard()
		local team_2_header = vgui.Create("DPanel", frame)
		team_2_header:SetSize(frame:GetWide(), 50)
		team_2_header:SetPos(0,host_dpanel:GetTall()+spacing)
		team_2_header.Paint = function()
			draw.RoundedBox(0,0,0,team_2_header:GetWide(),team_2_header:GetTall(),Color(0,0,0,100))
			draw.DrawText("Bleu", "NexaLight35",5,10, Color(255, 255, 255, 255),TEXT_ALIGN_LEFT)
			draw.DrawText(team.GetScore(2), "NexaLight40",team_2_header:GetWide()-5,7, Color(255, 255, 255, 255),TEXT_ALIGN_RIGHT)
		end
	
		local team_2_panel = vgui.Create("DPanel", frame)
			team_2_panel:SetPos(0,host_dpanel:GetTall()+team_2_header:GetTall()+spacing)
			team_2_panel:SetSize(team_2_header:GetWide(),26)
			team_2_panel.Paint = function()
				draw.RoundedBox(0,0,0,team_2_panel:GetWide(),team_2_panel:GetTall(),Color(65, 131, 215,150))
				draw.DrawText("PSEUDO", "NexaLight20",5,5, Color(255, 255, 255, 255),TEXT_ALIGN_LEFT)
				draw.DrawText("KILLS", "NexaLight20",team_2_panel:GetWide()-230,5, Color(255, 255, 255, 255),TEXT_ALIGN_RIGHT)
				draw.DrawText("MORTS", "NexaLight20",team_2_panel:GetWide()-120,5, Color(255, 255, 255, 255),TEXT_ALIGN_RIGHT)
				draw.DrawText("PING", "NexaLight20",team_2_panel:GetWide()-30,5, Color(255, 255, 255, 255),TEXT_ALIGN_RIGHT)
				draw.RoundedBox(0,0,25,team_2_panel:GetWide(),1,Color(255,255,255,150))
			end
			
		local team_2_scroll = vgui.Create("DScrollPanel", frame)
		team_2_scroll:SetPos(0,host_dpanel:GetTall()+team_2_header:GetTall()+spacing+26)
		team_2_scroll:SetSize(team_2_header:GetWide(),height-26)
		team_2_scroll.Paint = function()
			draw.RoundedBox(0,0,0,team_2_scroll:GetWide(),team_2_scroll:GetTall(),Color(1,155,223,150))
		end
			
		local num = 0
		for k, v in pairs(team.GetPlayers(2)) do
			local nick_lbl = vgui.Create("DButton", team_2_scroll)
			nick_lbl:SetText("")
			nick_lbl.DoClick = function()
				if v:IsMuted() then
					v:SetMuted(false)
					chat.AddText(Color(242,99,91), "[MINIGAMES] ", Color(255,255,255), "Tu as mute ", Color(67,191,227),  v:Nick(), Color(255,255,255), ".")
				else
					v:SetMuted(true)
					chat.AddText(Color(242,99,91), "[MINIGAMES] ", Color(255,255,255), "Tu as demute ", Color(67,191,227),  v:Nick(), Color(255,255,255), ".")
				end
			end
			nick_lbl:SizeToContents()
			nick_lbl:SetSize(team_2_panel:GetWide(),30)
			nick_lbl:SetPos(0,num*nick_lbl:GetTall())
			nick_lbl.Paint = function()
				draw.DrawText(v:Nick(), "NexaLight20",5,5, Color(255, 255, 255, 255),TEXT_ALIGN_LEFT)
				draw.DrawText(v:Frags(), "NexaLight20",team_2_panel:GetWide()-261,5, Color(255, 255, 255, 255),TEXT_ALIGN_RIGHT)
				draw.DrawText(v:Deaths(), "NexaLight20",team_2_panel:GetWide()-183,5, Color(255, 255, 255, 255),TEXT_ALIGN_LEFT)
				draw.DrawText(v:Ping(), "NexaLight20",team_2_panel:GetWide()-30,5,Color(255, 255, 255, 255),TEXT_ALIGN_RIGHT)
				
				

				if not v:Alive() then
					draw.RoundedBox(0,0,0,nick_lbl:GetWide(),nick_lbl:GetTall(),Color(210, 215, 211,150))
				end
			end
			num = num + 1
		end
	end
	
	if Minigames:TeamGamemode() then
		Minigames:TeamScoreboard()
	else
		Minigames:SoloScoreboard()
	end
	
	function Minigames:HideScoreboard()
		frame:Remove()
		Minigames.ScoreboardOpen = false
	end
	
end

function Minigames:TeamGamemode()
	if #team.GetPlayers(3) >= 1 then
		return true
	end
	
	return false
end
